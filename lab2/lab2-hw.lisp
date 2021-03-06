;;;; CZ3005 2015 Semester 2: Lab 2 (Total Marks: 100)
;;;;
;;;; Due two weeks from the lab.
;;;;
;;;; Submission procedure will be announced during the lecture or the
;;;; lab session.
;;;;
;;;; This file is a loadable Lisp file.  You are to modify this file and
;;;; add your answers.  Then CHECK TO MAKE SURE that the file still loads
;;;; properly into the Lisp system.
;;;;
;;;; Name your lab 2 lisp code as  "LAB2-<YOUR_MATRICULATION_NUMBER>.lisp"
;;;;
;;;; Any line breaks due to word wrapping will be treated as errors.
;;;; Moral of the story: DO NOT USE WINDOWS NOTEPAD OR PICO.
;;;;
;;;; Before you submit your code, be sure to test it in GNU CLISP 2.49.
;;;; Lispworks 6.1 software installed on NTU machines is based on Clisp 2.49,
;;;; so if your code works there, it qualifies.
;;;;
;;;; If our checker detects wrong output, you may still get partial marks for
;;;; such problem. If we cannot run your code, including our automatic checker,
;;;; you cannot get marks for correct answer.
;;;;
;;;; You are NOT allowed to use external libraries in this assignment other than
;;;; the AIMA framework! If you choose to not use AIMA, you may find inspiration
;;;; in the robustness of the AIMA framework and model your problems using
;;;; the know-how and principles used in AIMA. You won't be penalized in any way
;;;; if you choose to write the answers from scratch.
;;;;
;;;; For those using AIMA, the framework will be loaded prior to checking your
;;;; solution! DO NOT load it again,
;;;; and DO NOT include any AIMA functions or code in your submission. This
;;;; would result in plagiarism detection and severe consequences.
;;;;
;;;; There are TWO questions in this homework assignment. Function definitions
;;;; of functions that will be checked are provided.
;;;;
;;;; COMMENT EXCESSIVELY -- 20% of marks for every task is awarded solely based
;;;; on sufficiently commented code! Comment both inline in your code and
;;;; comment each function and structure you write. Make sure we understand
;;;; the nitty-gritty of you answers.


;;;; (change-directory "/users/Chaitanya/desktop/study/4.2/CZ3005\ -\ Artificial\ Intelligence/lab/lab2")
;;;; (load "aima/aima.lisp")
;;;; (aima-load 'search)


;;;; INTRO

; The knight's tour problem is a problem of finding a sequence of moves of
; a knight on a chessboard such that the knight must not step on the same
; square more than once and the knight visits all the squares of the
; chessboard.

; See https://en.wikipedia.org/wiki/Knight%27s_tour for details



;;;; QUESTION 1 [70 marks total:
;;;;             10 marks for correct state representation
;;;;             10 marks for correct successor state generation
;;;;              5 marks for final state detection / validation
;;;;              5 marks for detection of nonexistence of any solution
;;;;             15 marks for correct results
;;;;              5 marks for more effective detection of visited states
;;;;                (constant time, check for visited states not by
;;;;                 iteration through a list of all positions visited)
;;;;              5 marks for more effective final / solution state detection
;;;;                (constant time, i.e. no length or list-length)
;;;;             10 marks for comments and documentation
;;;;              5 marks for well-structured code]

; On a MxN chessboard, given the initial coordinates, find one open
; knight's tour. Start with 5x5 chessboard. Note that there are no closed
; knight's tours on 5x5 chessboard.

; Use a depth first search with backtracking, i.e. in every step,
; visit all the available squares (that have not been visited in any previous
; step). You have to be able to effectively generate the successor states
; and check for already visited states.
; Do not use naive brute force algorithm that generates all possible
; sequences of M*N positions - including invalid knight's moves or visiting
; previously visited states.
; Note that it is possible to use brute force algorithm that does not check
; for revisiting states, but generates paths according to the knight's
; moves, which are then filtered. However, such algorithm is too slow.

; The input to your function is a list with four integers, indicating the
; starting position of the tour and the size of the chessboard.
; Coordinates range from 1 to M, resp 1 to N.

; The output is a list of length M*N consisting of cons cells of length 2,
; indicating the position on a chessboard visited by the knight. The first
; position is identical to (x y) from the input.
; Please note that the output is not a list of lists of length 2!

; Example:
;     (knights-tour-backtracking (1 1 5 5)) -> ((1 . 1) (3 . 2) (5 . 1) ... )

; You are allowed to add any number of functions into this file, as the whole
; file will be loaded, but only the knights-tour-backtracking function will be
; checked for correctness. If the correctness check passes, the whole code will
; be checked for correct use of backtracking method.

; All code in this assignment has to be your own. No external library is
; allowed (except for AIMA).

; Test it on 5x5 chessboard, optionally on 6x6, 7x7 and 8x8 chessboard.
; Please comment out any excessive calls you used for debugging or testing.



(defun knights-tour-backtracking (x y m n) nil)



(defun initknightsTourstate(m n x y) 
;"Define a new visited state with initial x,y visited and rest all unvisited"
  (if (eql m n)
    (progn
    (setf visited (make-array (list m n) :initial-element 0))
    (visitTile x y visited))))

(defun knightsTour-goalstate (m n)
  (setf *allvisited* (make-array (list m n) :initial-element 1)))




;;;;Modifying State

(defun visitTile(x y visited)
  (if (= (aref visited x y) 0) (setf (aref visited x y) 1)))

(defun checkifVisited(x y visited)
  (if (= (aref visited x y) 1) 1
  0))

(initknightsTourstate 5 5 0 0)

;;;;Printing State

(defun printState (visited &optional (stream t))
  (dotimes (i (array-total-size visited))
     (if (= (mod i (array-dimension visited 0)) 0) (format t "~C" #\linefeed))
     (if (= (checkifVisited (mod i (array-dimension visited 0)) (floor (/ i (array-dimension visited 1))) visited) 1) (prin1 'X )
       (prin1 'O)))
       (values))


;;;; Defining Problems


(defstructure (knights-tour  
  (:include problem
   (initial-state (visited)) 
   (goal (*allvisited*))       ;all tiles visited               
   (num-expanded 1)                  
  )))


(defun knightstour-legalmoves(x y visited) 
; "Get legal moves from current node (x y) and state visited"
  (setf moves (list '(1 2) '(1 -2) '(-1 2) '(-1 -2) 
                    '(2 -1) '(2 1) '(-2 1) '(-2 -1))) 
  (setf results (make-array '(8 2) :initial-element nil))
  (setq n 0)
 
   (dolist(move moves results)
        (setf x1 (+ x (car move)))
        (setf y1 (+ y (cadr move)))
        (if (and (<= (+ 1 x1) (array-dimension visited 0)) (>= x1 0) (<= (+ 1 y1) (array-dimension visited 1)) (>= y1 0)) 
          (if (= (checkifVisited x1 y1 visited) 0) 
            (progn 
              (setf (aref results n 0) x1) 
              (setf (aref results n 1) y1) 
              (incf n)) ))))


(defmethod goal-test ((problem knights-tour) visited) 
  (if (eql visited *allvisited*) 1))


(defmethod successors((problem knights-tour) visited)
; "Generate all possible reachable and unvisited tiles from the current tile (x y)"
  (let (results nil))
  (dolist(move (knightstour-legalmoves x y visited) result) 
    (if (move) (push move results))))   


(setf s1 (make-knights-tour :initial-state visited))

(print (8-puzzle-problem-initial-state p1))
(8-puzzle-print (8-puzzle-problem-goal p1))






;;;; QUESTION 2 [30 marks total:
;;;;              5 marks for correct Warnsdorff's heuristic implementation
;;;;             10 marks for correct results
;;;;              5 marks for effective implementation of the heuristic
;;;;                (constant time evaluation instead of generating set of
;;;;                 neighbors for each of the successor states and then
;;;;                 computing the length of the list of successor states)
;;;;              5 marks for comments and documentation
;;;;              5 marks for well-structured code
;;;;                (i.e. high code reuse from question 1)]

; Since backtracking approach is not very effective, we have to use something
; more sophisticated. A greedy best-first search with Warnsdorff's heuristic
; seems like a significantly better approach.

; Warnsdorff's heuristic evaluates moves based on the number of available
; squares for the next move. Applying this heuristic to our greedy best-first
; search, we will always choose the move with the lowest number of subsequent
; moves from that square. Resolution of ties is not specified, you may choose
; randomly.

; You are again allowed to add any number of functions, but only the
; knights-tour-greedy function will be checked for correctness. If the
; correctness check passes, the whole code will be checked for correct
; use of greedy best-first search method.

; All code in this assignment has to be your own. No external library is
; allowed.

; Input and output formats remain the same.

; Test it on 8x8 chessboard, optionally on larger chessboards.
; Please comment out any excessive calls you used for debugging or testing.

(defun knights-tour-greedy (x y m n) nil)



;;;; BONUS: [Additional up 15 points for better tie resolution]

; If you try your own heuristic for tie resolution, please describe thoroughly
; how it works.

; Or you can use an existing one. For example:
; http://slac.stanford.edu/pubs/slacpubs/0250/slac-pub-0261.pdf
