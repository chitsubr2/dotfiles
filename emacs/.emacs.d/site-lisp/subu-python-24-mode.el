;; (require 'python-mode)

(message "Loading Subu Python 24 Mode ....")

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

(require 'comint)
(define-key comint-mode-map [(meta p)]
  'comint-previous-matching-input-from-input)
(define-key comint-mode-map [(meta n)]
  'comint-next-matching-input-from-input)
(define-key comint-mode-map [(control meta n)]
  'comint-next-input)
(define-key comint-mode-map [(control meta p)]
  'comint-previous-input)
(py-toggle-shells 1)

(defvaralias 'python-mode-map 'py-mode-map)
(setq font-lock-maximum-decoration t)

(provide 'subu-python-24-mode)
