/*
  hyphen-spanner.hh -- part of GNU LilyPond

  (c) 1999 Glen Prideaux <glenprideaux@iname.com>
*/

#ifndef HYPHEN_SPANNER_HH
#define HYPHEN_SPANNER_HH

#include "spanner.hh"

/** 
  centred hyphen 

  A centred hyphen is a simple line between lyrics used to
  divide syllables.

  The length of the hyphen line should stretch based on the
  size of the gap between syllables.
  */
struct Hyphen_spanner // interface
{
public:
  Spanner* elt_l_;
  Hyphen_spanner  (Spanner*);
  void set_textitem (Direction, Item*);
  static SCM scheme_molecule (SCM);
};

#endif // HYPHEN_SPANNER_HH

