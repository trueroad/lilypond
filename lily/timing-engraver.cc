/*
  timing-grav.cc -- implement Timing_engraver

  source file of the GNU LilyPond music typesetter

  (c)  1997--2000 Han-Wen Nienhuys <hanwen@cs.uu.nl>
*/

#include "translator-group.hh"
#include "command-request.hh"
#include "score-element-info.hh"
#include "multi-measure-rest.hh"
#include "timing-translator.hh"
#include "engraver.hh"

/**
  Do time bookkeeping
 */
class Timing_engraver : public Timing_translator, public Engraver
{   
  Bar_req * bar_req_l_;
protected:
  virtual bool do_try_music (Music * );
  virtual void do_post_move_processing ();
  virtual void do_process_music ();
public:
  String which_bar (); 
  VIRTUAL_COPY_CONS(Translator);
};

ADD_THIS_TRANSLATOR(Timing_engraver);

void
Timing_engraver::do_post_move_processing( )
{
  bar_req_l_ = 0;
  Timing_translator::do_post_move_processing ();

  SCM nonauto = get_property ("barNonAuto");
  SCM which = now_mom () ? SCM_UNDEFINED : ly_str02scm ("|");
  
  if (which == SCM_UNDEFINED && !to_boolean (nonauto))
    {
      SCM always = get_property ("barAlways");
      if (!measure_position ()
	  || (to_boolean (always)))
	{
	  which=get_property ("defaultBarType" );
	}
    }

  daddy_trans_l_->set_property ("whichBar", which);
}

bool
Timing_engraver::do_try_music (Music*m)
{
  if (Bar_req  * b= dynamic_cast <Bar_req *> (m))
    {
      if (bar_req_l_ && !bar_req_l_->equal_b (b)) 
	return false;
      
      bar_req_l_ = b;
      return true;
    }
  
  return Timing_translator::do_try_music (m);
}

void
Timing_engraver::do_process_music ()
{
  if (bar_req_l_)
    daddy_trans_l_->set_property ("whichBar", bar_req_l_->get_mus_property ("type"));
}

