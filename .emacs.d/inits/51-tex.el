;; tex-mode
;; (setq auto-mode-alist 
;;       (cons (cons "\\.tex$" 'tex-mode) auto-mode-alist))
(add-hook 'tex-mode 'auto-complete-mode)
(autoload 'yatex-mode "latex" "Yet Another LaTeX mode" t)

;; tex用 auto-complete
(require 'auto-complete)
(add-to-list 'ac-modes 'tex-mode)
(add-to-list 'ac-modes 'latex-mode)
(global-auto-complete-mode t)

;; 英語論文スペルチェック用
;; Aspell
(setq-default ispell-program-name "aspell")
(eval-after-load "ispell"
  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))
(global-set-key (kbd "C-M-$") 'ispell-complete-word)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-display-errors-function (function flycheck-pos-tip-error-messages))
 '(safe-local-variable-values
   (quote
    ((TeX-master . t)
     (TeX-master . "main")
     (TeX-master . "../main")))))
