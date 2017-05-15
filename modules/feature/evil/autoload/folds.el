;;; feature/evil/autoload/folds.el

;; It's frustrating how hideshow is a decent code folding implementation, but it
;; won't let you create custom folds. Meanwhile, evil-vimish-fold offers custom
;; folds, but essentially ignores any other type of folding (indent or custom
;; markers, which hs-minor-mode gives you).
;;
;; So this is my effort to combine them.

;; Initialize the two modes
(evil-vimish-fold-mode +1)

(defun +evil*fold-hs-minor-mode (&rest args)
  "Lazily activate buffer-local hs-minor-mode."
  (unless (bound-and-true-p hs-minor-mode)
    (hs-minor-mode +1)))
(advice-add #'evil-fold-action :before #'+evil*fold-hs-minor-mode)

(add-to-list
 'evil-fold-list
 '((evil-vimish-mode hs-minor-mode)
   :delete vimish-fold-delete
   :open-all +evil/fold-open-all
   :close-all +evil/fold-close-all
   :toggle +evil/fold-toggle
   :open +evil/fold-open
   :open-rec nil
   :close +evil/fold-close))


;; --- fold functions ---------------------

(defun +evil--vimish-fold-p ()
  (cl-some #'vimish-fold--vimish-overlay-p (overlays-at (point))))

;;;###autoload
(defun +evil-fold-p ()
  (or (+evil--vimish-fold-p)
      (hs-already-hidden-p)))

;;;###autoload (autoload '+evil/fold-toggle "feature/evil/autoload/folds" nil t)
(evil-define-command +evil/fold-toggle ()
  (interactive)
  (if (+evil--vimish-fold-p)
      (vimish-fold-toggle)
    (hs-toggle-hiding)))

;;;###autoload (autoload '+evil/fold-open "feature/evil/autoload/folds" nil t)
(evil-define-command +evil/fold-open ()
  (interactive)
  (if (+evil--vimish-fold-p)
      (vimish-fold-unfold)
    (hs-hide-block)))

;;;###autoload (autoload '+evil/fold-close "feature/evil/autoload/folds" nil t)
(evil-define-command +evil/fold-close ()
  (interactive)
  (if (+evil--vimish-fold-p)
      (vimish-fold-refold)
    (hs-hide-block)))

;;;###autoload (autoload '+evil/fold-open-all "feature/evil/autoload/folds" nil t)
(evil-define-command +evil/fold-open-all (&optional level)
  (interactive "<c>")
  (vimish-fold-unfold-all)
  (if level (hs-hide-level level) (hs-show-all)))

;;;###autoload (autoload '+evil/fold-close-all "feature/evil/autoload/folds" nil nil)
(evil-define-command +evil/fold-close-all (&optional level)
  (interactive "<c>")
  (vimish-fold-refold-all)
  (if level (hs-hide-level level) (hs-hide-all)))


;; --- misc -------------------------------

;;;###autoload
(defun +evil/matchit-or-toggle-fold ()
  "Do what I mean. If on a fold-able element, toggle the fold with
`hs-toggle-hiding'. Otherwise, if on a delimiter, jump to the matching one with
`evilmi-jump-items'. If in a magit-status buffer, use `magit-section-toggle'."
  (interactive)
  (call-interactively
   (cond ((eq major-mode 'magit-status-mode)
          #'magit-section-toggle)
         ((+evil-fold-p)
          #'+evil/fold-toggle)
         (t
          #'evilmi-jump-items))))
