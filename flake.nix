{
  description = "Kargo demo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    crane.url = "github:ipetkov/crane";
    nix2container.url = "github:nlewo/nix2container";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    crane,
    nix2container,
    ...
  }: (flake-utils.lib.eachDefaultSystem (system: let
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (pkgs) lib;
    craneLib = crane.mkLib pkgs;
    nix2containerPkgs = nix2container.packages.x86_64-linux;
  in rec {
    packages.default = craneLib.buildPackage {
      src = ./.;
      strictDeps = true;
      meta.mainProgram = "demo";
    };

    packages.container = nix2containerPkgs.nix2container.buildImage {
      name = "ghcr.io/cfi2017/kargo-demo/server";
      config = {
        entrypoint = ["${packages.default}/bin/demo"];
        exposedPorts = {
          # as required by the OCI spec
          "3000/tcp" = {};
        };
      };
    };

    checks = {
      build = packages.default;
      rustfmt = craneLib.cargoFmt {src = ./.;};
    };

    devShells.default = craneLib.devShell {
      inherit checks;
      propagatedBuildInputs = [packages.default.cargoArtifacts];
      packages = with pkgs; [
        clippy
        rust-analyzer
      ];
    };
  }));
}
