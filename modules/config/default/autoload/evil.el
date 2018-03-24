;; config/default/autoload/evil.el -*- lexical-binding: t; -*-
;;;###if (featurep! :feature evil)

;;;###autoload (autoload '+default:multi-next-line "config/default/autoload/evil" nil t)
(evil-define-motion +default:multi-next-line (count)
  "Move down 6 lines."
  :type line
  (let ((line-move-visual (or visual-line-mode (derived-mode-p 'text-mode))))
    (evil-line-move (* 6 (or count 1)))))

;;;###autoload (autoload '+default:multi-previous-line "config/default/autoload/evil" nil t)
(evil-define-motion +default:multi-previous-line (count)
  "Move up 6 lines."
  :type line
  (let ((line-move-visual (or visual-line-mode (derived-mode-p 'text-mode))))
    (evil-line-move (- (* 6 (or count 1))))))

;;;###autoload (autoload '+default:cd "config/default/autoload/evil" nil t)
(evil-define-command +default:cd ()
  "Change `default-directory' with `cd'."
  (interactive "<f>")
  (cd input))

;;;###autoload (autoload '+default:kill-all-buffers "config/default/autoload/evil" nil t)
(evil-define-command +default:kill-all-buffers (&optional bang)
  "Kill all buffers. If BANG, kill current session too."
  (interactive "<!>")
  (if bang
      (+workspace/kill-session)
    (doom/kill-all-buffers)))

;;;###autoload (autoload '+default:kill-matching-buffers "config/default/autoload/evil" nil t)
(evil-define-command +default:kill-matching-buffers (&optional bang pattern)
  "Kill all buffers matching PATTERN regexp. If BANG, only match project
buffers."
  (interactive "<a>")
  (doom/kill-matching-buffers pattern bang))

;;;###autoload
(defun +default/easymotion ()
  "TODO"
  (interactive)
  (let ((prefix (this-command-keys)))
    (map! :m prefix nil)
    (evilem-default-keybindings prefix)
    (let ((map evilem-map))
      (define-key map "n" (evilem-create #'evil-ex-search-next))
      (define-key map "N" (evilem-create #'evil-ex-search-previous))
      (define-key map "s"
        (evilem-create #'evil-snipe-repeat
                       :pre-hook (save-excursion (call-interactively #'evil-snipe-s))
                       :bind ((evil-snipe-scope 'buffer)
                              (evil-snipe-enable-highlight)
                              (evil-snipe-enable-incremental-highlight))))
      (define-key map "S"
        (evilem-create #'evil-snipe-repeat-reverse
                       :pre-hook (save-excursion (call-interactively #'evil-snipe-s))
                       :bind ((evil-snipe-scope 'buffer)
                              (evil-snipe-enable-highlight)
                              (evil-snipe-enable-incremental-highlight))))
      (set-transient-map map)
      (which-key-reload-key-sequence prefix))))
