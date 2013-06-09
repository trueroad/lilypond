;;;; This file is part of LilyPond, the GNU music typesetter.
;;;;
;;;; Copyright (C) 2003--2012 Han-Wen Nienhuys <hanwen@xs4all.nl>
;;;;
;;;; LilyPond is free software: you can redistribute it and/or modify
;;;; it under the terms of the GNU General Public License as published by
;;;; the Free Software Foundation, either version 3 of the License, or
;;;; (at your option) any later version.
;;;;
;;;; LilyPond is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.
;;;;
;;;; You should have received a copy of the GNU General Public License
;;;; along with LilyPond.  If not, see <http://www.gnu.org/licenses/>.

"
Internally markup is stored as lists, whose head is a function.

  (FUNCTION ARG1 ARG2 ... )

When the markup is formatted, then FUNCTION is called as follows

  (FUNCTION GROB PROPS ARG1 ARG2 ... )

GROB is the current grob, PROPS is a list of alists, and ARG1.. are
the rest of the arguments.

The function should return a stencil (i.e. a formatted, ready to
print object).


To add a markup command, use the define-markup-command utility.

  (define-markup-command (mycommand layout prop arg1 ...) (arg1-type? ...)
    \"my command usage and description\"
    ...function body...)

The command is now available in markup mode, e.g.

  \\markup { .... \\MYCOMMAND #1 argument ... }

" ; "

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; markup definer utilities

;; For documentation purposes
;; category -> markup functions
(define-public markup-functions-by-category (make-hash-table 150))
;; markup function -> used properties
(define-public markup-functions-properties (make-weak-key-hash-table 151))
;; List of markup list functions
(define-public markup-list-functions (make-weak-key-hash-table 151))

(use-modules (ice-9 optargs))

(defmacro*-public define-markup-command
  (command-and-args signature
                    #:key (category '()) (properties '())
                    #:rest body)
  "
* Define a COMMAND-markup function after command-and-args and body,
register COMMAND-markup and its signature,

* add COMMAND-markup to markup-functions-by-category,

* sets COMMAND-markup markup-signature object property,

* define a make-COMMAND-markup function.

Syntax:
  (define-markup-command (COMMAND layout props . arguments)
                                 argument-types
                                 [ #:properties properties ]
    \"documentation string\"
    ...command body...)

where:
  `argument-types' is a list of type predicates for arguments
  `properties' a list of (property default-value) lists

The specified properties are available as let-bound variables in the
command body, using the respective `default-value' as fallback in case
`property' is not found in `props'.  `props' itself is left unchanged:
if you want defaults specified in that manner passed down into other
markup functions, you need to adjust `props' yourself.

The autogenerated documentation makes use of some optional
specifications that are otherwise ignored:

After `argument-types', you may also specify
                                 [ #:category category ]
where:
  `category' is either a symbol or a symbol list specifying the
             category for this markup command in the docs.

As an element of the `properties' list, you may directly use a
COMMANDx-markup symbol instead of a `(prop value)' list to indicate
that this markup command is called by the newly defined command,
adding its properties to the documented properties of the new
command.  There is no protection against circular definitions.
"
  (let* ((command (car command-and-args))
         (args (cdr command-and-args))
         (command-name (string->symbol (format #f "~a-markup" command)))
         (make-markup-name (string->symbol (format #f "make-~a-markup" command))))
    (while (and (pair? body) (keyword? (car body)))
           (set! body (cddr body)))
    `(begin
       ;; define the COMMAND-markup function
       ,(let* ((documentation (if (string? (car body))
                                  (list (car body))
                                  '()))
               (real-body (if (or (null? documentation)
                                  (null? (cdr body)))
                              body (cdr body))))
          `(define-public (,command-name ,@args)
             ,@documentation
             (let ,(map (lambda (prop-spec)
                          (let ((prop (car prop-spec))
                                (default-value (if (null? (cdr prop-spec))
                                                   #f
                                                   (cadr prop-spec)))
                                (props (cadr args)))
                            `(,prop (chain-assoc-get ',prop ,props ,default-value))))
                        (filter pair? properties))
               ,@real-body)))
       (set! (markup-command-signature ,command-name) (list ,@signature))
       ;; Register the new function, for markup documentation
       ,@(map (lambda (category)
                `(hashq-set!
                  (or (hashq-ref markup-functions-by-category ',category)
                      (let ((hash (make-weak-key-hash-table 151)))
                        (hashq-set! markup-functions-by-category ',category
                                    hash)
                        hash))
                  ,command-name #t))
              (if (list? category) category (list category)))
       ;; Used properties, for markup documentation
       (hashq-set! markup-functions-properties
                   ,command-name
                   (list ,@(map (lambda (prop-spec)
                                  (cond ((symbol? prop-spec)
                                         prop-spec)
                                        ((not (null? (cdr prop-spec)))
                                         `(list ',(car prop-spec) ,(cadr prop-spec)))
                                        (else
                                          `(list ',(car prop-spec)))))
                                (if (pair? args)
                                    properties
                                    (list)))))
       ;; define the make-COMMAND-markup function
       (define-public (,make-markup-name . args)
         (let ((sig (list ,@signature)))
           (make-markup ,command-name ,(symbol->string make-markup-name) sig args))))))

(defmacro*-public define-markup-list-command
  (command-and-args signature #:key (properties '()) #:rest body)
  "Same as `define-markup-command', but defines a command that, when
interpreted, returns a list of stencils instead of a single one"
  (let* ((command (car command-and-args))
         (args (cdr command-and-args))
         (command-name (string->symbol (format #f "~a-markup-list" command)))
         (make-markup-name (string->symbol (format #f "make-~a-markup-list" command))))
    (while (and (pair? body) (keyword? (car body)))
           (set! body (cddr body)))
    `(begin
       ;; define the COMMAND-markup-list function
       ,(let* ((documentation (if (string? (car body))
                                  (list (car body))
                                  '()))
               (real-body (if (or (null? documentation)
                                  (null? (cdr body)))
                              body (cdr body))))
          `(define-public (,command-name ,@args)
             ,@documentation
             (let ,(map (lambda (prop-spec)
                          (let ((prop (car prop-spec))
                                (default-value (if (null? (cdr prop-spec))
                                                   #f
                                                   (cadr prop-spec)))
                                (props (cadr args)))
                            `(,prop (chain-assoc-get ',prop ,props ,default-value))))
                        (filter pair? properties))
               ,@real-body)))
       (set! (markup-command-signature ,command-name) (list ,@signature))
       ;; add the command to markup-list-function-list, for markup documentation
       (hashq-set! markup-list-functions ,command-name #t)
       ;; Used properties, for markup documentation
       (hashq-set! markup-functions-properties
                   ,command-name
                   (list ,@(map (lambda (prop-spec)
                                  (cond ((symbol? prop-spec)
                                         prop-spec)
                                        ((not (null? (cdr prop-spec)))
                                         `(list ',(car prop-spec) ,(cadr prop-spec)))
                                        (else
                                          `(list ',(car prop-spec)))))
                                (if (pair? args)
                                    properties
                                    (list)))))
       ;; it's a markup-list command:
       (set-object-property! ,command-name 'markup-list-command #t)
       ;; define the make-COMMAND-markup-list function
       (define-public (,make-markup-name . args)
         (let ((sig (list ,@signature)))
           (list (make-markup ,command-name
                              ,(symbol->string make-markup-name) sig args)))))))

;;;;;;;;;;;;;;;
;;; Utilities for storing and accessing markup commands signature
;;; Examples:
;;;
;;; (set! (markup-command-signature raise-markup) (list number? markup?))
;;; ==> (#<primitive-procedure number?> #<procedure markup? (obj)>)
;;;
;;; (markup-command-signature raise-markup)
;;; ==> (#<primitive-procedure number?> #<procedure markup? (obj)>)
;;;

(define-public (markup-command-signature-ref markup-command)
  "Return markup-command's signature (the 'markup-signature object property)"
  (object-property markup-command 'markup-signature))

(define-public (markup-command-signature-set! markup-command signature)
  "Set markup-command's signature (as object property)"
  (set-object-property! markup-command 'markup-signature signature)
  signature)

(define-public markup-command-signature
  (make-procedure-with-setter markup-command-signature-ref
                              markup-command-signature-set!))

;;;;;;;;;;;;;;;;;;;;;;
;;; markup type predicates

(define (markup-function? x)
  (and (markup-command-signature x)
       (not (object-property x 'markup-list-command))))

(define (markup-list-function? x)
  (and (markup-command-signature x)
       (object-property x 'markup-list-command)))

(define-public (markup-command-list? x)
  "Determine if `x' is a markup command list, ie. a list composed of
a markup list function and its arguments."
  (and (pair? x) (markup-list-function? (car x))))

(define-public (markup-list? arg)
  "Return a true value if `x' is a list of markups or markup command lists."
  (define (markup-list-inner? lst)
    (or (null? lst)
        (and (or (markup? (car lst)) (markup-command-list? (car lst)))
             (markup-list-inner? (cdr lst)))))
  (not (not (and (list? arg) (markup-list-inner? arg)))))

(define (markup-argument-list? signature arguments)
  "Typecheck argument list."
  (if (and (pair? signature) (pair? arguments))
      (and ((car signature) (car arguments))
           (markup-argument-list? (cdr signature) (cdr arguments)))
      (and (null? signature) (null? arguments))))


(define (markup-argument-list-error signature arguments number)
  "return (ARG-NR TYPE-EXPECTED ARG-FOUND) if an error is detected, or
#f is no error found.
"
  (if (and (pair? signature) (pair? arguments))
      (if (not ((car signature) (car arguments)))
          (list number (type-name (car signature)) (car arguments))
          (markup-argument-list-error (cdr signature) (cdr arguments) (+ 1 number)))
      #f))

;;
;; full recursive typecheck.
;;
(define (markup-typecheck? arg)
  (or (string? arg)
      (and (pair? arg)
           (markup-function? (car arg))
           (markup-argument-list? (markup-command-signature (car arg))
                                  (cdr arg)))))

;;
;;
;;
;;
(define (markup-thrower-typecheck arg)
  "typecheck, and throw an error when something amiss.

Uncovered - cheap-markup? is used."

  (cond ((string? arg) #t)
        ((not (pair? arg))
         (throw 'markup-format "Not a pair" arg))
        ((not (markup-function? (car arg)))
         (throw 'markup-format "Not a markup function " (car arg)))
        ((not (markup-argument-list? (markup-command-signature (car arg))
                                     (cdr arg)))
         (throw 'markup-format "Arguments failed  typecheck for " arg)))
  #t)

;;
;; good enough if you only  use make-XXX-markup functions.
;;
(define (cheap-markup? x)
  (or (string? x)
      (and (pair? x)
           (markup-function? (car x)))))

;;
;; replace by markup-thrower-typecheck for more detailed diagnostics.
;;
(define-public markup? cheap-markup?)

(define-public (make-markup markup-function make-name signature args)
  " Construct a markup object from MARKUP-FUNCTION and ARGS. Typecheck
against SIGNATURE, reporting MAKE-NAME as the user-invoked function.
"
  (let* ((arglen (length args))
         (siglen (length signature))
         (error-msg (if (and (> siglen 0) (> arglen 0))
                        (markup-argument-list-error signature args 1)
                        #f)))
    (if (or (not (= arglen siglen)) (< siglen 0) (< arglen 0))
        (ly:error (string-append make-name ": "
                                 (_ "Wrong number of arguments.  Expect: ~A, found ~A: ~S"))
                  siglen arglen args))
    (if error-msg
        (ly:error
         (string-append
          make-name ": "
          (_ "Invalid argument in position ~A.  Expect: ~A, found: ~S."))
         (car error-msg) (cadr error-msg)(caddr error-msg))
        (cons markup-function args))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; markup constructors
;;; lilypond-like syntax for markup construction in scheme.

(use-modules (ice-9 receive))

(define (compile-all-markup-expressions expr)
  "Return a list of canonical markups expressions, e.g.:
  (#:COMMAND1 arg11 arg12 #:COMMAND2 arg21 arg22 arg23)
  ===>
  ((make-COMMAND1-markup arg11 arg12)
   (make-COMMAND2-markup arg21 arg22 arg23) ...)"
  (do ((rest expr rest)
       (markps '() markps))
      ((null? rest) (reverse markps))
    (receive (m r) (compile-markup-expression rest)
             (set! markps (cons m markps))
             (set! rest r))))

(define (keyword->make-markup key)
  "Transform a keyword, e.g. #:COMMAND, in a make-COMMAND-markup symbol."
  (string->symbol (string-append "make-" (symbol->string (keyword->symbol key)) "-markup")))

(define (compile-markup-expression expr)
  "Return two values: the first complete canonical markup expression
   found in `expr', e.g. (make-COMMAND-markup arg1 arg2 ...),
   and the rest expression."
  (cond ((and (pair? expr)
              (keyword? (car expr)))
         ;; expr === (#:COMMAND arg1 ...)
         (let ((command (symbol->string (keyword->symbol (car expr)))))
           (if (not (pair? (lookup-markup-command command)))
               (ly:error (_ "Not a markup command: ~A") command))
           (let* ((sig (markup-command-signature
                        (car (lookup-markup-command command))))
                  (sig-len (length sig)))
             (do ((i 0 (1+ i))
                  (args '() args)
                  (rest (cdr expr) rest))
                 ((>= i sig-len)
                  (values (cons (keyword->make-markup (car expr)) (reverse args)) rest))
               (cond ((eqv? (list-ref sig i) markup-list?)
                      ;; (car rest) is a markup list
                      (set! args (cons `(list ,@(compile-all-markup-expressions (car rest))) args))
                      (set! rest (cdr rest)))
                     (else
                       ;; pick up one arg in `rest'
                       (receive (a r) (compile-markup-arg rest)
                                (set! args (cons a args))
                                (set! rest r))))))))
        ((and (pair? expr)
              (pair? (car expr))
              (keyword? (caar expr)))
         ;; expr === ((#:COMMAND arg1 ...) ...)
         (receive (m r) (compile-markup-expression (car expr))
                  (values m (cdr expr))))
        ((and (pair? expr)
              (string? (car expr))) ;; expr === ("string" ...)
         (values `(make-simple-markup ,(car expr)) (cdr expr)))
        (else
          ;; expr === (symbol ...) or ((funcall ...) ...)
          (values (car expr)
                  (cdr expr)))))

(define (compile-all-markup-args expr)
  "Transform `expr' into markup arguments"
  (do ((rest expr rest)
       (args '() args))
      ((null? rest) (reverse args))
    (receive (a r) (compile-markup-arg rest)
             (set! args (cons a args))
             (set! rest r))))

(define (compile-markup-arg expr)
  "Return two values: the desired markup argument, and the rest arguments"
  (cond ((null? expr)
         ;; no more args
         (values '() '()))
        ((keyword? (car expr))
         ;; expr === (#:COMMAND ...)
         ;; ==> build and return the whole markup expression
         (compile-markup-expression expr))
        ((and (pair? (car expr))
              (keyword? (caar expr)))
         ;; expr === ((#:COMMAND ...) ...)
         ;; ==> build and return the whole markup expression(s)
         ;; found in (car expr)
         (receive (markup-expr rest-expr) (compile-markup-expression (car expr))
                  (if (null? rest-expr)
                      (values markup-expr (cdr expr))
                      (values `(list ,markup-expr ,@(compile-all-markup-args rest-expr))
                              (cdr expr)))))
        ((and (pair? (car expr))
              (pair? (caar expr)))
         ;; expr === (((foo ...) ...) ...)
         (values (cons 'list (compile-all-markup-args (car expr))) (cdr expr)))
        (else (values (car expr) (cdr expr)))))

(define (lookup-markup-command-aux symbol)
  (let ((proc (catch 'misc-error
                     (lambda ()
                       (module-ref (current-module) symbol))
                     (lambda (key . args) #f))))
    (and (procedure? proc) proc)))

(define-public (lookup-markup-command code)
  (let ((proc (lookup-markup-command-aux
               (string->symbol (format #f "~a-markup" code)))))
    (and proc (markup-function? proc)
         (cons proc (markup-command-signature proc)))))

(define-public (lookup-markup-list-command code)
  (let ((proc (lookup-markup-command-aux
               (string->symbol (format #f "~a-markup-list" code)))))
    (and proc (markup-list-function? proc)
         (cons proc (markup-command-signature proc)))))
