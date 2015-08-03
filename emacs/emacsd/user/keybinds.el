;;;;;;;;;;;;;;;;;;;;;
;;;; global bindings:

(dolist (opt '(("C-s" save-buffer)
	       ("C-x f" find-file)
	       ("C-f" isearch-forward)
	       ("C-S-f" isearch-backward)
	       ("C-b" switch-to-buffer)
	       ("C-S-w" other-window)
	       ("C-v" yank)
	       ("C-z" undo)))
  (global-set-key (kbd (car opt)) (nth 1 opt)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; bindings for major modes:

;;; c/c++

(let ((opts (lambda ()
	      ;; Ctrl+Shift+b, shift buffer to paired C-file
	      (local-set-key (kbd "C-S-b") '@c-switch-b-to-paired)
	      ;; wrap file with inclusion guard (useful for headers only)
	      (local-set-key (kbd "C-x i") '@c-add-inc-guard))))
  (add-hook 'c-mode-hook opts)
  (add-hook 'c++-mode-hook opts))


