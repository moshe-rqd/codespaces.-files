;;; I press this wayyy too many times by accident, and it's annoying every time
(keymap-global-unset "C-h C-f")

(use-package emacs
	:custom (
		sentence-end-double-space t

		show-trailing-whitespace t

		;;; soft-wrap lines, don't just fucking truncate them
		truncate-lines nil
		;;; visually wrap at end of screen, no matter the character
		word-wrap nil

		; scroll-preserve-screen-position t

		;;; another horrendous default that messes up hard links, btimes, etc.
		backup-by-copying t

		;;; this setting that only made sense 40 years ago when storage was so limited that tabs were used simply as a data-compression mechanism is for some reason enabled by default still, when it's actively harmful and should probably have been disabled, if not outright deprecated, decades ago...
		backward-delete-char-untabify-method nil )

	:config
		(tool-bar-mode -1)

		(xterm-mouse-mode 1)

		(column-number-mode)

		(setq enable-recursive-minibuffers t)
		(minibuffer-depth-indicate-mode 1)

		(temp-buffer-resize-mode)
	
	;TODO: refactor out into terminal mode-map
	:bind
		("M-SPC C-a" . #'beginning-of-visual-line)
		("M-SPC C-e" . #'end-of-visual-line) )

(use-package comint
	:custom
		(comint-input-ring-size most-positive-fixnum)
		(comint-input-ignoredups nil) )


;;;; emacs feels so bad without this, wow
(use-package vertico :config (vertico-mode))

(use-package marginalia :config (marginalia-mode))


(use-package corfu :config (global-corfu-mode))


(use-package crux)


(use-package helpful
	:bind
		;;;l Note that the built-in `describe-function' includes both functions and macros. `helpful-function' is functions only, so we provide `helpful-callable' as a drop-in replacement.
		("C-h f" . #'helpful-callable)
		;;; Look up *F*unctions (excludes macros).  By default, `C-h F' is bound to `Info-goto-emacs-command-node'. Helpful already links to the manual, if a function is referenced there.
		("C-h F" . #'helpful-function)
		("C-h v" . #'helpful-variable)
		("C-h k" . #'helpful-key)
		("C-h x" . #'helpful-command)
		;;; Lookup the current symbol at point. C-c C-d is a common keybinding for this in lisp modes.
		("C-c C-d" . #'helpful-at-point) )

(use-package which-key
	:config
		(which-key-setup-minibuffer)
		(which-key-mode) )


;;; recently-visited files
(use-package recentf
	:custom
		(recentf-auto-cleanup 'never)
		(setq recentf-max-saved-items nil)
	;;; not only is this prime real estate, but the default binding is pretty much actively harmful
	:init (keymap-global-unset "C-x f")
	:bind 
		("C-x f r" . #'recentf-open)
		("C-x f R" . #'recentf-open-files)
		("C-x f M-r" . #'recentf-open-more-files)
	:config (recentf-mode 1) )


(use-package kmacro
	:custon (kmacro-ring-max most-positive-fixnum) )


(use-package avy
	;TODO: ergonomic avy-mode-map (hard in TTY though)
	:bind
		;;;; functions as a drop-in replacement for `goto-line'
		("M-g M-g" . #avy-goto-line) )


(use-package magit
	:after info
	:config
		(info-initialize)
		(add-to-list 'Info-directory-list "~/config/emacs/packages/magit/Documentation/") )


(use-package web-mode
	:mode
		(("\\.phtml\\'" . web-mode)
		 ("\\.php\\'" . web-mode)
		 ("\\.tpl\\'" . web-mode)
		 ("\\.[agj]sp\\'" . web-mode)
		 ("\\.as[cp]x\\'" . web-mode)
		 ("\\.erb\\'" . web-mode)
		 ("\\.mustache\\'" . web-mode)
		 ("\\.djhtml\\'" . web-mode) ) )


(use-package rustic
	:custom
		(rustic-lsp-client 'eglot)
		(rustic-compile-backtrace 1)
		(compilation-scroll-output 'first-error)

	:bind-keymap  ("C-c C-c C-c" 'rustic-mode-map)
	:bind-keymap* ("C-c C-c C-m" 'rustic-mode-map)
	:bind
		; ("C-j" . #'insert-and-indent-line)
		("C-c C-c r" . #'eglot-rename)
		("C-c C-c C-a" . #'eglot-code-actions) )


(use-package eglot
	:bind-keymap* ("C-c C-c C-l" 'eglot-mode-map)
	:bind (:map eglot-mode-map -keymap
		;;; meta
			("m r" . eglot-reconnect)
		;;; symbols
			("s r" . eglot-rename)
			("s d" . eglot-find-declaration)
		;;; code-actions
			("a a" . #'eglot-code-actions)
			("a q" . eglot-code-action-quickfix)
			;CONSIDER: e instead?
			("a x" . #'eglot-code-action-extract)
			("a i" . #'eglot-code-action-inline)
			("a r" . #'eglot-code-action-rewrite)
			("a o" . #'eglot-code-action-organize-imports)
			;CONSIDER: binding `eglot-code-actions-at-mouse' to some mouse button or another
		;;; formatting
			("f b" . #'eglot-format-buffer)
			;;; works on the region
			("f r" . #'eglot-format) )

	:hook python-mode-hook )


(keymap-global-set "C-;" #'comment-line)
