

;;
;; (name . (glyph clef-position octavation))
;; -- the name clefOctavation is misleading the value 7 is 1 octave not 7 Octaves.
;;
(define supported-clefs '(
	  ("treble" . ("clefs-G" -2 0))
	  ("violin" . ("clefs-G" -2 0))
	  ("G" . ("clefs-G" -2 0))
	  ("G2" . ("clefs-G" -2 0))
	  ("french" . ("clefs-G" -4  0))
	  ("soprano" . ("clefs-C" -4  0))
	  ("mezzosoprano" . ("clefs-C" -2  0))
	  ("alto" . ("clefs-C" 0 0))
	  ("tenor" . ("clefs-C" 2 0))
	  ("baritone" . ("clefs-C" 4  0))
	  ("varbaritone"  . ("clefs-F" 0 0))
	  ("bass" . ("clefs-F" 2  0))
	  ("F" . ( "clefs-F" 2 0))
	  ("subbass" . ("clefs-F" 4 0))
	  ("none" . ("" 0 0))

	  ;; should move mensural stuff to separate file? 
	  ("vaticana_do1" . ("clefs-vaticana_do" -1 0))
	  ("vaticana_do2" . ("clefs-vaticana_do" 1 0))
	  ("vaticana_do3" . ("clefs-vaticana_do" 3 0))
	  ("vaticana_fa1" . ("clefs-vaticana_fa" -1 0))
	  ("vaticana_fa2" . ("clefs-vaticana_fa" 1 0))
	  ("medicaea_do1" . ("clefs-medicaea_do" -1 0))
	  ("medicaea_do2" . ("clefs-medicaea_do" 1 0))
	  ("medicaea_do3" . ("clefs-medicaea_do" 3 0))
	  ("medicaea_fa1" . ("clefs-medicaea_fa" -1 0))
	  ("medicaea_fa2" . ("clefs-medicaea_fa" 1 0))
	  ("hufnagel_do1" . ("clefs-hufnagel_do" -1 0))
	  ("hufnagel_do2" . ("clefs-hufnagel_do" 1 0))
	  ("hufnagel_do3" . ("clefs-hufnagel_do" 3 0))
	  ("hufnagel_fa1" . ("clefs-hufnagel_fa" -1 0))
	  ("hufnagel_fa2" . ("clefs-hufnagel_fa" 1 0))
	  ("hufnagel_do_fa" . ("clefs-hufnagel_do_fa" 4 0))
	  ("mensural1_c1" . ("clefs-mensural1_c" -4 0))
	  ("mensural1_c2" . ("clefs-mensural1_c" -2 0))
	  ("mensural1_c3" . ("clefs-mensural1_c" 0 0))
	  ("mensural1_c4" . ("clefs-mensural1_c" 2 0))
	  ("mensural2_c1" . ("clefs-mensural2_c" -4 0))
	  ("mensural2_c2" . ("clefs-mensural2_c" -2 0))
	  ("mensural2_c3" . ("clefs-mensural2_c" 0 0))
	  ("mensural2_c4" . ("clefs-mensural2_c" 2 0))
	  ("mensural2_c5" . ("clefs-mensural2_c" 4 0))
	  ("mensural3_c1" . ("clefs-mensural3_c" -2 0))
	  ("mensural3_c2" . ("clefs-mensural3_c" 0 0))
	  ("mensural3_c3" . ("clefs-mensural3_c" 2 0))
	  ("mensural3_c4" . ("clefs-mensural3_c" 4 0))
	  ("mensural1_f" . ("clefs-mensural1_f" 2 0))
	  ("mensural2_f" . ("clefs-mensural2_f" 2 0))
	  ("mensural_g" . ("clefs-mensural_g" -2 0))
	)
)

(define (clef-name-to-properties cl)
  (let ((e '())
	(oct 0)
	(l (string-length cl))
	)

    ;; ugh. cleanme
    (if (equal? "8" (substring cl (- l 1) l))
	(begin
	(if (equal? "^" (substring cl (- l 2) (- l 1)))
	    (set! oct 7)
	    (set! oct -7))
	
	(set! cl (substring cl 0 (- l 2)))))


    (set! e  (assoc cl supported-clefs))
    (if (pair? e)
	`(((symbol . clefGlyph)
	   (iterator-ctor . ,Property_iterator::constructor)
	   (value . ,(cadr e))
	   )
	  
;	  ((symbol . forceClef)
;	   (iterator-ctor . ,Property_iterator::constructor)
;	   (value . #t)
;	   )

	  ((symbol . clefPosition)
	   (iterator-ctor . ,Property_iterator::constructor)
	   (value . ,(caddr e))
	   )
	  ,(if (not (equal? oct 0))
	       `((symbol . clefOctavation)
		 (iterator-ctor . ,Property_iterator::constructor)
		 (value . ,oct)
	       ))
	  )
	(begin
	  (ly-warn (string-append "Unknown clef type `" cl "'\nSee scm/lily.scm for supported clefs"))
	  '())
    )))


