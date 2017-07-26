;;; 40-template.el 

(require 'autoinsert)

;; テンプレートのディレクトリ
(setq auto-insert-directory "~/.emacs.d/template/")

;; 各ファイルによってテンプレートを切り替える
(setq auto-insert-alist
      (nconc '(
      	       ("\\.c$" . ["template.c" my-template])
	       ("\\.cpp$" . ["template.cpp" my-template])
	       ("\\.h$"   . ["template.h" my-template])
	       ("\\.py$"  . ["template.py" my-template])
	       ("\\.html$". ["template.html" my-template])
	       ("\\.sh"   . ["template.sh" my-template])
               ("\\.jsx"   . ["template.jsx" my-template])
	       ) auto-insert-alist))

(require 'cl)

(defvar template-replacements-alists
  '(("%file%"             . (lambda () (file-name-nondirectory (buffer-file-name))))
    ("%file-without-ext%" . (lambda () (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
    ("%include-guard%"    . (lambda () (format "__SCHEME_%s__" (upcase (file-name-sans-extension (file-name-nondirectory buffer-file-name))))))))

(defun my-template ()
  (time-stamp)
  (mapc #'(lambda (c)
	    (progn
	      (goto-char (point-min))
	      (replace-string (car c) (funcall (cdr c)) nil)))
	template-replacements-alists)
  (goto-char (point-max))
  (message "done."))
(add-hook 'find-file-not-found-hooks 'auto-insert)
