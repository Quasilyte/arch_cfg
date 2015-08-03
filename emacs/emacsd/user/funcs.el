;;;;;;;;;;;;;;;;;;;;
;;;; utility $funcs:

;;; buffer helpers

(defun $b-prepend (s)
  (goto-char 0)
  (insert s))

(defun $b-append (s)
  (goto-char (buffer-size))
  (insert s))
    
(defun $b-wrap (top bot)
  ($buffer-prepend top)
  ($buffer-append bot))

(defun $b-del-between-lines (from to)
  (goto-line (1+ from))
  (let ((from (point)))
    (goto-line to)
    (delete-backward-char (- (point) from))))

(defun $b-del-line (n)
  ($buffer-del-between-lines (1- n) (1+ n)))

;;; file helpers

(defun $f-name-change-ext (name ext)
  (concat (file-name-sans-extension name) "." ext))

(defun $f-name (path)
  (concat (file-name-base path) "." (file-name-extension path)))

;;; perl-like regexps feel into shitty elisp regexp facility

(defun $perl-escapable-p (c)
  (or (= ?| c)
      (= ?\( c)
      (= ?\) c)))

(defun $perl-escape-elisp (s)
  (mapconcat (lambda (c)
	       (format (if ($perl-escapable-p c) "\\%c" "%c") c))
	     s
	     ""))

(defun $perl/s (pattern rep s)
  (replace-regexp-in-string ($perl-escape-elisp pattern) rep s))

;;; c/c++ helpers

(defun $c-f-signature ()
  "create file describing string based on its path"
  (let ((src-path (nth 1 (split-string (buffer-file-name) "src/"))))
    (if src-path
	(let ((src-path (file-name-sans-extension src-path))
	      (case-fold-search nil))
	  (concat (upcase ($perl/s "/|([^_])([A-Z])" "\\1_\\2" src-path))
		  "_"))
      (error "expected to see `/src/' somewhere in current path"))))

(defun $c-header-guarded-p (signature)
  "check if file has proper inclusion guard"
  (goto-char 0)
  (if (search-forward "#ifndef " 9 t)
      (if (search-forward signature (+ (point) (length signature)) t)
	  2
	1)
    0))

(defun $c-paired-f-name ()
  (let ((ext (file-name-extension (buffer-name))))
    ($f-name-change-ext (buffer-file-name)
			(pcase ext
			  ("c" "h")
			  ("h" "c")
			  ("cpp" "hpp")
			  ("hpp" "cpp")
			  (_ (error "expected C/C++ related file ext"))))))
			  
;;;;;;;;;;;;;;;;;;;;;;;;
;;;; interactive @funcs:

;;; c/c++ helpers

(defun @c-incg ()
  "wrap file in i-guard (if it is not already)"
  (interactive)
  (save-excursion
    (let* ((signature ($c-f-signature))
	   (guard-state ($c-header-guarded-p signature)))
      (when (not (= 2 guard-state)) ;; if file i-guard is not set or invalid
	(let ((guard (concat "#ifndef " signature
			     "\n#define " signature "\n")))
	  (cond ((= 1 guard-state) ;; if file has invalid i-guard
		 ($b-del-between-lines 0 3)
		 ($b-prepend guard))
		(t ($b-wrap guard "\n\n#endif"))))))))

(defun @c-switch-b-to-paired ()
  (interactive)
  (let ((name ($f-name ($c-paired-f-name))))
    (if (file-exists-p name)
	(find-file name)
      (message "no paired file found to open"))))
