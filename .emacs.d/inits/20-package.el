(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)


(require 'cl)

(defvar installing-package-list
  '(
    ac-slime
    anything
    auto-complete
    auto-complete-clang
    auto-complete-clang-async
    codic
    col-highlight
    concurrent
    crosshairs
    ctable
    dash
    deferred
    dic-lookup-w3m
    epc
    epl
    flycheck
    flycheck-pos-tip
    flycheck-pyflakes
    flymake-cursor
    helm
    hiwin
    hl-line+
    jedi
    markdown-mode
    pep8
    pkg-info
    popup
    popwin
    py-autopep8
    python-environment
    quickrun
    rotate
    search-web
    slime
    stem
    swbuff
    twittering-mode
    uzumaki
    vline
    w3m
    yasnippet
    init-loader
    ))
(let ((not-installed (loop for x in installing-package-list
			   when (not (package-installed-p x))
			   collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
      (package-install pkg))))
