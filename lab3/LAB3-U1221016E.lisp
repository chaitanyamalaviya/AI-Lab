;;;; CZ3005 2015 Semester 2: Lab 3 (Total Marks: 100)
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
;;;; Name your lab 3 lisp code as  "LAB3-<YOUR_MATRICULATION_NUMBER>.lisp"
;;;;
;;;; Any line breaks due to word wrapping will be treated as errors.
;;;; Moral of the story: DO NOT USE WINDOWS NOTEPAD OR PICO.
;;;;
;;;; Before you submit your code, be sure to test it in GNU CLISP 2.49.
;;;; Lispworks 6.1 software installed on NTU machines is based on Clisp 2.49,
;;;; so if your code works there, it qualifies.
;;;;
;;;; If we cannot run your code, including our automatic checker, your answer
;;;; will not be considered at all. If our checker detects wrong output, you may
;;;; still get partial marks for such problem.
;;;;
;;;; You are NOT allowed to use external libraries in this assignment other than
;;;; the AIMA framework! If you choose to not use AIMA, you may find inspiration
;;;; in the robustness of the AIMA framework and model your problems using
;;;; the know-how and principles used in AIMA. You won't be penalized in any way
;;;; if you choose to write the answers from scratch.
;;;;
;;;; For those using AIMA, the framework will be loaded prior to checking your
;;;; solution! DO NOT load it again,
;;;; and DO NOT put any code from AIMA in your submission. This
;;;; would result in plagiarism detection and severe consequences.
;;;; You can USE the framework (e.g. call funcions, define substructures, etc.)
;;;;
;;;; There are THREE questions in this homework assignment. One extra question is
;;;; optional, but worth a lot of marks.
;;;;
;;;; COMMENT EXCESSIVELY -- 20% of marks for every task is awarded solely based
;;;; on sufficiently commented code! Comment both inline in your code and
;;;; comment each function and structure you write. Make sure we understand
;;;; the nitty-gritty of you answers.



;;;; QUESTION 1 [5 marks for successfully sucking all dirt in the
;;;;               default vacuum world
;;;;             5 marks for successfully sucking all dirt in arbitrary sized
;;;;               vacuum worlds
;;;;             5 marks for robust, concise conditions, i.e. do not
;;;;               hard-code the moves based on individual cells, use
;;;;               constant-length conditions (number of conditions does not
;;;;               depend on size of the grid)
;;;;             5 marks for comments and documentation]

; Remember our agent with GPS who walks around the perimeter of your grid?
; Improve this agent so that it sucks all the dirt and returns home.

; Remember that this agent's percept is quite limited:
; (bump dirt home loc heading)

; Your agent also has no memory nor the complete grid percept
0
; You may assume that the start (home) of the agent is default (@ 1 1), so is
; the boundary specification (bspec) of the grid '((at edge wall)). The size
; of the grid and probability / locations of dirt are variable.

; Modify the following agent function:

; The following smart agent traverses the grid column-wise and returns to home on the shortest path upon exploring the entire grid
(defun smart-traversal-vacuum-agent-with-gps-program (percept)
     (destructuring-bind (bump dirt home loc heading) (subseq percept 0 5)
       (cond (dirt 'suck)                                    ; if found dirt -> suck
         ((and home (equal heading (@ -1 0))) '(shut-off))   ; if on way back home (heading left) and reached home -> shut-off
         ((and (not (equal heading (@ 0 1))) home) '(turn left)) ; if not heading up and at home-> turn left

         ((and (equal heading (@ 0 1)) bump) '(turn right))  ; if heading up and bump -> turn right
         ((and (equal heading (@ 0 -1)) bump) '(turn left))  ; if heading down and bump -> turn left
         ((and (equal heading (@ 1 0)) bump) '(turn left)) ; if heading right and bump -> turn left //grid over-> go home
         ((and (equal heading (@ 0 1)) (eql (mod (car loc) 2) 0)) '(turn left))  ; if heading up and in even column -> turn left

         ((and (not home) (equal heading (@ 1 0)) (equal (mod (car loc) 2) 0) (not (equal (cdr loc) '(1)))) '(turn right)) 
         ; if not at home and heading right and in even column and not in first row -> turn right
         ((and (not home) (equal heading (@ 1 0)) (equal (mod (car loc) 2) 1) (equal (cdr loc) '(1))) '(turn left))
         ; if not at home and heading right and in odd column and in first row -> turn right
         
         (t 'forward)))) ; else-> keep moving forward
          

; Do not write anything else, especially the agent body or the environment.
; The checker will do that for you. You can use the following code to test it.
; The code has to be commented for submission!

; The number of steps in our
; checker is always adapted to the size of the grid and the number of dirts,
; so unless your agent gets lost, he should have sufficient time to finish
; his task and return home.

; You may need to define smart-traversal-vacuum-agent-with-gps-program
; function after the smart-traversal-vacuum-agent-with-gps structure if you
; are getting an error "...is not a structure of type SMART-TRAVERSAL-..."

; (defstructure (smart-traversal-vacuum-agent-with-gps
;   (:include agent
;     (program #'smart-traversal-vacuum-agent-with-gps-program))))

; (run-environment (make-vacuum-world-gps
;     :size (@ 8 8)
;     :aspec '(smart-traversal-vacuum-agent-with-gps)
;     :max-steps 64))



;;;; QUESTION 2 [10 marks for better agent-trials evaluation (i.e defeating
;;;;                out reference dumb agent)
;;;;             10 marks for correct implementation of next move evaluation
;;;;                (choosing which dirt to go for and navigating there
;;;;                consistently by selecting proper next moves)
;;;;              5 marks for proper distance estimations (including turns) to
;;;;                a dirt on the grid
;;;;              5 marks for comments and documentation]

; Write an agent that is able to clean all dust faster than our reference
; dumb-traversal-vacuum-agent-with-radar. Note that the evaluation function is
; (defmethod performance-measure ((env vacuum-world) agent) from AIMA.

; It is easy to be better than dumb-traversal-vacuum-agent-with-radar. What is
; the agent's weakness? How does he search for the next dirt?

; When you estimate distances to dirt, don't forget that the function takes 3
; inputs, not two: agent-location, agent-heading, dirt-location


(defun distance (elem loc heading) 
; """Finds the distance (including turns) between the agent location 
;    loc facing direction heading, and a target tile elem"""

  (setf dist (apply '+ (mapcar #'(lambda (x y) (abs (- x y))) elem loc)))  ; Gives the Manhattan Distance between the tiles, similar to Lab1 exercise

  ; Adding the extra moves due to turns, agent needs to turn in the following cases

  ; if target tile is left of current location and agent is not heading left -> increment distance
  (if (and (< (car elem) (car loc)) (not (equal heading '(-1 0)))) (incf dist))  
  ; if target tile is right of current location and agent is not heading right -> increment distance
  (if (and (> (car elem) (car loc)) (not (equal heading '(1 0)))) (incf dist))
  ; if target tile is below the current location and agent is not heading down -> increment distance
  (if (and (< (cadr elem) (cadr loc)) (not (equal heading '(0 -1)))) (incf dist))
  ; if target tile is above the current location and agent is not heading up -> increment distance
  (if (and (> (cadr elem) (cadr loc)) (not (equal heading '(0 1)))) (incf dist))

 dist)



; Finds straight-line distance between the home-location and a tile elem
(defun linear_distance (elem home-loc)
  (sqrt (apply '+ (mapcar #'(lambda (x y) (expt (- x y) 2)) elem home-loc))))


(defun find-dirt-in-grid (radar type loc heading home-loc) 
; Finds which dirt to go for next based on an A star search, 
; where the heuristic used is straight-line distance between home-loc and the considered dirty tile,
; along with a closest dirt first approach. Returns the (x y) of the target dirt.
    (setf nextmove nil)  ; Stores the best next move
    (setf min 1000)  ; Initialized to a large number
    (dotimes (x (car (array-dimensions radar)))
        (dotimes (y (cadr (array-dimensions radar)))  ; Iterate over grid
            (let ((elems (aref radar x y)))  ; elems stores the element at x y in a list
                (dolist (e elems) 
                    (when (eq (type-of e) type)  ; Check if the element is of type dirt
                        (setf dist (+ (linear_distance (list x y) home-loc) (distance (list x y) loc heading))) ; Calculation of A star search distance
                        (if (<= dist min) ; Check if the calculated distance is less than current minimum - in order to get closest dirt first
                            (progn 
                              (setf min dist) ; Set the new minimum distance
                              (setf nextmove (list x y)))))))))  ; Set the new next move as x y
     (return-from find-dirt-in-grid nextmove) nil)     ; Return the next pursued dirt location (x y)


(defun smart-traversal-vacuum-agent-with-radar-program (percept)
; """The vacuum agent with radar program gets the next best dirt to be sucked,
; and makes moves towards this dirt according to the turn-towards-dirt function.
; At the end of sucking all the dirt on the grid, it returns home by making moves 
; again using the turn-towards-dirt function"""

    (destructuring-bind (bump dirt home loc heading radar home-loc) percept
        (setf go-to-dirt nil)
        (let ((go-to-dirt (find-dirt-in-grid radar 'DIRT loc heading home-loc)) ; Get (x y) for next dirt
              (go-to-home home-loc))  ; 
            (let ((turn (turn-towards-dirt loc heading
                    (if go-to-dirt go-to-dirt go-to-home)))) ; if dirt exists, then find where to turn to go towards dirt, else find where to turn to go towards home
                (cond
                    (turn turn)  ; turn if a turn is specified
                    (dirt 'suck)  ; suck on dirt
                    ((and (not go-to-dirt) home) 'shut-off)  ; if at home and no dirt exists -> shut-off
                    (t 'forward) ;  else -> Keep moving forward
                    )))))



; Do not write anything else, especially the agent body or the environment.
; The checker will do that for you. You can use the following code to test it.
; The code has to be commented for submission!

; The number of steps in our checker is always adapted to the size of the grid
; and the number of dirts, just like in the previous question.

; You may need to define smart-traversal-vacuum-agent-with-radar-program
; function after the smart-traversal-vacuum-agent-with-radar structure if you
; are getting an error "...is not a structure of type SMART-TRAVERSAL-..."

; (defstructure (smart-traversal-vacuum-agent-with-radar
;   (:include agent
;     (program #'smart-traversal-vacuum-agent-with-radar-program))))

; (run-environment (make-vacuum-world-radar
;     :aspec '(smart-traversal-vacuum-agent-with-radar)
;     :max-steps 64))

; (agent-trials 'make-vacuum-world-radar
;          '(smart-traversal-vacuum-agent-with-radar
;            dumb-traversal-vacuum-agent-with-radar) :n 16)

; (defstructure (vacuum-world-radar-fixed-dirt (:include vacuum-world-radar
;     (cspec '((at (and (3 3) (4 4) (4 5) (5 5)) dirt))))))

; (agent-trials 'make-vacuum-world-radar-fixed-dirt
;          '(smart-traversal-vacuum-agent-with-radar
;            dumb-traversal-vacuum-agent-with-radar) :n 1)



;;;; QUESTION 3 [15 marks for defeating minimax-cutoff-vacuum-agent (depth 6)
;;;;                using your alpha-beta-pruning (with depth 9)
;;;;             10 marks for correct alpha-beta pruning implementation
;;;;             10 marks for better implementation of state evaluation
;;;;                function - refer to function Utility(state) in the textbook
;;;;                (better = a lot more sophisticated than vacuum-agent-eval)
;;;;                (describe your reasoning and implementation thoroughly)
;;;;              5 marks for static ordering of examining successors
;;;;                (describe your reasoning, ideally backed up with tests)
;;;;              5 marks for comments and documentation
;;;;              5 marks for well-structured code]

; Write an algorithm function. When this function is used by a vacuum-agent
; it has to perform better than our reference agent from lab 3

; You have to use alpha-beta-pruning algorithm.

; You are allowed to use all functions of vacuum-game, e.g. to generate all
; possible next moves. In fact, you should use them, otherwise you risk running
; into too much trouble reimplementing the game models.
; Make use of aima/search/environments/vacuum-game.lisp, but DO NOT copy
; any code from there!

; You CAN'T use any code from aima/search/algorithms/minimax.lisp.
; This code will not be available to your agent. Original code won't be loaded.
; The stock AIMA code for alpha-beta pruning only works on zero-sum games and
; uses a simplification, so that both alpha and beta values are computed
; using max. BE AWARE that your implementation can't afford these assumptions,
; thus you have to implement it from scratch!

; You can use all other AIMA code (except aima/search/algorithms/minimax.lisp).

; See section 3: Alpha-Beta Pruning in chapter Adversarial Search in the course
; textbook (AIMA) for details about alpha-beta pruning
; Adversarial Search is chapter 5 (in 3rd edition) or chapter 6
; (in 2nd edition) of the book.

; You may find inspiration in lab3.lisp, section ADVERSARIAL SEARCH, where
; we refer to files from AIMA.


(defun smart-vacuum-agent-algorithm (state game)
  (vacuum-minimax-alphabeta-decision state game #'smart-eval-score 9))

(defun smart-eval-score (state game)
; """The evaluation function uses the sum of (difference between distance to closest dirts 
; for the current agent and the enemy agent and the difference between their current game scores)

  (destructuring-bind (my-agent foe-agent) (vacuum-game-state-agents state)
   (destructuring-bind (my-loc my-heading) my-agent
    (destructuring-bind (foe-loc foe-heading) foe-agent
      (+ 
      (- (min (mapcar #'(lambda (dirt) (distance dirt my-loc my-heading)) (vacuum-game-state-dirts state)))  ; Sum of the distance to the closest dirt
      (min (mapcar #'(lambda (dirt) (distance dirt foe-loc foe-heading)) (vacuum-game-state-dirts state)))) 
      (- (cadr (game-state-scores state)) ;  Difference between the scores for the agents 
      (cadddr (game-state-scores state))))))))


(defun distance (elem loc heading) 
; """Finds the distance (including turns) between the agent location 
;    loc facing direction heading, and a target tile elem. Similar to Q2."""

  (setf dist (apply '+ (mapcar #'(lambda (x y) (abs (- x y))) elem loc)))
  (if (and (< (car elem) (car loc)) (not (equal heading '(-1 0)))) (incf dist))
  (if (and (> (car elem) (car loc)) (not (equal heading '(1 0)))) (incf dist))
  (if (and (< (cadr elem) (cadr loc)) (not (equal heading '(0 -1)))) (incf dist))
  (if (and (> (cadr elem) (cadr loc)) (not (equal heading '(0 1)))) (incf dist))
 dist)



; Get the best move after alphabeta pruning search
(defun vacuum-minimax-alphabeta-decision(state game eval-fn lim)
    (let*(
         (successors (mapcar #'(lambda (move) (cons move (make-move game state move)))
	             (legal-moves game state)))   ; Get successors from current state
         (alpha -1000)  ; Set alpha to large negative value
         (beta 1000)    ; Set beta to large positive value
         (best-move (car (the-biggest 
                           #'(lambda (a+s)   
                              (alpha-beta-value (cdr a+s) game eval-fn 
                              alpha beta (- lim 1)))
                             successors))))  
         ; Apply the alpha beta search algorithm on each successor node to find the next best move

     (format t "best-move: ~A ~%" best-move)
    best-move))


(defun alpha-beta-value(state game eval-fn alpha beta lim) 
; """Use Max value for maximizing player and min value for minimizing player"""
  (if (equal (first (game-state-players state)) 'A)
     (max-value state game eval-fn alpha beta lim)
   (min-value state game eval-fn alpha beta lim)))


(defun max-value(state game eval-fn alpha beta lim)
  (if (or (game-over? game state) (<= lim 0)) (return-from max-value (smart-eval-score state game))) 
  ; If game is over or depth is reached, return the value of evaluation function for current state

  (let (successors (mapcar #'(lambda (move) (cons move (make-move game state move)))
	             (legal-moves game state)))  ; Get successors from current state

   (mapcar #'(lambda (a+s)          ; For every child of the successor node, apply the lambda function
           (let alpha (max alpha (min-value (cdr a+s) game eval-fn alpha beta (- lim 1)))  ; 
           (if (>= alpha beta) (return-from max-value beta)))) successors)) 
           ; Pruning Happens here! (When alpha >= beta) search tree can be pruned and we return the value of beta
   (return-from max-value alpha))


(defun min-value(state game eval-fn alpha beta lim)
  (if (or (game-over? game state) (<= lim 0)) (return-from min-value (smart-eval-score state game)))
  ; If game is over or depth is reached, return the value of evaluation function for current state

  (let (successors (mapcar #'(lambda (move) (cons move (make-move game state move)))
	             (legal-moves game state))) ;Get successors from current state

   (mapcar #'(lambda (a+s)          
          (let beta (min beta (max-value (cdr a+s) game eval-fn alpha beta (- lim 1)))
          (if (> alpha beta) (return-from min-value alpha)))) successors))
          ; Pruning Happens here! (When alpha > beta) search tree can be pruned and we return the value of alpha
   (return-from min-value beta))



; Do not write anything else, especially the agent body or the environment.
; The checker will do that for you. You can use the following code to test it.
; The code has to be commented for submission!

; (defstructure (smart-vacuum-agent (:include game-agent
;         (algorithm #'smart-vacuum-agent-algorithm))))

; ; Pure minimax vacuum agent
; (run-environment (make-game-environment
;     :max-steps 32
;     :game (make-vacuum-game :dirt-probability 0.5)
;     :agents '(smart-vacuum-agent minimax-cutoff-vacuum-agent)))

; ; Minimax agent that prefers immediate moves
; (run-environment (make-game-environment
;     :max-steps 32
;     :game (make-vacuum-game :dirt-probability 0.5)
;     :agents '(smart-vacuum-agent minimax-combining-cutoff-vacuum-agent)))

; ; For fun (and learning the minimax-combining-cutoff-vacuum-agent)
; (run-environment (make-game-environment
;     :max-steps 32
;     :game (make-vacuum-game :dirt-probability 0.5)
;     :agents '(minimax-combining-cutoff-vacuum-agent
;           minimax-combining-cutoff-vacuum-agent)))


;;;; BONUS 1:   [10 marks for each improvement (listed below) (maximum of 20
;;;;                marks total)]

; Improvements:
;   * ordering states by some dynamic heuristic
;   * well-thought-out and well-implemented model of killer moves
;   * transposition table
;   * cutting-off search


; See section 3: Alpha-Beta Pruning and section 4: Imperfect
; Real-Time Decision in chapter Adversarial Search in the course
; textbook (AIMA) for details about alpha-beta pruning
; and description of possible improvements.
; Adversarial Search is chapter 5 (in 3rd edition) or chapter 6
; (in 2nd edition) of the book.

; To receive credit for improvements, incorporate them into
; question 3, well commented and documented!

; Then list which improvements you have implemented here.



;;;; BONUS 2:   [-5 to +30 points based on performance]

; You may enter a competition against other students by defining a structure
; YOUR_MATRICULATION_NUMBER-vacuum-agent

; The agents will compete against each other in pairs. Each agent gets to
; compete against each other agent twice -- with swapped starting positions,
; but in the same environment. Evaluation is the same as in question 3.

; WARNING: Entering the competition costs you 5 marks!

; Winner wins (min 30 (length competitors)) marks. Player at n-th position
; "wins" (max (+ (- (min 30 (length competitors)) n) 1) -5) marks.

; FAIR PLAY: In order to give all agents a fair chance, we limit the execution
; of agents to 1 second per move on the lab computers, with CLisp 2.49,
; compiled code.

; In case your agent exceeds this limit, the execution of your agent
; causes an error during a competition, your agent will be disqualified.
; Test your agent thoroughly, e.g. against your classmates!

; (defstructure (YOUR_MATRICULATION_NUMBER-vacuum-agent
           ; (:include game-agent (algorithm 'pick-random-move))))


