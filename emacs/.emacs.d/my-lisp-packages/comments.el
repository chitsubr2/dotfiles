;; Comments
;; Stuff to maybe uncomment later
;; (define-key input-decode-map "\eOA" (kbd "M-<up>"))
;; (menu-bar-mode -1)
;; (setq mac-pass-command-to-system nil)  ;avoid hiding with M-h

;; (require 'w3m-e21)
;; (provide 'w3m-e23
;; (setq mac-pass-command-to-system nil)  ;avoid hiding with M-h

;; (require 'w3m-e21)
;; (provide 'w3m-e23)
;; bold keywords and italics comments
;; (set-face-bold-p 'font-lock-keyword-face t)
;; (set-face-italic-p 'font-lock-comment-face t)

;;(require 'ns-platform-support)
;;(ns-extended-platform-support-mode 1)

;; (global-linum-mode 1)

;; (require 'magit)

;; (server-start)

;; (add-hook 'server-switch-hook
;; 	  (lambda nil
;; 	    (let ((server-buf (current-buffer)))
;; 	      (bury-buffer)
;; 	      (switch-to-buffer-other-frame server-buf))))
;; (add-hook 'server-done-hook 'delete-frame)

;;
;;
;; (when (require 'lusty-explorer nil 'noerror)
;;   (global-set-key (kbd "C-x C-f")
;; 		  'lusty-file-explorer)
;;   (global-set-key (kbd "C-x b")
;; 		  'lusty-buffer-explorer)
;;   )
;;


