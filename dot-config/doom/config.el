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
;;
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
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' for it, and
;; 'M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. Font issues are rarely Doom issues!

;; Increase fonts on emacs for better view
(add-hook 'doom-init-ui-hook #'doom-big-font-mode)

(setq doom-font (font-spec :family "JetBrainsMonoNL Nerd Font Propo" :size 19))

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
;;  CUSTOM KEYBINDINGS
;;; -----------------------------------------------------------------------

;; Enable clipboard
(map! "C-S-c" #'clipboard-kill-ring-save)
(map! "C-S-v" #'clipboard-yank)

;; custom shift, shift+tab indendation
;; TODO: this isn't work because doom use snippet for tab
;; find a way to handle it
;; disable other doom keybind?
;;
;; (defun my-dedent-region (beg end)
;;   "Dedent region by one level."
;;   (interactive "r")
;;   (unless (use-region-p) (message "No active region"))
;;   (indent-rigidly beg end (- 0 tab-width)))

;; (map! :v "S-<tab>" #'my-dedent-region
;;       :v "<tab>"   #'indent-region)

;;; -----------------------------------------------------------------------
;;  CUSTOM EMACS SETTINGS
;;; -----------------------------------------------------------------------
(setq confirm-kill-emacs nil)        ;; Don't confirm on exit

;; remove ``` tick to became ```` tick on org mode
(after! smartparens
  (sp-local-pair 'org-mode "`" nil :actions nil))

;; Fixes gc comment wrong behavior that won't work like neovim default
;; basically, doom default don't comment all line if you on the middle (e.g line 4 not 0)
;; so default one is need to go first line via `0` shortcut and select two line to work default
(map! :v "gc" #'evilnc-comment-or-uncomment-lines)

(after! org-agenda
  (set-popup-rule! "^\\*Org Agenda"
    :side 'right
    :size 0.5
    :select
    :quit nil))
;;TESTING: enable highlight for code lines in orgmode
;;(setq org-src-fontify-natively t)
;; (setq +tree-sitter-enable t)

;;; -----------------------------------------------------------------------
;;; CUSTOM TODO STATES
;;;
;;; after! org ensures your settings apply after Org mode initializes.
;;;
;;; ‘!’ (for a timestamp) or ‘@’ (for a note with timestamp)
;;;
;;; NOTE: You can't list DONE, CANCELED, or FIXED on your custom agenda views,
;;; because they are considered "done" states.
;;; -----------------------------------------------------------------------

(after! org
  (setq org-todo-keywords
        '((sequence "TODO(t)" "DOING(i!)" "TESTING(e!)" "BLOCKED(w@/!)"
           "BUY(B)" "READ(r)" "WATCH(v)" "|" "DONE(d!)")
          (sequence "BACKLOG(k@/!)" "SOMEDAY(s)" "|")
          (sequence "BUG(b)" "|")))

  (setq org-todo-keyword-faces
        '(("BLOCKED" . (:inherit (bold org-todo) :foreground "#f5870a"))
          ("DOING"   . (:inherit (bold org-todo) :foreground "#355bf2"))
          ("TESTING" . (:inherit (bold org-todo) :foreground "#f2ea02"))
          ("HOLD"    . (:inherit (bold org-todo) :foreground "#8638fc"))
          ("SOMEDAY" . (:inherit (bold org-todo) :foreground "gray"))
          ("BUG"     . (:inherit (bold org-todo) :foreground "red")))))

;; ;; Alternative: maintain a separate backlog file (not included in `org-agenda-files`)
;; (setq org-agenda-files '("~/org/tasks.org" "~/org/projects.org")) ; don't add backlog.org

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
  (setq org-wild-notifier-alert-time '(30 15 5 4 3 2 1))

  ;; customisation requested by the user
  ;; Notification title and icon
  (setq org-wild-notifier-notification-title "Org Reminder")

  ;; Alert severity can be one of 'high, 'medium or 'low — affects the icon
  (setq org-wild-notifier--alert-severity 'medium)

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

  ;; NOTE: send notification for overdue tasks
  ;; remind about day‑wide items at 9 a.m. and 2 p.m.
  ;; only DONE state won't send notif
  ;; TODO: disable notification if deadline exist
  (setq org-wild-notifier-day-wide-alert-times '("09:00" "14:00"))

  (org-wild-notifier-mode 1))

;;; -----------------------------------------------------------------------
;;; CUSTOM AGENDA VIEWS
;;; -----------------------------------------------------------------------
;;;
;;; org-super-agenda — Dashboard with file-grouped overflow
;;;
;;; Group order (first match wins):
;;;   1. Today: scheduled today, deadline today, TODO "TODAY", time-grid items for today
;;;   2. Overdue Tasks (No Deadline): scheduled past tasks that don't have a deadline
;;;   3. Scheduled Today: scheduled today
;;;   4. Testing: TODO "TESTING"
;;;   5. DOING: TODO "DOING"
;;;   6. Important (Priority A): priority "A"
;;;   7. Important (Priority B): priority "B"
;;;   8. Bugs: TODO "BUG"
;;;   9. Blocked: TODO "BLOCKED"
;;;   10. Priority <= C: priority "C" or lower (C, D, E...)
;;;   11. Backlog: TODO "BACKLOG"
;;;   12. Discard all remaining items, hide other-items
;;;
;;; ---------------------------------------------------------------------------

;; Fixes the keybind(jk) issue on org-super-agenda.
(after! org-super-agenda
  (setq org-super-agenda-header-map (make-sparse-keymap)))

(setq org-agenda-start-day nil) ; Sets the agenda to start on today (fixes wrong date)
(setq org-agenda-todo-ignore-deadlines nil)
(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-include-diary t
      org-agenda-block-separator nil
      org-agenda-compact-blocks t
      org-agenda-start-with-log-mode t)

(setq org-agenda-custom-commands
      '(("g" "Dashboard"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                          :time-grid t
                          :date today
                          :todo "TODAY"
                          :scheduled today
                          :order 1)
                         ;; Discard all remaining items, including those in timeline (hide other-items)
                         (:discard (:anything t))))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '(;; Each group has an implicit boolean OR operator between its selectors.
                          (:name "Passed Deadline"
                           :deadline past
                           :order 1)
                          (:name "Deadline Today"
                           :deadline today
                           :order 2)
                          (:name "Overdue Tasks (No Deadline)"
                           ;; Show only scheduled past tasks that don't have a deadline
                           :and (:scheduled past :not (:deadline t))
                           :order 3)
                          (:name "Scheduled Today"
                           :scheduled today
                           :order 4)
                          (:name "Testing"
                           :todo "TESTING"
                           :order 5)
                          (:name "DOING"
                           :todo "DOING"
                           :order 6)
                          (:name "Important (Priority A)"
                           :priority "A"
                           :order 7)
                          (:name "Important (Priority B)"
                           :priority "B"
                           :order 8)
                          (:name "Bugs"
                           :todo "BUG"
                           :order 9)
                          (:name "Blocked"
                           :todo "BLOCKED"
                           :order 10)
                          (:priority<= "C"
                           ;; Show this section after "Today" and "Important", because
                           ;; their order is unspecified, defaulting to 0. Sections
                           ;; are displayed lowest-number-first.
                           :order 11)
                          (:name "Backlog"
                           :todo "BACKLOG"
                           :order 12)
                          (:name "Read"
                           :todo "READ"
                           :order 13)
                          (:name "Watch"
                           :todo "WATCH"
                           :order 14)
                          (:name "Buy"
                           :todo "BUY"
                           :order 15)
                          (:name "Next Tasks"
                           :todo "TODO"
                           :order 16)
                          (:name "SOMEDAY"
                           :todo "SOMEDAY"
                           :order 17)
                          ;; Discard all remaining items, hide other-items
                          (:discard (:anything t))))))))))
(add-hook 'org-agenda-mode-hook 'org-super-agenda-mode)

;; ;;; origami — fold/unfold sections in the agenda buffer only
;; ;;;
;; ;;; TAB toggles the fold state of the section header under point.
;; ;;; Origami is hooked only to org-agenda-mode so it does not interfere
;; ;;; with the native folding in regular org-mode buffers.
;; ;;; ---------------------------------------------------------------------------

;; ;; (use-package origami
;; ;;   :hook (org-agenda-mode . origami-mode)
;; ;;   :bind (:map org-agenda-mode-map
;; ;;          ("TAB" . origami-toggle-node)))
