/*
  midi-def.cc -- implement Midi_def

  source file of the GNU LilyPond music typesetter

  (c) 1997 Jan Nieuwenhuizen <jan@digicash.com>

*/
#include <math.h>
#include "misc.hh"
#include "midi-def.hh"
#include "translator.hh"
#include "performance.hh"
#include "assoc-iter.hh"
#include "score-performer.hh"
#include "debug.hh"

// classes, alphasorted
//     statics
//     constructors
//     destructor
//     routines, alphasorted

Midi_def::Midi_def()
{
  outfile_str_ = ""; 
  // ugh
  set_tempo (Moment (1, 4), 60);
}

Midi_def::~Midi_def()
{
}

Real
Midi_def::duration_to_seconds_f (Moment mom)
{
  if (!mom)
    return 0;
  
  return Moment (whole_in_seconds_mom_) * mom;
}


int
Midi_def::get_tempo_i (Moment one_beat_mom)
{
  Moment wholes_per_min = Moment(60) /Moment(whole_in_seconds_mom_);
  int beats_per_min = wholes_per_min / one_beat_mom;
  return int (beats_per_min);
}

void
Midi_def::set_tempo (Moment one_beat_mom, int beats_per_minute_i)
{
  Moment beats_per_second = Moment (beats_per_minute_i) / Moment (60);
  whole_in_seconds_mom_ = 1/(beats_per_second * one_beat_mom);
}

void
Midi_def::print() const
{
#ifndef NPRINT
  DOUT << "Midi {";
  DOUT << "4/min: " << Real (60) / (whole_in_seconds_mom_ * 4);
  DOUT << "out: " << outfile_str_;
  DOUT << "}\n";
#endif
}


IMPLEMENT_IS_TYPE_B1(Midi_def, Music_output_def);
