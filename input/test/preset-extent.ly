\version "2.1.26"
\header { texidoc = "

@cindex Preset Extent

The object may be extended to larger sized by overriding their properties.
The lyrics in this example have an extent of @code{(-10,10)}, which is why 
they are spaced so widely.

"

}

\score {
    \context Lyrics \lyrics {
	foo --
	
	\override LyricText  #'X-extent = #'(-10.0 . 10.0)
 bar baz
	}
    \paper { raggedright = ##t}
}
    

