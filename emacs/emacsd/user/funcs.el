;;;;;;;;;;;;;;;;;;;;
;;;; utility $funcs:

;;; buffer helpers

(defun $buffer-prepend (s)
  (goto-char 0)
  (insert s))

(defun $buffer-append (s)
  (goto-char (buffer-size))
  (insert s))
    
(defun $buffer-wrap (top bot)
  ($buffer-prepend top)
  ($buffer-append bot))

(defun $buffer-del-between-lines (from to)
  (goto-line (1+ from))
  (let ((from (point)))
    (goto-line to)
    (delete-backward-char (- (point) from))))

(defun $buffer-del-line (n)
  ($buffer-del-between-lines (1- n) (1+ n)))
		 

;;; perl-like regexps feel into shitty elisp regexp facility

(defun $perl-escapable-p (c)
  (or (= ?| c)
      (= ?( c)
      (= ?) c)))

(defun $perl-escape-elisp (s)
  (mapconcat (lambda (c)
	       (format (if ($perl-escapable-p c) "\\%c" "%c") c))
	     s
	     ""))

(defun $perl/s (pattern rep s)
  (replace-regexp-in-string ($perl-escape-elisp pattern) rep s))

;;; c/c++ helpers

(defun $c-file-signature ()
  (let ((src-path (nth 1 (split-string (buffer-file-name) "src/"))))
    (if src-path
	(let ((src-path (file-name-sans-extension src-path))
	      (case-fold-search nil))
	  (concat (upcase ($perl/s "/|([^_])([A-Z])" "\\1_\\2" src-path))
		  "_"))
      (error "expected to see `/src/' somewhere in current path"))))

(defun $c-header-guarded-p (signature)
  (goto-char 0)
  (if (search-forward "#ifndef " 9 t)
      (if (search-forward (concat signature) 48 t)
	  2
	1)
    0))

;;;;;;;;;;;;;;;;;;;;;;;;
;;;; interactive @funcs:

;;; c/c++ helpers

(defun @c-incg ()
  (interactive)
  (save-excursion
    (let* ((signature ($c-file-signature))
	   (guard-state ($c-header-guarded-p signature)))
      (when (not (= 2 guard-state)) ;; if file i-guard is not set or invalid
	(let ((guard (concat "#ifndef " signature
			     "\n#define " signature "\n")))
	  (cond ((= 1 guard-state) ;; if file has invalid i-guard
		 ($buffer-del-between-lines 0 3)
		 ($buffer-prepend guard))
		(t ($buffer-wrap guard "\n\n#endif"))))))))
 
