;; TODO: consider using use-package
;; TODO: <C-u> doesn't seem to work as VIM binding
;; TODO: Use <Esc> instead of <C-g>? Not sure its worth unlearning that...
;;       Or even <C-[> from VIM background
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

;; Evil Mode
(use-package evil
  :ensure t
  :config

  (evil-mode 1)
  (use-package evil-leader
    :ensure t
    :config
    (global-evil-leader-mode t)
    (evil-leader/set-leader "<SPC>"))

  (use-package evil-surround
    :ensure t
    :config (global-evil-surround-mode))

  (use-package evil-indent-textobject
    :ensure t)

  (use-package evil-org
    :ensure t
    ;; TODO: after necessary? Should all of the above things have :after evil instead of being nested like this?
    :after org
    :config
    (evil-org-set-key-theme
	  '(textobjects insert navigation additional shift todo heading))
    (add-hook 'org-mode-hook 'evil-org-mode)
    (add-hook 'evil-org-mode-hook (lambda () (evil-org-set-key-theme)))
    (require 'evil-org-agenda)
    (evil-org-agenda-set-keys))

  ;; TODO: Keep this?
  (use-package powerline-evil
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


;; End
