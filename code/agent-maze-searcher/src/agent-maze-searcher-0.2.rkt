; Filename: robot-search.rkt
; Author:   Aren Tyr
; Date:     18/09/19
; Version:  0.2
; Status:   Working with breadth-first search algorithm.
; Description:
; A path/maze-searching program, that, given an input "world" 
; (i.e. maze), performs a breath-first search to identify a 
; valid search path to the goal, if it exists.
; Original code ported from Scheme to Racket.
;
; TODO: 
;
; 1.) Refactor code to make it tidier/more elegant
; 2.) Implement goal-cost accumulator for comparison
; 3.) Implement alternative search algorithms (i.e. A*)
;
;

;==== Some global variables ================================

(define straight-distance 0)

; total number of obstacles
(define obstacle-total 0)

; temporary variables - indexX and indexY are used for accumulation
(define indexX 0)
(define indexY 0)
(define iter 0)

; the world axis
(define x-axis 0)
(define y-axis 0)

; store fixed "#" object as "$"
(define block '$)

; node lists used for search operations
(define visited-node-list '())
(define working-node-list1 '())
(define working-node-list2 '())
(define working-node-list3 '())
(define working-node-list4 '())
(define node-list-sublist-1 '())
(define node-list-sublist-2 '())
(define node-list-sublist-3 '())
(define node-list-sublist-4 '())
(define search-path-list '())
(define previous-occurence '())
(define node-path-list '())
(define last-solution-list '())
(define cheap-node '())
(define cheap-node-true-val 0)
(define cheap-node-val-tmp 0)
(define cheap-node-val 0)
(define cheap-node-tmp '())
(define list1null 'f)
(define list2null 'f)
(define list3null 'f)
(define list4null 'f)
(define ls1 '())
(define ls2 '())
(define ls3 '())
(define ls4 '())
(define lsElem1 '())
(define lsElem2 '())
(define lsElem3 '())
(define lsElem4 '())
(define value1 0)
(define value2 0)
(define value3 0)
(define value4 0)
(define goal-cost 0)
(define value-index 0)
(define value-index-tmp1 0)
(define value-index-tmp2 0)
(define value-index-tmp3 0)
(define value-index-tmp4 0)
(define value-index-tmp5 0)
(define value-index-tmp6 0)
(define up 't)
(define down 't)
(define left 't)
(define right 't)
(define tuple '())
(define add-node '())
(define previous-node '())
; the starting node position
(define starting-node '())
(define current-node '())

; goal state node position
(define goal-node '())

; flow control variables
(define solution-check-1 1)
(define solution-check-2 1)
(define solution-check-3 1)
(define solution-check-4 1)
(define exit-condition 'f)
(define goal-found 'f)
(define search-type 'bf)
(define first-time 't)
; the matrix used to store the world
(define world-matrix '())

;==== Helper functions =====================================

; reverse the path list for sensible display
(define reverse-all
  (lambda (ls)
    (if (null? ls) '() (append (reverse-all (cdr ls))
                               (list (if (pair? (car ls))
                                         (reverse-all (car ls))
                                         (car ls)))))))

; nullify function to clear the search lists after finishing a search
(define nullify
  (lambda ()
    (begin
      (set! working-node-list1 '())
      (set! working-node-list2 '())
      (set! working-node-list3 '())
      (set! working-node-list4 '())
      (set! node-list-sublist-1 '())
      (set! node-list-sublist-2 '())
      (set! node-list-sublist-3 '())
      (set! node-list-sublist-4 '())
      (set! visited-node-list '()))))

; return the last element of the given list
(define last-element
  (lambda (ls)
    (cond
      ((null? (cdr ls)) (car ls))
      (else (last-element (cdr ls))))))

; set an exit condition (flow control)
(define return-false
  (lambda ()
    (set! exit-condition 't)))

;==== Matrix Operation functions ===========================

; add1 function is actually *not* part of ANSI scheme
; so define it here for compliance
(define add1
	(lambda (item)
	(+ item 1)))

; create a given matrix
(define matrix-make-1 
        (lambda (m rows columns row) 
        (if (< row rows) 
            (begin 
                (vector-set! m row (make-vector columns)) 
                (matrix-make-1 m rows columns (add1 row))) 
                m))) 

; tail-recursive call for matrix creation
(define matrix-make 
      (lambda (rows columns) 
      (let ((m (make-vector rows))) 
            (matrix-make-1 m rows columns 0)))) 

; allow setting of individual elements
(define matrix-set!
  (lambda (m row column item)
    (vector-set! (vector-ref m row) column item)))

; obtain a specific element at given index
(define matrix-ref
  (lambda (m row column)
    (vector-ref (vector-ref m row) column)))

;==== User display functions ======================================

; output prompt for user
(define user-input-request-prompt 
  (lambda ()
    (display "-> Please enter filename of world to read in format: \"filename\"")
    (newline)
    (display "=>")))

; display a key to the world representation
(define display-key
  (lambda ()
    (begin
    (newline)
    (newline)
    (display "The world has been displayed!")
    (newline)
    (newline)
    (display "-----")
    (newline)
    (display "KEY: ")
    (newline)
    (newline)
    (display "* : The Edge Of The World!")
    (newline)
    (display "# : An immovable obstruction")
    (newline)
    (display "~ : A default piece of terrain")
    (newline)
    (display "+ : Our robot")
    (newline)
    (display "= : The goal our robot seeks")
    (newline)
    (display "Number[1-9] = An obstacle of difficultly (cost) n[1-9]")
    (newline)
    (display "-----")
    (newline)
    (newline))))

; display an introduction to the program
(define program-introduction
  (lambda ()
    (begin
      (newline)
      (display "                R   o   B   o   T      N  a  V  a  G  a  T  i  O  n")
      (newline)
      (newline)
      (display "                                  in ")
      (newline)
      (newline)
      (display "                                                  Racket (Scheme)")
      (newline)
      (newline)
      (display "================================================================================")
      (newline)
      (display "Program operation key: ")
      (newline)
      (newline)
      (display "=> Indicates that user input is expected")
      (newline)
      (display "-> <text> Indicates a process in operation.")
      (newline)
      (display "* <text> Indicates data information/transformation")
      (newline)
      (display "#EXCPT#-> <text> Indicates an exception that has been handled.")
      (newline)
      (display "#ERROR#-> <text> Indicates a non-trivial error resulting in program termination.")
      (newline)
      (display "================================================================================")
      (newline)
      (newline))))

; display some information about the searches to be performed
(define show-search-display
  (lambda ()
    (begin
      (display "------------------")
      (newline)
      (newline)
      (display "I will perform these three searches in this order: ")
      (newline)
      (newline)
      (display "1. Breadth-first search")
      (newline)
      (display "2. Iterative-deepening search")
      (newline)
      (display "3. A* search")
      (newline)
      (newline)
      (display "-> Enter any character to perform searches.")
      (let ((stop (read)))
        (newline)
        (display "-> Searching - this may take some time...")
        (newline)))))

               
;=====World generation functions ===========================

; the main function for creation of the world
(define create-world-matrix
  (lambda (dataFile)
    (display "-> Reading file...")
    (newline)
    ; open the datafile as specified by the user (if possible)
    (let ((sourceFile (open-input-file dataFile)))
      
      ; set x-axis value
      (let ((xa (read sourceFile)))
            (if (eq? (eof-object? xa) #f) (begin
      (set! x-axis xa)
      (display "* X-axis set to size: ")
      (display x-axis)
      (newline)
      
      ; set y-axis value
      (let ((ya (read sourceFile)))
            (if (eq? (eof-object? ya) #f) (begin
      (set! y-axis ya)
      (display "* Y-axis set to size: ")
      (display y-axis)
      (newline)
      
      ; actually create the world-matrix
      (set! world-matrix (matrix-make x-axis y-axis))
      
      ; fill the matrix initially with default values
      (fill-matrix world-matrix x-axis y-axis)
      (set! indexX 0)
      (set! indexY 0)
      
      ; obtain starting (x-axis) coordinate
      (let ((starting-node-x (read sourceFile)))
        (if (eq? (eof-object? starting-node-x) #f) 
            (begin 
      
      ; obtain starting (y-axis) coordinate                                              
        (let ((starting-node-y (cons (read sourceFile) '())))
          (if (eq? (eof-object? (car starting-node-y)) #f)
              (begin
                
                
          (if (eq? (< starting-node-x x-axis) #t) (if (eq? (< (car starting-node-y) y-axis) #t) (begin   
                                 
      ; set the starting node position in the world
                                                                                                  (set! starting-node (cons starting-node-x starting-node-y)) 
          (matrix-set! world-matrix starting-node-x (car starting-node-y) 20)
          
          ; obtain destination (x-axis) coordinate
          (let ((ending-node-x (read sourceFile)))
            (if (eq? (eof-object? ending-node-x) #f) (begin
            
              ; obtain destination (y-axis) coordinate                                         
              (let ((ending-node-y (cons (read sourceFile) '())))
              (if (eq? (eof-object? (car ending-node-y)) #f) (begin
              (if (eq? (< ending-node-x x-axis) #t) (if (eq? (< (car ending-node-y) y-axis) #t)
                                                        (begin
              
              ; set the destination node position in the world
                                                          
              (set! goal-node (cons ending-node-x ending-node-y))
              (matrix-set! world-matrix ending-node-x (car ending-node-y) 0)
              
              ; obtain the number of obstacles in the world (to be read)
              (let ((number-of-obstacles (read sourceFile)))
                (if (eq? (eof-object? number-of-obstacles) #f) (begin
                (display "* ")
                (display number-of-obstacles)
                (display " obstacles in world")
                (newline)
                
                ; now implant those obstacles into the world...
                
                (implant-obstacles world-matrix number-of-obstacles sourceFile)
                
                ; display the world out to the user...
                
                (display-world world-matrix x-axis y-axis)
                
                ; start executing the searches!
                (close-input-port sourceFile))
	;	(breadth-first world-matrix))
                ;does this WORK??? (start-searches world-matrix)) 
                    
                    ; error messages for:
                    ; 1.) An unexpected EOF token (i.e a malformed data file)
                    ; 2.) An invalid coordinate specified for either starting or
                    ;     ending position
                    (display "#ERROR#-> Unexpected end of file reached")))) 
		    (display "#ERROR#-> Invalid data file (destination point is out of range)"))
		    (display "#ERROR#-> Invalid data file (destination point is out of range)")))
		    (display "#ERROR#-> Unexpected end of file reached"))))
	            (display "#ERROR#-> Unexpected end of file reached")))) 
		    (display "#ERROR#-> Invalid data file (starting point is out of range!)")) 
                    (display "#ERROR#-> Invalid data file (starting point is out of range!)"))) 
	            (display "#ERROR#-> Unexpected end of file reached")))) 
	            (display "#ERROR#-> Unexpected end of file reached")))) 
	            (display "#ERROR#-> Unexpected end of file reached")))) 
	            (display "#ERROR#-> Unexpected end of file reached"))))))

; --> Fill the matrix with movable positions

; fill the matrix with default (i.e of value 1) movable positions

(define fill-matrix
  (lambda (matrix-to-fill x-axis y-axis)
  (cond
    ((< indexX x-axis)
      (cond 
        ((< indexY y-axis)
         ; set that default "1"
          (matrix-set! matrix-to-fill indexX indexY '1)
          (set! indexY (add1 indexY))
          (fill-matrix matrix-to-fill x-axis y-axis))
        (else 
         (set! indexX (add1 indexX))
         (set! indexY 0)
         (fill-matrix matrix-to-fill x-axis y-axis))))
      (else (display "-> Matrix filled.")
            (newline)))))
 
; --> Some routines to give the nice square "wall" around the world

; all the following functions are used to 
; put a nice rectangular border of "*"s around the world
(define horizontal-padding
  (lambda (iter y-axis)
    (when (eqv? iter 0) (display "*   "))
    (when (eqv? iter y-axis) (display "*"))
    (cond
      ((< iter y-axis)
       (display "    ")
       (horizontal-padding (add1 iter) y-axis)))))

(define fill-horizontal
 (lambda (indexX y-axis)
   (when (eqv? indexX y-axis) (display "*"))
   (cond
     ((<= indexX y-axis)
      (display "****")
      (fill-horizontal (add1 indexX) y-axis))
     (else 
      (newline)
      (set! indexX 0)
      (horizontal-padding indexX y-axis)
      (newline)))))

(define fill-horizontal-end
 (lambda (indexX y-axis)
   (when (eqv? indexX y-axis) (display "*"))
   (cond
     ((<= indexX y-axis)
      (display "****")
      (fill-horizontal-end (add1 indexX) y-axis)))))

;--> Functions to actually output the visual representation to the user

; display to world to the user
(define display-world
  (lambda (matrix-to-display x-axis y-axis)
    (display "-> Generating world...")
    (newline)
    (newline)
    (fill-horizontal 0 y-axis)
    (display-world-main matrix-to-display x-axis y-axis)
    (display-key)))
    
; main world display function
(define display-world-main
  (lambda (matrix-to-display x-axis y-axis)
    (cond
      ((< indexX x-axis)
       (cond
         ((< indexY y-axis)
          (when (eqv? indexY 0) (display "*   "))
          (cond
            ; display the "~"s and "#"s
            ((eqv? (matrix-ref matrix-to-display indexX indexY) 1) (display "~"))
            ((eqv? (matrix-ref matrix-to-display indexX indexY) 1000000) (display "#"))
            ((eqv? (matrix-ref matrix-to-display indexX indexY) 20) (display "+"))
            ((eqv? (matrix-ref matrix-to-display indexX indexY) 0) (display "="))
            (else
             (display (matrix-ref matrix-to-display indexX indexY))))
          (display "   ")
          (set! indexY (add1 indexY))
          (display-world-main matrix-to-display x-axis y-axis))
         (else
          (when (eqv? indexY y-axis) (display "*"))
          (set! indexX (add1 indexX))
          (set! indexY 0)
          (newline)
          ; create the border of "#"s around the world
          (horizontal-padding iter y-axis)
          (newline)
          (display-world-main matrix-to-display x-axis y-axis))))
       (else (fill-horizontal-end 0 y-axis)))))
       
;--> Functions to place the obstacles in the world

; implant all the obstacles in the world
(define implant-obstacles
  (lambda (world number-of-obstacles sourceFileDat)
    (cond
      ((> number-of-obstacles obstacle-total) 
       (let ((obstacle-coord-x (read sourceFileDat)))
         (if (eq? (eof-object? obstacle-coord-x) #f) (begin
       (let ((obstacle-coord-y (read sourceFileDat)))                               
         (if (eq? (eof-object? obstacle-coord-y) #f) (begin
         (let ((obstacle-coord-cost (read sourceFileDat)))
           (if (eq? (eof-object? obstacle-coord-cost) #f) (begin
           (if (eq? (< obstacle-coord-x x-axis) #t) 
	     (if (eq? (< obstacle-coord-y y-axis) #t) 
	       (if (eq? (equal? starting-node (cons obstacle-coord-x (cons obstacle-coord-y '()))) #f) 
		 (if (eq? (equal? goal-node (cons obstacle-coord-x (cons obstacle-coord-y '()))) #f) 
		   (begin     
       			(if (eqv? obstacle-coord-cost 0) (matrix-set! world obstacle-coord-x obstacle-coord-y 1000000) 
			  (matrix-set! world obstacle-coord-x obstacle-coord-y obstacle-coord-cost))) 
		   (begin (display "#EXCPT#-> Invalid obtacle position at: ")
              (display "(" )
              (display obstacle-coord-x)
              (display ", ")
              (display obstacle-coord-y)
              (display ")")
              (display " - obstacle ignored!")
              (newline)
              (display "* Continuing... ")
              (newline)
              (newline))) 
       (begin (display "#EXCPT#-> Invalid obstacle position at: ")
              (display "(" )
              (display obstacle-coord-x)
              (display ", ")
              (display obstacle-coord-y)
              (display ")")
              (display " - obstacle ignored!")
              (newline)
              (display "* Continuing...")
              (newline)
              (newline)))
       (begin (display "#EXCPT#-> Invalid obtacle position at: ")
              (display "(" )
              (display obstacle-coord-x)
              (display ", ")
              (display obstacle-coord-y)
              (display ")")
              (display " - obstacle ignored!")
              (newline)
              (display "* Continuing... ")
              (newline)
              (newline)))
                      (begin (display "#EXCPT#-> Invalid obtacle position at: ")
              (display "(" )
              (display obstacle-coord-x)
              (display ", ")
              (display obstacle-coord-y)
              (display ")")
              (display " - obstacle ignored!")
              (newline)
              (display "* Continuing... ")
              (newline)
              (newline)))
        ; increment the obstacle total count   
       (set! obstacle-total (add1 obstacle-total))
       (implant-obstacles world number-of-obstacles sourceFileDat)) 
	     (begin (display "#EXCPT#-> Unexpected end of file reached - obstacle ignored!") (newline) (newline))))) 
	     (begin (display "#EXCPT#-> Unexpected end of file reached - obstacle ignored!") (newline) (newline)))))
	     (begin (display "#EXCPT#-> Unexpected end of file reached - obstacle ignored!") (newline) (newline)))))
      (else 
       (display "-> Obstacle input complete.")
       (newline)))))

;===== Searching functions ===============================
  
; a function to add nodes to a visited list (so we don't revisit nodes)
(define add-to-visited-list
  (lambda (node)
    (set! visited-node-list (cons node visited-node-list))))

; set the current node to be the given node
(define set-current-node
  (lambda (node)
     (set! current-node node)))

; is the node in our visited node list? If so, don't expand...
(define is-in-search-list
  (lambda (node visited-node-list)
    ;(display "in is-in-search-list")
    (cond
      ((null? visited-node-list) #f)
      ((null? node) #t)
      ((equal? node (car visited-node-list)) #t)
      (else (is-in-search-list node (cdr visited-node-list))))))

; initialize the search list
(define initialize-search-list
  (lambda (node)
    (set! search-path-list (cons node '()))))

; this function will expand (where possible) the given node in the four
; directions - north, south, east and west
(define expand-4-directions
  (lambda (current-node current-working-list)
    (begin
      ; not in list so lets start expanding from this node...
      
       ; lets first add it to our visited list so we don't expand this again
       (add-to-visited-list current-node)
      
      
      (when (eq? (equal? (matrix-ref world-matrix (car current-node) (cadr current-node)) 1000000) #f) 
          ; it isn't a block ("#"), so...
          
         ; first we add the "top" move postion 
      (begin 
      (if (< (cadr current-node) (- y-axis 1)) (set! working-node-list1 (cons (cons (car current-node) (cons (+ (cadr current-node) 1) '())) current-working-list)) (set! working-node-list1 '()))
      
      ; now we add the "bottom" move position
      (if (> (cadr current-node) 0) (set! working-node-list2 (cons (cons (car current-node) (cons (- (cadr current-node) 1) '())) current-working-list)) (set! working-node-list2 '()))  
            
      ; now add the "left" move position
     
      (if (< (car current-node) (- x-axis 1)) (set! working-node-list3 (cons (cons (+ (car current-node) 1) (cons (cadr current-node) '())) current-working-list)) (set! working-node-list3 '()))

      ; now add the "right" move position
      
       (if (> (car current-node) 0) (set! working-node-list4 (cons (cons (- (car current-node) 1) (cons (cadr current-node) '())) current-working-list)) (set! working-node-list4 '()))

       ; check to see whether we've found the solution!
      (when (eq? (null? working-node-list1) #f) (when (equal? (car working-node-list1) goal-node) (set-goal-state-found working-node-list1)))
      
      (when (eq? (null? working-node-list2) #f) (when (equal? (car working-node-list2) goal-node) (set-goal-state-found working-node-list2)))
      
      (when (eq? (null? working-node-list3) #f) (when (equal? (car working-node-list3) goal-node) (set-goal-state-found working-node-list3)))
      
      (when (eq? (null? working-node-list4) #f) (when (equal? (car working-node-list4) goal-node) (set-goal-state-found working-node-list4)))
      
      (set! search-path-list (append (append (append (cons working-node-list1 '()) (cons working-node-list2 '()) ) (cons working-node-list3 '())) (cons working-node-list4 '()) search-path-list))
      )))))

; expand the current node 
(define expand-node
  (lambda (current-node current-working-list sol)
    (begin

      ; set our flow control operators...
      (set! solution-check-1 1)
      (set! solution-check-2 1)
      (set! solution-check-3 1)
      (set! solution-check-4 1)
      
      ; 
      (cond
        ; we must check for the trivial case - the case where we are already at the solution!
        ((null? current-node) #f)
        ((equal? current-node goal-node) (set-goal-state-found current-working-list))
        ; we're not, so let's find it...
        (else (when (eq? (is-in-search-list current-node visited-node-list) #f) (expand-4-directions current-node current-working-list)))))))
  
; perform a breadth first search on our search problem
(define breadth-first-search
  (lambda (node-list)
    (begin
      ; initialize each sublist to the given direction (N, S, E or W)
      (set! node-list-sublist-1 (car node-list))
      (set! node-list-sublist-2 (cadr node-list))
      (set! node-list-sublist-3 (caddr node-list))
      (set! node-list-sublist-4 (car (cdr (cddr node-list))))
      (when (equal? exit-condition 'f)
          ; expand (if not null, i.e. when there is nowhere to go) each node in the
          ; given direction
          (begin
            (when (eq? (null? node-list-sublist-1) #f) (expand-node (car node-list-sublist-1) node-list-sublist-1 solution-check-1))
            (when (eq? (null? node-list-sublist-2) #f) (expand-node (car node-list-sublist-2) node-list-sublist-2 solution-check-2))
            (when (eq? (null? node-list-sublist-3) #f) (expand-node (car node-list-sublist-3) node-list-sublist-3 solution-check-3))
            (when (eq? (null? node-list-sublist-4) #f) (expand-node (car node-list-sublist-4) node-list-sublist-4 solution-check-4))
             
            ; clean out our temporary search list 
            (set! node-path-list '())
            
            (when (equal? last-solution-list search-path-list)
                (begin 
                  (set! exit-condition 't)
                  (when (eq? goal-found 'f)
                  (begin (display "-> No solutions found.")
                         (newline)
                         ;(display search-path-list)
                         (newline)))))
            
            (set! last-solution-list search-path-list)
            ; do we need to exit? (i.e. no valid solutions...)
                
            ; otherwise recursively call the breadth-first search on the list...
                    (breadth-first-search search-path-list))))))

; first time only initialization of breadth first routine
(define search-initialize
  (lambda (world-matrix node-list type)
    (begin
        (cond
          ((null? (car node-list)) (display "Starting node is null!"))
          (else 
           (let ((node-list-sublist (car node-list)))
            (cond
              ((null? node-list-sublist) (display "Sub-list is broken"))
              (else
               (cond
                 ; are we already at the solution?
                 
                  ((equal? (car node-list-sublist) goal-node) (set-goal-state-found node-path-list))
                  (else 
                   ; expand the initial node
                   (begin
                          (expand-node (car node-list-sublist) search-path-list solution-check-1)
                          (newline)
                          ; now perform the breadth first search on this expansion
                          (breadth-first-search search-path-list))))))))))))            

; declare the goal state to be found
(define set-goal-state-found
  (lambda (goal-list)
    (begin
      (set! search-path-list goal-list)
      (set! goal-found 't)
      (nullify)
      (goal-state-found))))

; start off the breadth-first search...
(define breadth-first
  (lambda (world)
    (begin
      ;(show-search-display)
      (set-current-node starting-node)
      (initialize-search-list current-node)
      (if (equal? starting-node goal-node) (set-goal-state-found search-path-list) 
      (search-initialize world (cons (cons starting-node '()) '()) search-type)))))


;==== Wait for user before beginning search =================

(define search-prompt
  (lambda ()
	(display "-> Enter any key to begin search...")
        (read)))

;==== Exit if user enters incorrect filename ================

(define exit-incorrect-filename
  (lambda ()
      (display "Invalid filename/missing file. Input must be of form \"<filename>\".") 
      (newline)
      (display "For example, \"my-robot-world.dat\". Aborting.")
      (newline)
      (exit)))

;===== Attempt to open/create a new world ===================
   
(define open-world
  (lambda ()
    (user-input-request-prompt)
    (let ((response (read)))
      (if (string? response)
         (create-world-matrix response)
	 (exit-incorrect-filename)))))

;===== Celebrations ;-) =================================

(define goal-state-found
  (lambda ()
    (begin
    (display "-> Path found.")
    (newline)
    (display "-> A valid path to the goal is: ")
    (if (eq? search-type 'bf) (begin 
				(display (reverse-all search-path-list)))
				       ;(display "goal cost:")
				       ;(display goal-cost))
        (begin 
          (display search-path-list)
          (newline)))
          ;(display "-> Cost to goal is: ")
          ;(display goal-cost)))
    (newline)
    (newline))))

;===== Main program execution ===========================

; the main program starts here!
(define start-program
  (lambda ()
    (begin
      ; Display program introductory text
      (program-introduction)
      ; Read the world in from an input file
      (open-world)
      (search-prompt)
      ; Actually perform the search using a breadth-first algorithm
      (breadth-first world-matrix))))


;===== Execute program ==================================

; execute!
(start-program)

