
slashSeparator = \markup {
    \hcenter
    \vcenter \combine
      \beam #2.0 #0.5 #0.48
      \raise #0.7 \beam #2.0 #0.5 #0.48
  }

bookTitleMarkup = \markup {

  \column {
    \fill-line { \fromproperty #'header:dedication }
    \fill-line {
      \huge \bigger \bigger \bigger \bold \fromproperty #'header:title
    }
    \fill-line {
      \override #'(baseline-skip . 3)
      \column {
	\fill-line {
	  \huge \bigger \bigger
	  \bold \fromproperty #'header:subtitle
	}
	\fill-line {
	  \huge \bigger
	  \bold \fromproperty #'header:subsubtitle
	}
      }
    }
    \fill-line {
      \fromproperty #'header:poet
      \fromproperty #'header:instrument 
      \column {
	\fromproperty #'header:composer
	\fromproperty #'header:arranger
      }
    }
  }

}

scoreTitleMarkup = \markup {
  \fill-line {
    \fromproperty #'header:piece
    \fromproperty #'header:opus
  }
}


oddHeaderMarkup = \markup
\fill-line {
  ""
  \fromproperty #'header:instrument
  \fromproperty #'page:page-number-string
}

evenHeaderMarkup = \markup
\fill-line {
  \fromproperty #'page:page-number-string
  \fromproperty #'header:instrument
  ""
}

oddFooterMarkup = \markup {
  \column {
    \fill-line {

      % put copyright only on pagenr. 1 
      \on-the-fly #(lambda (layout props arg)
		    (if (= 1 (chain-assoc-get 'page:page-number props   -1))
		     (interpret-markup layout props arg)
		     empty-stencil
		   ))
      \fromproperty #'header:copyright
    }
    \fill-line {
      % put tagline only on last page
      \on-the-fly #(lambda (layout props arg)
		    (if (chain-assoc-get 'page:last?  props #f)
		     (interpret-markup layout props arg)
		     empty-stencil
		   ))
      \fromproperty #'header:tagline
    }
  }
}


