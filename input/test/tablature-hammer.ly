
\version "2.1.30"
\header {texidoc = "@cindex Tablature hammer
A hammer in tablature can be faked with slurs. "
} 

\score{
  \context TabStaff <<
	\notes\relative c''{
		c(d)
		d(d)
		d(c)
  }
  >>
	\paper{ raggedright = ##t}
}

