(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(require 'cl)

(defvar installing-package-list
  '(
    ac-slime
    anything
    anzu
    auto-complete
    auto-complete-clang
    auto-complete-clang-async
    clang-format
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
    exec-path-from-shell
    flycheck
    flycheck-pos-tip
    flycheck-pyflakes
    flymake-cursor
    helm
    hiwin
    highlight-indentation
    hl-line+
    jedi
    lispxmp
    magit
    markdown-mode
    open-junk-file
    paredit
    pep8
    pkg-info
    popup
    popwin
    py-autopep8
    python-environment
    quickrun
    rainbow-delimiters
    rotate
    search-web
    slime
    stem
    swbuff
    twittering-mode
    use-package
    uzumaki
    vline
    volatile-highlights
    w3m
    web-beautify
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
