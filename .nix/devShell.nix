{ nixpkgs, ... }:
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
  };

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
  ];

  shellHook = ''
    export FLAKE_ROOT="$(pwd)"
  '';
}
