{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachSystem utils.lib.allSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        defaultPackage = pkgs.stdenvNoCC.mkDerivation {
          name = "readers";
          src = ./.;
          phases = [
            "unpackPhase"
            "buildPhase"
            "installPhase"
          ];
          buildPhase = ''
            emacs --batch -Q -f toggle-debug-on-error --eval '(org-babel-load-file "project.org")'
          '';
          installPhase = ''
            mkdir -p $out
            cp -r ./public/* $out
            mkdir -p $out/debug
            cp -r ./debug/* $out/debug
          '';

          buildInputs = with pkgs; [
            emacs # org mode
            (texlive.combine {
              inherit (texlive)
              # required
              plain
              graphics
              graphics-cfg
              graphics-def
              tools
              wrapfig
              ulem
              amsmath
              amsfonts
              capt-of
              hyperref
              ltxcmds
              iftex
              pdftexcmds
              infwarerr
              kvsetkeys
              kvdefinekeys
              pdfescape
              hycolor
              letltxmacro
              auxhook
              refcount
              gettitlestring
              kvoptions
              intcalc
              etexcmds
              url
              bitset
              bigintcalc
              rerunfilecheck
              uniquecounter
              l3backend
              epstopdf-pkg
              latexconfig
              cm-super
              latex-bin # contains: pdflatex
              texlive-scripts
              ec # default fonts, probably not necessary if other fonts are used

              # scrbook class
              koma-script
              bookmark # required by scrbook

              # drop caps
              lettrine
              xkeyval # required by lettrine
              minifp # required by lettrine
              # another package to try:
              # dropping

              # xelatex latex compiler
              xetex

              # other
              texliveonfly # use to see which packages are needed
              # Running the build with these flags is also helpful for finding missing package names:
              # nix build --keep-failed --print-build-logs
              # tlmgr can be used to find which texlive package contains required files
              # currently, this must be done using an external installation of texlive
              # for example: tlmgr info what_you're_looking_for
              ;
            })
          ];
        };
      });
}
