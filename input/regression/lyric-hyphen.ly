\version "1.9.2"
\header {texidoc="Tests lyric hyphens. "}
\score{
	<
	\context Staff \notes { c' (c') (c') c' }
	\context Lyrics \context LyricsVoice \lyrics { bla -- alb xxx -- yyy }
	>
}






