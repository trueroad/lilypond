/*
  This file is part of LilyPond, the GNU music typesetter.

  Copyright (C) 1999--2015 Han-Wen Nienhuys <hanwen@xs4all.nl>

  LilyPond is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  LilyPond is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with LilyPond.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "change-iterator.hh"
#include "context.hh"
#include "direction.hh"
#include "international.hh"
#include "music.hh"
#include "music-wrapper-iterator.hh"

class Auto_change_iterator : public Music_wrapper_iterator
{
public:
  DECLARE_SCHEME_CALLBACK (constructor, ());

  Auto_change_iterator ();

protected:
  virtual void do_quit ();
  virtual void construct_children ();
  virtual void process (Moment);
  vector<Pitch> pending_pitch (Moment) const;
private:
  SCM split_list_;
  Direction where_dir_;

  Context_handle up_;
  Context_handle down_;
};

void
Auto_change_iterator::process (Moment m)
{
  Music_wrapper_iterator::process (m);

  Moment *splitm = 0;

  for (; scm_is_pair (split_list_); split_list_ = scm_cdr (split_list_))
    {
      splitm = unsmob<Moment> (scm_caar (split_list_));
      if (*splitm > m)
        break;

      SCM tag = scm_cdar (split_list_);
      Direction d = to_dir (tag);

      if (d && d != where_dir_)
        {
          where_dir_ = d;
          string to_id = (d >= 0) ? "up" : "down";
          // N.B. change_to() returns an error message. Silence is the legacy
          // behavior here, but maybe that should be changed.
          Change_iterator::change_to (*child_iter_,
                                      ly_symbol2scm ("Staff"),
                                      to_id);
        }
    }
}

Auto_change_iterator::Auto_change_iterator ()
{
  where_dir_ = CENTER;
  split_list_ = SCM_EOL;
}

void
Auto_change_iterator::construct_children ()
{
  split_list_ = get_music ()->get_property ("split-list");

  SCM props = get_outlet ()->get_property ("trebleStaffProperties");
  Context *up = get_outlet ()->find_create_context (ly_symbol2scm ("Staff"),
                                                    "up", props);

  props = get_outlet ()->get_property ("bassStaffProperties");
  Context *down = get_outlet ()->find_create_context (ly_symbol2scm ("Staff"),
                                                      "down", props);

  up_.set_context (up);
  down_.set_context (down);

  Context *voice = up->find_create_context (ly_symbol2scm ("Voice"),
                                            "", SCM_EOL);
  set_context (voice);
  Music_wrapper_iterator::construct_children ();
}

void
Auto_change_iterator::do_quit ()
{
  up_.set_context (0);
  down_.set_context (0);
}

IMPLEMENT_CTOR_CALLBACK (Auto_change_iterator);
