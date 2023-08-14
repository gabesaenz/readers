# Chrome, Chromium or Edge are required as well
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachSystem utils.lib.allSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
        base = with pkgs; [
          mdbook
          mdbook-epub # required for [output.epub]
          mdbook-pdf # required for [output.pdf]
        ];
        chrome = with pkgs; [ chromium ];
      in {
        defaultPackage = pkgs.stdenvNoCC.mkDerivation {
          name = "peter-rabbit";
          src = ./.;
          phases = [ "unpackPhase" "buildPhase" "installPhase" ];
          buildPhase = ''
            alias chrome="chromium"
            mdbook build
          '';
          installPhase = ''
            mkdir $out
            cp -r book/* $out
          '';

          buildInputs =
            if system != "x86_64-darwin" then [ base chrome ] else [ base ];
          # if system != "x86_64-darwin" then [ base ] else [ base ];
        };
      });
}
