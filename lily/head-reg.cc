/*
  headreg.cc -- part of LilyPond

  (c) 1997 Han-Wen Nienhuys <hanwen@stack.nl>
*/

#include "notehead.hh"
#include "head-reg.hh"
#include "paper-def.hh"
#include "complex-walker.hh"
#include "musical-request.hh"

Notehead_register::Notehead_register()
{
    note_p_ = 0;
    post_move_processing();
}

bool
Notehead_register::try_request(Request *req_l) 
{
    if (req_l->note() || req_l->rest())
	note_req_l_=req_l->rhythmic();
    else
	return false;

    return true;
}

void
Notehead_register::process_requests()
{
    if (!note_req_l_)
	return;
    
    Notehead*n_p = new Notehead(8);	// ugh
    note_p_ = n_p;
    n_p->set_rhythmic(note_req_l_->rhythmic());

    if (note_req_l_->note()) {
	n_p->position_i_ = note_req_l_->note()->height() +
	    *get_staff_info().c0_position_i_l_;
    } else if (note_req_l_->rest()) {
	n_p->rest_b_ = true;
	if (note_req_l_->rhythmic()->duration_.type_i_ <= 2)
	    note_p_->translate(
		Offset(0,
		       6 * paper()->internote()));
    }
    
    Score_elem_info itinf(note_p_,note_req_l_);
    announce_element(itinf);
}

void
Notehead_register::pre_move_processing()
{
    if (note_p_) {
	typeset_element(note_p_);
	note_p_ = 0;
    }
}
void
Notehead_register::post_move_processing()
{
    note_req_l_ = 0;
}

IMPLEMENT_STATIC_NAME(Notehead_register);
ADD_THIS_REGISTER(Notehead_register);
