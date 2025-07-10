{ nixpkgs, ... }:
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
  };
  lib = pkgs.lib;

  queue-tool = pkgs.callPackage ./pkgs/queue-tool { };
in
pkgs.mkShell {
  name = "sustainability-lab";
  packages = with pkgs; [
    k3d

    queue-tool
    (writeShellApplication {
      name = "update-queue-tool-package-deps";
      text = ''
        ${queue-tool.passthru.fetch-deps} "$FLAKE_ROOT/.nix/pkgs/queue-tool/deps.json"
      '';
    })

    (writeShellApplication {
      name = "create-demand-shaping-cluster";
      runtimeInputs = [
        k3d
      ];
      text = ''
        k3d cluster create -c ${./demand-shaping-cluster.yaml}
      '';
    })

    (writeShellApplication {
      name = "setup-demand-shaping-cluster";
      runtimeInputs = [
        helmfile
        kubectl
      ];
      text =
        let
          mkApply =
            step:
            "helmfile apply -f \"\$FLAKE_ROOT/demand-shaping-k8s/cluster-config/${step}.helmfile.yaml.gotmpl\"";
        in
      ''
        bash "$FLAKE_ROOT/demand-shaping-k8s/cluster-config/scripts/setup_crds.sh"

        ${mkApply "10_setup"}
        ${mkApply "20_scaling"}
        ${mkApply "25_scaling"}
        ${mkApply "30_kepler"}
        ${mkApply "40_demand_shaping"}
        ${mkApply "45_demand_shaping"}
      '';
    })

    (writeShellApplication {
      name = "build-and-publish-queue-tool";
      text =
        let
          imageRepo = "ghcr.io/bluehands/kubernetes-queue-tool:latest";
        in
      ''
        docker build "$FLAKE_ROOT/demand-shaping-k8s/tools/QueueTool" -t ${imageRepo}
        docker push ${imageRepo}
      '';
    })

    (writeShellApplication {
      name = "build-static-queue-tool";
      runtimeInputs = [
        dotnet-sdk_9
      ];
      text =
        let
          osList = [
            "linux"
            "win"
            "osx"
          ];
          archList = [
            "x64"
            "arm64"
          ];
          build =
            { os, arch }:
            let
              fileExt = if os == "win" then ".exe" else "";
            in
            ''
              dotnet build \
                -c Release \
                --os ${os} --arch ${arch} \
                --self-contained true \
                -p:PublishTrimmed=true \
                "$FLAKE_ROOT/demand-shaping-k8s/tools/QueueTool/QueueTool.csproj"
              cp -v "$FLAKE_ROOT/demand-shaping-k8s/tools/QueueTool/bin/Release/net8.0/${os}-${arch}/queue-tool${fileExt}" "$FLAKE_ROOT/demand-shaping-k8s/workshop/tools/queue-tool-${os}-${arch}${fileExt}"
            '';
          buildCommands =
            lib.mapCartesianProduct
            build
            {
              os = osList;
              arch = archList;
            };
          buildCommandsScript = lib.concatStringsSep "\n" buildCommands;
        in
      ''
        mkdir -p "$FLAKE_ROOT/demand-shaping-k8s/workshop/tools"
        ${buildCommandsScript}
      '';
    })
  ];

  shellHook = ''
    export FLAKE_ROOT="$(pwd)"
  '';
}
