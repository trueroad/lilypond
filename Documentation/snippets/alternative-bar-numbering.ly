% DO NOT EDIT this file manually; it is automatically
% generated from Documentation/snippets/new
% Make any changes in Documentation/snippets/new/
% and then run scripts/auxiliar/makelsr.py
%
% This file is in the public domain.
%% Note: this file works from version 2.15.24
\version "2.15.24"

\header {
%% Translation of GIT committish:
  texidocfr = "
Deux méthodes alternatives vous permettent de gérer la numérotation ds
mesures en cas de reprises.

"
  doctitlefr = "Numérotation des mesures et alternatives"

  lsrtags = "editorial-annotations, staff-notation, tweaks-and-overrides"
  texidoc = "Two alternative methods for bar numbering can be set,
  especially for when using repeated music."
  doctitle = "Alternative bar numbering"
} % begin verbatim


\relative c'{
  \set Score.alternativeNumberingStyle = #'numbers
  \repeat volta 3 { c4 d e f | }
    \alternative {
      { c4 d e f | c2 d \break }
      { f4 g a b | f4 g a b | f2 a | \break }
      { c4 d e f | c2 d }
    }
  c1 \break
  \set Score.alternativeNumberingStyle = #'numbers-with-letters
  \repeat volta 3 { c,4 d e f | }
    \alternative {
      { c4 d e f | c2 d \break }
      { f4 g a b | f4 g a b | f2 a | \break }
      { c4 d e f | c2 d }
    }
  c1
}
