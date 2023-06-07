;;;;;;;;;;;;;;
;; PACKAGES ;;
;;;;;;;;;;;;;;
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; activate all the packages (in particular autoloads)
(package-initialize)
;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; install:
;; helm highlight-symbol highlight-numbers clean-aindent-mode hl-todo
;; glsl-mode smart-tabs-mode shell-pop


;;;;;;;;;;;;;;;;;;;;;
;; GLOBAL SETTINGS ;;
;;;;;;;;;;;;;;;;;;;;;
(blink-cursor-mode 0)
(global-undo-tree-mode 1)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(show-paren-mode t)
(setq inhibit-startup-screen 1)
;; yes-or-no
(defalias 'yes-or-no-p 'y-or-n-p)
;; update any change made on file to the current buffer
(global-auto-revert-mode)
;; when this mode is active, marked text will be replaced with newly written
(delete-selection-mode)
;; better scrolling through files.
;; Cursor at the top line and pressing key up won't move the file many, many
;; lines upwards as is the default.
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position nil)
;; toggle line highlighting in all buffers
(global-hl-line-mode)
(setq gc-cons-threshold (* 100 1024 1024))


;;;;;;;;;;;;;;;;;;;;;;;;;
;; NAVIGATION SETTINGS ;;
;;;;;;;;;;;;;;;;;;;;;;;;;
;; winner-mode, easy switch between views
(global-set-key (kbd "C-c <left>") 'winner-undo)
(global-set-key (kbd "C-c <right>") 'winner-redo)
(winner-mode t)
;; window navigation
(windmove-default-keybindings)
;; buffer navigation
(defun bufmove-default-keybindings (&optional modifier)
  "Set up keybindings for switching between buffers in current window."
  (interactive)
  (unless modifier (setq modifier 'control))
  (global-set-key (vector (list modifier 'left)) 'previous-buffer)
  (global-set-key (vector (list modifier 'right)) 'next-buffer)
  (global-set-key (kbd "C-<left>") 'previous-buffer)
  (global-set-key (kbd "C-<right>") 'next-buffer)
  )
(bufmove-default-keybindings)
;; Replace `list-buffers' with `ibuffer', which is a superior alternative
(global-set-key (kbd "C-x C-b") 'ibuffer)


;;;;;;;;;;;;;;;
;; HELM-MODE ;;
;;;;;;;;;;;;;;;
(require 'helm)
;; (require 'helm-config) ;; this was removed from helm package in later versions
;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change 'helm-command-prefix-key' once 'helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
;; rebind tab to run persistent action
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
;; make TAB work in terminal
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
;; list actions using C-z
(define-key helm-map (kbd "C-z") 'helm-select-action)
(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))
;;
(setq
 ;; open helm buffer inside current window, not occupy whole other window
 helm-split-window-in-side-p           t

 ;; move to end or beginning of source when reaching top or bottom
 helm-move-to-line-cycle-in-source     t

 ;; search for library in 'require' and 'declare-function' sexp.
 helm-ff-search-library-in-sexp        t

 ;; scroll 8 lines other window using M-<next>/M-<prior>
 helm-scroll-amount                    8
 helm-ff-file-name-history-use-recentf t
 )
;; by enabling auto-resize, Helm will resize its buffer automatically
;; to fit the number of search candidates.
(helm-autoresize-mode t)
;; Command: helm-M-x
(global-set-key (kbd "M-x") 'helm-M-x)
;; if this is activated, helm-M-x will fuzzy match candidates
(setq helm-M-x-fuzzy-match t) ; optional fuzzy match for helm-M-x
;; enable the helm kill-ring with binding it to M-y
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
;; helm-mini:
(global-set-key (kbd "C-x b") 'helm-mini)
;; Helm-semantic support.
;; The command 'helm-semantic-or-imenu' can be useful for finding
;; definitions inside a source file.
;; 'helm-imenu' is bound to (C-c h i).
(semantic-mode 1)
(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)
(global-set-key (kbd "C-c h s") 'helm-semantic-or-imenu)
;; to enable fuzzy matching with helm-mini, add the following settings:
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t
      helm-locate-fuzzy-match     t)
;; helm-find-files - file navigation on steroids!
(global-set-key (kbd "C-x C-f") 'helm-find-files)
;; if the point is located on a folder path, C-x C-f will
;; start in that folder. (Use C-l C-r to navigate directories)
;; use arrow keys to navigate helm-find-files menu
(setq helm-ff-lynx-style-map t)
;; Better keymap for helm-occur.
;; This is extremely useful and, opposed to semantic, searches for
;; everything in file indiscriminate of language syntax.
;; Matches are updated on the fly.
(global-set-key (kbd "C-c h o") 'helm-occur)
(helm-mode 1)


;;;;;;;;;;;;;;;;;;;;;;;;
;; BASIC TEXT EDITING ;;
;;;;;;;;;;;;;;;;;;;;;;;;
;; rebind C-a to move to the beginning of text instead of beginning of line
(defun prelude-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.
Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.
If ARG is not nil or 1, move forward ARG - 1 lines first. If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))
;;
(global-set-key (kbd "C-a") 'prelude-move-beginning-of-line)
;;
;; hover with mouse over a symbol or definition and press
;; C-S-mouse-1 and see the definition highlighted all through
;; the file. Really useful.
(require 'highlight-symbol)
;;
(highlight-symbol-nav-mode)
;;
(add-hook 'prog-mode-hook (lambda () (highlight-symbol-mode)))
(add-hook 'org-mode-hook (lambda () (highlight-symbol-mode)))
;;
(setq highlight-symbol-idle-delay 0.2
      highlight-symbol-on-navigation-p t)
;;
(global-set-key [(control shift mouse-1)]
                (lambda (event)
                  (interactive "e")
                  (defvar last-point)
                  (setq last-point (point))
                  (goto-char (posn-point (event-start event)))
                  (highlight-symbol-at-point)
                  (goto-char last-point)))
;;
(global-set-key (kbd "M-n") 'highlight-symbol-next)
(global-set-key (kbd "M-p") 'highlight-symbol-prev)

(global-set-key (kbd "C-c w") 'whitespace-mode)

;;(set-frame-font "Monaco 14")
(set-face-attribute 'default nil :height 105) ;; was 105
;; (set-face-attribute 'default nil :height 170)
;; (set-face-attribute 'default nil :height 150)

(defvar face-attribute-height 125
  "Default font face height when Emacs starts.")

(defun face-attribute-height-increase ()
  (interactive)
  (setq face-attribute-height (+ face-attribute-height 5))
  (set-face-attribute 'default nil :height face-attribute-height)
  )
(defun face-attribute-height-decrease ()
  (interactive)
  (setq face-attribute-height (- face-attribute-height 5))
  (set-face-attribute 'default nil :height face-attribute-height)
  )

(define-key global-map (kbd "C-+") 'face-attribute-height-increase)
(define-key global-map (kbd "C--") 'face-attribute-height-decrease)


;;;;;;;;;;;;;;;;;;;
;; UTF-8 EDITING ;;
;;;;;;;;;;;;;;;;;;;
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GENERAL PROGRAMMING SETTINGS ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'prog-mode-hook 'highlight-numbers-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'hl-todo-mode)
(add-hook 'prog-mode-hook
	  (lambda ()
	    (setq show-trailing-whitespace 1)
	    (text-scale-decrease 1)
	    (define-key global-map (kbd "RET") 'newline-and-indent)))


;;;;;;;;;;;;;;;;;;;;;;
;; LISP PROGRAMMING ;;
;;;;;;;;;;;;;;;;;;;;;;
(defun edit-init-file ()
  (interactive)
  ;; TODO: (when not-nil 'user-init-file)
  (find-file user-init-file)
  )
(global-set-key (kbd "<f12>") 'edit-init-file)


;;;;;;;;;;;;;;;;;;;;;;;
;; CMAKE PROGRAMMING ;;
;;;;;;;;;;;;;;;;;;;;;;;
(defun my-cmake-mode-hook ()
  (setq cmake-tab-width 4)
  (setq indent-tabs-mode nil)
  )
(add-hook 'cmake-mode-hook 'my-cmake-mode-hook)


;;;;;;;;;;;;;;;;;;;;;;;
;; LATEX PROGRAMMING ;;
;;;;;;;;;;;;;;;;;;;;;;;
(defun my-latex-compile-fun ()
  (interactive)
  (defvar filename)
  (setq filename (file-name-nondirectory buffer-file-name))
  ;; TODO: Check if `latexrun' is available on the system, and default to that!
  (setq compile-command (concat "latexrun " filename))
  ;(setq compile-command (concat "pdflatex " filename))
  ;; When this variable is non-nil, it will cause the Compilation mode
  ;; commands to put point at the end of their output window, so that the
  ;; end of output is always visible rather than the beginning.
  (setq compilation-scroll-output t)
  (call-interactively 'compile)
  )
(defun my-latex-mode-hook ()
  (text-scale-decrease 1)
  (hl-todo-mode t)
  (clean-aindent-mode 0)
  (setq electric-indent-inhibit 1)
  (setq tex-indent-basic 0)
  (setq tex-indent-item 0)
  (setq show-trailing-whitespace 1)
  (local-set-key (kbd "<f5>") 'my-latex-compile-fun)
  )
(add-hook 'latex-mode-hook 'my-latex-mode-hook)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COMMON C AND C++ PROGRAMMING ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-c-mode-common-hook ()
  "For use in both C and C++ major modes."
  (local-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)


;;;;;;;;;;;;;;;;;;;;;
;; C++ PROGRAMMING ;;
;;;;;;;;;;;;;;;;;;;;;
(defun my-cpp-compile-fun ()
  (interactive)
  (defvar filename)
  (setq filename (file-name-nondirectory buffer-file-name))
  (setq comp-flags "-std=c++20 -Wall ")
  (setq output (concat "-o " (file-name-sans-extension filename) " "))
  ;; When this variable is non-nil, it will cause the Compilation mode
  ;; commands to put point at the end of their output window, so that the
  ;; end of output is always visible rather than the beginning.
  (setq compile-command (concat "g++-12 " comp-flags output filename))
  (setq compilation-scroll-output t)
  (call-interactively 'compile)
  )
(defun my-cpp-common-mode-hook ()
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'inline-open 0)
  (c-set-offset 'comment-intro 0)
  (c-set-offset 'defun-block-intro 'tab-width)
  (c-set-offset 'statement-block-intro 'tab-width)
  (c-set-offset 'substatement 'tab-width)
  (c-set-offset 'topmost-intro 0)
  (c-set-offset 'statement-cont 'tab-width)
  (c-set-offset 'func-decl-cont 0)
  (c-set-offset 'brace-list-open 0)
  (c-set-offset 'brace-list-intro 'tab-width)
  (c-set-offset 'brace-list-entry 0)
  ;; EXPERIMENTAL:
  ;;(c-set-offset 'arglist-intro 'c-lineup-arglist-intro-after-paren)
  (c-set-offset 'arglist-intro 'tab-width)
  )

(add-hook 'c++-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode t)
	    (setq tab-width 4)
	    (setq c-basic-offset 4)
	    (highlight-doxygen-mode t)
	    (local-set-key (kbd "<f5>") 'my-cpp-compile-fun)
	    )
	  )
(add-hook 'c++-mode-hook 'my-cpp-common-mode-hook)


;;;;;;;;;;;;;;;;;;;
;; C PROGRAMMING ;;
;;;;;;;;;;;;;;;;;;;
(defvar my-custom-c-style "ninja")

(defun my-c-mode-hook ()
  (when (equal my-custom-c-style "ninja")
    (setq-default c-basic-offset 4
				  tab-width 4
				  indent-tabs-mode t)
    (c-set-offset 'substatement-open 0)
    (c-set-offset 'comment-intro 0)
    (c-set-offset 'defun-block-intro 4)
    (c-set-offset 'statement-block-intro 4)
    (c-set-offset 'substatement 4)
    (c-set-offset 'topmost-intro 0)
    (c-set-offset 'statement-cont 0)
    (c-set-offset 'func-decl-cont 0)
	(c-set-offset 'brace-list-open 0)
	(c-set-offset 'brace-list-intro 4)
    )
  )
(add-hook 'c-mode-hook 'my-c-mode-hook)



;;;;;;;;;;;;;;;;;;;;;;
;; GLSL PROGRAMMING ;;
;;;;;;;;;;;;;;;;;;;;;;
(autoload 'glsl-mode "glsl-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.shd\\'" . glsl-mode))

(defun my-glsl-mode-hook ()
  "Custom OpenGL shader language(glsl) settings."

  (setq indent-tabs-mode t)
  (setq tab-width 4)
  (c-set-offset 'defun-block-intro 4)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'statement-block-intro 4)
  (c-set-offset 'knr-argdecl -100) ;; DIRTY HACK ??!
  (c-set-offset 'arglist-intro 4)
  (c-set-offset 'arglist-close 0)
  )

(add-hook 'glsl-mode-hook 'my-glsl-mode-hook)


;;;;;;;;;;;;;;;;;;;;;
;; SMART-TABS-MODE ;;
;;;;;;;;;;;;;;;;;;;;;
(smart-tabs-mode t)
(smart-tabs-insinuate 'c++)


;;;;;;;;;;;;;;;
;; TEXT-MODE ;;
;;;;;;;;;;;;;;;
(defun  my-text-mode-hook ()
  (hl-todo-mode t)
  )

(add-hook 'text-mode-hook 'my-text-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;
;; KILL ACTIVE BUFFER ;;
;;;;;;;;;;;;;;;;;;;;;;;;
;; rebind C-x k to kill the active buffer instead of asking which one to kill
(defun kill-default-buffer ()
  "Kill the currently active buffer -- set to C-x k so that users are not asked
which buffer they want to kill."
  (interactive)
  (let (kill-buffer-query-functions) (kill-buffer)))
;;
(global-set-key (kbd "C-x k") 'kill-default-buffer)


;;;;;;;;;;;;;;;
;; TERM-MODE ;;
;;;;;;;;;;;;;;;
(defun my-term-setup ()
  (interactive)
  (define-key term-raw-map (kbd "C-y") 'term-send-raw)
  (define-key term-raw-map (kbd "C-p") 'term-send-raw)
  (define-key term-raw-map (kbd "C-n") 'term-send-raw)
  (define-key term-raw-map (kbd "C-s") 'term-send-raw)
  (define-key term-raw-map (kbd "C-r") 'term-send-raw)
  (define-key term-raw-map (kbd "M-w") 'kill-ring-save)
  (define-key term-raw-map (kbd "M-y") 'helm-show-kill-ring)
  (define-key term-raw-map (kbd "M-d") (lambda () (interactive) (term-send-raw-string "\ed")))
  (define-key term-raw-map (kbd "<C-backspace>") (lambda () (interactive) (term-send-raw-string "\e\C-?")))
  (define-key term-raw-map (kbd "M-p") (lambda () (interactive) (term-send-raw-string "\ep")))
  (define-key term-raw-map (kbd "M-n") (lambda () (interactive) (term-send-raw-string "\en")))
  (define-key term-raw-map (kbd "M-,") 'term-send-input)
  (define-key term-raw-map (kbd "C-c y") 'term-paste)
  (define-key term-raw-map (kbd "C-S-y") 'term-paste)
  (define-key term-raw-map (kbd "C-h") nil) ; unbind C-h
  (define-key term-raw-map (kbd "M-x") nil) ; unbind M-x
  (define-key term-raw-map (kbd "C-c C-b") 'helm-mini)
  (define-key term-raw-map (kbd "C-1") 'zygospore-toggle-delete-other-windows)
  (define-key term-raw-map (kbd "C-2") 'split-window-below)
  (define-key term-raw-map (kbd "C-3") 'split-window-right)
  (define-key term-mode-map (kbd "C-0") 'delete-window)
  (define-key term-raw-map (kbd "<C-left>") 'previous-buffer)
  (define-key term-raw-map (kbd "<C-right>") 'next-buffer))
(add-hook 'term-mode-hook 'my-term-setup t)
(setq term-buffer-maximum-size 0)
;;
(require 'term)
;;
;; taken from here: http://www.enigmacurry.com/2008/12/26/emacs-ansi-term-tricks/
(defun visit-ansi-term ()
  "If the current buffer is:
     1) a running ansi-term named *ansi-term*, rename it.
     2) a stopped ansi-term, kill it and create a new one.
     3) a non ansi-term, go to an already running ansi-term
        or start a new one while killing a defunt one"
  (interactive)
  (let ((is-term (string= "term-mode" major-mode))
        (is-running (term-check-proc (buffer-name)))
        (term-cmd "/bin/bash")
        (anon-term (get-buffer "*ansi-term*")))
    (if is-term
        (if is-running
            (if (string= "*ansi-term*" (buffer-name))
                ;; (call-interactively 'rename-buffer)
                (ansi-term term-cmd)
              (if anon-term
                  (switch-to-buffer "*ansi-term*")
                (ansi-term term-cmd)))
          (kill-buffer (buffer-name))
          (ansi-term term-cmd))
      (if anon-term
          (if (term-check-proc "*ansi-term*")
              (switch-to-buffer "*ansi-term*")
            (kill-buffer "*ansi-term*")
            (ansi-term term-cmd))
        (ansi-term term-cmd)))))

(add-hook 'term-mode-hook
	  (function
	   (lambda ()
	     (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
	     (setq-local mouse-yank-at-point t)
	     (setq-local transient-mark-mode nil)
	     (auto-fill-mode -1)
	     (setq tab-width 8 ))))
(add-hook 'term-mode
	  (lambda nil (color-theme-buffer-local 'color-theme-black-on-gray (current-buffer))))

(global-set-key (kbd "<f1>") 'visit-ansi-term)


;;;;;;;;;;;;;;;
;; SHELL POP ;;
;;;;;;;;;;;;;;;
(require 'shell-pop)
(global-set-key (kbd "<f2>") 'shell-pop)
(setq shell-pop-window-size 25)


;;;;;;;;;;;;;;;;;;
;; BACKUP FILES ;;
;;;;;;;;;;;;;;;;;;
(defvar backup-directory "~/.backups")
(if (not (file-exists-p backup-directory))
    (make-directory backup-directory t))
;;
(setq
 make-backup-files t    ; backup a file the first time it is saved
 backup-directory-alist `((".*" . ,backup-directory)) ; save files in chosen backup folder
 backup-by-copying t    ; copy the current file into backup directory
 version-control t      ; version numbers for backup files
 delete-old-versions t  ; delete unnecessary versions
 kept-old-versions 6    ; oldest versions to keep when a new numbered backup is made (default: 2)
 kept-new-versions 9    ; newest versions to keep when a new numbered backup is made (default: 2)
 auto-save-default t    ; auto-save every buffer that visits a file
 auto-save-timeout 40   ; number of seconds idle time before auto-save (default: 30)
 auto-save-interval 400 ; number of keystrokes between auto-saves (default: 300)
 )

;;;;;;;;;;;;;;
;; GDB-MODE ;;
;;;;;;;;;;;;;;
(setq-default gdb-many-windows t)


;;;;;;;;;;;;;;;;;;;;
;; CUSTOMIZATIONS ;;
;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(column-number-mode t)
 '(custom-enabled-themes '(wombat))
 '(custom-safe-themes
   '("8136cbb3b29b4c86ca3354d85005f527adcf9393b227980fc144a2c24ba63688" default))
 '(flymake-error-bitmap '(flymake-double-exclamation-mark modus-theme-fringe-red))
 '(flymake-note-bitmap '(exclamation-mark modus-theme-fringe-cyan))
 '(flymake-warning-bitmap '(exclamation-mark modus-theme-fringe-yellow))
 '(helm-completion-style 'emacs)
 '(hl-todo-keyword-faces
   '(("HOLD" . "#e5f040")
     ("TODO" . "#feacd0")
     ("NEXT" . "#b6a0ff")
     ("THEM" . "#f78fe7")
     ("PROG" . "#00d3d0")
     ("OKAY" . "#4ae8fc")
     ("DONT" . "#58dd13")
     ("FAIL" . "#ff8059")
     ("DONE" . "#44bc44")
     ("NOTE" . "#f0ce43")
     ("KLUDGE" . "#eecc00")
     ("HACK" . "#eecc00")
     ("TEMP" . "#ffcccc")
     ("FIXME" . "#ff9977")
     ("XXX+" . "#f4923b")
     ("REVIEW" . "#6ae4b9")
     ("DEPRECATED" . "#aaeeee")))
 '(ibuffer-deletion-face 'dired-flagged)
 '(ibuffer-filter-group-name-face 'dired-mark)
 '(ibuffer-marked-face 'dired-marked)
 '(ibuffer-saved-filter-groups
   '(("vtek_headers"
      ("headers"
       (filename . ".hpp"))
      ("elisp"
       (used-mode . emacs-lisp-mode))
      ("cpp"
       (used-mode . c++-mode)))))
 '(ibuffer-saved-filters
   '(("programming"
      (or
       (derived-mode . prog-mode)
       (mode . ess-mode)
       (mode . compilation-mode)))
     ("text document"
      (and
       (derived-mode . text-mode)
       (not
	(starred-name))))
     ("TeX"
      (or
       (derived-mode . tex-mode)
       (mode . latex-mode)
       (mode . context-mode)
       (mode . ams-tex-mode)
       (mode . bibtex-mode)))
     ("web"
      (or
       (derived-mode . sgml-mode)
       (derived-mode . css-mode)
       (mode . javascript-mode)
       (mode . js2-mode)
       (mode . scss-mode)
       (derived-mode . haml-mode)
       (mode . sass-mode)))
     ("gnus"
      (or
       (mode . message-mode)
       (mode . mail-mode)
       (mode . gnus-group-mode)
       (mode . gnus-summary-mode)
       (mode . gnus-article-mode)))))
 '(ibuffer-title-face 'dired-header)
 '(package-selected-packages
   '(wfnames highlight-doxygen fsharp-mode glsl-mode helm hl-todo highlight-symbol lua-mode clean-aindent-mode highlight-numbers shell-pop smart-tabs-mode undo-tree modus-vivendi-theme))
 '(send-mail-function 'mailclient-send-it)
 '(shell-pop-shell-type
   '("ansi-term" "*ansi-term*"
     (lambda nil
       (ansi-term shell-pop-term-shell))))
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   '((20 . "#ff8059")
     (40 . "#feacd0")
     (60 . "#f78fe7")
     (80 . "#f4923b")
     (100 . "#eecc00")
     (120 . "#e5f040")
     (140 . "#f8dec0")
     (160 . "#bfebe0")
     (180 . "#44bc44")
     (200 . "#58dd13")
     (220 . "#6ae4b9")
     (240 . "#4ae8fc")
     (260 . "#00d3d0")
     (280 . "#c6eaff")
     (300 . "#33beff")
     (320 . "#72a4ff")
     (340 . "#00baf4")
     (360 . "#b6a0ff")))
 '(vc-annotate-very-old-color nil)
 '(xterm-color-names
   ["#000000" "#ff8059" "#44bc44" "#eecc00" "#33beff" "#feacd0" "#00d3d0" "#a8a8a8"])
 '(xterm-color-names-bright
   ["#181a20" "#f4923b" "#58dd13" "#e5f040" "#72a4ff" "#f78fe7" "#4ae8fc" "#ffffff"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(highlight-doxygen-code-block ((t nil)))
 '(highlight-doxygen-comment ((t (:inherit font-lock-doc-face))))
 '(hl-line ((t (:background "gray17")))))
