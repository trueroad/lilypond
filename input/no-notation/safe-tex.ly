\version "2.1.16"

\header{
    
    texidoc = "This should not survive lilypond --safe-mode --no-pdf --png
    run, and certainly not write /tmp/safe-tex.tex"

    % beware
    % openout_any=y lilypond --keep --safe-mode -S latexoptions=']{article}
    % \let\nofiles\relax%' input/no-notation/safe-tex.ly

}

\score{
    \notes c''-"\\newwrite\\barf\\immediate\\openout\\barf=/tmp/safe-tex.tex\\immediate\\write\\barf{hallo}"
}
