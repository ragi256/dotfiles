(global-set-key "\C-h" 'delete-backward-char)
(cond (window-system
       (global-unset-key "\C-z")
       ))

(add-to-list 'default-frame-alist '(font . "ricty-13.5"))


(require 'auto-complete)
(add-to-list 'ac-modes 'tex-mode)
(add-to-list 'ac-modes 'latex-mode)
(global-auto-complete-mode t)


;; tex-mode
(setq auto-mode-alist 
      (cons (cons "\\.tex$" 'tex-mode) auto-mode-alist))
(add-hook 'tex-mode 'auto-complete-mode)
(autoload 'yatex-mode "latex" "Yet Another LaTeX mode" t)

;;; YaTeX
;; yatex-mode の起動

;; 野鳥が置いてある directry の load-path 設定
;; default で load-path が通っている場合は必要ありません
;;(setq load-path
;;      (cons (expand-file-name
;;             "~/share/emacs/site-lisp/yatex") load-path))


;; 文章作成時の日本語文字コード
;; 0: no-converion
;; 1: Shift JIS (windows & dos default)
;; 2: ISO-2022-JP (other default)
;; 3: EUC
;; 4: UTF-8
;;(setq YaTeX-kanji-code 4)
;; C-c tj でpdfまで作成。platex2pdfにスクリプトが入ってる。＠yatex
;;(setq tex-command "sh ~/.platex2pdf")

;; flymake 
(require 'flymake)

;; c++のflymake
(defun flymake-cc-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "g++" (list "-std=c++11" "-Wall" "-Wextra" "-fsyntax-only" local-file))))
;    (list "g++" (list "-Wall" "-Wextra" local-file))))

(push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)


;; pythonのflymake
(require 'flycheck-pyflakes)
(add-hook 'python-mode-hook 'flycheck-mode)
;; python pep8
(add-hook 'before-save-hook 'py-autopep8-before-save)

;;; flymake for python
(add-hook 'find-file-hook 'flymake-find-file-hook)
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pycheckers.sh"  (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
;;               '("\\.py\\'" flymake-pyflakes-init)))
               '("\\.py$" flymake-pyflakes-init)))
(load-library "flymake-cursor")
(global-set-key [f10] 'flymake-goto-prev-error)
(global-set-key [f11] 'flymake-goto-next-error)

;;C++ style
(add-hook 'c++-mode-hook
	  '(lambda()
	     (c-set-style "cc-mode")))

(add-hook 'c++-mode-hook
          '(lambda ()
             (flymake-mode t)))

(require 'flymake)
(defun flymake-get-make-cmdline (source base-dir)
  (list "make"
        (list "-s"
              "-C"
              base-dir
              (concat "CHK_SOURCES=" source)
              "SYNTAX_CHECK_MODE=1"
              "LANG=C"
              "check-syntax")))


;;flymakeのエラー行表示色
;;(set-face-background 'flymake-errline "red3")
;;(set-face-background 'flymake-warnline "orange3")

(custom-set-faces
;;  '(flymake-errline ((((class color)) (:background "Gray30"))))
  '(flymake-warnline ((((class color)) (:background "Gray20")))))


;; flymake を使えない場合をチェック
(defadvice flymake-can-syntax-check-file
  (after my-flymake-can-syntax-check-file activate)
  (cond
   ((not ad-return-value))
   ;; tramp 経由であれば、無効
   ((and (fboundp 'tramp-list-remote-buffers)
         (memq (current-buffer) (tramp-list-remote-buffers)))
    (setq ad-return-value nil))
   ;; 書き込み不可ならば、flymakeは無効
   ((not (file-writable-p buffer-file-name))
    (setq ad-return-value nil))
   ;; flymake で使われるコマンドが無ければ無効
   ((let ((cmd (nth 0 (prog1
                          (funcall (flymake-get-init-function buffer-file-name))
                        (funcall (flymake-get-cleanup-function buffer-file-name))))))
      (and cmd (not (executable-find cmd))))
    (setq ad-return-value nil))
   ))

(defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
  (setq flymake-check-was-interrupted t))
(ad-activate 'flymake-post-syntax-check)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )


;;; リージョンを削除できるように
(delete-selection-mode t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(setf inferior-lisp-program "/usr/local/bin/sbcl") ; your Lisp system
(require 'slime-autoloads)
(slime-setup '(slime-repl))

(require 'popwin)
(popwin-mode 1)
;; Apropos
(push '("*slime-apropos*") popwin:special-display-config)
;; Macroexpand
(push '("*slime-macroexpansion*") popwin:special-display-config)
;; Help
(push '("*slime-description*") popwin:special-display-config)
;; Compilation
(push '("*slime-compilation*" :noselect t) popwin:special-display-config)
;; Cross-reference
(push '("*slime-xref*") popwin:special-display-config)
;; Debugger
(push '(sldb-mode :stick t) popwin:special-display-config)
;; REPL
(push '(slime-repl-mode) popwin:special-display-config)
;; Connections
(push '(slime-connection-list-mode) popwin:special-display-config)

(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))


;; skk用設定
(setq load-path
      (append '("~/.emacs.d"
		"~/.emacs.d/ddskk-15.1"
		"~/.emacs.d/elisp/skk")
		load-path))

(require 'skk-setup)
(require 'skk-study)

;;skk-server AquaSKK
(setq skk-server-portnum 1178)
(setq skk-server-host "localhost")

(global-set-key "\C-x\C-j" 'skk-mode)

(add-hook 'isearch-mode-hook
          (function (lambda ()
                      (and (boundp 'skk-mode) skk-mode
                           (skk-isearch-mode-setup)))))
(add-hook 'isearch-mode-end-hook
          (function (lambda ()
                      (and (boundp 'skk-mode) skk-mode (skk-isearch-mode-cleanup))
                      (and (boundp 'skk-mode-invoked) skk-mode-invoked
                           (skk-set-cursor-properly)))))

(setq mac-pass-control-to-system nil)


(add-to-list 'load-path "~/.emacs.d/jedi/emacs-deferred")
(add-to-list 'load-path "~/.emacs.d/jedi/emacs-epc")
(add-to-list 'load-path "~/.emacs.d/jedi/emacs-ctable")
(add-to-list 'load-path "~/.emacs.d/jedi/emacs-jedi")
(require 'auto-complete-config)
;;(require 'python)

;;(add-hook 'python-mode-hook 'jedi:ac-setup)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)
(require 'jedi)
;;(define-key python-mode-map (kbd "<C-tab>") 'jedi:complete)
(setq jedi:complete-on-dot t)


      
