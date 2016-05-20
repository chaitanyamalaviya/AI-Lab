; The minimax algorithm used here is a slight modification of minimax
; implemnetation in AIMA modified for vacuum world.

; This is a very primitive evaluation function that is based solely on the
; current score of the state. There is no notion of proximity to any dirt nor
; coverage of dirt by the two agents.
(defun vacuum-agent-eval (state)  ; Evaluation function that gets the scores for a state and each player
  (mapcar #'(lambda (player) (getf (game-state-scores state) player))
      (game-state-players state)))  ; players attrib of game-state

(defun vacuum-agent-eval-score (state)
  (game-state-scores state))


; Return the best move to take from a given state using minimax algorithm given the limit and evaluation function.
(defun vacuum-minimax-cutoff-decision (state game eval-fn limit)
  (let* (
        (successors (game-successors state game))
        (current-player (first (game-state-players state)))  ;first player
        (list-of-actions+eval   ; list of actions and their evaluation value for successors
          (mapcar #'(lambda (a+s)
                (vacuum-minimax-cutoff-value (cdr a+s) game eval-fn  ;(cdr a+s) gives state
                               (list (car a+s)) (- limit 1)))
                successors))
        (best-actions+eval
            (the-biggest
                #'(lambda (actions+eval)
                    (getf (cdr actions+eval) current-player))
                list-of-actions+eval))     ;get the biggest/max evaluation's action+eval
        (my-best-eval
            (getf (cdr best-actions+eval) current-player))   ;get current player's best evaluation value
        (best-move
            (car (car best-actions+eval))))    ; best action/move
     (format t "list-of-actions+eval: ~A ~%" list-of-actions+eval)
     (format t "best-actions+eval: ~A ~%" best-actions+eval)
     (format t "my-best-eval: ~A ~%" my-best-eval)
     (format t "best-move: ~A ~%" best-move)
    best-move))

; Recursive function to compute the best value starting from given state
; Note that this function does not depend on lowest level states only, as
; the naive minimax implementation does. We combine values of intermediate
; states. This is to evaluate good states closer to the current state with
; better value, to prevent some deadlocks and to make the agent partially
; predictable even with lower level minimax (or other algorithms).

(defun vacuum-minimax-cutoff-value (state game eval-fn actions &optional (limit 3))
  (print (first (game-state-players state)))
  (let ((current-eval (funcall eval-fn state)) ; Evaluate the passed state's evaluation func(here, simply the score)
        (current-player (first (game-state-players state))))
    (cond ; First check for terminal conditions
      ((or (game-over? game state)
           (>= 0 limit)) ; Hit the bottom (recursive func)  ; when limit is 0 all recursive calls start returning and printing score/eval and actions
           (progn
           (format t "   score/eval: ~A; Actions: ~A ~%" current-eval actions)
        (cons actions current-eval))) ; Return ( nil . current-values )
      (t (format t "In T")
         (let* (
            ; Generate all successor states
            (successors (game-successors state game))
            ; List of length 5 (1 element for each action)
            ; consisting of cons cells of actions list (that lead to the best
            ; states at lower levels and evaluaiton for that sequence of actions
            (list-of-actions+eval
                (mapcar #'(lambda (a+s)
                     (vacuum-minimax-cutoff-value (cdr a+s) game eval-fn
                                   (append actions (list (car a+s)))
                                   (- limit 1)))
                     successors))
            ; Choose the best action from the previous list based on the best
            ; evaluation (corresponding to current agent)

            (best-actions+eval
              (the-biggest
                #'(lambda (actions+eval)
                    (getf (cdr actions+eval) current-player))
                  list-of-actions+eval))
            ; Combine the evaluation for the best state with the evaluation of this
            ; intermediate state - this makes the agent prefer actions that result
            ; in more immediate benefits, i.e. sucking nearby dirt
            (combined-best-actions+eval
                (cons
                    (car best-actions+eval) ; Actions of the best move are the same
                    (apply #'append ; append to make a property list
                        (mapcar ; Combine current value with the best value from lower levels
                        #'(lambda (player)
                            (let ((below-eval (cdr best-actions+eval)))
                                ; Create a cell of property list
                                (list player (+
                                    (* (getf current-eval player) 0.5)
                                    (* (getf below-eval player) 0.5)))))
                        (game-state-players state))))))
         (format t "combined-best-actions+eval: ~A ~%" combined-best-actions+eval)
        ; Return cons cell of:
        ;   * actions that lead to the best eval
        ;   * combined value of eval
        combined-best-actions+eval)))))

; Both of these agents use simple score of the state as the evaluation
; function, causing them to effectively miss all the dirts they cannot
; "see" within the (depth of minimax)/2

(defstructure (minimax-cutoff-vacuum-agent
    (:include game-agent
        (algorithm #'(lambda (state game)
            (minimax-cutoff-decision
                state game #'vacuum-agent-eval 6))))))

(defstructure (minimax-combining-cutoff-vacuum-agent
    (:include game-agent
        (algorithm #'(lambda (state game)
            (vacuum-minimax-cutoff-decision
                state game #'vacuum-agent-eval-score 6))))))

