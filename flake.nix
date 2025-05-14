{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            imagemagick
            ghostscript
            typst
            typstyle
            gnumake
            entr
            git
          ];

          shellHook = ''
            echo `${pkgs.typst}/bin/typst --version`
          '';
        };
      });
}
