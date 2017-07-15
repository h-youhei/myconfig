(require 'evil)

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
(defun evil-break-line(count)
  "Break current line, insert COUNT empty lines, then start insert mode."
  (interactive "p")
  (unless (eq evil-want-fine-undo t) (evil-start-undo-step))
  (newline)
  (evil-open-above count))

;;;###autoload
(evil-define-operator evil-backward-substitute (beg end type register)
  "Change backward character"
  :motion evil-backward-char
  (interactive "<R><x>")
  (evil-change beg end type register))

;;;###autoload
(evil-define-operator evil-upcase-whole-word (beg end type register)
  "Upcase whole word"
  :motion evil-a-word
  (interactive "<r>")
  (evil-upcase beg end type))

;;;###autoload
(evil-define-operator evil-downcase-whole-word (beg end type register)
  "Howncase whole word"
  :motion evil-a-word
  (interactive "<R>")
  (evil-downcase beg end type))

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

