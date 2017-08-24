;;; 54-coffeescript.el ---

(require 'flymake-coffee)
(add-hook 'coffee-mode-hook 'flymake-coffee-load)

(defun coffee-custom ()
  "coffee-mode-hook"
 (set (make-local-variable 'tab-width) 2)
 (setq coffee-tab-width 2))

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))

(setq coffee-tab-width 2)
