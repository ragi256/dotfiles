(global-set-key "\C-h" 'delete-backward-char)
(cond (window-system
       (global-unset-key "\C-z")
       ))

(add-to-list 'default-frame-alist '(font . "ricty-13.5"))

;;C++ style
(add-hook 'c++-mode-hook
	  '(lambda()
	     (c-set-style "cc-mode")))

;;; YaTeX
;; yatex-mode の起動
(setq auto-mode-alist 
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
;; 野鳥が置いてある directry の load-path 設定
;; default で load-path が通っている場合は必要ありません
(setq load-path
      (cons (expand-file-name
             "~/share/emacs/site-lisp/yatex") load-path))


;; 文章作成時の日本語文字コード
;; 0: no-converion
;; 1: Shift JIS (windows & dos default)
;; 2: ISO-2022-JP (other default)
;; 3: EUC
;; 4: UTF-8
(setq YaTeX-kanji-code 4)
;; C-c tj でpdfまで作成。platex2pdfにスクリプトが入ってる。＠yatex
(setq tex-command "sh ~/.platex2pdf")

;; flymake 
(require 'flymake)

(defun flymake-cc-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
;    (list "g++" (list "-Wall" "-Wextra" local-file))))

(push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)

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


;;emacs日本語入力でmozcを利用する
(require 'mozc)
;; or (load-file "/path/to/mozc.el")
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")

(setq mozc-candidate-style 'overlay)

(setq mozc-color "blue")

(defun mozc-change-cursor-color ()
  (if mozc-mode
      (set-buffer-local-cursor-color mozc-color)
    (set-buffer-local-cursor-color nil)))

(add-hook 'input-method-activate-hook
          (lambda () (mozc-change-cursor-color)))

(if (featurep 'key-chord)
    (defadvice toggle-input-method (after my-toggle-input-method activate)
      (mozc-change-cursor-color)))

(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(prefer-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8)

;;; リージョンを削除できるように
(delete-selection-mode t)


;;; Common Lisp用 slimeヘルパー
  (load (expand-file-name "~/.quicklisp/slime-helper.el"))
  ;; Replace "sbcl" with the path to your implementation
  (setq inferior-lisp-program "sbcl")

;;; slime用オートコンプリートac-slime
(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))


;;; ファイラ用リネームwdiredモード
;;; emacs-goodies-elパッケージが必要
(when (require 'wdired nil t)
  ;; rキーでwdiredモードに入る
  (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode))

;;; load-pathを追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
     (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
         (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
             (normal-top-level-add-subdirs-to-load-path))))))

;;; ディレクトリをサブディレクトリごとload-pathに追加
(add-to-load-path "elisp")