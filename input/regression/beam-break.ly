
\header {
    texidoc = "Beams can be printed across line breaks if forced.
"

}
\version "1.9.2"
    \paper { raggedright= ##t }

\score { \notes \relative c''  {
    \property Score.forbidBeamBreak = ##f
    c2. c8[ c8 \break c8 c8]   } }
