/*
  paper-def.cc -- implement Paper_def

  source file of the GNU LilyPond music typesetter

  (c)  1997--2002 Han-Wen Nienhuys <hanwen@cs.uu.nl>
*/

#include <math.h>

#include "all-font-metrics.hh"
#include "string.hh"
#include "misc.hh"
#include "paper-def.hh"
#include "warn.hh"
#include "scaled-font-metric.hh"
#include "main.hh"
#include "scm-hash.hh"
#include "input-file-results.hh" // urg? header_global
#include "paper-outputter.hh"

/*
  This is an almost empty thing. The only substantial thing this class
  handles, is scaling up and down to real-world dimensions (internally
  dimensions are against global staff-space.)
  
 */
Paper_def::Paper_def ()
{
}

Paper_def::~Paper_def ()
{
}

Paper_def::Paper_def (Paper_def const&src)
  : Music_output_def (src)
{
}


Real
Paper_def::get_var (String s) const
{
  return get_realvar (ly_symbol2scm (s.to_str0 ()));
}

SCM
Paper_def::get_scmvar (String s) const
{
  return variable_tab_->get (ly_symbol2scm (s.to_str0 ()));
}


SCM
Paper_def::get_scmvar_scm (SCM sym) const
{
  return  gh_double2scm (get_realvar (sym));
}

Real
Paper_def::get_realvar (SCM s) const
{
  SCM val ;
  if (!variable_tab_->try_retrieve (s, &val))
    {
      programming_error ("unknown paper variable: " +  ly_symbol2string (s));
      return 0.0;
    }

  Real sc = 1.0;
  SCM ssc;
  if (variable_tab_->try_retrieve (ly_symbol2scm ("outputscale"), &ssc))
    {
      sc = gh_scm2double (ssc);
    }
  if (gh_number_p (val))
    {
      return gh_scm2double (val) / sc;
    }
  else
    {
      programming_error ("not a real variable");
      return 0.0;
    }
}

/*
  FIXME. This is broken until we have a generic way of
  putting lists inside the \paper block.
 */
Interval
Paper_def::line_dimensions_int (int n) const
{
  Real lw =  get_var ("linewidth");
  Real ind = n? 0.0:get_var ("indent");

  return Interval (ind, lw);
}



int Paper_def::score_count_ = 0;

int
Paper_def::get_next_score_count () const
{
  return score_count_ ++;
}

void
Paper_def::reset_score_count ()
{
  score_count_ = 0;
}


Paper_outputter*
Paper_def::get_paper_outputter () 
{
  String outname = outname_string (); 
  progress_indication (_f ("paper output to `%s'...",
			   outname == "-" ? String ("<stdout>") : outname));

  global_input_file->target_strings_.push (outname);
  Paper_outputter * po = new Paper_outputter (outname);
  Path p = split_path (outname);
  p.ext = "";
  po->basename_ = p.string ();
  return po;
}


/*
  todo: use symbols and hashtable idx?
*/
Font_metric *
Paper_def::find_font (SCM fn, Real m)
{
  SCM key = gh_cons (fn, gh_double2scm (m));
  SCM met = scm_assoc (key, scaled_fonts_);

  if (gh_pair_p (met))
    return unsmob_metrics (ly_cdr (met));

  SCM ssc;
  if (variable_tab_->try_retrieve (ly_symbol2scm ("outputscale"), &ssc))
    {
      m /= gh_scm2double (ssc);
    }
  
  Font_metric*  f = all_fonts_global->find_font (ly_scm2string (fn));
  SCM val = Scaled_font_metric::make_scaled_font_metric (f, m);
  scaled_fonts_ = scm_acons (key, val, scaled_fonts_);

  scm_gc_unprotect_object (val);

  return dynamic_cast<Scaled_font_metric*> (unsmob_metrics (val));
}


/*
  Return alist to translate internally used fonts back to real-world
  coordinates.  */
SCM
Paper_def::font_descriptions ()const
{
  SCM l = SCM_EOL;
  for (SCM s = scaled_fonts_; gh_pair_p (s); s = ly_cdr (s))
    {
      SCM desc = ly_caar (s);
      SCM mdesc = unsmob_metrics (ly_cdar (s))->description_;

      l = gh_cons (gh_cons (mdesc, desc), l);
    }
  return l;
}
