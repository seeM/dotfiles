;; TODO: Go through this: http://ryan.himmelwright.net/post/switched-to-joplin-notes/
;; - Set Enter to follow link?
;; - Override org C-h C-k to actually do window switching
;; TODO: Figure out defer / demand shit, things have gotten way slower to start...

;; TODO: GTD/PARA stuff looks interesting: https://github.com/mwfogleman/.emacs.d/blob/master/michael.org#organization-gtd-and-para

;; Sources:
;; - http://ryan.himmelwright.net/post/emacs-update-evil-usepackage/
;; - http://evgeni.io/posts/quick-start-evil-mode/
;; - https://github.com/mwfogleman/.emacs.d/blob/master/michael.org


;; =============
;; = Constants =
;; =============

(defconst my-leader ",")
(defconst notes-dir "~/gdrive/notes")

;; ============
;; = Packages =
;; ============

;; Load package manager, add the MELPA package registry.
(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; Bootstrap use-package.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

(use-package general
  :ensure t
  :demand t)

(use-package evil
  :ensure t
  :demand t
  :general
  (:states '(normal insert)
   "C-a" 'beginning-of-line
   "C-e" 'end-of-line
   "C-p" 'previous-line
   "C-n" 'next-line)
  :init
  (setq evil-want-C-u-scroll t
	evil-split-window-below t
	evil-vsplit-window-right t
	evil-want-keybinding nil
	evil-respect-visual-line-mode t
	evil-disable-insert-state-bindings t)
  :config
  (evil-mode t))

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
  :config
  (global-evil-surround-mode))

(use-package evil-org
  :after (evil org)
  :ensure t
  :general
  (:keymaps 'org-mode-map
   :states '(normal insert)
   "C-a" 'org-beginning-of-line
   "C-e" 'org-end-of-line
   "C-p" 'org-previous-visible-heading
   "C-n" 'org-next-visible-heading)
  (:keymaps 'org-mode-map
   :states 'normal
   "RET" 'org-toggle-narrow-to-subtree)
  :config
  (evil-org-set-key-theme
   '(textobjects insert navigation additional shift todo heading return))
  :hook
  ((org-mode . evil-org-mode)))

(use-package evil-org-agenda
  :after evil-org
  :config
  (evil-org-agenda-set-keys))

(use-package powerline-evil
  :after evil
  :ensure t
  :config
  (powerline-evil-vim-color-theme))

(use-package emacs
  :general
  (:keymaps 'key-translation-map
   "C-[" "C-g")
  (:keymaps 'override
   :states 'normal
   "-" 'dired-jump
   "C-h" 'evil-window-left
   "C-l" 'evil-window-right
   "C-k" 'evil-window-up
   "C-j" 'evil-window-down)
  (:states '(normal emacs)
   :prefix my-leader
   ;; Unmap the prefix key first
   ;; "" nil
   ;; "r" for rc, as in run commands
   "r e" (lambda () (interactive) (find-file "~/.emacs.d/init.el"))
   "r v" (lambda () (interactive) (find-file "~/.vimrc"))
   "r b" (lambda () (interactive) (find-file "~/.bashrc"))
   ;; "f" 'counsel-find-file
   ;; "f" '
   "s" 'save-buffer
   "q" 'evil-quit
   "," 'evil-switch-to-windows-last-buffer
   ;; "b" 'ivy-switch-buffer
   "h" help-map
   ;; "x" 'counsel-M-x
   "x" 'execute-extended-command
   "g s" 'magit-status
   "d" 'deft)
  :config
  (set-default 'truncate-lines t)
  (global-prettify-symbols-mode))

(use-package vc
  :custom
  (vc-follow-symlinks t))

(use-package dired-x)

(use-package calendar
  :hook
  (calendar-mode . (lambda ()
		     (setq-local show-trailing-whitespace nil))))

(use-package org
  :ensure t
  :demand t
  :preface
  (defun seem/set-buffer-variable-pitch-font-face ()
    "Set the buffer's font face to the variable pitch font."
    (interactive)
    (setq buffer-face-mode-face '(:family "Open Sans" :height 140 :width semi-condensed))
    (buffer-face-mode))
  (defun seem/prettify-org-symbols ()
    "Add unicode symbols to prettify-symbols-alist for org keywords."
    (interactive)
    ;; ❍
    ;; ▲ □ ○ ☐
    (push '("TODO"  . ?☐) prettify-symbols-alist)
    ;; ✓ ■ ● ☑
    (push '("DONE"  . ?☑) prettify-symbols-alist)
    (push '("CANCELLED"  . ?✘) prettify-symbols-alist)
    (push '("QUESTION"  . ??) prettify-symbols-alist)
    (push '("-"  . ?•) prettify-symbols-alist))
  :hook
  (org-mode . seem/prettify-org-symbols)
  ;; (org-mode . (lambda () (interactive) (text-scale-set 1)))
  (text-mode . auto-fill-mode)
  (text-mode . seem/set-buffer-variable-pitch-font-face)
  ;; :custom-face
  ;; (org-done ((t (:background "#E8E8E8" :foreground "#0E0E0E" :strike-through t :weight bold))))
  ;; (org-headline-done ((t (:foreground "#171717" :strike-through t))))
  ;; (org-level-1 ((t (:foreground "#090909" :weight bold :height 1.3))))
  ;; (org-level-2 ((t (:foreground "#090909" :weight normal :height 1.2))))
  ;; (org-level-3 ((t (:foreground "#090909" :weight normal :height 1.1))))
  :custom
  (org-directory "~/gdrive/notes")
  (org-default-notes-file "~/gdrive/notes/inbox.org")
  (org-agenda-files '("~/gdrive/notes"))
  (org-log-done 'time)
  ;; Don't try to be clever about adding blank lines before new entries.
  (org-blank-before-new-entry '((heading) (plain-list-item)))
  ;; (org-startup-indented t)
  (org-adapt-indentation nil)
  (org-export-backends '(ascii html icalendar latex odt md))
  (org-hide-emphasis-markers t)
  (org-special-ctrl-a/e t)
  (org-special-ctrl-k t)
  (org-ellipsis " ")
  (org-pretty-entities t)
  (org-fontify-done-headline t)
  (org-src-tab-acts-natively t)
  (org-src-preserve-indentation t))

(use-package org-tempo
  :after org)

(use-package org-mouse
  :after org)

(use-package org-journal
  :ensure t
  :after org
  :preface
  (defun seem/org-journal-today ()
    "Open today's journal file."
    (interactive)
    (org-journal-new-entry t))
  (defun seem/org-journal-yesterday ()
    "Open yesterday's journal file."
    (interactive)
    (org-journal-new-entry t)
    (org-journal-previous-entry))
  ;; :general
  ;; (:prefix my-leader
  ;;  :states 'normal
  ;;  :keymaps 'org-journal-mode-map
  ;;  "j" 'org-journal-new-entry
  ;;  "s" 'org-journal-search-forever)
  ;; (:states 'normal
  ;;  :keymaps 'org-journal-mode-map
  ;;  "C-p" 'org-journal-previous-entry
  ;;  "C-n" 'org-journal-next-entry)
  :general
  (:states 'normal
   :prefix my-leader
   "j j" 'org-journal-new-entry
   "j t" 'seem/org-journal-today
   "j y" 'seem/org-journal-yesterday)
  (:states '(normal insert)
   :keymaps 'org-journal-mode-map
   "C-b" 'org-journal-previous-entry
   "C-f" 'org-journal-next-entry)
  :custom
  (org-journal-dir notes-dir)
  (org-journal-date-format "%A, %d %B %Y")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-date-prefix "#+title: ")
  (org-journal-time-prefix "* ")
  (org-journal-find-file 'find-file))

(use-package org-roam
  :ensure t
  :after org
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory notes-dir)
  :general
  (:states '(normal insert)
   :keymaps 'org-mode-map
   "C-c n i" 'org-roam-insert
   "C-c n I" 'org-roam-insert-immediate)
  (:states 'normal
   :prefix my-leader
   "n l" 'org-roam
   "n f" 'org-roam-find-file
   "n g" 'org-roam-graph-show))

(use-package org-cliplink
  :ensure t
  :after org
  :general
  (:keymaps 'org-mode-map
   "C-c l" 'org-cliplink))

;; (use-package visual-fill-column
;;   :ensure t
;;   :hook
;;   (visual-line-mode . visual-fill-column-mode)
;;   :config
;;   (advice-add 'text-scale-adjust :after #'visual-fill-column-adjust)
;;   :custom
;;   (visual-fill-column-width 70)
;;   (split-window-preferred-function 'visual-fill-column-split-window-sensibly))

(use-package deft
  :commands (deft)
  :general
  (:states 'emacs
   :keymaps 'deft-mode-map
   :prefix my-leader
   ;; TODO: Might prefer "C-[" but can't get it to work.
   "q" 'kill-current-buffer)
  :config
  (evil-set-initial-state 'deft-mode 'emacs)
  :custom
  (deft-recursive t)
  (deft-directory notes-dir)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-extensions '("org")))

;; (use-package ivy
;;   :ensure t
;;   :config
;;   (ivy-mode 1)
;;   ;; (setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
;;   (add-to-list 'ivy-ignore-buffers "\\*scratch\\*")
;;   (add-to-list 'ivy-ignore-buffers "\\*Messages\\*")
;;   (add-to-list 'ivy-ignore-buffers "\\*Compile-Log\\*")
;;   (add-to-list 'ivy-ignore-buffers "\\*Ido Completions\\*")
;;   (add-to-list 'ivy-ignore-buffers "\\*Warnings\\*")
;;   (add-to-list 'ivy-ignore-buffers "\\*Help\\*")
;;   (add-to-list 'ivy-ignore-buffers "\\*Deft\\*"))

(use-package selectrum
  :ensure t
  :config
  (selectrum-mode +1))

(use-package consult
  :ensure t
  :general
  (:states '(normal emacs)
   :prefix my-leader
   "b" 'consult-buffer
   ;; "g g" 'consult-git-grep
   ;; TODO: Should use consult-find?
   "f" 'find-file))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode)
  (advice-add
   #'marginalia-cycle :after
   (lambda () (when (bound-and-true-p selectrum-mode) (selectrum-exhibit))))
  (setq marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil)))

(use-package prescient
  :ensure t)

(use-package selectrum-prescient
  :ensure t
  :after (prescient selectrum)
  :init
  (selectrum-prescient-mode))

(use-package embark
  :ensure t
  :bind
  ("C-S-a" . embark-act))              ; pick some comfortable binding

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . embark-consult-preview-minor-mode))

;; (use-package counsel
;;   :ensure t
;;   :config
;;   (counsel-mode 1))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown")
  :custom
  (markdown-hide-markup t))

(use-package cider
  :ensure t)

(use-package clojure-mode
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
  (setq projectile-project-search-path '("~/code/"))
	;; projectile-completion-system 'ivy)
  (projectile-mode 1))

;; (use-package modus-vivendi-theme
;;   :ensure t)

(use-package modus-operandi-theme
  :ensure t)

;; (use-package night-owl-theme
;;   :ensure t)

;; (use-package dracula-theme
;;   :ensure t)

;; (use-package vscode-dark-plus-theme
;;   :ensure t)

(use-package magit
  :ensure t)

(use-package csv-mode
  :ensure t)

(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  :general
  (:keymaps 'company-mode-map
   :states 'insert
   "C-p" 'company-select-previous
   "C-n" 'company-select-next))

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

;; Make yes/no prompts be y/n
(fset 'yes-or-no-p 'y-or-n-p)

;; Source: https://github.com/mwfogleman/.emacs.d/blob/master/michael.org#buffer--file-warnings
;; Remove the warning if a buffer or file does not exist, so you can create them.
(setq confirm-nonexistent-file-or-buffer nil)

(defun create-non-existent-directory ()
  "Check whether a given file's parent directories exist; if they do not, offer to create them."
  (let ((parent-directory (file-name-directory buffer-file-name)))
    (when (and (not (file-exists-p parent-directory))
               (y-or-n-p (format "Directory `%s' does not exist! Create it?" parent-directory)))
      (make-directory parent-directory t))))

(add-to-list 'find-file-not-found-functions #'create-non-existent-directory)

;; Turn off the bell
(setq ring-bell-function 'ignore)

;; Font
(set-frame-font "SF Mono 13")

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("ce76fe14c6a9269a1ab4bf0060c6cdb3fd2c99f829de345494b6f30ee4258a1c" "41c478598f93d62f46ec0ef9fbf351a02012e8651e2a0786e0f85e6ac598f599" "5f824cddac6d892099a91c3f612fcf1b09bb6c322923d779216ab2094375c5ee" "0423ec89db11589d86cbd6f0c9e5417594a4506cf26e29ff400797fdcb25732b" "928ffa547ce426cdcea1f3ea8b5a25fd4808ca2bc2ab2f964621a8691406d94c" default)))
 '(package-selected-packages
   (quote
    (company embark-consult embark selectrum-prescient prescient marginalia consult selectrum exec-path-from-shell visual-fill-column org-bullets org-cliplink org-clip vscode-dark-plus-theme use-package projectile powerline-evil org-roam org-journal night-owl-theme modus-vivendi-theme modus-operandi-theme markdown-preview-mode magit helm gruber-darker-theme general fzf evil-surround evil-org evil-leader evil-indent-textobject evil-commentary evil-collection dracula-theme deft csv-mode cider))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'modus-operandi)
