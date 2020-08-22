;; TODO: Go through this: http://ryan.himmelwright.net/post/switched-to-joplin-notes/
;; - Set Enter to follow link?
;; - Override org C-h C-k to actually do window switching

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

(defconst my-leader ",")
(general-create-definer my-leader-def
  :prefix my-leader)

(use-package general
  :ensure t)

(use-package org
  :ensure t
  :custom
  (org-directory "~/org")
  (org-default-notes-file "~/org/inbox.org")
  (org-agenda-files '("~/org"))
  (org-log-done 'time)
  (org-adapt-indentation nil)
  (org-export-backends '(ascii html icalendar latex odt md))
  (add-hook 'text-mode-hook #'visual-line-mode)
  ;; Replace ` and ' with prettier versions
  ;; (add-hook 'text-mode-hook #'electric-quote-mode)
  )

;; ;; Use variable width font in org mode
;; (defun my-buffer-face-mode-face-variable ()
;;   "Set font to a variable width (proportional) fonts in current buffer"
;;   (interactive)
;;   (setq buffer-face-mode-face '(:family "ETBembo" :height 180 :width semi-condensed))
;;   (buffer-face-mode))
;; (add-hook 'text-mode-hook #'my-buffer-face-mode-face-variable)

(use-package org-journal
  :ensure t
  :after org
  :defer t
  :general
  (:prefix my-leader
   :keymaps 'org-journal-mode-map
   "p" 'org-journal-previous-entry
   "n" 'org-journal-next-entry
   "j" 'org-journal-new-entry
   "s" 'org-journal-search-forever)
  :config
  (setq org-journal-dir "~/gdrive/notes/journal/"
        org-journal-date-format "%A, %d %B %Y"
	org-journal-file-format "%Y-%m-%d"))

(use-package org-roam
  :ensure t
  :after org
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "~/gdrive/notes/"))

(use-package evil
  :ensure t
  ;; TODO: Is demand needed?...
  :demand t
  :init
  (setq evil-want-C-u-scroll t
	evil-split-window-below t
	evil-vsplit-window-right t
	evil-want-keybinding nil
	evil-respect-visual-line-mode t)
  :general
  (:keymaps 'key-translation-map
   "C-[" "C-g")
  (:states 'normal
   "-" 'dired-jump
   "C-h" 'evil-window-left
   "C-l" 'evil-window-right
   "C-k" 'evil-window-up
   "C-j" 'evil-window-down)
  (:states 'normal
   :prefix ","
   ;; Unmap the prefix key first
   "" nil
   "f" 'counsel-find-file
   "w" 'save-buffer
   "q" 'evil-quit
   "," 'evil-switch-to-windows-last-buffer
   "b" 'ivy-switch-buffer
   "h" help-map
   "c" 'counsel-M-x
   "j j" 'org-journal-new-entry)

  :config
  (evil-mode t)

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

  (use-package evil-surround
    :after evil
    :ensure t
    :config (global-evil-surround-mode))

  (use-package evil-org
    :after (evil org)
    :ensure t
    :config
    (evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading return))
    (add-hook 'org-mode-hook 'evil-org-mode)
    (require 'evil-org-agenda)
    (evil-org-agenda-set-keys))

(use-package powerline-evil
  :after evil
  :ensure t
  :config
  (powerline-evil-vim-color-theme)))

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  ;; (setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  (add-to-list 'ivy-ignore-buffers "\\*scratch\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Messages\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Compile-Log\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Ido Completions\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Help\\*"))

(use-package counsel
  :ensure t
  :config
  (counsel-mode 1))

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
  ;; TODO: Needed?
  :demand t
  :general
  (:keymaps 'projectile-mode-map
   "s-p" 'projectile-command-map
   "C-c p" 'projectile-command-map)
  :config
  (setq projectile-project-search-path '("~/code/")
	projectile-completion-system 'ivy)
  (projectile-mode 1))

(use-package modus-vivendi-theme
  :ensure t)

(use-package night-owl-theme
  :ensure t)

(use-package dracula-theme
  :ensure t)

(use-package vscode-dark-plus-theme
  :ensure t)

(use-package magit
  :ensure t
  :general
  (:prefix ","
   "g s" 'magit-status))

(require 'dired-x)

(use-package csv-mode
  :ensure t)

;; =========
;; = Other =
;; =========

(load-theme 'leuven)

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;; Hide the splash screen -- instead open an empty scratch buffer.
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; Auto-indent
(define-key global-map (kbd "RET") 'newline-and-indent)

; Line wrapping
(setq-default fill-column 80)

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

;; Set window title to full file path
(setq frame-title-format "%f")

;; Fix LISP indentation
;; Source: https://github.com/Fuco1/.emacs.d/blob/af82072196564fa57726bdbabf97f1d35c43b7f7/site-lisp/redef.el#L20-L94
;;         via https://emacs.stackexchange.com/a/10233
(eval-after-load "lisp-mode"
  '(defun lisp-indent-function (indent-point state)
     "This function is the normal value of the variable `lisp-indent-function'.
The function `calculate-lisp-indent' calls this to determine
if the arguments of a Lisp function call should be indented specially.
INDENT-POINT is the position at which the line being indented begins.
Point is located at the point to indent under (for default indentation);
STATE is the `parse-partial-sexp' state for that position.
If the current line is in a call to a Lisp function that has a non-nil
property `lisp-indent-function' (or the deprecated `lisp-indent-hook'),
it specifies how to indent.  The property value can be:
* `defun', meaning indent `defun'-style
  \(this is also the case if there is no property and the function
  has a name that begins with \"def\", and three or more arguments);
* an integer N, meaning indent the first N arguments specially
  (like ordinary function arguments), and then indent any further
  arguments like a body;
* a function to call that returns the indentation (or nil).
  `lisp-indent-function' calls this function with the same two arguments
  that it itself received.
This function returns either the indentation to use, or nil if the
Lisp function does not specify a special indentation."
     (let ((normal-indent (current-column))
           (orig-point (point)))
       (goto-char (1+ (elt state 1)))
       (parse-partial-sexp (point) calculate-lisp-indent-last-sexp 0 t)
       (cond
        ;; car of form doesn't seem to be a symbol, or is a keyword
        ((and (elt state 2)
              (or (not (looking-at "\\sw\\|\\s_"))
                  (looking-at ":")))
         (if (not (> (save-excursion (forward-line 1) (point))
                     calculate-lisp-indent-last-sexp))
             (progn (goto-char calculate-lisp-indent-last-sexp)
                    (beginning-of-line)
                    (parse-partial-sexp (point)
                                        calculate-lisp-indent-last-sexp 0 t)))
         ;; Indent under the list or under the first sexp on the same
         ;; line as calculate-lisp-indent-last-sexp.  Note that first
         ;; thing on that line has to be complete sexp since we are
         ;; inside the innermost containing sexp.
         (backward-prefix-chars)
         (current-column))
        ((and (save-excursion
                (goto-char indent-point)
                (skip-syntax-forward " ")
                (not (looking-at ":")))
              (save-excursion
                (goto-char orig-point)
                (looking-at ":")))
         (save-excursion
           (goto-char (+ 2 (elt state 1)))
           (current-column)))
        (t
         (let ((function (buffer-substring (point)
                                           (progn (forward-sexp 1) (point))))
               method)
           (setq method (or (function-get (intern-soft function)
                                          'lisp-indent-function)
                            (get (intern-soft function) 'lisp-indent-hook)))
           (cond ((or (eq method 'defun)
                      (and (null method)
                           (> (length function) 3)
                           (string-match "\\`def" function)))
                  (lisp-indent-defform state indent-point))
                 ((integerp method)
                  (lisp-indent-specform method state
                                        indent-point normal-indent))
                 (method
                  (funcall method indent-point state)))))))))

;; End
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("5f824cddac6d892099a91c3f612fcf1b09bb6c322923d779216ab2094375c5ee" "950a9a6ca940ea1db61f7d220b01cddb77aec348d3c2524349a8683317d1dbb6" "dcdd1471fde79899ae47152d090e3551b889edf4b46f00df36d653adc2bf550d" "41c478598f93d62f46ec0ef9fbf351a02012e8651e2a0786e0f85e6ac598f599" "cf7c7ea6ccd8e251a9dbafb54a7ef7e29dcd17c5b5fbd37ea7f315b6daa509b9" default)))
 '(package-selected-packages
   (quote
    (general org-roam modus-operandi-theme gruber-darker-theme counsel ivy fzf helm evil-collection evil-commentary csv-mode dired magit night-owl-theme modus-vivendi-theme markdown-preview-mode use-package projectile powerline-evil markdown-mode evil-surround evil-org evil-leader evil-indent-textobject cider))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
