;; -*- no-byte-compile: t; -*-
;;; lang/javascript/packages.el

;; requires node npm tern js-beautify eslint eslint-plugin-react

(package! coffee-mode)
(package! js2-mode)
(package! js2-refactor)
(package! rjsx-mode)
(package! nodejs-repl)
(package! tern)
(package! web-beautify)
(package! skewer-mode)
(package! eslintd-fix)

(package! flow)

(when (featurep! :completion company)
  (package! company-tern)
  (package! company-flow)
  )

(when (featurep! :feature jump)
  (package! xref-js2))

