{
  description = "Kargo demo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    crane.url = "github:ipetkov/crane";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    crane,
    ...
  }: (flake-utils.lib.eachDefaultSystem (system: let
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (pkgs) lib;
    craneLib = crane.mkLib pkgs;
  in rec {
    packages.default = craneLib.buildPackage {
      src = ./.;
      strictDeps = true;
      meta.mainProgram = "demo";
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
