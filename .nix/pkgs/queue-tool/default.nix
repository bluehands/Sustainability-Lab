{ lib
, buildDotnetModule
}:
let
  inherit (lib)
    fileset
    sources
    ;
in
buildDotnetModule {
  name = "queue-tool";
  # version = "0.1";

  src =
    let
      srcPath = ../../../demand-shaping-k8s/tools/QueueTool;
    in
    fileset.toSource {
      root = srcPath;
      fileset = fileset.fromSource (sources.cleanSource srcPath);
    };

  projectFile = "QueueTool.csproj";
  nugetDeps = ./deps.json; # nix build .#xxxx.passthru.fetch-deps
  # dotnetInstallFlags = "-f net8.0";
}
