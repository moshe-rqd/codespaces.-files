(setq package-archives nil ;;; redundant with the below, I think, but better safe than sorry
	package-enable-at-startup nil )

(let
	((default-directory (concat user-emacs-directory "packages/")))
	(normal-top-level-add-subdirs-to-load-path))

(eval-when-compile
	(require 'use-package)
	(setq use-package-compute-statistics t))
;; (add-to-list 'load-path (concat user-emacs-directory "packages/no-littering/"))
(setq
	no-littering-etc-directory (expand-file-name "config/" user-emacs-directory)
	no-littering-var-directory (expand-file-name "data/" user-emacs-directory)
	no-littering-theme-backups t)
(require 'no-littering)

(when (fboundp 'startup-redirect-eln-cache)
      (startup-redirect-eln-cache (convert-standard-filename (concat no-littering-var-directory "/eln-cache/"))))

(setq session-directory (concat user-emacs-directory "sessions/" (format-time-string "%Y-%m-%d--%H-%M-%S.%N") "/"))
(make-directory session-directory)
(open-dribble-file (concat session-directory "dribblefile"))

(setq-default message-log-max t)


(setq
	custom-theme-directory (concat user-emacs-directory "themes/")

	custom-file (locate-user-emacs-file "custom.el")

	trash-directory (expand-file-name "~/trash/") )


(setq
	;;; no maximum history count!
	history-length t
	;;; don't delete duplicate history entries (the default)
	(setq history-delete-duplicates nil) )
(savehist-mode 1)

(save-place-mode 1)

(auto-save-mode 1)

;NOTE: Emacs errors if I use a higher value
(lossage-size 33554431)



(setq
	;!TODO: override make-backup-file-name-function to not like, truncate filenames (or worse, get confused between multiple!) if their full path is  over 255 bytes or whatever. A robust solution would be to instead store a numbered hash of the full path, persisting a file containing all historic mappings and perhaps if short enough also appending the !-escaped path (or simply the tail name) of the file to the BLAKE3-named or whatever backup file(s) for convenience. This might still be very annoying for external access, in practice at least. An example of the 69th backup of the file ~foo/emacs/cfg/init.el under this scheme would be "!home!foo!emacs!cfg!init.el 69 <hash of the string "/home/foo/emacs/cfg/init.el">", with the hashmap file containing a (null-delimited) line "<b3sum <<<'/home/foo/emacs/cfg/init.el'> !home!foo!emacs!cfg!init.el\0\n"
	;;; Make backups of files even when they're in version control
	vc-make-backup-files t
	;;; always make numbered backups (when saving file foo multiple times, backup as a new file foo.~1~, then a new file foo.~2~, and so on, as opposed to a singular overwritten ebackup named foo.~)
	version-control t
	;;; backup files under ~/config/emacs/data/file_backups/ (!-transformed, like nano). I think this overrides what no-littering should have done...
	backup-directory-alist `(("." . ,(no-littering-expand-var-file-name "file_backups/")))
	kept-old-versions most-positive-fixnum
	kept-new-versions most-positive-fixnum
	delete-old-versions 'NO
	file-preserve-symlinks-on-save t
)


(use-package undo-tree
	:init (let
		((undo-dir (expand-file-name "undo" user-emacs-directory)))
		(setq undo-tree-history-directory-alist (list (cons "." undo-dir))) )
	:config (global-undo-tree-mode)
	:custom
		(undo-tree-visualizer-timestamps t)
		(undo-tree-visualizer-diff t) )
