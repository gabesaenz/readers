{
  description = "";

  outputs = { self, nixpkgs }: {

    packages.x86_64-darwin.report = (
      let
        system = "x86_64-darwin";
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.stdenvNoCC.mkDerivation {
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

              # other
              # texliveonfly # use to see which packages are needed
              # tlmgr can be used to find which texlive package contains required files
              # currently, this must be done using an external installation of texlive
              # for example: tlmgr info what_you're_looking_for
              ;
            })
          ];
        }
    );
    defaultPackage.x86_64-darwin = self.packages.x86_64-darwin.report;
  };
}
