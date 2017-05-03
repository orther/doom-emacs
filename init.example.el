;;; init.el

(require 'core (concat user-emacs-directory "core/core"))

(doom! :core
       gdoom

       :feature
       evil
       jump
       syntax-checker
       version-control
       workspaces
       eval
       debug
       search
       editor
       snippet

       :completion
       company
       ivy

       :ui
       doom
       doom-dashboard
       doom-modeline
       doom-quit
       hl-todo
       window
      
       :tools
       eshell
       dired
       restclient

       :lang
       assembly
       cc
       csharp
       data
       emacs-lisp
       go
       haskell
       java
       javascript
       julia
       latex
       lua
       markdown
       octave
       org
       php
       python
       rest
       ruby
       rust
       scala
       sh
       swift
       typescript
       web

       :framework
       play

       :private gilbertw1)
