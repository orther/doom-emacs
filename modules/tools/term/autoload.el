;;; tools/term/autoload.el

;;;###autoload
(defun +term (&optional project-root)
  "Open a terminal buffer in the current window. If PROJECT-ROOT (C-u) is
non-nil, cd into the current project's root."
  (interactive "P")
  (let ((default-directory (if project-root (doom-project-root) default-directory)))
    (call-interactively 'multi-term)))

;; BMACS - term popup modeled after scratch buffer popup
;;;###autoload
(defun +term/popup (&optional project-root)
  "Open a terminal popup window. If PROJECT-ROOT (C-u) is non-nil, cd into the
current project's root."
  (interactive "P")
  (require 'multi-term)
  (let ((buf (get-buffer "*doom-esc:term*")))
    (if buf
        (doom-popup-buffer buf)
      (let* ((default-directory (if project-root (doom-project-root) default-directory))
             (buffer (multi-term-get-buffer current-prefix-arg))
             (window (doom-popup-buffer buffer :popup t :align t :size 25 :select t)))
        (select-window window)
        (setq multi-term-buffer-list (nconc multi-term-buffer-list (list buffer)))
        (multi-term-internal)
        (with-current-buffer buffer
          (rename-buffer "*doom-esc:term*"))))))

;;;###autoload
(defun +term/popup-in-project ()
  "Open a terminal popup window in the root of the current project."
  (interactive)
  (+term/popup t))
