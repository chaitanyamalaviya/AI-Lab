

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
  (if (= (aref visited x y) 0) (progn (setf (aref visited x y) 1) (push (cons x y) seq))))

(defun checkifVisited(x y visited)
  (if (= (aref visited x y) 1) 1
  0))



;;;;Printing State

(defun printState (visited &optional (stream t))
  (dotimes (i (array-total-size visited))
     (if (= (mod i (array-dimension visited 0)) 0) (format t "~C" #\linefeed))
     (if (= (checkifVisited (mod i (array-dimension visited 0)) (floor (/ i (array-dimension visited 1))) visited) 1) (prin1 'X )
       (prin1 'O)))
       (values))


;;;; Defining Problems



(defun knightstour-legalmoves(x y visited) 
; "Get legal moves from current node (x y) and state visited"
  (setf moves (list '(2 -1) '(2 1) '(-2 1) '(-2 -1)
                    '(1 2) '(1 -2) '(-1 2) '(-1 -2))) 
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




(defun backtrack(x y visited)
   (if (= (aref visited x y) 1) (setf (aref visited x y) 0))
   (pop seq)
   (setf newbt (+ 1 (aref btcount (caar seq) (cdar seq))))  
   (setf (aref btcount (caar seq) (cdar seq)) newbt) 
   (expand (caar seq) (cdar seq) visited newbt))


(defun goal-reached (visited) 
  (if (equalp visited *allvisited*) 1 
  0))


(defun expand(x y visited &optional (i 0))
  (setf k (knightstour-legalmoves x y visited))
  (print seq)
  (print (length seq))
  (cond ((aref k i 0)
    (progn
        (if (aref k i 0)
          (progn  
          (visitTile (aref k i 0) (aref k i 1) visited)
          (setf (aref btcount (aref k i 0) (aref k i 1)) 0) 
          (expand (aref k i 0) (aref k i 1) visited)))))
    ((eql (goal-reached visited) 0) 
     (backtrack x y visited))
    ((eql (goal-reached visited) 1)
     (print seq))))

(defun knights-tour-backtracking (x y m n)
  (setf seq nil)
  (setf btcount (make-array (list m n) :initial-element nil))
  (initknightsTourstate m n x y)
  (knightsTour-goalstate m n)
  (expand m n visited))

(knights-tour-backtracking 0 0 5 5)