%% DO NOT EDIT this file manually; it is automatically
%% generated from Documentation/snippets/new
%% Make any changes in Documentation/snippets/new/
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
%% Note: this file works from version 2.19.28
\version "2.19.28"

\header {
  lsrtags = "chords, really-simple, template"

  texidoc = "
Want to prepare a lead sheet with a melody and chords? Look no further!


"
  doctitle = "Single staff template with notes and chords"
} % begin verbatim

melody = \relative c' {
  \clef treble
  \key c \major
  \time 4/4

  f4 e8[ c] d4 g
  a2 ~ a
}

harmonies = \chordmode {
  c4:m f:min7 g:maj c:aug
  d2:dim b4:5 e:sus
}

\score {
  <<
    \new ChordNames {
      \set chordChanges = ##t
      \harmonies
    }
    \new Staff \melody
  >>
  \layout{ }
  \midi { }
}
