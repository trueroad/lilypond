/*
  inputmusic.hh -- part of LilyPond

  (c) 1996,97 Han-Wen Nienhuys
*/

#ifndef INPUTMUSIC_HH
#define INPUTMUSIC_HH

#include "plist.hh"
#include "proto.hh"
#include "voice.hh"
#include "moment.hh"

struct Voice_list : public PointerList<Voice*> {
    void translate_time(Moment dt);
};

/// ABC for input structures
struct Input_music {
    virtual Voice_list convert()const=0;
    virtual Moment length()const=0;
    virtual void translate_time(Moment dt)=0;
    virtual ~Input_music(){}
    virtual void print() const =0;
    virtual void set_default_group(String)=0;
    // virtual void transpose(...) const =0;
    
    
    virtual Input_music *clone() const = 0;
    virtual Simple_music *simple() { return 0; }
};
/**

  Input_music is anything that can simply be regarded as/converted to
  a set of voices "cooperating" or independant. It has some basic
  characteristics that real music has too:

  - it is rhythmic (it has a length, and can be translated horizontally)
  - a pitch (it can be transposed)

  */


/// Simple music consists of one voice
struct Simple_music : Input_music {
    Voice voice_;

    /****/
    virtual Simple_music*simple() { return this; }  
    void add(Voice_element*);
    virtual void set_default_group(String g) { voice_.set_default_group(g); }
    virtual Moment length()const;
    virtual Voice_list convert()const;
    virtual void translate_time(Moment dt);
    virtual void print() const;
    virtual Input_music *clone() const {
	return new Simple_music(*this);
    }

};

/// Complex_music consists of multiple voices
struct Complex_music : Input_music {
    IPointerList<Input_music*> elts;
    /****************/
    virtual void set_default_group(String g);
    void add(Input_music*);
    Complex_music();
    Complex_music(Complex_music const &);
    virtual void print() const ;
    void concatenate(Complex_music*);
 
};

/// multiple stuff  after each other
struct Music_voice : Complex_music {
 
    
    /****************/
    Moment length()const;
    virtual void translate_time(Moment dt);
    virtual Voice_list convert()const;
    void add_elt(Voice_element*);
    virtual Input_music *clone() const {
	return new Music_voice(*this);
    }
    virtual void print() const ;
};
/**
  voice like.

  different music forms which start after each other ( concatenated,
  stacked "horizontally )
 
 */

/// Multiple musicstuff stacked on top of each other
struct Music_general_chord : Complex_music {


    /****************/

    virtual Moment length()const;
    virtual Voice_list convert()const;
    virtual void translate_time(Moment dt);
    void add_elt(Voice_element*);
    virtual Input_music *clone() const {
	return new Music_general_chord(*this);
    }
    
    virtual void print() const ;
};
/**
  chord like :

  - different music forms which start at the same time ( stacked "vertically" )
  
  */

struct Multi_voice_chord : Music_general_chord {
    void set_default_group(String);
    virtual Input_music *clone() const {
	return new Multi_voice_chord(*this);
    }
};
struct Voice_group_chord : Music_general_chord {

    virtual Input_music *clone() const {
	return new Voice_group_chord(*this);
    }
};
#endif // INPUTMUSIC_HH
