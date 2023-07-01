with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "readers";
  src = ./.;
  phases = [
    "unpackPhase"
    "buildPhase"
    "installPhase"
  ];
  buildPhase = ''
    emacs --batch -Q --eval '(org-babel-load-file "project.org")'
  '';
  installPhase = ''
    mkdir -p $out
    cp -r ./public/* $out
    mkdir -p $out/debug
    cp ./texts/*.tex $out/debug
  '';

  buildInputs = [
    emacs # org mode
    git # required by emacs when using nix-build rather than nix-shell
    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        # required
        plain # "base" package on texlive
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
        # atbegshi-ltx # in plain
        rerunfilecheck
        uniquecounter
        l3backend
        epstopdf-pkg
        latexconfig
        # texmf-var # in pdftex
        # pdftex in schema-infraonly
        cm-super
        # second run:
        # scheme-infraonly # contains: mktexlsr, etc. # not enough: missing pdflatex
        # scheme-minimal # note enough: missing pdflatex
        scheme-basic # contains: pdflatex

        # other
        # texliveonfly # use to see which packages are needed
      ;
    })
  ];
}
