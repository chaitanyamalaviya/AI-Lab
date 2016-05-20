;;;; CZ3005 2015 Semester 2: Lab 3

; Make sure your working directory is labs

(unuse-package "EXT") ; In POXIS systems, there is a symbol conflict
; from now on, to quit, use (ext:quit) instead of (quit)
(load "aima/aima.lisp")
; (load "labs/aima/aima.lisp")
(aima-load '(agents search))
(aima-compile '(agents search)) ; in case of warnings, just "continue"
(test 'agents)
(test 'search)

; The following lab uses lots of code from AIMA
; Go through the source code of the following files from the search module
; of AIMA to get the general ideas used in the framework

; /aima/agents/environments/basic-env.lisp
; /aima/agents/environments/grid-env.lisp
; /aima/agents/environments/vacuum.lisp

; (change-directory "/Users/chaitanya/Desktop/study/4.2/CZ3005\ -\ Artificial\ Intelligence/Lab/lab3")
; (load "aima/aima.lisp")


; run-environment:: Basic environment simulator.  It gives each agent its percept, gets an
;                   action from each agent, and updates the environment. It also keeps score
;                   for each agent, and optionally displays intermediate results.
; Run the random (default) vacuum agent in the vacuum environment
; Defualt vacuum agent is random-vacuum-agent: "A very stupid agent: ignore percept and choose a random action."
; Defualt dirt probability at each square = .25
; Percept is a three-element sequence: bump, dirt and home


(run-environment (make-vacuum-world
    :max-steps 10))  ; Can only do 10 steps
; Do not print the intermediate states
(run-environment (make-vacuum-world
    :stream nil))

; Use :CSPEC (custom specification) to set the dirt probability
; at each square
(run-environment (make-vacuum-world
    :cspec '((at all (P 0.9 dirt)))
    :max-steps 10))




;;;; VACUUM AGENTS

;;; An agent is something that perceives and acts.  As such, each agent has a
;;; slot to hold its current percept, and its current action.  The action
;;; will be handed back to the environment simulator to perform (if legal).
;;; Each agent also has a slot for the agent program, and one for its score
;;; as determined by the performance measure.

; (defstructure agent
;   "Agents take actions (based on percepts and the agent program) and receive
;   a score (based on the performance measure).  An agent has a body which can
;   take action, and a program to choose the actions, based on percepts."
;   (program #'nothing)           ; fn: percept -> action
;   (body (make-agent-body))
;   (score 0)
;   (percept nil)
;   (action nil)
;   (name nil))

;;;; Some simple agents for the vacuum world

; (defstructure (random-vacuum-agent
;    (:include agent
;     (program
;      #'(lambda (percept)
;      (declare (ignore percept))  ; ignore percept even if it is there
;      (random-element
;       '(suck forward (turn right) (turn left) shut-off))))))
;   "A very stupid agent: ignore percept and choose a random action out of the .")


; (defstructure (reactive-vacuum-agent 
;    (:include agent
;     (program 
;      #'(lambda (percept)
;    (destructuring-bind (bump dirt home) percept
;      (cond (dirt 'suck)
;      (home (random-element '(shut-off forward (turn right))))
;      (bump (random-element '((turn right) (turn left))))
;      (t (random-element '(forward forward forward
;                 (turn right) (turn left))))))))))
;   "When you bump, turn randomly; otherwise mostly go forward, but
;   occasionally turn.  Always suck when there is dirt.")


; Use :ASPEC (agent specification) to set the agent type
(run-environment (make-vacuum-world
 ;   :stream nil
    :aspec '(reactive-vacuum-agent)))

; Compare two agents
(agent-trials 'make-vacuum-world
    '(reactive-vacuum-agent random-vacuum-agent)
    :n 10) ; run both in 10 environments


; Interactive agent

; We now define our own interactive agent. Try it by typing in one of the
; legal moves: '(suck forward (turn left) (turn right) shut-off))

(defun ask-user-vacuum (percept)
  "Ask the user what action to take."
  (format t "~&Percept is ~A; action? " percept)
  (parse-line (read-line)))

(defun parse-line (string)
  (if (or (null string) (equal "" string)) nil
    (let ((read (multiple-value-list (read-from-string string))))
      (if (car read) (cons (car read) (parse-line (subseq string (cadr read)))) nil ))))

(defstructure (ask-user-vacuum-agent (:include agent (program 'ask-user-vacuum)))
  "An agent that asks the user to type in an action.")

(run-environment (make-vacuum-world
    :aspec '(ask-user-vacuum-agent)
    :max-steps 10))


;;;; VACUUM AGENTS WITH GPS

; What if our vacuum machine has a GPS device?
; Let's define a new world, where all vacuum machines know their position and
; heading.
; get-percept is called in run-environment

(defstructure (vacuum-world-gps (:include vacuum-world)))

(defmethod get-percept ((env vacuum-world-gps) agent)
  (let ((loc (object-loc (agent-body agent)))
        (heading (object-heading (agent-body agent))))
    (append (call-next-method) (list loc heading))))  ; here if heading would be (1, 0) it is heading right, if (0,-1) heading down

(run-environment (make-vacuum-world-gps
    :aspec '(ask-user-vacuum-agent)
    :max-steps 10))


; In a world with GPS, what is a random vacuum agent going to do?

(run-environment (make-vacuum-world-gps
    :aspec '(random-vacuum-agent)
    :max-steps 10))

; And how about a reactive agent?

(defstructure (reactive-vacuum-agent-with-gps
   (:include agent
    (program
     #'(lambda (percept)
     (destructuring-bind (bump dirt home) (subseq percept 0 3)
       (cond (dirt 'suck)
         (home (random-element '(shut-off forward (turn right))))
         (bump (random-element '((turn right) (turn left))))
         (t (random-element '(forward forward forward
                          (turn right) (turn left))))))))))
  "When you bump, turn randomly; otherwise mostly go forward, but
  occasionally turn.  Always suck when there is dirt.")

(run-environment (make-vacuum-world-gps
    :aspec '(reactive-vacuum-agent-with-gps)
    :max-steps 10))


; Let's define our own agent. He's going to use his GPS to navigate
; around the grid

(defstructure (dumb-traversal-vacuum-agent-with-gps
  (:include agent
    (program #'smart-traversal-vacuum-agent-with-gps-program))))

(defun dumb-traversal-vacuum-agent-with-gps-program (percept)
     (destructuring-bind (bump dirt home loc heading) (subseq percept 0 5)
       (cond (dirt 'suck)
         ((and (not (equal heading (@ 0 1))) home) '(turn right)) ; if not heading up and at home-> turn right
         ((and bump (not home)) '(turn right))  ; bump->turn right 
         ((and (equal heading (@ 1 0)) (not home)) 'forward)
         (t 'forward)))) ; else-> move forward



(defun smart-traversal-vacuum-agent-with-gps-program (percept)
     (destructuring-bind (bump dirt home loc heading) (subseq percept 0 5)
       (cond (dirt 'suck)
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
          

(run-environment (make-vacuum-world-gps
    :aspec '(dumb-traversal-vacuum-agent-with-gps)
    :max-steps 80))

; It is obvious that this agent is not the best one. It only walks around
; the perimeter of the grid and doesn't suck any dirt inside the grid.




;;;; VACUUM WORLD WITH RADAR

; What if our agents could see the whole grid?
; Let's give our agents one last upgrade - a powerful radar!

(defstructure (vacuum-world-radar (:include vacuum-world-gps)))

(defstructure (home (:include object (name "H") (size 0.01))))

(defmethod get-percept ((env vacuum-world-radar) agent)
  (let ((grid (copy-array (vacuum-world-grid env)))
        (home (grid-environment-start env)))
    (append (call-next-method) (list grid (grid-environment-start env)))))

(defstructure (dumb-traversal-vacuum-agent-with-radar
  (:include agent
    (program #'dumb-traversal-vacuum-agent-with-radar-program))))

(defun dumb-traversal-vacuum-agent-with-radar-program (percept)
    (destructuring-bind (bump dirt home loc heading radar home-loc) percept
        (let ((go-to-dirt (find-some-in-grid radar 'DIRT)) ; (x y) for dirt
              (go-to-home home-loc))
            (let ((turn (turn-towards-dirt loc heading
                    (if go-to-dirt go-to-dirt go-to-home)))) ; if dirt exists, then find where to turn to go towards dirt, else find where to turn to go towards home
                (cond
                    (turn turn)  ; turn if a turn is specified
                    (dirt 'suck)  ; suck on dirt
                    ((and (not go-to-dirt) home) 'shut-off)  ; if at home and no dirt exists -> shut-off
                    (t 'forward)
                    )))))

(defun find-some-in-grid (radar type) ; search from x=0 to m and y=0 to n for first type(dirt) found and return the location
    (dotimes (x (car (array-dimensions radar)))
        (dotimes (y (cadr (array-dimensions radar)))
            (let ((elems (aref radar x y)))
                (dolist (e elems) 
                    (when (eq (type-of e) type)
                        (return-from find-some-in-grid (list x y)))) nil))))

(defun turn-towards-dirt (loc heading go-to-dirt)
    (let ((vdiff (- (first go-to-dirt) (first loc)))  ; vertical difference
          (hdiff (if (= (- (first go-to-dirt) (first loc)) 0) (- (second go-to-dirt) (second loc)) 0)) ; hdiff = if vertical_diff is 0, then horizontal_diff, else 0
          (vheading (first heading))  ; vheading= heading-x
          (hheading (second heading))) ;  hheading= heading-y
        (let ((vdiffn (if (= vdiff 0) 0 (/ vdiff (abs vdiff)))) ; vdiffn = if vdiff is 0, then 0 else sign_of_vdiff
              (hdiffn (if (= hdiff 0) 0 (/ hdiff (abs hdiff))))) ;  hdiffn = if hdiff is 0, then 0 else sign_of_hdiff
            (let ((cprodz
                (-  (* vdiffn hheading)     ; cprodz = vdiffn*heading-x - hdiffn*heading-y
                    (* hdiffn vheading))))
                ; (format t "~%loc: ~A, heading: ~A, go-to-dirt: ~A, cprodz: ~A, diffn: ~A ~A ~%" loc heading go-to-dirt cprodz vdiffn hdiffn)
                (cond
                    ((or (= (abs (- vdiffn vheading)) 2)
                        (= (abs (- hdiffn hheading)) 2)) '(turn right))
                    ((> cprodz 0) '(turn right))
                    ((< cprodz 0) '(turn left))
                    (t nil))))))


(defun distance (elem loc heading) 
(setf dist (apply '+ (mapcar #'(lambda (x y) (abs (- x y))) elem loc)))
(if (and (< (car elem) (car loc)) (not (equal heading '(-1 0)))) (incf dist))
(if (and (> (car elem) (car loc)) (not (equal heading '(1 0)))) (incf dist))
(if (and (< (cadr elem) (cadr loc)) (not (equal heading '(0 -1)))) (incf dist))
(if (and (> (cadr elem) (cadr loc)) (not (equal heading '(0 1)))) (incf dist))
dist)

(defun linear_distance (elem home-loc)
(sqrt (apply '+ (mapcar #'(lambda (x y) (expt (- x y) 2)) elem home-loc))))


(defun find-dirt-in-grid (radar type loc heading home-loc) 
    (setf nextmove nil)
    (setf min 1000)
    (dotimes (x (car (array-dimensions radar)))
        (dotimes (y (cadr (array-dimensions radar)))
            (let ((elems (aref radar x y)))
                (dolist (e elems) 
                    (when (eq (type-of e) type)
                        (setf dist (+ (linear_distance (list x y) home-loc) (distance (list x y) loc heading)))
                        (if (<= dist min) 
                            (progn 
                              (setf min dist) 
                              (setf nextmove (list x y)))))))))
     (return-from find-dirt-in-grid nextmove) nil)    
        

(defstructure (smart-traversal-vacuum-agent-with-radar
   (:include agent
     (program #'smart-traversal-vacuum-agent-with-radar-program))))

(defun smart-traversal-vacuum-agent-with-radar-program (percept)
    (destructuring-bind (bump dirt home loc heading radar home-loc) percept
        (setf go-to-dirt nil)
        (let ((go-to-dirt (find-dirt-in-grid radar 'DIRT loc heading home-loc)) ; (x y) for dirt
              (go-to-home home-loc))
            (let ((turn (turn-towards-dirt loc heading
                    (if go-to-dirt go-to-dirt go-to-home)))) ; if dirt exists, then find where to turn to go towards dirt, else find where to turn to go towards home
                (cond
                    (turn turn)  ; turn if a turn is specified
                    (dirt 'suck)  ; suck on dirt
                    ((and (not go-to-dirt) home) 'shut-off)  ; if at home and no dirt exists -> shut-off
                    (t 'forward)
                    )))))


(run-environment (make-vacuum-world-radar
    :aspec '(smart-traversal-vacuum-agent-with-radar)
    :max-steps 64))

; How does our dumb-traversal-vacuum-agent-with-radar compare to the previous
; agent dumb-traversal-vacuum-agent-with-gps?

(agent-trials 'make-vacuum-world-radar
          '(smart-traversal-vacuum-agent-with-radar
            dumb-traversal-vacuum-agent-with-radar) :n 16)


(agent-trials 'make-vacuum-world-radar
         '(dumb-traversal-vacuum-agent-with-gps dumb-traversal-vacuum-agent-with-radar) :n 4)





;;;; ADVERSARIAL SEARCH

; So far we have only been interested in a single agent in the grid at
; a time. Let's have two agents now. When one of them sucks dirt, the
; other one has to go get dirt elsewhere.

; We also use a simplified model this time. The score is evaluated according
; to the following two rules:
;       * -1 point for every turn (including successful suck)
;       * +10 points for successful suck

; The state model is simplified. There are no walls now. The dirt is described
; by a list of locations.

; VERY IMPORTANT !!!
; Read thoroughly aima/search/environments/vacuum-game.lisp
; then come back here!


; Here we run two random agents against each other
(run-game (make-vacuum-game) :agents '(random-game-agent random-game-agent))

; How about human controlled agents?
; Try to run the following code and control your agent by typing one of
; the legal moves. Can you beat a random agent?
; To stop the simulation, just use shut-off move.
(run-game (make-vacuum-game) :agents '(human-game-agent random-game-agent))

(defstructure (smart-vacuum-agent 
        (:include game-agent
        (algorithm 'smart-vacuum-agent-algorithm))))

(defun smart-vacuum-agent-algorithm (state game)
  (vacuum-minimax-alphabeta-decision state game #'smart-eval-score 9))


(defun distance (elem loc heading) 
(setf dist (apply '+ (mapcar #'(lambda (x y) (abs (- x y))) elem loc)))
(if (and (< (car elem) (car loc)) (not (equal heading '(-1 0)))) (incf dist))
(if (and (> (car elem) (car loc)) (not (equal heading '(1 0)))) (incf dist))
(if (and (< (cadr elem) (cadr loc)) (not (equal heading '(0 -1)))) (incf dist))
(if (and (> (cadr elem) (cadr loc)) (not (equal heading '(0 1)))) (incf dist))
dist)


(defun smart-eval-score (state game)

  (destructuring-bind (my-agent foe-agent) (vacuum-game-state-agents state)
   (destructuring-bind (my-loc my-heading) my-agent
    (destructuring-bind (foe-loc foe-heading) foe-agent
      (+ 
      (- (min (mapcar #'(lambda (dirt) (distance dirt my-loc my-heading)) (vacuum-game-state-dirts state))) 
      (min (mapcar #'(lambda (dirt) (distance dirt foe-loc foe-heading)) (vacuum-game-state-dirts state)))) 
      (- (cadr (game-state-scores state)) 
      (cadddr (game-state-scores state))))))))



(defun alpha-beta-value(state game eval-fn alpha beta lim) 
  (if (equal (first (game-state-players state)) 'A)
    (progn (print "bol")
     (max-value state game eval-fn alpha beta lim))
   (min-value state game eval-fn alpha beta lim)))


(defun max-value(state game eval-fn alpha beta lim)
  (if (or (game-over? game state) (<= lim 0)) (return-from max-value (smart-eval-score state game)))
  (let (successors (mapcar #'(lambda (move) (cons move (make-move game state move)))
	             (legal-moves game state)))

   (mapcar #'(lambda (a+s)          
           (let alpha (max alpha (min-value (cdr a+s) game eval-fn alpha beta (- lim 1)))
           (if (>= alpha beta) (return-from max-value beta)))) successors))
   (return-from max-value alpha))



(defun min-value(state game eval-fn alpha beta lim)
  (if (or (game-over? game state) (<= lim 0)) (return-from min-value (smart-eval-score state game)))
  (let (successors (mapcar #'(lambda (move) (cons move (make-move game state move)))
	             (legal-moves game state)))

   (mapcar #'(lambda (a+s)          
          (let beta (min beta (max-value (cdr a+s) game eval-fn alpha beta (- lim 1)))
          (if (> alpha beta) (return-from min-value alpha)))) successors))
   (return-from min-value beta))



; Get the best move after alphabeta pruning search
(defun vacuum-minimax-alphabeta-decision(state game eval-fn lim)
    (let*(
         (successors (mapcar #'(lambda (move) (cons move (make-move game state move)))
	             (legal-moves game state)))
         (alpha -1000)
         (beta 1000)
         (best-move (car (the-biggest 
                           #'(lambda (a+s)   
                              (alpha-beta-value (cdr a+s) game eval-fn 
                              alpha beta (- lim 1)))
                             successors))))

     (format t "best-move: ~A ~%" best-move)
    best-move))


 (run-environment (make-game-environment
     :max-steps 4
     :game (make-vacuum-game)
     :agents '(smart-vacuum-agent minimax-cutoff-vacuum-agent)))

; Let's now build our own agent based on minimax

; VERY IMPORTANT !!!
; Read thoroughly through:
;    * aima/search/algorithms/minimax.lisp
;    * aima/search/agents/vacuum-agent.lisp
; then come back here!


(run-environment (make-game-environment
    :max-steps 8
    :game (make-vacuum-game :dirt-probability 0.5)
    :agents '(minimax-cutoff-vacuum-agent random-game-agent)))
