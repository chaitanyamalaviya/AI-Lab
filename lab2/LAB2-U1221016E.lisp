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



;;;;Initializing knights tour current and goal state

(defun initknightsTourstate(m n x y) 
;"Define a new knights tour visited state with initial x,y visited(1) and rest all unvisited(0)"
    (setf visited (make-array (list m n) :initial-element 0))   ; visited is 2D array of size MXN that will hold a value for 1 or 0 for all elements, 1 representing a visited tile and 0 representing an unvisited tile
    (visitTile x y visited))     ; Visit the initial (x y) tile

(defun knightsTour-goalstate (m n)
; "Define the goal state for the knights tour problem as a 2D array of size MXN with all elements equal to 1 or all tiles visited"
  (setf *allvisited* (make-array (list m n) :initial-element 1)))


;;;;Modifying State

(defun visitTile(x y visited)
; "Visit the tile at (x y): If the tile (x y) is unvisited, set the visited element at (x y) to 1 and
;  push the cons of x and y to the sequence seq tracking the sequence of moves"
  (if (= (aref visited x y) 0) 
    (progn (setf (aref visited x y) 1) 
     (push (cons (+ x 1) (+ y 1)) seq)))) 
; Since seq stores sequence of visited tiles with positions indexed from 1 to M,N,
; 1 is added to (x y) positions before pushing it to seq as (x y) are indexed from 0 to M-1, N-1


(defun checkifVisited(x y visited)
; "Return 1 if the tile (x y) is visited and 0 if it is unvisited"
  (if (= (aref visited x y) 1) 1
  0))




;;;;Printing State

(defun printState (visited &optional (stream t))
; "Prints the current state of the knights tour by printing the 2D array visited"
  (dotimes (i (array-total-size visited))    ; Do for all elements of the 2D array visited
     (if (= (mod i (array-dimension visited 0)) 0) (format t "~C" #\linefeed))     ; Insert a new line after every mth element
     (if (= (checkifVisited (mod i (array-dimension visited 0)) (floor (/ i (array-dimension visited 1))) visited) 1) (prin1 'X )   ; Print X if tile has been visited and O otherwise
; The above mod and floor operations are used to retrieve the x and y positions of the ith element and call the checkifVisited method
       (prin1 'O)))
       (values))



;;;; Defining Problems


(defun knightstour-legalmoves(x y visited) 
; "Get the legal unvisited moves from current node (x y) and state visited"
;  There are 8 possible moves for a knight from any position on the board,
;  some of these will be outside the board so they won't be counted and some of these may be already visited
;  The moves can be 2 positions in X direction(+ or -) and 1 position in the Y direction(+ or -) and vice-versa.  
  (setf moves (list  '(-1 2) '(-1 -2) '(2 -1) '(2 1) 
                     '(1 2) '(1 -2) '(-2 1) '(-2 -1)))        ; Create a list of x and y distances of possible next tiles from the current tile (x y)
  (setf results (make-array '(8 2)))       ; Create an array storing the actual positions on the board that are counted as legal moves. This is of size 8X2 to allow storage of maximum 8 moves.
  (setq n 0)
 
   (dolist(move moves results)    ; Iterate over the list of possible moves 
        (setf x1 (+ x (car move)))       ; Temporary variable x1 initialized to position of next possible tile = (current horizontal position x + x-distance to next tile from the list moves)
        (setf y1 (+ y (cadr move)))      ; Temporary variable y1 initialized to position of next possible tile = (current vertical position y + y-distance to next tile from the list moves)
        (if (and (<= (+ 1 x1) (array-dimension visited 0)) (>= x1 0) (<= (+ 1 y1) (array-dimension visited 1)) (>= y1 0)) ; Check if x1, y1 lie inside the dimensions of the board and are greater than 0
          (if (= (checkifVisited x1 y1 visited) 0)   ; Check if this tile (x1 y1) is unvisited
            (progn 
              (setf (aref results n 0) x1)      ; Add (x1 y1) to the 2D array results
              (setf (aref results n 1) y1)        
              (incf n)) ))))   ; Increase the index n to be used for the next legal move in results


(defun goal-reached (visited) 
; "Checks if the goal state is reached and return 1 if yes and 0 if not"
  (if (equalp visited *allvisited*) 1   ; Compare the current visited 2D array and the goal 2D array which has all elements as 1  
  0))



;;;;Expansion of Nodes and Backtracking



(defun expand(x y)
; "Expands the tour with starting position (x y)"

  (setf i 0) ; i is used as first index of the list of legal moves, initialized to 0 to always make the first legal move first
  (loop
    (setf k (knightstour-legalmoves x y visited))  ; Store list of legal moves from (x y) in k 

    (cond ((aref k i 0)                          ; If at least one legal move exists (as the first element of the list k) =>CONTINUE_TOUR
       (progn
       (visitTile (aref k i 0) (aref k i 1) visited)      ; Visit the ith legal tile from the (x y) tile
       (setf x (aref k i 0))                  ; Set new x and y to the previously visited tile
       (setf y (aref k i 1)) 
       (setf i 0)))                
  
    
      ((eql (goal-reached visited) 0)    ; If no legal move exists and goal is not reached => BACKTRACK
       (progn
       (if (= (aref visited x y) 1) (setf (aref visited x y) 0)) ; Backtrack => "Unvisit" the tile (Set 0 to the corresponding visited element at the backtracked position)
       (setf (aref btcount x y) 0)                               ; 
       (pop seq) ;  Pop the tile from the sequence of visited tiles

       (if (eql (length seq) 0) (progn (format t "No Solution Found!") (values) (return-from expand))) ;   ; If length of sequence is 0, it means => NO SOLUTION FOUND
    
       (setf x (- (caar seq) 1))   ; Set new x to the last visited tile's x - 1 to abide with indexing from 0 to M-1
       (setf y (- (cdar seq) 1))   ; Set new y to the last visited tile's y - 1 to abide with indexing from 0 to N-1
       (setf newbt (+ 1 (aref btcount x y)))  
       (setf (aref btcount x y) newbt)  ; Increment the backtrack count to visit the next legal tile for (x y) in next iteration
       (setf i newbt)) ) ; Set index i to this backtrack count to visit the ith legal move next


      ((eql (goal-reached visited) 1)    ; If goal is reached and no more legal moves exist => GOAL_REACHED
        (print (reverse seq)) (return-from expand) ))))  ; Print the sequence in reverse order to print the first visited tile in the beginning and so on. Finally return from the function.



;;;;Knights Tour Backtracking Method


(defun knights-tour-backtracking (x y m n)
; "Method called by user to start the knights tour using backtracking with initial position (x y) and board dimensions MXN"

  (setf seq nil)  ; Initialize the sequence of visited tiles seq as nil, seq will store the position of tiles indexed from 1 to M,N as a list of cons of the visited positions

; If the initial position (x y) do not lie on the board of size MXN, show error and return from function 
  (if (or (> x m) (> y n) (< x 1) (< y 1)) (progn (format t "Index out of bounds!") (return-from knights-tour-backtracking))) 
  (decf x)  ; For ease, the x and y positions are decremented for abiding with the array indexing used in Lisp that starts from 0
  (decf y)

; Create a 2D array of size MXN called btcount that holds the backtrack count for each position. btcount is 1 for a position (x y) if a tile after (x y) was backtracked. 
; btcount is used for efficiently making the legal moves one by one from a position (x y) in case of backtracking
; btcount will be initialized to 0 for all positions at the start of the tour and set to 0 for a position when it is backtracked/removed from the sequence
  (setf btcount (make-array (list m n) :initial-element 0))    
  (initknightsTourstate m n x y)    ; Initialize the knights tour visited state
  (knightsTour-goalstate m n)    ; Initialize the goal state of the knights tour
  (expand x y))   ; Expand nodes from starting position (x y)




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



;;;;Expansion of Nodes

(defun expandWarnsdorff(x y visited)
; "Expands the tour with starting position (x y)"


  (setf k (knightstour-legalmoves x y visited))    ; Store list of legal moves from (x y) in k 
  (if (and (not (aref k 0 0)) (eql (goal-reached visited) 0)) (progn (format t "No Solution found!") (values)))  ; If goal is not reached and there is no available legal move => NO SOLUTION FOUND
 
  (setf min 8)  ; Create variable min storing the minimum number of subsequent legal moves from any of the current legal moves

  (dotimes (l 8)  ; Iterate over the list of legal moves, using l as first index of k
    (setf count 0) ; count stores the number of subsequent legal moves for the current iteration
    
    (if (aref k l 0)  ; If a legal move exists at the index l
      (progn    
      (setf moves (knightstour-legalmoves (aref k l 0) (aref k l 1) visited))   ; moves stores the subsequent legal moves from the current legal move
      
      (dotimes (j 8)   ; Iterate over the list of subsequent legal moves, using j as first index of moves
        (if (aref moves j 0) ; If a legal move exists at index j
          (incf count))) ; Increment the variable count
      (if (< count min) (progn (setf min count) (setf i l))))))  
 ; If count<min: the value of count is set to the new min, which will be compared with the count of other legal moves.
 ;  Also, index i, holding the first index of the next move to be taken, is set to l.


   (cond ((and (aref k 0 0) (eql (goal-reached visited) 0))   ; If at least one legal move exists and goal is not reached => CONTINUE_TOUR
     (progn  
     (visitTile (aref k i 0) (aref k i 1) visited)    ; Visit the ith legal tile from the (x y) tile
     (expandWarnsdorff (aref k i 0) (aref k i 1) visited)))  ; Call expandWarnsdorff recursively with the last visited tile's x,y

    ((eql (goal-reached visited) 1)   ; If goal is reached and no more legal moves exist => GOAL_REACHED
     (progn (let ((*print-length* nil))    ; Allow to print a long output, for eg, output for an 8X8 board
     (print (reverse seq)) ))))  ; Print the sequence in reverse order to print the first visited tile in the beginning and so on
      (values))  ; To avoid an extra Nil in the output
    



;;;;Knights Tour Greedy Method

(defun knights-tour-greedy (x y m n)
; "Method called by user to start the knights tour using the Warnsdorff Rule with initial position (x y) and board dimensions MXN"

 ; Initialize the sequence of visited tiles seq as nil, seq will store the position of tiles indexed from 1 to M,N as a list of cons of the visited positions
  (setf seq nil)

; If the initial position (x y) do not lie on the board of size MXN, show error and return from function 
  (if (or (> x m) (> y n) (< x 1) (< y 1)) (progn (format t "Index out of bounds!") (return-from knights-tour-greedy)))  
  (decf x)  ; For ease, the x and y positions are decremented for abiding with the array indexing used in Lisp that starts from 0
  (decf y)
  (initknightsTourstate m n x y)  ; Initialize the knights tour visited state
  (knightsTour-goalstate m n)   ; Initialize the goal state of the knights tour
  (expandWarnsdorff x y visited))   ; Expand nodes from starting position (x y)

