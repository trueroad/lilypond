/*
  beam.hh -- part of GNU LilyPond

  (c) 1996,97 Han-Wen Nienhuys
*/

#ifndef BEAM_HH
#define BEAM_HH
#include "lily-proto.hh"
#include "directional-spanner.hh"
#include "plist.hh"

/** a beam connects multiple stems Beam adjusts the stems its owns to
  make sure that they reach the beam and that point in the correct
  direction */
class Beam:  public Directional_spanner {
public:
  enum Pos { NONE, SIT = 1, STRADDLE = 2, HANG = 4, INTER = 8 };

  Link_array<Stem> stems;
  /// the slope of the beam in posns / point (dimension)   
  Real slope_f;

  /// position of leftmost end of beam  
  Real left_y;
   

  /* *************** */
  DECLARE_MY_RUNTIME_TYPEINFO;
  Beam();
  void add (Stem*);

  void set_grouping (Rhythmic_grouping def, Rhythmic_grouping current);
  void set_stemlens ();
  SCORE_ELEM_CLONE (Beam);

protected:
  virtual Interval do_width () const;    
  Offset center () const;
  void set_default_dir ();
  virtual void do_pre_processing ();
  virtual void do_post_processing ();
  virtual void do_substitute_dependent (Score_elem*, Score_elem*);

  virtual void do_print() const;

  virtual void quantise_left_y (Beam::Pos pos, bool extend_b);
  virtual Molecule stem_beams (Stem *here, Stem *next, Stem *prev) const;
  virtual void solve_slope ();
  virtual void quantise_yspan ();
  virtual Molecule*brew_molecule_p () const;
};

#endif // BEAM_HH

