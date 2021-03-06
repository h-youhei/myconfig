(require 'evil)

;;;###autoload
(evil-define-motion evil-smart-previous-line (count)
  "Move the cursor a screen line up.
If COUNT is given, move COUNT logical lines up."
  :type line
  (if count
      (evil-previous-line count)
    (evil-previous-visual-line nil)))

;;;###autoload
(evil-define-motion evil-smart-next-line (count)
  "Move the cursor a screen line down.
If COUNT is given, move COUNT logical lines down."
  :type line
  (if count
      (evil-next-line count)
    (evil-next-visual-line nil)))

;;;###autoload
(evil-define-motion evil-smart-beginning-of-line (count)
  "Move the cursor to the first non blank. If already there, to the beginning of line.
If COUNT is given, go to column COUNT on the current line."
  :type exclusive
  (if count
                                        ;because beggining of line is 0
      (evil-goto-column (1- count))
    (let ((oldpos (point)))
      (evil-first-non-blank)
      (when (= oldpos (point))
        (evil-beginning-of-line)))))

;;;###autoload
(evil-define-motion evil-smart-end-of-line (count)
  "Move the cursor to the end of line. If already there, to the last non blank.
If COUNT is given, go to COUNT column from end of the line on the current line."
  :type inclusive
  (if count
      (let ((end (- (line-end-position) (line-beginning-position))))
        (evil-goto-column (max 0 (- end count))))
    (let ((oldpos (point)))
      (evil-end-of-line-fix nil)
      (when (= oldpos (point))
        (evil-last-non-blank nil)))))

;; handle insert mode
(evil-define-motion evil-end-of-line-fix (count)
  (move-end-of-line count)
  (when evil-track-eol
    (setq temporary-goal-column most-positive-fixnum
          this-command #'next-line))
  (unless (or (evil-visual-state-p)
              (evil-insert-state-p))
    (evil-adjust-cursor t)
    (when (eolp)
      (setq evil-this-type 'exclusive))))

;;;###autoload
(evil-define-motion evil-smart-goto-last-line (count)
  "Go to the first non-blank character of the last line.
If COUNT is given, go to COUNT line from the last line."
  :jump t
  :type line
  (with-no-warnings (end-of-buffer))
  (when (looking-at-p "^$")
    (evil-previous-line))
  (when count (evil-previous-line (1- count)))
  (evil-first-non-blank))
;;;###autoload
(evil-define-operator evil-change-whole-word (beg end type register yank-handler)
  "Change whole word"
  :motion evil-inner-word
  (interactive "<R><x>")
  (evil-change beg end type register yank-handler #'evil-delete))

;;;###autoload
(evil-define-operator evil-change-whole-WORD (beg end type register yank-handler)
  "Change whole WORD"
  :motion evil-inner-WORD
  (interactive "<R><x>")
  (evil-change beg end type register yank-handler #'evil-delete))

;;;###autoload
(evil-define-operator evil-delete-whole-word (beg end type register yank-handler)
  "Delete whole word"
  :motion evil-a-word
  (interactive "<R><x>")
  (evil-delete beg end type register yank-handler))

;;;###autoload
(evil-define-operator evil-delete-whole-WORD (beg end type register yank-handler)
  "Delete whole WORD"
  :motion evil-a-WORD
  (interactive "<R><x>")
  (evil-delete beg end type register yank-handler))

;;;###autoload
(evil-define-operator evil-backward-delete-line (beg end type register yank-handler)
  "Delete backward to first-non-blank"
  :motion evil-first-non-blank
  (interactive "<R><x>")
  (evil-delete beg end type register yank-handler))

;;;###autoload
(evil-define-operator evil-yank-whole-word (beg end type register yank-handler)
  "Yank whole word"
  :motion evil-inner-word
  :move-point nil
  :repeat nil
  (interactive "<R><x>")
  (evil-yank beg end type register yank-handler))

;;;###autoload
(evil-define-operator evil-yank-whole-WORD (beg end type register yank-handler)
  "Yank whole WORD"
  :motion evil-inner-WORD
  :move-point nil
  :repeat nil
  (interactive "<R><x>")
  (evil-yank beg end type register yank-handler))

;;;###autoload
(evil-define-operator evil-upcase-whole-word (beg end type register)
  "Upcase whole word"
  :motion evil-a-word
  (interactive "<r>")
  (evil-upcase beg end type))

;;;###autoload
(evil-define-operator evil-downcase-whole-word (beg end type register)
  "Downcase whole word"
  :motion evil-a-word
  (interactive "<R>")
  (evil-downcase beg end type))

;;;###autoload
(defun evil-copy-word-from-above ()
  (interactive)
  (unless (= 1 (line-number-at-pos (point)))
    (let (beg end)
      (save-excursion
        (evil-previous-line)
        (setq beg (point))
        (evil-forward-word-begin)
        (setq end (point)))
      (evil-copy-from-above (- end beg))
      ;; If not having these lines, cursor point doesn't update properly.
      (ignore-errors
        (evil-forward-char)))))

;;;###autoload
(defun evil-copy-word-from-below ()
  (interactive)
  (unless (eq (line-number-at-pos (point))
              (line-number-at-pos (point-max)))
    (let (beg end)
      (save-excursion
        (evil-next-line)
        (setq beg (point))
        (evil-forward-word-begin)
        (setq end (point)))
      (evil-copy-from-below (- end beg))
      ;; If not having these lines, cursor point doesn't update properly.
      (ignore-errors
        (evil-forward-char)))))

(defun evil-simple-insert (count)
  (setq
   evil-insert-count count
   evil-insert-lines nil)
  (evil-insert-state 1))

;;;###autoload
(defun evil-insert-word (count)
  "Switch to insert state at beggining of current word.
The insertion will be repeated COUNT times."
  (interactive "p")
  (push (point) buffer-undo-list)
  (unless (bobp) (evil-backward-word-begin 1))
  (evil-simple-insert count))

;;;###autoload
(defun evil-insert-WORD (count)
  "Switch to insert state at beggining of current WORD.
The insertion will be repeated COUNT times."
  (interactive "p")
  (push (point) buffer-undo-list)
  (unless (bobp) (evil-backward-WORD-begin 1))
  (evil-simple-insert count))

;;;###autoload
(defun evil-append-word (count)
  "Switch to insert state at end of current word.
The insertion will be repeated COUNT times."
  (interactive "p")
  (push (point) buffer-undo-list)
  (unless (eobp)
    (evil-forward-word-end 1)
    (forward-char))
  (evil-simple-insert count)
  (add-hook 'post-command-hook #'evil-maybe-remove-spaces))

;;;###autoload
(defun evil-append-WORD (count)
  "Switch to insert state at end of current WORD.
The insertion will be repeated COUNT times."
  (interactive "p")
  (push (point) buffer-undo-list)
  (unless (eobp)
    (evil-forward-WORD-end 1)
    (forward-char))
  (evil-simple-insert count)
  (add-hook 'post-command-hook #'evil-maybe-remove-spaces))

;;;###autoload
(evil-define-operator evil-backward-substitute (beg end type register)
  "Change backward character"
  :motion evil-backward-char
  (interactive "<R><x>")
  (evil-change beg end type register))

;;;###autoload
(defun evil-escape ()
  "escape"
  (interactive)
  (evil-ex-nohighlight)
  (when (fboundp 'yas-abort-snippet)
    (yas-abort-snippet))
  (keyboard-quit))

;;;###autoload
(defun evil-split ()
  "Split current line"
  (interactive)
  (let ((comment (evil-in-comment-p)))
  (save-excursion
    (newline)
    (if comment
        (comment-line nil)
    (indent-according-to-mode)))))

;;;###autoload
(evil-define-operator evil-join-comment (beg end)
  "Join the selected lines."
  :motion evil-line
  (goto-char beg)
  (evil-last-non-blank)
  (let ((count (count-lines beg end))
        (uncomment (evil-in-comment-p))
        uncomment-next ln)
    (while (> count 0)
      (setq ln (line-number-at-pos))
      (save-excursion
        (evil-next-line)
        ;; check if it was in last line
        (if (= (line-number-at-pos) ln)
            (setq count 0)
          (evil-last-non-blank)
          (when (setq uncomment-next (evil-in-comment-p))
            (when uncomment (comment-line nil)))
          (setq count (1- count)
                uncomment uncomment-next)))
      (join-line 1))))

;;;###autoload
(evil-define-command evil-use-clipboard ()
  "Use clipboard for the next command."
  :keep-visual t
  :repeat ignore
  (setq evil-this-register ?+)
  (setq this-command #'evil-use-register))

;;;###autoload
(evil-define-operator evil-rectangle-number-lines (beg end type count)
  "If COUNT given, number lines start from COUNT"
  (interactive "<R>P")
  (rectangle-number-lines beg end (if count count 1)))

;;;###autoload
(evil-define-command evil-repeat-macro (count macro)
  :repeat nil
  (interactive
   (let (count macro)
     (setq
      count (if current-prefix-arg
                (if (numberp current-prefix-arg)
                    current-prefix-arg
                  0) 1))
     (cond
      ((eq evil-last-register ?:)
       (setq
        macro (lambda () (evil-ex-repeat nil))
        evil-last-register ?:))
      (t
       (unless evil-last-register
         (user-error "No previously executed keyboard macro."))
       (setq macro (evil-get-register evil-last-register t))))
     (list count macro)))
  (evil-execute-macro count macro))

;;;###autoload
(evil-define-command evil-save-and-delete-buffer ()
  :repeat nil
  (interactive)
  (save-buffer)
  (evil-delete-buffer nil))


(defmacro evil-ex-range-string ()
  '(list
    (let ((s (concat
              (cond
               ((and
                 (evil-visual-state-p)
                 evil-ex-visual-char-range
                 (memq (evil-visual-type) '(inclusive exclusive)))
                "`<,`>")
               ((evil-visual-state-p)
                "'<,'>")
               (current-prefix-arg
                (let ((arg (prefix-numeric-value current-prefix-arg)))
                  (cond
                   ((< arg 0) (setq arg (1+ arg)))
                   ((> arg 0) (setq arg (1- arg))))
                  (if (= arg 0) '(".") (format ".,.%+d" arg)))))
              evil-ex-initial-input)))
      (and (> (length s) 0) s))))

;;;###autoload
(evil-define-command evil-ex-interactive-substitute (&optional range)
  (interactive (evil-ex-range-string))
  (evil-ex (concat range "s/")))

(provide 'evil-plus)
