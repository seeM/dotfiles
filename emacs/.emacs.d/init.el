;; TODO:
;; - cmd-w to close window
;; - cmd-o to swap window?
;; - cmd-t for new window? tab?
;; - https://www.youtube.com/watch?v=CTOhosGQ2f0
;; TODO: Use <Esc> instead of <C-g>? Not sure its worth unlearning that...
;;       Or even <C-[> from VIM
;; TODO: Go through this: http://ryan.himmelwright.net/post/switched-to-joplin-notes/
;;       Looks like exactly my use-case...

;; Sources:
;; - http://ryan.himmelwright.net/post/emacs-update-evil-usepackage/
;; - http://evgeni.io/posts/quick-start-evil-mode/

;; ============
;; = Packages =
;; ============

;; Load package manager, add the MELPA package registry.
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Bootstrap use-package.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; TODO: Not sure why this needs to happen at "compile-time", and what that
;;       even means. What's the process that's going on here?
(eval-when-compile
  (require 'use-package))

(use-package org
  :ensure t
  :custom

  (org-directory "~/org")
  (org-default-notes-file "~/org/inbox.org")
  (org-agenda-files '("~/org"))
  (org-log-done 'time)
  (org-adapt-indentation nil)
  (org-export-backends '(ascii html icalendar latex odt md)))

;; Evil Mode
(use-package evil
  :ensure t
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-spit-window-below t)
  (setq evil-vspit-window-right t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  ;; (evil-define-key 'normal 'dired-mode-map "-" (lambda ()
  ;; 						 (interactive)
  ;; 						 (find-alternate-file "..")))
  (evil-define-key 'normal 'global "-" 'dired-jump)

  (use-package evil-collection
    :after evil
    :ensure t
    :config
    (evil-collection-init))

  (use-package evil-commentary
    :after evil
    :ensure t
    :config
    (evil-commentary-mode t))

  (use-package evil-leader
    :after evil
    :ensure t
    :config
    (global-evil-leader-mode t)
    (evil-leader/set-leader "<SPC>"))

  (use-package evil-surround
    :after evil
    :ensure t
    :config (global-evil-surround-mode))

  (use-package evil-indent-textobject
    :after evil
    :ensure t)

  (use-package evil-org
    :after (evil org)
    :ensure t
    :config
    (evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading return))
    (add-hook 'org-mode-hook 'evil-org-mode)
    (require 'evil-org-agenda)
    (evil-org-agenda-set-keys))

  ;; TODO: Keep this?
  (use-package powerline-evil
    :after evil
    :ensure t
    :config
    (powerline-evil-vim-color-theme)))

;; IDO (Interactively Do Everything)
(use-package ido
  :ensure t
  :config
  (ido-mode 1)
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package cider
  :ensure t)

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-project-search-path '("~/code/"))
  (projectile-mode +1))

;; (use-package modus-vivendi-theme
;;   :ensure t)

;; (use-package night-owl-theme
;;   :ensure t)

;; (use-package dracula-theme
;;   :ensure t)

(use-package vscode-dark-plus-theme
  :ensure t
  :config
  (load-theme 'vscode-dark-plus t))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(require 'dired-x)

(use-package csv-mode
  :ensure t)

;; =========
;; = Other =
;; =========

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;; Hide the splash screen -- instead open an empty scratch buffer.
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t) 

;; Auto-indent auto-magically.
(define-key global-map (kbd "RET") 'newline-and-indent)

; Rebinding modifiers for mac.
; (setq mac-command-modifier 'meta)
; (setq mac-option-modifier 'super)
; (setq ns-function-modifier 'hyper)

; Line wrapping
(setq-default fill-column 80)

;; Window movement
(windmove-default-keybindings)

;; Backups
;; Source: https://stackoverflow.com/a/151946
(setq backup-directory-alist `(("." . "~/.emacs_backups")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;; Font
(set-frame-font "IBM Plex Mono 14")

;; Show trailing whitespace
(setq-default show-trailing-whitespace t)

;; End
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("950a9a6ca940ea1db61f7d220b01cddb77aec348d3c2524349a8683317d1dbb6" "dcdd1471fde79899ae47152d090e3551b889edf4b46f00df36d653adc2bf550d" "41c478598f93d62f46ec0ef9fbf351a02012e8651e2a0786e0f85e6ac598f599" "cf7c7ea6ccd8e251a9dbafb54a7ef7e29dcd17c5b5fbd37ea7f315b6daa509b9" default)))
 '(package-selected-packages
   (quote
    (evil-collection evil-commentary csv-mode dired magit night-owl-theme modus-vivendi-theme markdown-preview-mode use-package projectile powerline-evil markdown-mode evil-surround evil-org evil-leader evil-indent-textobject cider))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
