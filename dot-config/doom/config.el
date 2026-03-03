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
(setq doom-theme 'doom-nord-light)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;;; -----------------------------------------------------------------------
;;  DEFAULT DIRECTORY
;;; -----------------------------------------------------------------------

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/orgfiles/")

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
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; Increase fonts on emacs for better view
(add-hook 'doom-init-ui-hook #'doom-big-font-mode)

(setq doom-font (font-spec :family "JetBrainsMonoNL Nerd Font Propo" :size 19))
;; (setq doom-font "Terminus (TTF):pixelsize=12:antialias=off")
;; (setq doom-font "Fira Code-14")

;; enable soft-wrapping
(setq +word-wrap-extra-indent 'single)
(setq +word-wrap-fill-style 'soft)
(+global-word-wrap-mode +1)

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

  ;; remind about day‑wide items at 9 a.m. and 2 p.m.
  (setq org-wild-notifier-day-wide-alert-times '("09:00" "14:00"))

  (org-wild-notifier-mode 1))

;; ;; CUSTOM TODO-KANBAN MANAGEMENT
;; (after! org
;; ;; This not fix either, make it remove enter usage on recur tasks
;; ;; Fix: In Doom, `RET` in `evil-org-mode-map` motion state runs `+org/dwim-at-point`,
;; ;; which *toggles todo headings* (and therefore advances repeating tasks).
;; ;; Rebind RET to `org-return` so pressing Enter on a heading doesn't mark it DONE.
;; ;; (This is independent from the kanban hook code.)
;; (map! :after org
;;       :map evil-org-mode-map
;;       :m "RET" #'org-return)
;;   ;; Workflow states
;;   (setq org-todo-keywords
;;         '((sequence "BACKLOG" "TODO" "DOING" "TEST" "DONE" "CANCELLED")))

;;   (setq org-todo-keyword-faces
;;         '(("BACKLOG" . "purple")
;;           ("TODO" . "tomato")
;;           ("DOING" . "orange")
;;           ("TEST" . "cyan")
;;           ("DONE" . "forest green")
;;           ("CANCELLED" . "gray")))

;;   ;; Move subtree preserving original headline stars (so *** stays ***)
;;   (defun my/org--move-entry-to-top-heading (heading)
;;     "Cut current Org subtree and insert it under a top-level *HEADING.
;; The subtree is inserted verbatim so its original number of leading stars is preserved."
;;     (when (org-at-heading-p)
;;       (let* ((first-line (save-excursion (org-back-to-heading t) (buffer-substring-no-properties (point) (line-end-position))))
;;              ;; copy subtree text (we capture it before cutting so we can insert it verbatim)
;;              (subtree-text (progn (org-back-to-heading t) (org-copy-subtree) (current-kill 0)))
;;              (orig-pos (point-marker)))
;;         ;; remove the original subtree
;;         (org-cut-subtree)
;;         ;; find or create the top-level heading
;;         (save-excursion
;;           (goto-char (point-min))
;;           (if (re-search-forward (concat "^\\* " (regexp-quote heading) "$") nil t)
;;               (beginning-of-line)
;;             ;; create the top-level heading at end of buffer
;;             (goto-char (point-max))
;;             (unless (bolp) (insert "\n"))
;;             (insert (concat "* " heading "\n")))
;;           ;; go to end of that heading's subtree
;;           (org-end-of-subtree t t)
;;           (unless (bolp) (insert "\n"))
;;           ;; insert the subtree text verbatim (preserves stars)
;;           (let ((insert-pos (point)))
;;             (insert subtree-text)
;;             ;; ensure there is a final newline
;;             (unless (bolp) (insert "\n"))
;;             ;; move point to start of inserted subtree for convenience
;;             (goto-char insert-pos)
;;             (when (search-forward (string-trim first-line) nil t)
;;               (goto-char (match-beginning 0))))))))


;; (defun my/org--is-recurring-task-p ()
;;   "Return t if the current Org headline has a recurring SCHEDULED or DEADLINE.

;; Detects Org repeaters inside planning timestamps, e.g.:
;;   SCHEDULED: <2026-03-02 Mon 18:00 +1d>
;;   DEADLINE:  <2026-03-02 Mon 18:00 ++1w>
;;   SCHEDULED: <2026-03-02 Mon 18:00 .+2d>

;; This scans the whole metadata/planning area because repeaters are part of the
;; timestamp syntax and may not be exposed via `org-entry-get`."
;;   (save-excursion
;;     (org-back-to-heading t)
;;     (let* ((end (save-excursion (org-end-of-meta-data t) (point)))
;;            (meta (buffer-substring-no-properties (point) end)))
;;       (string-match-p
;;        (rx (or "SCHEDULED:" "DEADLINE:")
;;            (* space)
;;            (or "<" "[")
;;            (+ (not (any ">]")))
;;            (or ">" "]")
;;            (* space)
;;            (or "++" ".+" "+")
;;            (+ digit)
;;            (any "hdwmy"))
;;        meta))))


;;   ;; Hook to move on state change
;;   (defun my/org-move-on-todo-state-change ()
;;     "Move the current Org entry to the appropriate emoji-prefixed kanban column after state change.

;; Important: Skip moving when Org is *repeating* a task (recurring SCHEDULED/DEADLINE).
;; When a repeating task is completed, Org updates/reschedules it in-place. If we
;; cut/paste the subtree at that moment, Org can no longer update the original
;; heading correctly, leading to wrong columns like BACKLOG."
;;     (when (and (derived-mode-p 'org-mode)
;;                (org-at-heading-p)
;;                ;; If this is a recurring task, let Org handle the repeat/reschedule
;;                ;; without us moving the subtree.
;;                (not (my/org--is-recurring-task-p))
;;                ;; Also skip if Org is currently repeating the task as part of this
;;                ;; state change (extra safety).
;;                (not (bound-and-true-p org-log-repeat)))
;;       (let ((state (org-get-todo-state)))
;;         (cond
;;          ((string= state "BACKLOG")
;;           (my/org--move-entry-to-top-heading "📥 BACKLOG"))
;;          ((string= state "TODO")
;;           (my/org--move-entry-to-top-heading "🔲 TODO"))
;;          ((string= state "DOING")
;;           (my/org--move-entry-to-top-heading "🔁 DOING"))
;;          ((string= state "TEST")
;;           (my/org--move-entry-to-top-heading "📝 TEST"))
;;          ((string= state "DONE")
;;           (my/org--move-entry-to-top-heading "✅ DONE"))))))

;;   (add-hook 'org-after-todo-state-change-hook #'my/org-move-on-todo-state-change))
