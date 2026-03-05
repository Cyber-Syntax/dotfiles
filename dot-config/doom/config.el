;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;;; -----------------------------------------------------------------------
;;  THEME AND APPEARANCE
;;; -----------------------------------------------------------------------

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;;; -----------------------------------------------------------------------
;;  DIRECTORY
;;; -----------------------------------------------------------------------

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/Documents/orgfiles/")

  (setq org-agenda-files
        (append
         (directory-files-recursively "~/Documents/orgfiles/" "\\.org$")
         (directory-files-recursively "~/Documents/my-repos/" "\\.org$")
         (directory-files-recursively "~/dotfiles/" "\\.org$")))

;;; -----------------------------------------------------------------------
;;  FONTS
;;; -----------------------------------------------------------------------
;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.

;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:

;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' for it, and
;; 'M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. Font issues are rarely Doom issues!

;; Increase fonts on emacs for better view
(add-hook 'doom-init-ui-hook #'doom-big-font-mode)

(setq doom-font (font-spec :family "JetBrainsMonoNL Nerd Font Propo" :size 19))

;; (setq doom-font "Terminus (TTF):pixelsize=12:antialias=off")
;; (setq doom-font "Fira Code-14")

;; ;; enable soft-wrapping
;; (setq +word-wrap-extra-indent 'single)
;; (setq +word-wrap-fill-style 'soft)
;; ;; set soft wrap lenght to max 80
;; (setq-default fill-column 80)
;; (+global-word-wrap-mode +1)

;; set up defaults for your soft wrap behaviour
(setq +word-wrap-extra-indent 'single)
(setq +word-wrap-fill-style 'soft)
(setq-default fill-column 80)

;; disable global word wrap if you've enabled it before
(+global-word-wrap-mode -1)

;; enable soft wrap only in org-mode
(add-hook 'org-mode-hook
          (lambda ()
            (+word-wrap-mode +1)
            (setq-local fill-column 80)))

;; enable soft wrap only in markdown-mode
(add-hook 'markdown-mode-hook
          (lambda ()
            (+word-wrap-mode +1)
            (setq-local fill-column 80)))

;;; -----------------------------------------------------------------------
;;  CUSTOM EMACS SETTINGS
;;; -----------------------------------------------------------------------
(setq confirm-kill-emacs nil)        ;; Don't confirm on exit

;;; -----------------------------------------------------------------------
;;; EMACS PLUGINS
;;; -----------------------------------------------------------------------

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;

;;; org-wild-notifier — Desktop notifications for Org agenda
;;;
;;; GitHub: https://github.com/akhramov/org-wild-notifier
;;;
;;; Description:
;;; Sends desktop notifications for scheduled and deadline items in Org mode.
;;; Works while Emacs is running (daemon or GUI).
;;; Uses the `alert` package backend (libnotify / notifications / etc).
;;;
;;; Why I use this:
;;; - Kanban-style workflow in org files
;;; - Reminders before deadlines (60, 30, 15, 5... minutes)
;;; - Lightweight and simple
;;;
;;; Notes:
;;; - Emacs must be running to receive notifications.
;;; - Times below are minutes BEFORE scheduled/deadline time.
;;; - org-wild-notifier focuses on calendar-style notifications:
;;;     remind me 10 minutes before my meeting, not every 5 minutes until it happens.
;;; ---------------------------------------------------------------------------

(use-package org-wild-notifier
  :config
  ;; make sure alert is loaded so the backend style is available
  (require 'alert)
  (setq alert-default-style 'notifications)

  ;; times in minutes before the scheduled/deadline event
  (setq org-wild-notifier-alert-time '(60 30 15 5 4 3 2 1))

  ;; customisation requested by the user
  ;; Notification title and icon
  (setq org-wild-notifier-notification-title "Org Reminder")

  ;; Alert severity can be one of 'high, 'medium or 'low — affects the icon
  (setq org-wild-notifier--alert-severity 'high)

  ;; additional arguments passed through to `alert'
  (setq org-wild-notifier-extra-alert-plist '(:persistent t))

  ;; Display time format in the notifications default “%I:%M %p”
  (setq org-wild-notifier-display-time-format-string "%H:%M")

  ;; org-wild-notifier-keyword-whitelist:
  ;; can be used to only get notifications for certain TODO states, e.g. '("TODO" "DOING")
  ;; org-wild-notifier-tags-whitelist:
  ;; can be used to only get notifications for items with certain tags, e.g. '("work" "urgent")

  ;; org-wild-notifier-day-wide-alert-times
  ;; Times to alert for day-wide events (default: nil)
  ;; org-wild-notifier-show-any-overdue-with-day-wide-alerts
  ;; Include overdue items in day-wide alerts (default: t)

  ;; TODO: this isn't work for overdue tasks
  ;; remind about day‑wide items at 9 a.m. and 2 p.m.
  (setq org-wild-notifier-day-wide-alert-times '("09:00" "14:00"))

  (org-wild-notifier-mode 1))

;; CUSTOM agenda
;;

;;(org-ql-search (org-agenda-files) '(and (todo) (scheduled :to -1)))
;;
(setq org-agenda-custom-commands
      '(("o" "Overdue tasks"
         ((org-ql-block
           '(and (todo) (scheduled :to -1))
           ((org-ql-block-header "Overdue scheduled tasks")))))))

;; (setq org-agenda-custom-commands
;;       '(("g" "GTD dashboard"
;;          (;; Overdue = missed scheduled/deadline items (before today)
;;           (tags-todo "SCHEDULED<\"<today>\"|DEADLINE<\"<today>\""
;;                      ((org-agenda-overriding-header "Overdue")))

;;           ;; Due = scheduled/deadline today
;;           (tags-todo "SCHEDULED=\"<today>\"|DEADLINE=\"<today>\""
;;                      ((org-agenda-overriding-header "Due today")))

;;           ;; Priority A bucket (keep this)
;;           (tags-todo "+PRIORITY=\"A\""
;;                      ((org-agenda-overriding-header "Important tasks")))

;;           ;; Hide "Backlog" completely by not showing it at all.
;;           ;; If you want a "DOING" kanban lane instead, add a section like:
;;           (todo "DOING" ((org-agenda-overriding-header "🔁 DOING")))
;;           ))))
