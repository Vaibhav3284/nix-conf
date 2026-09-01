;;; init.el --- Minimal Emacs Configuration -*- lexical-binding: t; -*-

;; ============================================================
;; PACKAGE MANAGEMENT
;; ============================================================

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

;; ============================================================
;; APPEARANCE - DARK THEME
;; ============================================================

;; Install and load a clean dark theme
(use-package doom-themes
  :config
  (load-theme 'doom-one t)        ;; Modern dark theme
  (doom-themes-visual-bell-config))

;; Or use built-in alternatives (uncomment one):
;; (load-theme 'modus-vivendi t)   ;; Built-in high-contrast dark
;; (load-theme 'wombat t)          ;; Built-in warm dark

;; ============================================================
;; QUALITY OF LIFE
;; ============================================================

;; Visual
(menu-bar-mode -1)                ;; Hide menu bar
(tool-bar-mode -1)                ;; Hide tool bar
(scroll-bar-mode -1)              ;; Hide scroll bar
(global-display-line-numbers-mode t) ;; Show line numbers
(global-visual-line-mode t)       ;; Soft line wrapping
(blink-cursor-mode -1)            ;; Steady cursor

;; Editing
(delete-selection-mode t)         ;; Typing replaces selection
(electric-pair-mode t)            ;; Auto-close brackets/quotes
(global-auto-revert-mode t)       ;; Auto-reload changed files
(recentf-mode t)                  ;; Track recent files
(savehist-mode t)                 ;; Save command history

;; Keyboard shortcuts
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "M-z") 'zap-up-to-char)

;; Backup/autosave cleanup
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups" user-emacs-directory)))
      auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-save" user-emacs-directory) t))
      create-lockfiles nil)

;; UI refinements
(setq inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore
      visible-bell nil
      use-dialog-box nil)

;; Better scrolling
(setq scroll-step 1
      scroll-conservatively 10000
      mouse-wheel-scroll-amount '(1 ((shift) . 1))
      mouse-wheel-progressive-speed nil)

;; ============================================================
;; MINIMAL HELPER FUNCTIONS
;; ============================================================

(defun my/delete-trailing-whitespace ()
  "Delete trailing whitespace in current buffer."
  (interactive)
  (delete-trailing-whitespace))

;; ============================================================
;; PER-MODE SETTINGS
;; ============================================================

;; No tabs, spaces only
(setq-default indent-tabs-mode nil
              tab-width 2)

;; ============================================================

(provide 'init)
;;; init.el ends heer
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'set-goal-column 'disabled nil)
