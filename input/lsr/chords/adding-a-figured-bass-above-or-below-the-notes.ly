%%  Do not edit this file; it is auto-generated from LSR!
\version "2.10.12"

\header { texidoc = "
When writing a figured bass, here's a way to specify if you want your
figures to be placed above or below the bass notes, by defining the
BassFigureAlignmentPositioning #'direction property (exclusively in a
Staff context). Choices are #UP (or #1), #CENTER (or #0) and #DOWN (or
#-1).

As you can see here, this property can be changed as many times as you
wish. Use \\once \\override if you dont want the tweak to apply to the
whole score.
" }

bass = { \clef bass g4 b, c d e d8 c d2}
continuo = \figuremode {
         < _ >4 < 6 >8   
   \once \override Staff.BassFigureAlignmentPositioning #'direction = #CENTER
         <5/>  < _ >4 
   \override Staff.BassFigureAlignmentPositioning #'direction = #UP
         < _+ > < 6 >
   \set Staff.useBassFigureExtenders = ##t
   \override Staff.BassFigureAlignmentPositioning #'direction = #DOWN
         < 4 >4. < 4 >8 < _+ >4
       } 
\score {
    << \new Staff = bassStaff \bass 
    \context Staff = bassStaff \continuo >>
}

