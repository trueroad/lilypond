\header  {
  texidoc = "grace notes in different voices/staffs are synchronized."
}

\score  {\notes < \context Staff  { c2
 \ngrace  c8
 c2 c4 }
		\context Staff = SB { c2 \clef bass
 %\ngrace { [dis8 ( d8] }

  ) c2 c4 }
		\context Staff = SC { c2 c2 c4 }
		>
		\paper { linewidth = -1. }
 } 
