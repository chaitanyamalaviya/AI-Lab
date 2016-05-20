; The minimax algorithm used here is a slight modification of minimax
; implemnetation in AIMA modified for vacuum world.

; This is a very primitive evaluation function that is based solely on the
; current score of the state. There is no notion of proximity to any dirt nor
; coverage of dirt by the two agents.
(defun vacuum-agent-eval (state)
  (mapcar #'(lambda (player) (getf (game-state-scores state) player))
      (game-state-players state)))


; Return the best move to take from a given state using minimax algorithm.
(defun vacuum-minimax-cutoff-decision (state game eval-fn limit)
  (let* ((successors (game-successors state game))
         (best-move
           (car (the-biggest
              #'(lambda (a+s)
                (let* ((mcv (minimax-cutoff-value
                           (cdr a+s) game eval-fn (- limit 1)))
                       (valreal (first (right-rotate (cdr mcv)))))
                  (format t
                    "Action: ~A, action-list: ~A, value: ~A, valreal: ~A ~%"
                    (car a+s)
                    (append (list (car a+s)) (car mcv))
                    (cdr mcv)
                    valreal)
                valreal))
             successors))))
    (format t "Best move: ~A ~%" best-move)
    best-move))

; Recursive function to compute the best value starting from given state
; Note that this function does not depend on lowest level states only, as
; the naive minimax implementation does. We combine values of intermediate
; states. This is to evaluate good states closer to the current state with
; better value, to prevent some deadlocks and to make the agent partially
; predictable even with lower level minimax (or other algorithms).
(defun vacuum-minimax-cutoff-value (state game eval-fn &optional (limit 3))
  (let ((current-eval (funcall eval-fn state))) ; Evaluate current state
    (cond ; First check for terminal conditions
      ((or (game-over? game state)
           (>= 0 limit) ; Hit the bottom
           ; Once shut-off is played by either agent, we don't search
           ; further. Even though it takes both to shut-off to finish a game.
           (eq (game-state-previous-move state) 'shut-off))
        (cons (list) current-eval)) ; Return ( nil . current-values )
      (t (let* ( ; Generate all successor states
                (successors (game-successors state game))
                ; a cons cell consisting of a list of moves (accumulator)
                ; and the best values from the previous layer
                (best-alist+val
                  (the-biggest ; find the biggest value in a list
                    ; Returns second cell (opponent) of values from lower layer
                    #'(lambda (values) (first (right-rotate (cdr values))))
                      (mapcar ; Run a function for all successor states
                        #'(lambda (a+s) ; Run minimax for lower layer
                          (let* ((mcv (minimax-cutoff-value
                                        (cdr a+s)
                                        game eval-fn
                                        (- limit 1))))
                          (cons ; Append actions to first cell cont cell
                            (append (list (car a+s)) (car mcv))
                            (cdr mcv)))) ; Second cell are values
                        successors))))
            (cons ; Create cons cell to be returned
              (car best-alist+val) ; List of actions
              (mapcar ; Combine current value with lower values
                #'(lambda (ce mcve) (+ (* ce 0.5) (* mcve 0.5)))
                current-eval
                (right-rotate
                    (cdr best-alist+val)))))))))


(defstructure (minimax-cutoff-vacuum-agent
    (:include game-agent
        (algorithm #'(lambda (state game)
            (vacuum-minimax-cutoff-decision
                state game #'vacuum-agent-eval 6))))))
