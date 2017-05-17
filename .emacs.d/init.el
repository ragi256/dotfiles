(require 'init-loader)
(init-loader-load "~/.emacs.d/inits")

(require 'use-package)

(put 'upcase-region 'disabled nil) ;; C-x C-uで選択領域を大文字
(put 'downcase-region 'disabled nil) ;; C-x C-lで選択領域を小文字, 
(delete-selection-mode t) ;; リージョンを削除できるように

(menu-bar-mode 0) ;; メニュバーをoff
(tool-bar-mode 0) ;; ツールバーをoff
(line-number-mode 1) ;; カーソルの行番号をモードラインに表示
(column-number-mode 1) ;; カーソルの列番号をモードラインに表示
(setq inhibit-startup-message t) ;;
(fset 'yes-or-no-p 'y-or-n-p) ;; yes or no をすべて yn へ
(setq use-dialog-box nil) ;; ダイアログ(ポップアップみたいな)を作らない
(show-paren-mode t) ;; 閉じ括弧に反応して開き括弧を光らせる
(which-function-mode 1) ;; 現在の関数名をモードラインに表示
(setq-default indent-tabs-mode nil)

(setq message-log-max 10000) ;; 
(setq history-length 1000) ;; 
(setq history-delete-duplicates t) ;;  


(bind-keys*
 ("C-h" . delete-backward-char)
 ("C-x C-j". skk-mode)
 ("C-t" . rotate-layout)
 ("M-t" . rotate-window))

(add-to-list 'default-frame-alist '(font . "ricty-13.5"))

;; Mac用フォント設定
 ;; 英語
 (set-face-attribute 'default nil
             :family "Ricty" ;; font
             :height 130)  ;; font size

(require 'popwin)
(popwin-mode 1)
(push '("^\\*helm" :regexp t :height 10 :position :bottom) popwin:special-display-config)


;; flymake --------------------
(require 'flymake)

;; c++のflymake
(defun flymake-cc-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))

    (list "g++" (list "-std=c++11" "-Wall" "-Wextra" "-fsyntax-only" "-Wno-sign-compare" local-file))))

(push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)

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

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
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

(setq flycheck-display-errors-function 'flycheck-display-error-messages-unless-error-list)

;; flymake --------------------


;; slime --------------------

(setf inferior-lisp-program "/usr/local/bin/sbcl") ; your Lisp system
(require 'slime-autoloads)
(slime-setup '(slime-repl))

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

;; slime --------------------


;; ;; skk用設定
;; (setq load-path
;;       (append '("~/.emacs.d/ddskk-15.1"
;; 		"~/.emacs.d/elisp/skk"
;; 		"~/.emacs.d/elisp")
;; 		load-path))

;; (require 'skk-setup)
;; (require 'skk-study)

;; ;;skk-server AquaSKK
;; (setq skk-server-portnum 1178)
;; (setq skk-server-host "localhost")

;; (add-hook 'isearch-mode-hook
;;           (function (lambda ()
;;                       (and (boundp 'skk-mode) skk-mode
;;                            (skk-isearch-mode-setup)))))
;; (add-hook 'isearch-mode-end-hook
;;           (function (lambda ()
;;                       (and (boundp 'skk-mode) skk-mode (skk-isearch-mode-cleanup))
;;                       (and (boundp 'skk-mode-invoked) skk-mode-invoked
;;                            (skk-set-cursor-properly)))))

;; (setq mac-pass-control-to-system nil)

;; (require 'epc)

;; python --------------------

(add-to-list 'load-path "~/.emacs.d/jedi/emacs-deferred")
(add-to-list 'load-path "~/.emacs.d/jedi/emacs-epc")
(add-to-list 'load-path "~/.emacs.d/jedi/emacs-ctable")
(add-to-list 'load-path "~/.emacs.d/jedi/emacs-jedi")
(require 'auto-complete-config)
(require 'python)
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:ac-setup)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)
(define-key python-mode-map (kbd "<C-tab>") 'jedi:complete)
(setq jedi:complete-on-dot t)

;; pythonのflymake
(require 'flycheck-pyflakes)
(add-hook 'python-mode-hook 'flycheck-mode)
;; python pep8
(add-hook 'before-save-hook 'py-autopep8-before-save)

;; python --------------------

(require 'col-highlight)
(toggle-highlight-column-when-idle t)
(col-highlight-set-interval 10)

(require 'hl-line+)
(toggle-hl-line-when-idle t)
(hl-line-when-idle-interval 10)


;; 各種モードで折りたたみモードをONに
;; C coding style
(add-hook 'c-mode-hook
          '(lambda ()
      (hs-minor-mode 1)))
;; C++ coding style
(add-hook 'c++-mode-hook
          '(lambda ()
      (hs-minor-mode 1)))
;; Scheme coding style
(add-hook 'scheme-mode-hook
          '(lambda ()
      (hs-minor-mode 1)))
;; Elisp coding style
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
      (hs-minor-mode 1)))
;; Lisp coding style
(add-hook 'lisp-mode-hook
          '(lambda ()
      (hs-minor-mode 1)))
;; Python coding style
(add-hook 'python-mode-hook
          '(lambda ()
      (hs-minor-mode 1)))





;; 許されざるText is read-onlyを回避する
(defadvice eshell-get-old-input (after eshell-read-only-korosu activate)
  (setq ad-return-value (substring-no-properties ad-return-value)))

(defun eshell/clear ()
 "Clear the current buffer, leaving one prompt at the top."
 (interactive)
 (let ((inhibit-read-only t))
   (erase-buffer)))



(require 'twittering-mode)
(setq twittering-mode-auth-method 'xauth)
(setq twittering-icon-mode t)
(setq twittering-timer-interval 45)



;; (require 'smart-compile)
;; (global-set-key (kbd "C-x c") 'smart-compile)
;; (global-set-key (kbd "C-x C-x") (kbd "C-x c C-m"))
;; (setq smart-compile-alist
;;       (append
;;        '(("\\.[Cc]+[Pp]*\\'" . "g++ -O2 %f; ./a.out"))
;;        smart-compile-alist))

(use-package smart-compile
  :config (setq smart-compile-alist
		(append
		 '(("\\.[Cc]+[Pp]*\\'" . "g++ -O2 %f; ./a.out"))
		 smart-compile-alist))
  :bind (("C-x c" . smart-compile)))




;; ;; yasnippet.el----------------------------------
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/mySnippets"
        "~/.emacs.d/elpa/yasnippet-20160403.830/snippets"
        ))
(yas-global-mode 1)

;; (use-package yasnippet
;;   :config
;;   ((setq yas-snippet-dirs
;; 	 '("~/.emacs.d/mySnippets"
;; 	   "~/.emacs.d/elpa/yasnippet-20160403.830/snippets" ))
;;    (yas-global-mode 1)))

(require 'clang-format)
(global-set-key [C-M-tab] 'clang-format-region)


;; GUI Emacsの透明度指定
(add-to-list 'default-frame-alist '(alpha . (0.75 0.75)))

;; 透明度を変更するコマンド M-x set-alpha
;; http://qiita.com/marcy@github/items/ba0d018a03381a964f24
(defun set-alpha (alpha-num)
  "set frame parameter 'alpha"
  (interactive "nAlpha: ")
  (set-frame-parameter nil 'alpha (cons alpha-num '(90))))



;; エスケープシーケンスを処理
;; http://d.hatena.ne.jp/hiboma/20061031/1162277851
(autoload 'ansi-color-for-comint-mode-on "ansi-color"
          "Set `ansi-color-for-comint-mode' to t." t)
(add-hook 'eshell-load-hook 'ansi-color-for-comint-mode-on)
;; http://www.emacswiki.org/emacs-ja/EshellColor
(require 'ansi-color)
(require 'eshell)
(defun eshell-handle-ansi-color ()
  (ansi-color-apply-on-region eshell-last-output-start
                              eshell-last-output-end))
(add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color)


(require 'lispxmp)
(require 'paredit)
(require 'rainbow-delimiters)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)

(require 'exec-path-from-shell)
(exec-path-from-shell-initialize)

(require 'anzu)
(global-anzu-mode +1)
(set-face-attribute 'anzu-mode-line nil
                    :foreground "firebrick" :weight 'bold)

(require 'volatile-highlights)

(set-face-attribute 'which-func nil
		    :foreground "black")




(require 'highlight-indentation)



(require 'web-beautify) ;; Not necessary if using ELPA package
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))
(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))


(setq exec-path (append exec-path '("/usr/local/share/npm/bin")))
(setq flymake-log-level 3)

(flycheck-add-next-checker 'javascript-jshint
			   'javascript-gjslint)


;; ;; dired系
;; wdired切り替えをrでできるように
;; デフォでdired-xに
;; dired-x時にSKKできるように
(use-package dired
  :defer t
  :init (bind-keys :map dired-mode-map
		   ("r" . wdired-change-to-wdired-mode))
  :config (add-hook 'dired-load-hook
		    (lambda ()
		      (load "dired-x")
		      (global-set-key "\C-x\C-j" 'skk-mode))))
;;(setq dired-listing-switches (purecopy "-gohvBG"))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
	 ("C-x M-g" . magit-dispatch-popup))
  :init
  :config)

(use-package open-junk-file
  :config (setq open-junk-file-format "~/workspace/junk/%y-%m-%d.")
  :bind (("C-x C-z" . open-junk-file))
  )

(add-hook 'commint-mode-hook
                    (lambda () (setenv "PAGER" "cat")))
