%% Do not edit this file; it is auto-generated from input/new
%% This file is in the public domain.
\version "2.12.0"
\header {
  texidoces = "
Las marcas de cesura se pueden crear sobreescribiendo la propiedad
@code{'text} del objeto @code{BreathingSign}.  También está disponible
una marca de cesura curva.

"
  doctitlees = "Insertar una cesura"
  
%% Translation of GIT committish :<6ce7f350682dfa99af97929be1dec6b9f1cbc01a>
 texidocde = "
Zäsurzeichen können erstellt werden, indem die @code{'text}-Eigenschaft
des @code{BreathingSign}-Objektes verändert wird.  Ein gekrümmtes
Zäsurzeichen ist auch möglich.
"
  doctitlede = "Eine Zäsur einfügen"

  lsrtags = "expressive-marks,tweaks-and-overrides"
  texidoc = "
Caesura marks can be created by overriding the @code{'text}
property of the @code{BreathingSign} object.  A curved caesura
mark is also available.
"
  doctitle = "Inserting a caesura"
} % begin verbatim


\relative c'' {
  \override BreathingSign #'text = \markup {
    \musicglyph #"scripts.caesura.straight"
  }
  c8 e4. \breathe g8. e16 c4

  \override BreathingSign #'text = \markup {
    \musicglyph #"scripts.caesura.curved"
  }
  g8 e'4. \breathe g8. e16 c4
}
