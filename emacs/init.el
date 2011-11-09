;; Uncomment next line to make emacs produce a stack trace for errors.
;; (setq debug-on-error t)

(setq inhibit-bit-startup-message t
      inhibit-startup-echo-area-message t)

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(fset 'yes-or-no-p 'y-or-n-p)
(setq yank-excluded-properties t)

(defun subu-add-correct-path (path alt-path)
  (if (file-exists-p path)
      (add-to-list 'load-path path)
    (add-to-list 'load-path alt-path)
    )
  )

(add-to-list 'load-path "/mnt/nethome/chitsubr/.emacs.d")
(subu-add-correct-path "/data/analysis/chitsubr/.emacs.d/" "/data/chitsubr/.emacs.d/")
(subu-add-correct-path "/data/analysis/chitsubr/.emacs.d/site-lisp/" "/data/chitsubr/.emacs.d/site-lisp/")
(subu-add-correct-path "/data/analysis/chitsubr/.emacs.d/color-theme-6.6.0/" "/data/chitsubr/.emacs.d/color-theme-6.6.0/")
(subu-add-correct-path "/data/analysis/chitsubr/.emacs.d/elpa/paredit-20/" "/data/chitsubr/.emacs.d/elpa/paredit-20/")
(subu-add-correct-path "/data/analysis/chitsubr/.emacs.d/icicles/" "/data/chitsubr/.emacs.d/icicles/")
(subu-add-correct-path "/data/analysis/chitsubr/.emacs.d/plugins/" "/data/chitsubr/.emacs.d/plugins/")
(subu-add-correct-path "/data/analysis/chitsubr/.emacs.d/my-lisp-packages/" "/data/chitsubr/.emacs.d/my-lisp-packages/")

;; (add-to-list 'load-path "/data/analysis/chitsubr/.emacs.d")
;; (add-to-list 'load-path "/data/analysis/chitsubr/.emacs.d/site-lisp/")
;; (add-to-list 'load-path "/data/analysis/chitsubr/.emacs.d/color-theme-6.6.0/")
;; (add-to-list 'load-path "/data/analysis/chitsubr/.emacs.d/elpa/paredit-20/")
;; (add-to-list 'load-path	 "/data/analysis/chitsubr/.emacs.d/plugins/")
;; (add-to-list 'load-path	 "/data/analysis/chitsubr/.emacs.d/icicles/")
;; (add-to-list 'load-path "/data/analysis/chitsubr/.emacs.d/my-lisp-packages/")
;; (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/w3m/")


(require 'custom)
(require 'compile)

(require 'ansi-color)
(require 'auto-complete)
(require 'auto-complete-config)
;; piece of shit bookmark+ interferes with python setup.
(require 'bookmark+)
(require 'browse-kill-ring)
(require 'cl)
(require 'color-theme)
(require 'column-marker)
(require 'crosshairs)
(require 'diminish)
(require 'eldoc)
(require 'ffap)
(require 'indent-file)
(require 'linum)
(require 'magit)
(require 'package)
(require 'paredit)
(require 'rainbow-delimiters)
(require 'recentf)
(require 'saveplace)
(require 'uniquify)
(require 'undo-tree)
(require 'visible-mark)
(require 'w3m-load)
(require 'yasnippet-bundle)

(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)


;;
;; other configs.
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)
(setq tramp-default-method "ssh")
(ffap-bindings)
(setq uniquify-buffer-name-style 'forward)
(recentf-mode 1)
(show-paren-mode 1)
(setq show-paren-delay 0)
(set-register ?e '(file . "~/.emacs.d/init.el"))
(setq whitespace-style '(trailing lines space-before-tab indentation
				  space-after-tab) whitespace-line-column 80)
;; (autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;; (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(when (fboundp 'winner-mode) (winner-mode 1))
(windmove-default-keybindings)
(column-number-mode 1)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'slime-repl-mode-hook 'clojure-mode-font-lock-setup)
(setq eldoc-idle-delay 0)
(autoload 'turn-on-eldoc-mode "eldoc" nil t)

;; (when
;;     (load
;;      (expand-file-name "/data/analysis/chitsubr/.emacs.d/elpa/package.el"))
;;   (package-initialize))


(global-undo-tree-mode 1)
(setq vc-handled-backends nil)

;;
;;
(browse-kill-ring-default-keybindings)

;;
;; diminish
(diminish 'eldoc-mode "E")
(diminish 'paredit-mode "P")
(diminish 'undo-tree-mode "U")
(diminish 'auto-complete-mode "A")
(diminish 'yas/minor-mode "Y")

(add-hook 'emacs-lisp-mode-hook
	    (lambda ()
	      (setq mode-name "eL")))


(eldoc-add-command
 'paredit-backward-delete
 'paredit-close-round)


;;
;; w3m config.
(autoload 'w3m "w3m" "Interface for w3m on Emacs." t)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
 (global-set-key "\C-xm" 'browse-url-at-point)
(setq w3m-use-cookies 't)
(setq browse-url-browser-function 'w3m-browse-url)

;; Keep all backup files in a separate directory.
(if (file-exists-p "/data/analysis/chitsubr/.my-emacs-backups")
    (setq backup-directory-alist `(("." . "/data/analysis/chitsubr/.my-emacs-backups")))
  (setq backup-directory-alist `(("." . "/data/chitsubr/.my-emacs-backups")))
  )

;; (setq backup-directory-alist `(("." . "/data/analysis/chitsubr/.my-emacs-backups")))
(setq delete-old-versions t
      kept-new-versions 5
      kept-old-versions 2
      version-control t)


(put 'narrow-to-region 'disabled nil)

;; Remember the place (line,column) in each file visited even if
;; we close the files.
(if (file-exists-p "/data/analysis/chitsubr/.emacs.d/saveplace")
    (setq save-place-file "/data/analysis/chitsubr/.emacs.d/saveplace")
  (setq save-place-file "/data/chitsubr/.emacs.d/saveplace")
  )

;;(setq save-place-file "/data/analysis/chitsubr/.emacs.d/saveplace")
(setq-default save-place t)                   ;; activate it for all buffers

;;
;; auto-complete config with ropemacs.
(if (file-exists-p "/data/analysis/chitsubr/.emacs.d/ac-dict")
    (add-to-list 'ac-dictionary-directories "/data/analysis/chitsubr/.emacs.d/ac-dict")
  (add-to-list 'ac-dictionary-directories "/data/chitsubr/.emacs.d/ac-dict")
  )
;; (add-to-list 'ac-dictionary-directories "/data/analysis/chitsubr/.emacs.d/ac-dict")
(if (file-exists-p "/data/analysis/chitsubr/.emacs.d/ac-comphist.dat")
    (setq ac-comphist-file  "/data/analysis/chitsubr/.emacs.d/ac-comphist.dat")
  (setq ac-comphist-file  "/data/chitsubr/.emacs.d/ac-comphist.dat")
  )
;; (setq ac-comphist-file  "/data/analysis/chitsubr/.emacs.d/ac-comphist.dat")
(ac-config-default)
(global-auto-complete-mode t)
(ac-ropemacs-initialize)

;;
;; my color theme and fonts.
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     ))
(color-theme-clarity)
(set-frame-font "Monaco-13")

;;; crosshair
;; (crosshairs-mode)
(set-face-background 'hl-line "#115")
(col-highlight-set-interval 60)
(hl-line-when-idle-interval 60)
(toggle-crosshairs-when-idle 1)
(set-face-foreground 'highlight nil)

;;
;; Config for lispy modes.

(defvar electrify-return-match
  "[\]}\)\"]"
  "If this regexp matches the text after the cursor, do an \"electric\"
  return.")

(defun electrify-return-if-match (arg)
  "If the text after the cursor matches `electrify-return-match' then
  open and indent an empty line between the cursor and the text.  Move the
  cursor to the new line."
  (interactive "p")
  (let ((case-fold-search nil))
    (if (looking-at electrify-return-match)
	(save-excursion (newline-and-indent)))
    (newline arg)
    (indent-according-to-mode)))

(setq lispy-modes (list 'lisp-mode-hook 'clojure-mode-hook 'slime-repl-mode-hook
			'emacs-lisp-mode-hook 'lisp-interaction-mode-hook
			'ielm-mode-hook
			))

(defun subu-turn-on-paredit ()
  (paredit-mode 1)
  )

(setq-default frame-background-mode 'dark)
(loop for hook in lispy-modes do
      (add-hook hook (lambda () (rainbow-delimiters-mode 1)))
      (add-hook hook 'turn-on-eldoc-mode)
      (setq autopair-dont-activate t)
      (local-set-key (kbd "RET") 'electrify-return-if-match)
      (add-hook hook 'subu-turn-on-paredit)
      )

;;
;; Python setup.

(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
				   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)

(add-hook 'python-mode-hook
	  (lambda ()
	    (setq process-connection-type nil)
	    (set-variable 'py-indent-offset 4)
	    (set-variable 'indent-tabs-mode nil)
	    (define-key py-mode-map (kbd "RET") 'newline-and-indent)
	    (interactive) (column-marker-1 80)
	    ;; (subu-turn-on-paredit)
	    ))

;; (setq python24-machines '("dev-ibnp-app1.soma.ironport.com"
;; 			  ))

;; (if (member (system-name) python24-machines)
;;     (load "subu-python-24-mode")
;;     )

;; (unless (member (system-name) python24-machines)
;;   (add-hook 'python-mode-hook
;; 	    (lambda ()
;; 	      ;; (require 'ipython)
;; 	      ;; (setq ipython-command "/usr/local/bin/ipython2.7")
;; 	      ;; (setq py-python-command-args '("--pylab" "--colors=Linux"))
;; 	      (setq pylookup-dir "/data/analysis/chitsubr/.emacs.d/pylookup/")
;; 	      (add-to-list 'load-path pylookup-dir)
;; 	      (eval-when-compile (require 'pylookup))
;; 	      (setq pylookup-program (concat pylookup-dir "/pylookup.py"))
;; 	      (setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))
;; 	      (autoload 'pylookup-lookup "pylookup"
;; 		"Lookup SEARCH-TERM in the Python HTML indexes." t)
;; 	      (global-set-key "\C-ch" 'pylookup-lookup)
;; 	      (message "Before Subu Python Mode")
;; 	      (load "subu-python-mode"))
;; 	    )
;;   )

;; Toggle window dedication
(defun toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not"
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
	 (set-window-dedicated-p window
				 (not (window-dedicated-p window))))
       "Window '%s' is dedicated"
     "Window '%s' is normal")
   (current-buffer)))

(defun push-mark-no-activate ()
  (interactive)
  (push-mark (point)
	      t nil)
  (message "Pushed mark to ring"))

(defun jump-to-mark ()
  (interactive)
  (set-mark-command 1)
  )

(defun subu-switch-default-buffer ()
  (interactive)
  (setq first-good
	(catch 'break
	  (loop for name in  (cdr (mapcar (function buffer-name) (buffer-list))) do
		(unless (or (= ?* (aref name 0))
			    (= ?  (aref name 0))
			 )
		  (throw 'break name)
		  )
		)
	  )
	)
  ;; (switch-to-buffer(other-buffer (current-buffer) nil))
  (switch-to-buffer first-good)
  )

(setq kill-read-only-ok t)
(defun copy-line (&optional arg)
  "Do a kill-line but copy rather than kill. This function directly calls
kill-line, so see documentation of kill-line for how to use it including prefix
argument and relevant variables. This function works by temporarily making the
buffer read-only, so I suggest setting kill-read-only-ok to t.\"
"
  (interactive "p")
  (toggle-read-only 1)
  (setq kill-whole-line t)
  (move-beginning-of-line nil)
  (kill-line arg)
  (setq kill-whole-line nil)
  (toggle-read-only 0)
  )

(defun copy-whole-line (&optional arg)
  (interactive)
  (save-excursion
    (move-beginning-of-line 1)
    (copy-line arg)))

(defun toggle-term-mode ()
  "Toggle between term-char-mode and term-line-mode"
  (interactive)
  (if (term-in-line-mode)
      (progn
	(term-char-mode)
	)
    (term-line-mode)
    )
  )

(defun reload-init-file ()
  (interactive)
  (save-buffer)
  (toggle-debug-on-error)
  (load-file "~/.emacs.d/init.el")
  (toggle-debug-on-error)
  )

(custom-set-variables
 '(server-done-hook (quote ((lambda nil (kill-buffer nil))
			    delete-frame)))
 '(server-switch-hook (quote ((lambda nil
				(let (server-buf)
				  (setq server-buf (current-buffer))
				  (bury-buffer)
				  (switch-to-buffer-other-frame server-buf)))))))

(add-hook 'server-switch-hook
	  (lambda ()
	    (when (current-local-map)
	      (use-local-map (copy-keymap (current-local-map))))
	    (when server-buffer-clients
	      (local-set-key (kbd "C-x k")
			     'server-edit))))

(defun subu-redraw ()
  (interactive)
  (delete-other-windows)
  (winner-undo)
)

;; Diff the current buffer with the file contents
(defun my-diff-current-buffer-with-disk ()
   "Compare the current buffer with it's disk file."
    (interactive)
    (diff-buffer-with-file (current-buffer)))

(global-set-key (kbd "<f1>")  `recentf-open-files)
(global-set-key (kbd "<f2>")  'subu-switch-default-buffer)
(global-set-key (kbd "<f4>")  'toggle-term-mode)
(global-set-key (kbd "<f5>")  'reload-init-file)
(global-set-key (kbd "<f6>")  'toggle-window-dedicated)
(global-set-key (kbd "<f7>")  'jump-to-mark)
(global-set-key (kbd "<f8>")  'server-edit)
(global-set-key (kbd "<f10>") 'py-execute-buffer)

;; (global-set-key (kbd "C-x M-p") 'toggle-window-dedicated)
;; (global-set-key (kbd "C-x y") 'copy-whole-line)
;; (global-set-key (kbd "C-c l") 'copy-whole-line)
;; (global-set-key (kbd "C-c c") 'comment-region)
;; (global-set-key (kbd "C-c v") 'uncomment-region)
;; (global-set-key (kbd "C-c d") 'py-execute-region)
;; (global-set-key (kbd "C-c b") 'python-add-breakpoint)
;; (global-set-key (kbd "C-z")   'subu-redraw)
;; (global-set-key (kbd "C-c w") 'my-diff-current-buffer-with-disk)

;;; The custom search URLs
(defvar *internet-search-urls*
  (quote ("http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
	  "http://en.wikipedia.org/wiki/Special:Search?search=")))


;; Search a query on the Internet using the selected URL.
(defun search-in-internet (arg)
  "Searches the internet using the ARGth custom URL for the marked text.
    If a region is not selected, prompts for the string to search on.
    The prefix number ARG indicates the Search URL to use. By default the
    search URL at position 1 will be used."
  (interactive "p")
  ;; Some sanity check.
  (if (> arg (length *internet-search-urls*))
      (error "There is no search URL defined at position %s" arg))
  (let ((query                          ; Set the search query first.
	 (if (region-active-p)
	     (buffer-substring (region-beginning) (region-end))
	   (read-from-minibuffer "Search for: ")))
	;; Now get the Base URL to use for the search
	(baseurl (nth (1- arg) *internet-search-urls*)))

    ;; Add the query parameter
    (let ((url
	   (if (string-match "%s" baseurl)
	       ;; If the base URL has a %s embedded, then replace it
	       (replace-match query t t baseurl)
	     ;; Else just append the query string at end of the URL
	     (concat baseurl query))))

      (message "Searching for %s at %s" query url)
      ;; Now browse the URL
      (w3m-browse-url url))))

(defun subu-comment-line (&optional arg)
  "Replacement for the comment-dwim command.
   If no region is selected and current line is not blank and we are not at the end of the line,
   then comment current line.
   Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*p")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg))
  )

(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
	   (and (not current-prefix-arg)
		(member major-mode '(emacs-lisp-mode lisp-mode
						     clojure-mode    scheme-mode
						     haskell-mode    ruby-mode
						     rspec-mode
						     c-mode          c++-mode
						     objc-mode       latex-mode
						     plain-tex-mode))
		(let ((mark-even-if-inactive transient-mark-mode))
		  (indent-region (region-beginning)
				 (region-end)
				 nil))))))

(defun kill-and-join-forward (&optional arg)
  (interactive "P")
  (if (and (eolp)
	   (not (bolp)))
      (progn (forward-char 1)
	     (just-one-space 0)
	     (backward-char 1)
	     (kill-line arg))
    (kill-line arg)))

(defun subu-open-init-file (&optional arg)
  (interactive "P")
  (find-file "~/.emacs.d/init.el")
  )

(global-set-key (kbd "C-k") 'kill-and-join-forward)

(global-set-key (kbd "C-z") nil)

(global-set-key (kbd "C-z a") 'recentf-open-files)
(global-set-key (kbd "C-z b") 'python-add-breakpoint)
(global-set-key (kbd "C-z c") 'comment-or-uncomment-region)
(global-set-key (kbd "C-z d") 'toggle-window-dedicated)
(global-set-key (kbd "C-z e") 'server-edit)
(global-set-key (kbd "C-z f") 'subu-switch-default-buffer)
(global-set-key (kbd "C-z g") 'toggle-term-mode)
(global-set-key (kbd "C-z h") nil)
(global-set-key (kbd "C-z i") 'reload-init-file)
(global-set-key (kbd "C-z j") 'py-execute-buffer)
(global-set-key (kbd "C-z k") 'jump-to-mark)
(global-set-key (kbd "C-z l") 'push-mark-no-activate)
(global-set-key (kbd "C-z m") nil)
(global-set-key (kbd "C-z n") nil)
(global-set-key (kbd "C-z o") 'subu-open-init-file)
(global-set-key (kbd "C-z p") 'py-execute-region)
(global-set-key (kbd "C-z q") nil)
(global-set-key (kbd "C-z r") nil)
(global-set-key (kbd "C-z s") 'search-in-internet)
(global-set-key (kbd "C-z t") nil)
(global-set-key (kbd "C-z u") nil)
(global-set-key (kbd "C-z v") nil)
(global-set-key (kbd "C-z w") 'copy-whole-line)
(global-set-key (kbd "C-z y") 'subu-comment-line)
(global-set-key (kbd "C-z z") 'subu-redraw)

(defun subu-turn-on-icicles ()
  (interactive)
  (require 'icicles)
  (icy-mode 1)
  (setq icicle-hide-common-match-in-Completions-flag 1)
  (setq icicle-hide-non-matching-lines-flag 1)
  )

;; turn on icicles as late as possible.
;; piece of shit icicles interferes with pymacs.
(subu-turn-on-icicles)

(require 'ediff)
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-make-buffers-readonly-at-startup t)

(defun command-line-diff (switch)
  (let ((file1 (pop command-line-args-left))
	(file2 (pop command-line-args-left)))
    (setq inhibit-startup-message t
	  inhibit-startup-echo-area-message t)
    (ediff file1 file2)))

(add-to-list 'command-switch-alist '("diff" . command-line-diff))
(add-to-list 'command-switch-alist '("-diff" . command-line-diff))
