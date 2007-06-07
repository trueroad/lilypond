%%  Do not edit this file; it is auto-generated from LSR!
\version "2.11.23"

\header { texidoc = "
The \startTextSpan and \stopTextSpan commands give you the ability to
create text spanners as easily as pedals indications or octavations.
Override some properties of the TextSpanner object to modify its
output.
" }

\relative c''{
    \override TextSpanner  #'edge-text = #'("bla" . "blu")
    a \startTextSpan
    b c 
    a \stopTextSpan

    \override TextSpanner  #'dash-period = #2
    \override TextSpanner  #'dash-fraction = #0.0
    a \startTextSpan
    b c 
    a \stopTextSpan

    \revert TextSpanner #'style
    \override TextSpanner  #'style = #'dashed-lineNone \override TextSpanner #'bound-details #'left #'text = \markup { \draw-line #'(0 . 1) }
None \override TextSpanner #'bound-details #'right #'text = \markup { \draw-line #'(0 . -2) }

    a \startTextSpan
    b c 
    a \stopTextSpan


    \set Staff.middleCPosition = #-13

    \override TextSpanner  #'dash-period = #10
    \override TextSpanner  #'dash-fraction = #.5
    \override TextSpanner  #'thickness = #10
    a \startTextSpan
    b c 
    a \stopTextSpan
    \set Staff.middleCPosition = #-6	
}

