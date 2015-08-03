($v-add "popup")

($v-add "auto-complete")
(require 'auto-complete-config)
(ac-config-default)

($v-add "yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

(require 'ido)
(ido-mode t)
; (setq ido-enable-flex-matching t)
