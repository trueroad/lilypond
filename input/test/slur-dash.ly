\version "2.1.30"
\header {texidoc = "@cindex Slur, dotted
The appearance of slurs may be changed from solid to dotted or dashed.
"
} 
\score{
	\notes{
		c( d e  c) |
		\slurDotted
		c( d e  c) |
		\slurSolid
		c( d e  c) |
		\override Slur  #'dashed = #0.0
		c( d e  c) |
		\slurSolid
		c( d e  c) |
	}
	\paper{ raggedright=##t }
%	      indent = 0.0\pt
		%for broken!
		% linewidth= 30.\mm
%	}
}



