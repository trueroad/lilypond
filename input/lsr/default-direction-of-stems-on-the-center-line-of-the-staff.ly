%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.49"

\header {
  lsrtags = "editorial-annotations"

  texidoc = "
The default direction of stems on the center line of the staff is set
by the @code{Stem} property @code{neutral-direction}.

"
  doctitle = "Default direction of stems on the center line of the staff"
} % begin verbatim
\relative c'' {
  a4 b c b
  \override Stem #'neutral-direction = #up
  a4 b c b
  \override Stem #'neutral-direction = #down
  a4 b c b
}
