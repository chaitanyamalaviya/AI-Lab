;;;; CZ3005 2015 Semester 2: Lab 2

;;;; AIMA

(unuse-package "EXT") ; In POXIS systems, there is a symbol conflict

; Make sure your working directory contains aima folder
; then load aima.lisp
(load "aima/aima.lisp")

; Troubleshooting:
; ================
;
; In command line interface:
; --------------------------
; Make sure your working directory contains the aima folder, run clisp,
; then you can load "aima/aima.lisp" using (load "aima/aima.lisp")
;
; In Lispworks:
; -------------
; If you are loading AIMA from Lispworks, you can check your (current-pathname)
; and place the aima folder there, so that "aima/aima.lisp" can be loaded.
;
; Alternatively, you can change the current directory in Lispworks using
; (change-directory "lab2-directory"), for example on Windows:
;     (change-directory "C:\\Users\\Me\\Desktop\\CZ3005\\lab2")
; Then you load the file (load "aima/aima.lisp")
;
; Another option: you can load AIMA by specifying the directory directly, such
; as (load "C:\\Users\\Public\\Desktop\\CZ3005\\lab2\\aima\\aima.lisp"), but
; then you also have to change one line (line 9) in the aima.lisp file:
; From
;   (defparameter *aima-root* (truename "./aima/")
; to
;   (defparameter *aima-root* (truename "C:\\Users\\Me\\Desktop\\CZ3005\\lab2\\aima\\")
; (load "labs/aima/aima.lisp")

; Load, compile and test the search module of AIMA
(aima-load 'search)
(aima-compile 'search) ; in case of warnings, just "continue"
(test 'search)

; The following lab uses lots of code from AIMA
; Go through the source code of the following files from the search module
; of AIMA to get the general ideas used in the framework

;;; In today's lab we will define the basic elements of a probelm and its
;;; solution, and give some examples to illustrate these defintions.
;;; We then show how use several general-purpose searching algoorithms to 
;;; solve these probelms 
;;; Todays lab focuses on methods for deciding what action to take when 
;;; needing to think several steps ahead such while playing a game.
;;; Problem formulation is deciding what actions and states to consider 
;;; given a goal.

; aima/search/algorithms/problems.lisp
; aima/search/algorithms/simple.lisp
; aima/search/algorithms/repeated.lisp
; aima/search/domains/puzzle8.lisp

; You can also see the overview of AIMA at
; http://aima.cs.berkeley.edu/lisp/doc/overview.html

;;;; 8-puzzle probelm. It is played on a 3-by-3 grid with 8 square blocks 
;;;; labeled 1 through 8 and a blank square. Your goal is to rearrange the 
;;;; blocks so that they are in order.

;;;; Representing States

; (defun 8-puzzle-state (&rest pieces)
;   "Define a new state with the specified tiles."
;   (assert (= 9 (length pieces))) ;  assures that pieces length is 9. If not, signals an error 
;   (let ((sum 0))
;    (for i = 0 to 8 do
;     (incf sum (* (elt pieces i) (expt 9 i))))
;    sum))

; (defun 8-puzzle-ref (state square)
;   "Return the tile that occupies the given square."
;   (mod (floor state (9-power square)) 9))

; (defun 8-puzzle-print (state &optional (stream t))
;   (for i = 0 to 8 do
;        (if (= 0 (mod i 3)) (terpri stream))
;        (let ((tile (8-puzzle-ref state i)))
;           (format stream " ~A" (if (= tile 0) "." tile))))
;   state)

; (defun random-8-puzzle-state (&optional (num-moves 100) (state *8-puzzle-goal*))
;   "Return a random state of the 8 puzzle."
;   (for i = 1 to num-moves do
;        (setf state (random-move-blank state))) ;
;   state)

; (defun 9-power (n)
;   "Raise 9 to the nth power, 0 <= n <= 9."
;   ;; This measures about 8 times faster than (expt 9 i)
;   (svref '#(1 9 81 729 6561 59049 531441 4782969 43046721 387420489) n))


; Create specific states
(8-puzzle-state 1 2 3 4 5 6 7 8 0)
(8-puzzle-state 2 6 5 1 8 0 6 7 4)

; Generate a random state by executing 128 random moves
(random-8-puzzle-state 8 (8-puzzle-state 1 2 3 4 5 6 7 8 0))

(setf goal-state (8-puzzle-state 0 1 2 3 4 5 6 7 8))
(setf init-state (random-8-puzzle-state 128 goal-state))

; Print states
(8-puzzle-print init-state)
(8-puzzle-print goal-state)

; Get the piece on position 4
(8-puzzle-ref init-state 4)
(8-puzzle-location  4)


;;;; Setting Up the Goal

; (defvar *8-puzzle-goal-locations* (make-array 9)
;   "A vector indexed by tile numbers, saying where the tile should be.")

; (defun use-8-puzzle-goal (goal)
;   "Define a new goal for the 8 puzzle."
;   (setf *8-puzzle-goal* goal)
;   (for square = 0 to 8 do
;        (let ((tile (8-puzzle-ref goal square)))
;      (setf (svref *8-puzzle-goal-locations* tile)
;            (8-puzzle-location square))))
;   goal)

; (defun 8-puzzle-goal-location (tile)
;   "Return the location where the tile should go."
;   (svref *8-puzzle-goal-locations* tile))


; Set the target state
; Set a gloabl variable *8-puzzle-goal-locations*
(use-8-puzzle-goal goal-state)
(print *8-puzzle-goal-locations*)


;;;; Representing the Board

; (defun 8-puzzle-legal-moves (square)
;   "The moves that can be made when the blank is in a given square.
;   This is a list of (direction destination-square) pairs."
;   (svref
;    '#(((> 1) (V 3))        ((< 0) (> 2) (V 4))        ((< 1) (V 5))
;       ((^ 0) (> 4) (V 6))  ((^ 1) (< 3) (> 5) (V 7))  ((^ 2) (< 4) (V 8))
;       ((^ 3) (> 7))        ((^ 4) (< 6) (> 8))        ((^ 5) (< 7)))
;    square))

; (defun 8-puzzle-location (square)
;   "Return the (x y) location of a square number."
;   (svref '#((0 2) (1 2) (2 2)
;         (0 1) (1 1) (2 1)
;         (0 0) (1 0) (2 0))
;      square))

; (defun neighbors (square)
;   "The squares that can be reached from a given square."
;   (svref
;    '#((1 3)     (0 2 4)     (1 5)
;       (0 4 6)   (1 3 5 7)   (2 4 8)
;       (3 7)     (4 6 8)     (7 5))
;    square))

(neighbors 7)
(8-puzzle-legal-moves 7)
(8-puzzle-location 7)



;;;; Modifying the state

; (defun blank-square (state)
;   "Find the number of the square where the blank is."
;   (for i = 0 to 8 do
;        (when (= 0 (8-puzzle-ref state i)) (return i))))

; (defun move-blank (state from to)
;   "Move the blank from one square to another and return the resulting state.
;   The FROM square must contain the blank; this is not checked."
;   (+ state (* (8-puzzle-ref state to) (- (9-power from) (9-power to)))))

; (defun random-move-blank (state)
;   "Return a state derived from this one by a random move."
;   (let ((blank (blank-square state)))
;     (move-blank state blank (random-element (neighbors blank)))))

; find the blank square
(blank-square init-state)
(blank-square goal-state)

; make a move from blank-square to a random neighbor
(setf state2
  (move-blank
    init-state
    (blank-square init-state)
    (random-element (neighbors (blank-square init-state)))))

(8-puzzle-print init-state)
(8-puzzle-print state2)

; make a random move again
(setf state3
  (random-move-blank state2))

(8-puzzle-print state2)
(8-puzzle-print state3)



;;;; Defining Problems

; (defstructure problem
;   "A problem is defined by the initial state, and the type of problem it is.
;   We will be defining subtypes of PROBLEM later on.  For bookkeeping, we
;   count the number of nodes expanded.  Note that the three other fields from
;   the book's definition [p 60] have become generic functions; see below."
;   (initial-state (required)) ; A state in the domain
;   (goal nil)                 ; Optionally store the desired state here.
;   (num-expanded 0)           ; Number of nodes expanded in search for solution.
;   (iterative? nil)           ; Are we using an iterative algorithm?
;   )

; ;;; When we define a new subtype of problem, we need to define a SUCCESSORS
; ;;; method. We may need to define methods for GOAL-TEST, H-COST, and
; ;;; EDGE-COST, but they have default methods which may be appropriate.

; (defmethod successors ((problem problem) state)
;   "Return an alist of (action . state) pairs, reachable from this state."
;   (declare-ignore state)
;   (error "You need to define a SUCCESSORS method for ~A" problem))

; (defmethod goal-test ((problem problem) state)
;   "Return true or false: is this state a goal state?  This default method
;   checks if the state is equal to the state stored in the problem-goal slot.
;   You will need to define your own method if there are multiple goals, or if
;   you need to compare them with something other than EQUAL."
;   (declare-ignore state)
;   (equal state (problem-goal problem)))

; (defmethod h-cost ((problem problem) state)
;   "The estimated cost from state to a goal for this problem.
;   If you don't overestimate, then A* will always find optimal solutions.
;   The default estimate is always 0, which certainly doesn't overestimate."
;   (declare (ignore state))
;   0)

; (defmethod edge-cost ((problem problem) node action state)
;   "The cost of going from one node to the next state by taking action.
;   This default method counts 1 for every action.  Provide a method for this if
;   your subtype of problem has a different idea of the cost of a step."
;   (declare-ignore node action state)
;   1)

;;;; Defining a particular problem - 8 puzzle

; (defstructure (8-puzzle-problem
;            (:include problem
;              (initial-state (random-8-puzzle-state))
;              (goal *8-puzzle-goal*)))
;   "The sliding tile problem known as the 8-puzzle.")

; (defmethod successors ((problem 8-puzzle-problem) state)
;   "Generate the possible moves from an 8-puzzle state."
;   (let ((blank (blank-square state))
;     (result nil))
;      (for each (action destination) in (8-puzzle-legal-moves blank) do
;       (push (cons action (move-blank state blank destination)) result))
;      result))

; (defmethod h-cost ((problem 8-puzzle-problem) state)
;   "Manhatten, or sum of city block distances.  This is h_2 on [p 102]."
;   (let ((sum 0))
;    (for square = 0 to 8 do
;     (let ((tile (8-puzzle-ref state square)))
;       (unless (= tile 0)
;         (incf sum (x+y-distance (8-puzzle-location square)
;                     (8-puzzle-goal-location tile))))))
;    sum))

; Create 8-puzzle problem instance
(setf p1 (make-8-puzzle-problem :initial-state init-state))
(h-cost p1 (8-puzzle-problem-initial-state p1)) 

(8-puzzle-print (8-puzzle-problem-initial-state p1))
(8-puzzle-print (8-puzzle-problem-goal p1))

; Query successor states
(successors p1 init-state)
; Check h-cost of successor states
; What is the h-cost after taking any of the successor actions
(mapcar (lambda (s) (h-cost p1 (cdr s)))
    (successors p1 (8-puzzle-problem-initial-state p1)))


;;;; Alternative Heuristic Function

; (defun misplaced-tiles (state)
;   "Number of misplaced tiles.  This is h_1 on [p 102]."
;   (let ((sum 0))
;    (for square = 0 to 8 do
;     (when (misplaced-tile? state square) (incf sum)))
;    sum))

; (defun misplaced-tile? (state square)
;   "Is the tile in SQUARE different from the corresponding goal tile?
;   Don't count the blank."
;   (let ((tile (8-puzzle-ref state square)))
;     (and (/= tile 0)
;      (/= tile (8-puzzle-ref *8-puzzle-goal* square)))))
;
;;;;  Checks if (tile is not 0) and (tile is the same as the location in the puzzle goal)

; Check alternative h-cost of successor states
(mapcar (lambda (s) (misplaced-tiles (cdr s)))
    (successors p1 (8-puzzle-problem-initial-state p1)))


;;;; Manipulating Nodes

; (defstructure node
;   "Node for generic search.  A node contains a state, a domain-specific
;   representation of a point in the search space.  A node also contains
;   bookkeeping information such as the cost so far (g-cost) and estimated cost
;   to go (h-cost). [p 72]"
;   (state (required))        ; a state in the domain
;   (parent nil)              ; the parent node of this node
;   (action nil)              ; the domain action leading to state
;   (successors nil)          ; list of sucessor nodes
;   (unexpanded nil)          ; successors not yet examined (SMA* only)
;   (depth 0)                 ; depth of node in tree (root = 0)
;   (g-cost 0)                ; path cost from root to node
;   (h-cost 0)                ; estimated distance from state to goal
;   (f-cost 0)                ; g-cost + h-cost
;   (expanded? nil)           ; any successors examined?
;   (completed? nil)          ; all successors examined? (SMA* only)
;   )

; (defun expand (node problem)
;   "Generate a list of all the nodes that can be reached from a node."
;   ;; Note the problem's successor-fn returns a list of (action . state) pairs.
;   ;; This function turns each of these into a node.
;   ;; If a node has already been expanded for some reason, then return no nodes,
;   ;; unless we are using an iterative algorithm.
;   (unless (and (node-expanded? node) (not (problem-iterative? problem)))
;     (setf (node-expanded? node) t)
;     (incf (problem-num-expanded problem))
;     (display-expand problem node)
;     (let ((nodes nil))
;       (for each (action . state) in (successors problem (node-state node)) do
;        (let* ((g (+ (node-g-cost node)
;             (edge-cost problem node action state)))
;           (h (h-cost problem state)))
;          (push
;           (make-node
;            :parent node :action action :state state
;            :depth (1+ (node-depth node)) :g-cost g :h-cost h
;            ;; use the pathmax equation [p 98] for f:
;            :f-cost (max (node-f-cost node) (+ g h)))
;           nodes)))
;       nodes)))

; (defun create-start-node (problem)
;   "Make the starting node, corresponding to the problem's initial state."
;   (let ((h (h-cost problem (problem-initial-state problem))))
;     (make-node :state (problem-initial-state problem)
;            :h-cost h :f-cost h)))


; Create starting node of the 8 puzzle problem
(setf n1 (create-start-node p1))


(node-h-cost n1)
(node-expanded? n1)
(node-depth n1)

; Expand the starting node
(setf n2 (expand n1 p1))
(node-expanded? n1)
(mapcar #'node-depth n2)
(mapcar #'node-g-cost n2)
(mapcar #'node-h-cost n2)
(mapcar #'node-f-cost n2)

; Expand the node with the lowest f-cost
(setf n3
  (expand (nth
    (let ((n2-f-costs (mapcar #'node-f-cost n2)))
      (position (apply #'min n2-f-costs) n2-f-costs))
        n2) p1))



;;;; Manipulating Solutions

;;; Solutions are represented just by the node at the end of the path.  The
;;; function SOLUTION-ACTIONS returns a list of actions that get there.  It
;;; would be problematic to represent solutions directly by this list of
;;; actions, because then we couldn't tell a solution with no actions from a
;;; failure to find a solution.

; (defun solution-actions (node &optional (actions-so-far nil))
;   "Return a list of actions that will lead to the node's state."
;   (cond ((null node) actions-so-far)
;     ((null (node-parent node)) actions-so-far)
;     (t (solution-actions (node-parent node)
;                  (cons (node-action node) actions-so-far)))))

; (defun solution-nodes (node &optional (nodes-so-far nil))
;   "Return a list of the nodes along the path to the solution."
;   (cond ((null node) nodes-so-far)
;     (t (solution-nodes (node-parent node)
;                (cons node nodes-so-far)))))

; (defun solve (problem &optional (algorithm 'A*-search))
;   "Print a list of actions that will solve the problem (if possible).
;   Return the node that solves the problem, or nil."
;   (setf (problem-num-expanded problem) 0)
;   (let ((node (funcall algorithm problem)))
;     (print-solution problem node)
;     node))

; (defun print-solution (problem node)
;   "Print a table of the actions and states leading up to a solution."
;   (if node
;       (format t "~&Action ~20T State~%====== ~20T =====~%")
;     (format t "~&No solution found.~&"))
;   (for each n in (solution-nodes node) do
;        (format t "~&~A ~20T ~A~%"
;            (or (node-action n) "") (node-state n)))
;   (format t "====== ~20T =====~%Total of ~D node~:P expanded."
;       (problem-num-expanded problem))
;   node)


(setf s1 (solve p1))
(solution-actions s1)
(solution-nodes s1)
(print-solution p1 (second (solution-nodes s1)))
(expand (second (solution-nodes s1)) p1)

;;;; Simple Search Algorithms

;;; Here we define the GENERAL-SEARCH function, and then a set of
;;; search functions that follow specific search strategies.  None of
;;; these algorithms worries about repeated states in the search.

; (defun general-search (problem queuing-fn)
;   "Expand nodes according to the specification of PROBLEM until we find
;   a solution or run out of nodes to expand.  The QUEUING-FN decides which
;   nodes to look at first. [p 73]"
;   (let ((nodes (make-initial-queue problem queuing-fn))
;     node)
;     (loop (if (empty-queue? nodes) (RETURN nil))
;       (setq node (remove-front nodes))
;       (if (goal-test problem (node-state node)) (RETURN node))
;       (funcall queuing-fn nodes (expand node problem)))))

; (defun make-initial-queue (problem queuing-fn)
;   (let ((q (make-empty-queue)))
;     (funcall queuing-fn q (list (create-start-node problem)))
;     q))

; (defun breadth-first-search (problem)
;   "Search the shallowest nodes in the search tree first. [p 74]"
;   (general-search problem #'enqueue-at-end))

; (defun depth-first-search (problem)
;   "Search the deepest nodes in the search tree first. [p 78]"
;   (general-search problem #'enqueue-at-front))

; (defun iterative-deepening-search (problem)
;   "Do a series of depth-limited searches, increasing depth each time. [p 79]"
;   (for depth = 0 to infinity do
;        (let ((solution (depth-limited-search problem depth)))
;      (unless (eq solution :cut-off) (RETURN solution)))))

; (defun depth-limited-search (problem &optional (limit infinity)
;                                      (node (create-start-node problem)))
;   "Search depth-first, but only up to LIMIT branches deep in the tree."
;   (cond ((goal-test problem node) node)
;         ((>= (node-depth node) limit) :cut-off)
;         (t (for each n in (expand node problem) do
;         (let ((solution (depth-limited-search problem limit n)))
;           (when solution (RETURN solution)))))))

;;;; Search Algorithms That Use Heuristic Information

; (defun best-first-search (problem eval-fn)
;   "Search the nodes with the best evaluation first. [p 93]"
;   (general-search problem #'(lambda (old-q nodes)
;                   (enqueue-by-priority old-q nodes eval-fn))))

; (defun greedy-search (problem)
;   "Best-first search using H (heuristic distance to goal). [p 93]"
;   (best-first-search problem #'node-h-cost))

; (defun tree-a*-search (problem)
;   "Best-first search using estimated total cost, or (F = G + H). [p 97]"
;   (best-first-search problem #'node-f-cost))

; (defun uniform-cost-search (problem)
;   "Best-first search using the node's depth as its cost.  Discussion on [p 75]"
;   (best-first-search problem #'node-depth))

; Be careful running these! Some of the default "stupid" search algorithms
; don't check for repeated states.

(setf s1 (solve p1 #'depth-first-search))
(setf s1 (solve p1 #'no-cycles-depth-first-search))
(setf s1 (solve p1 #'iterative-deepening-search))
(setf s1 (solve p1 #'breadth-first-search))
(setf s1 (solve p1 #'no-returns-breadth-first-search))
(setf s1 (solve p1 #'no-duplicates-breadth-first-search))
(setf s1 (solve p1 #'hill-climbing-search))

