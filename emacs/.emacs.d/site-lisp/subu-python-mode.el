;; (require 'python-mode)

(message "Loading Subu Python Mode ....")
(add-hook 'subu-python-mode-hook
	  (lambda ()
	    (add-to-list 'ac-sources 'ac-source-ropemacs)))

(defun annotate-pdb ()
  (interactive)
  (highlight-lines-matching-regexp "import pdb")
  (highlight-lines-matching-regexp "pdb.set_trace()"))

(add-hook 'subu-python-mode-hook 'annotate-pdb)

(defun python-add-breakpoint ()
  (interactive)
  (py-newline-and-indent)
  (insert "import pdb; pdb.set_trace();")
  (py-newline-and-indent)
  (highlight-lines-matching-regexp "^[ ]*import pdb; pdb.set_trace()"))

(require 'python-pep8)
(require 'python-pylint)

;; (require 'comint)
;; (define-key comint-mode-map [(meta p)]
;;   'comint-previous-matching-input-from-input)
;; (define-key comint-mode-map [(meta n)]
;;   'comint-next-matching-input-from-input)
;; (define-key comint-mode-map [(control meta n)]
;;   'comint-next-input)
;; (define-key comint-mode-map [(control meta p)]
;;   'comint-previous-input)
;; (py-toggle-shells 1)

;; (custom-set-variables
;;  '(py-pychecker-command "pychecker.sh")
;;  '(py-py-checker-command-args (quote ("")))
;;  '(python-check-command "pychecker.sh")
;;  )

(defvaralias 'python-mode-map 'py-mode-map)
(setq font-lock-maximum-decoration t)

;; pymacs
(setq pymacs-load-path '("/home/chitsubr/.local/lib/python2.7/site-packages/rope/"
			 "/home/chitsubr/.local/lib/python2.7/site-packages/ropemode/"
			 "/home/chitsubr/.local/lib/python2.7/site-packages/Pymacs/"
			 "/home/chitsubr/.local/lib/python2.7/site-packages/ropemacs-0.6-py2.7.egg/ropemacs/"
			 "/home/chitsubr/.local/lib/python2.7/site-packages/ropemacs-0.6-py2.7.egg/ropemacs/ropemacs"
			 ))

(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)
;; (setq ropemacs-enable-shortcuts nil)
(setq ropemacs-local-prefix "C-c C-p")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Auto-completion
;;;  Integrates:
;;;   1) Rope
;;;   2) Yasnippet
;;;   all with AutoComplete.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun prefix-list-elements (list prefix)
  (let (value)
    (nreverse
     (dolist (element list value)
       (setq value (cons (format "%s%s" prefix element) value))))))

(defvar ac-source-rope
  '((candidates
     . (lambda ()
	 (prefix-list-elements (rope-completions) ac-target))))
  "Source for Rope")

(defun ac-python-find ()
  "Python `c-find-function'."
  (require 'thingatpt)
  (let ((symbol (car-safe (bounds-of-thing-at-point 'symbol))))
    (if (null symbol)
	(if (string= "." (buffer-substring (- (point) 1) (point)))
	    (point)
	  nil)
      symbol)))

(defun ac-python-candidate ()
  "Python `c-candidates-function'"
  (let (candidates)
    (dolist (source ac-sources)
      (if (symbolp source)
	  (setq source (symbol-value source)))
      (let* ((ac-limit (or (cdr-safe (assq 'limit source)) ac-limit))
	     (requires (cdr-safe (assq 'requires source)))
	     cand)
	(if (or (null requires)
		(>= (length ac-target) requires))
	    (setq cand
		  (delq nil
			(mapcar (lambda (candidate)
				  (propertize candidate 'source source))
				(funcall (cdr (assq 'candidates source)))))))
	(if (and (> ac-limit 1)
		 (> (length cand) ac-limit))
	    (setcdr (nthcdr (1- ac-limit) cand) nil))
	(setq candidates (append candidates cand))))
    (delete-dups candidates)))

(add-hook 'subu-python-mode-hook
	  (lambda ()
	    (set (make-local-variable 'ac-sources)
		 (append ac-sources '(ac-source-rope)))
	    (set (make-local-variable 'ac-find-function) 'ac-python-find)
	    (set (make-local-variable 'ac-candidate-function) 'ac-python-candidate)
	    (set (make-local-variable 'ac-auto-start) nil)))

;;Ryan's python specific tab completion
                                        ; Try the following in order:
                                        ; 1) Try a yasnippet expansion without autocomplete
                                        ; 2) If at the beginning of the line, indent
                                        ; 3) If at the end of the line, try to autocomplete
                                        ; 4) If the char after point is not alpha-numerical, try autocomplete
                                        ; 5) Try to do a regular python indent.
                                        ; 6) If at the end of a word, try autocomplete.


(defun ryan-indent ()
  "Runs indent-for-tab-command but returns t if it actually did an indent; nil otherwise"
  (let ((prev-point (point)))
    (indent-for-tab-command)
    (if (eql (point) prev-point)
	nil
      t)))

(defun ryan-python-expand-after-yasnippet ()
  (interactive)
  ;;2) Try indent at beginning of the line
  (let ((prev-point (point))
	(beginning-of-line nil))
    (save-excursion
      (move-beginning-of-line nil)
      (if (eql 0 (string-match "\\W*$" (buffer-substring (point) prev-point)))
	  (setq beginning-of-line t)))
    (if beginning-of-line
	(ryan-indent)))
  ;;3) Try autocomplete if at the end of a line, or
  ;;4) Try autocomplete if the next char is not alpha-numerical
  (if (or (string-match "\n" (buffer-substring (point) (+ (point) 1)))
	  (not (string-match "[a-zA-Z0-9]" (buffer-substring (point) (+ (point) 1)))))
      (ac-start)
    ;;5) Try a regular indent
    (if (not (ryan-indent))
	;;6) Try autocomplete at the end of a word
	(if (string-match "\\W" (buffer-substring (point) (+ (point) 1)))
	    (ac-start)))))

;; End Tab completion


;;Workaround so that Autocomplete is by default is only invoked explicitly,
;;but still automatically updates as you type while attempting to complete.
(defadvice ac-start (before advice-turn-on-auto-start activate)
  (set (make-local-variable 'ac-auto-start) t))
(defadvice ac-cleanup (after advice-turn-off-auto-start activate)
  (set (make-local-variable 'ac-auto-start) nil))

(define-key python-mode-map "\t" 'ryan-python-expand-after-yasnippet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; End Auto Completion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'subu-python-mode)