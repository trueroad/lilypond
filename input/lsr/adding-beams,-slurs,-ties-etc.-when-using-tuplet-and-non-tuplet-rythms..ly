%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.12.0"

\header {
  lsrtags = "rhythms, expressive-marks"

  texidoces = "
La sintaxis de LilyPond puede implicar muchas colocaciones poco
comunes para los paréntesis, corchetes, etc, que a veces se tienen
que intercalar. Por ejemplo, al introducir una barra manual, el
corchete izquierdo de apertura se debe escribir después de la nota
inicial y de su duración, no antes. De forma similar, el corchete
derecho de cierre debe seguir inmediatamente a la nota que se
quiere situar al final del barrado, incluso si esta nota resulta
estar dentro de un grupo de valoración especial. Este fragmento de
código muestra cómo combinar el barrado manual, las ligaduras de
expresión y de unión y las ligaduras de fraseo, con secciones de
valoración especial (encerradas entre llaves).

"
  doctitlees = "Añadir barras, ligaduras de expresión y de unión, etc. cuando se usan ritmos con y sin grupos de valoración especial."

  texidoc = "
LilyPond syntax can involve many unusual placements for parentheses,
brackets etc., which might sometimes have to be interleaved. For
example, when entering a manual beam, the left square bracket has to be
placed after the starting note and its duration, not before. Similarly,
the right square bracket should directly follow the note which is to be
at the end of the requested beaming, even if this note happens to be
inside a tuplet section. This snippet demonstrates how to combine
manual beaming, manual slurs, ties and phrasing slurs with tuplet
sections (enclosed within curly braces). 

"
  doctitle = "Adding beams, slurs, ties etc. when using tuplet and non-tuplet rythms."
} % begin verbatim

{
  r16[ g16 \times 2/3 { r16 e'8] }
  g16( a \times 2/3 { b d e') }
  g8[( a \times 2/3 { b d') e']~ }
  \time 2/4
  \times 4/5 { e'32\( a b d' e' } a'4.\)
}
