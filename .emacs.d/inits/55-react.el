;;; 55-react.el ---    


(add-to-list 'auto-mode-alist '("\.jsx$" . js2-jsx-mode))
(flycheck-add-mode 'javascript-eslint 'js2-jsx-mode)
(add-hook 'js2-jsx-mode-hook 'flycheck-mode)

(add-hook 'js2-mode-hook
          '(lambda ()
             (setq web-mode-markup-indent-offset 2
                   web-mode-css-indent-offset    2
                   web-mode-code-indent-offset   2 
                   js2-basic-offset 2
                   tab-width        2
                   indent-tabs-mode nil)))

(add-hook 'js2-jsx-mode-hook
          '(lambda ()
             (setq js-indent-level  2
                   js2-basic-offset 2
                   tab-width        2
                   indent-tabs-mode nil)))

;; web-mode-markup-indent-offset 2
;; web-mode-css-indent-offset    2
;; web-mode-code-indent-offset   2
