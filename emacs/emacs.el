(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq $emacsd (concat (getenv "HOME") "/.emacs.d/"))

(defun $u-inc (files)
  (dolist (file files)
    (load (concat $emacsd "user/" file ".el"))))

(defun $v-add (dir)
  (add-to-list 'load-path (concat $emacsd "/vendor/" dir)))

($u-inc '("incs" "backups" "vars"
	  "funcs" "autoloads" "keybinds"))
