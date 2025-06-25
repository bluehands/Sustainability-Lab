{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs: {
    devShells.x86_64-linux.default = import ./.nix/devShell.nix inputs;
  };
}
