;;; 52-typescript.el ---


(require 'typescript)
(add-to-list 'auto-mode-alist '("\.ts$" . typescript-mode))

(defun typescript-mode-init () 
  (set (make-local-variable 'compile-command) 
       (format "tsc -sourcemap --target es6 %s" 
	       (file-name-nondirectory (buffer-file-name))))) 
(add-hook 'typescript-mode-hook 'typescript-mode-init) 

(require 'tss)

;; キーバインド
(setq tss-popup-help-key "C-:")
(setq tss-jump-to-definition-key "C->")
(setq tss-implement-definition-key "C-c i")


;; 必要に応じて適宜カスタマイズして下さい。以下のS式を評価することで項目についての情報が得られます。
;; (customize-group "tss")

;; 推奨設定を行う
(tss-config-default)
