(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(defvar auto-install t)
(defconst favorite-packages '(evil
                              evil-surround
                              evil-exchange
                              nlinum-relative
                              counsel
                              projectile
                              company
                              bool-flip
                              haskell-mode
                              ghc
                              company-ghc
                              markdown-mode
                              ))

;; appearence
(setq inhibit-startup-screen t)

(setq whitespace-style '(face
                         trailing
                         tabs
                         spaces
                         space-mark
                         tab-mark
                         ))
(setq whitespace-display-mappings '((tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t]))
      whitespace-space-regexp "\\(\u3000+\\)")

;; history
(defconst temp-emacs-dir (expand-file-name (format "emacs%d" (user-uid))
                                           temporary-file-directory))
(setq backup-directory-alist `((".*" . ,(expand-file-name "backup" temp-emacs-dir))))

;; auto-save/'s trailing slash is important
(setq auto-save-file-name-transforms `((".*"
                                        ,(locate-user-emacs-file ".auto-save/")
                                        t))
      auto-save-list-file-prefix nil
      auto-save-timeout 60
      auto-save-interval 50)

(setq desktop-load-locked-desktop nil
      desktop-save 'if-exists ;to not save if locked
      desktop-restore-frames nil
      desktop-restore-eager 1
      desktop-lazy-idle-delay 0
      desktop-locals-to-save '()
      )

(setq create-lockfiles nil)

(setq recentf-save-file (locate-user-emacs-file ".recentf")
      ;recentf-max-saved-items 30
      ;recentf-exclude '("/TAGS$" "/var/tmp/" "/tmp/")
      )

(setq save-place-file (locate-user-emacs-file ".places"))

(setq bookmark-save-flag 1
      bookmark-default-file (locate-user-emacs-file ".bookmarks")
      )

;; Put last selected bookmark on top
(setq bookmark-sort-flag nil)
(defvar bookmark-order-changed nil)
(advice-add #'bookmark-save :after
            #'(lambda () (setq bookmark-order-changed nil)))
(defun bookmark-put-last-use-on-top ()
  (let ((last (bookmark-get-bookmark bookmark-current-bookmark)))
    (setq bookmark-alist (delq last bookmark-alist))
    (add-to-list 'bookmark-alist last)
    (setq bookmark-order-changed t)))
(add-hook 'bookmark-after-jump-hook #'bookmark-put-last-use-on-top)
(add-hook 'bookmark-exit-hook
          #'(lambda () (when bookmark-order-changed (bookmark-save))))

(setq scroll-margin 3
      scroll-step 1)

;; misc
(setq help-window-select t)
(setq-default tab-width 4)
(setq backward-delete-char-untabify-method 'hungry
      electric-indent-chars (remq ?\n electric-indent-chars)
 )
(setq comment-style 'indent)
(fset 'yes-or-no-p 'y-or-n-p)
(setq use-dialog-box nil)

;; use clipboard only explicitly
(setq select-enable-clipboard nil)

;; packages
;; packape manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;;auto install
(when auto-install
  (require 'cl-lib)
  (let ((not-installed (cl-remove-if #'package-installed-p favorite-packages)))
    (when not-installed
      (package-refresh-contents)
      (mapc #'package-install not-installed))))

;;evil
(setq evil-cross-lines t ;at line egde
      evil-want-C-i-jump nil
      evil-want-C-d-scroll nil
      evil-echo-state nil
      evil-text-object-change-visual-type nil
      evil-ex-substitute-case 'sensitive
      evil-ex-search-persistent-highlight nil
      evil-search-module 'evil-search
      evil-magic 'very-nomagic
      evil-ex-visual-char-range t
      evil-ex-search-vim-style-regexp t
      evil-ex-substitute-global t
      )
(setq-default evil-shift-width tab-width)
(require 'evil)

;;(setq-global evil-surround-pairs-alist)

(evil-declare-not-repeat #'evil-yank-line)

(setq undo-tree-auto-save-history t
      undo-limit 100000
      undo-strong-limit 150000
      undo-tree-history-directory-alist `((".*" . ,(locate-user-emacs-file ".undo-tree" )))
      undo-tree-visualizer-diff t
      )

(setq
      evil-motion-state-modes (delete 'undo-tree-visualizer-mode
                                      evil-motion-state-modes)
      evil-emacs-state-modes (append '(undo-tree-visualizer-mode
                                       dired-mode
                                       )
                                     evil-emacs-state-modes
                                     evil-insert-state-modes)
      evil-insert-state-modes '()
      )

;; real number for current line
;; relative number for the other line
(setq nlinum-relative-redisplay-delay 0.01)

;; ivy
(setq ivy-wrap t
      ivy-extra-directories '()
      ivy-ignore-buffers '("\\` " "\\`\\*")
      ivy-minibuffer-faces '(ivy-minibuffer-match-face-1
                             ivy-minibuffer-match-face-2)
      )
(setq swiper-faces '(swiper-match-face-1
                     swiper-match-face-2)
      swiper-goto-start-of-match t
      swiper-action-recenter t)

(setq enable-recursive-minibuffers t)
(evil-declare-not-repeat #'ivy-plus-bookmark)
(evil-declare-not-repeat #'ivy-plus-find-file)
(evil-declare-not-repeat #'ivy-plus-recentf)
(evil-declare-not-repeat #'ivy-plus-switch-buffer)
(evil-declare-not-repeat #'ivy-plus-with-find-directory)
(evil-declare-not-repeat #'counsel-imenu)
(evil-declare-not-repeat #'ivy-plus-git)
(evil-declare-not-repeat #'counsel-git-grep)
(evil-declare-not-repeat #'swiper)
(evil-declare-motion #'swiper)

;; projectile
(setq projectile-completion-system 'ivy
      projectile-keymap-prefix (kbd "C-p")
      projectile-known-projects-file (locate-user-emacs-file ".projectile/bookmarks.eld")
      projectile-cache-file (locate-user-emacs-file ".projectile/projectile.cache")
      projectile-idle-timer-seconds 60
      )
(define-key evil-normal-state-map (kbd "C-p") nil)

;; company
(setq company-idle-delay 0
      company-minimum-prefix-length 2
      company-tooltip-minimum 3
      company-tooltip-limit 5
      company-tooltip-offset-display nil
      )
(eval-after-load 'company '(add-to-list 'company-backends 'company-ghc))

(defvar loaded-company nil)
(defun company-turn-on-lazy ()
  (unless loaded-company
    (setq loaded-company t)
    (global-company-mode 1)))
(add-hook 'evil-insert-state-entry-hook #'company-turn-on-lazy)
(add-hook 'evil-insert-state-exit-hook #'company-abort)

(add-to-list 'load-path (locate-user-emacs-file "autoload"))
(require 'autoload-init)

(defun evil-maybe-remove-spaces-fix (&optional do-remove)
  (if do-remove
      (progn
        (when (and
               evil-maybe-remove-spaces
               (save-excursion
                 (beginning-of-line)
                 (looking-at "^\\s-*$")))
          (delete-region (line-beginning-position) (line-end-position))
          (setq evil-maybe-remove-spaces nil)))
    (setq evil-maybe-remove-spaces
          (memq this-command '(evil-open-above
                               evil-open-below
                               evil-append
                               evil-append-line
                               newline
                               newline-and-indent
                               indent-and-newline
                               evil-ret-and-indent
                               )))))
(advice-add #'evil-maybe-remove-spaces :override #'evil-maybe-remove-spaces-fix)

;; don't use register when delete a char
(defun evil-without-register (orig-fn beg end type register &rest args)
  (if (evil-visual-state-p)
      (apply orig-fn beg end type register args)
    (apply orig-fn beg end type ?_ args)))
(advice-add #'evil-delete-char :around #'evil-without-register)
(advice-add #'evil-delete-backward-char :around #'evil-without-register)
(advice-add #'evil-substitute :around #'evil-without-register)
(advice-add #'evil-backward-substitute :around #'evil-without-register)

;; order is important
(ivy-mode 1)
(evil-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(projectile-mode 1)
(desktop-save-mode 1)
(show-paren-mode 1)
(blink-cursor-mode 0)
(set-frame-font "Dejavu Sans Mono 11" nil t)
;; https://ja.wikipedia.org/wiki/IPA%E3%83%95%E3%82%A9%E3%83%B3%E3%83%88
;; ... JIS X 0213:2004に準拠している。
(set-fontset-font t 'japanese-jisx0213.2004-1 (font-spec :family "IPA Gothic"))
(global-whitespace-mode 1)
(global-nlinum-mode 1)
(nlinum-relative-on)

(load (locate-user-emacs-file "keymap"))
(load (locate-user-emacs-file "alias"))
(load (locate-user-emacs-file "mode-specific"))
(load (locate-user-emacs-file "modeline"))
(load (locate-user-emacs-file "theme"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (linum-relative evil-surround))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
