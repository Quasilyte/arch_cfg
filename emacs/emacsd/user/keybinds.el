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

;; (key-binding (kbd "C-x C-w"))
