;; User pack init file
;;
;; Use this file to initiate the pack configuration.
;; See README for more information.

;; Load bindings config
(live-load-config-file "bindings.el")
(live-load-config-file "eshell-here.el")

(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

(require 'eshell)
(require 'em-smart)
(setq eshell-where-to-jump 'begin)
(setq eshell-review-quick-commands nil)
(setq eshell-smart-space-goes-to-end t)


(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(set-face-attribute 'default nil :height 77)
(server-start)


;; sage-shell-mode
(setq sage-shell:use-prompt-toolkit t)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
;;(global-set-key (kbd "C-S-c C-\\") 'mc/mark-next-like-this)
(global-set-key (kbd "C-x <down>") 'mc/mark-next-like-this)
;(global-set-key (kbd "C-S-c C-S-e") 'mc/mark-next-word-like-this)
;;(global-set-key (kbd "C-S-c C-|") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-x <up>") 'mc/mark-previous-like-this)
;(global-set-key (kbd "C-S-c C-S-w") 'mc/mark-previous-word-like-this)
(global-set-key (kbd "<M-down-mouse-1>") 'mc/add-cursor-on-click)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Format the title-bar to always include the buffer name
(setq frame-title-format "%b")
;; Display time
(display-time)
;; Make the mouse wheel scroll Emacs
(mouse-wheel-mode t)
;; Always end a file with a newline
(setq require-final-newline nil)
;; Stop emacs from arbitrarily adding lines to the end of a file when the
;; cursor is moved past the end of it:
(setq next-line-add-newlines nil)
;; Flash instead of that annoying bell
(setq visible-bell t)

;; Use y or n instead of yes or not
(fset 'yes-or-no-p 'y-or-n-p)

;; (add-to-list 'load-path "/home/brian/.live-packs/brian-pack/lib/move-lines")
;; (load "move-lines")
;; (move-lines-binding)
(drag-stuff-global-mode 1)
(drag-stuff-define-keys)


(add-hook 'python-mode-hook 'column-enforce-mode)
(setq column-enforce-column 100)

;; dockerfile
(push '("\\Dockerfile\\'" . shell-script-mode) auto-mode-alist)

(setq org-todo-keywords
      '((sequence "TODO" "FEEDBACK" "VERIFY" "WIP" "|" "DONE" "DELEGATED")))

;; Angular HTML mode
(push '("\\.tpl.html\\'" . angular-html-mode) auto-mode-alist)

(require 'google-translate)
(require 'google-translate-default-ui)
(global-set-key "\C-ct" 'google-translate-at-point)
(global-set-key "\C-cT" 'google-translate-query-translate)

;; cargo.toml
(add-to-list 'auto-mode-alist '("Cargo.toml\\'" . rust-mode))

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)

(add-hook 'racer-mode-hook #'company-mode)

(require 'rust-mode)
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)

(defun wherewasi ()
  (interactive)
  (find-file "/home/brian/.wherewasi"))

(wherewasi)

;; Kill other buffers
(defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer
          (delq (current-buffer)
                (remove-if-not 'buffer-file-name (buffer-list)))))

(global-set-key (kbd "C-c k o b") 'kill-other-buffers)

;; CUDA
(add-to-list 'auto-mode-alist '("\\.cuh\\'" . cuda-mode))

;;; multi-occur-in-matching-buffers
(defun multi-occur-in-all-open-buffers (regexp &optional allbufs)
  "Show all lines matching REGEXP in all buffers."
  (interactive (occur-read-primary-args))
  (multi-occur-in-matching-buffers ".*" regexp))
(global-set-key (kbd "M-s /") 'multi-occur-in-all-open-buffers)

(eval-after-load "sql"
  '(load-library "sql-indent"))


;; LISP
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq slime-contribs '(slime-fancy))

(autoload 'maxima-mode "maxima" "Maxima mode" t)
(autoload 'imaxima "imaxima" "Frontend for maxima with Image support" t)
(autoload 'maxima "maxima" "Maxima interaction" t)
(autoload 'imath-mode "imath" "Imath mode for math formula input" t)
(setq imaxima-use-maxima-mode-flag t)
(add-to-list 'auto-mode-alist '("\\.ma[cx]" . maxima-mode))


;; convenience function that lets me use C-c o s to reopen a file as
;; root after emacs tells me `Note: file is write protected`. Now I
;; don't have to open the damn path again.

(eval-after-load "tramp"
  '(progn
     (defvar sudo-tramp-prefix
       "/sudo:"
       (concat "Prefix to be used by sudo commands when building tramp path "))
     (defun sudo-file-name (filename)
       (set 'splitname (split-string filename ":"))
       (if (> (length splitname) 1)
           (progn (set 'final-split (cdr splitname))
                  (set 'sudo-tramp-prefix "/sudo:")
                  )
         (progn (set 'final-split splitname)
                (set 'sudo-tramp-prefix (concat sudo-tramp-prefix "root@localhost:")))
         )
       (set 'final-fn (concat sudo-tramp-prefix (mapconcat (lambda (e) e) final-split ":")))
       (message "splitname is %s" splitname)
       (message "sudo-tramp-prefix is %s" sudo-tramp-prefix)
       (message "final-split is %s" final-split)
       (message "final-fn is %s" final-fn)
       (message "%s" final-fn)
       )

     (defun sudo-find-file (filename &optional wildcards)
       "Calls find-file with filename with sudo-tramp-prefix prepended"
       (interactive "fFind file with sudo ")
       (let ((sudo-name (sudo-file-name filename)))
         (apply 'find-file
                (cons sudo-name (if (boundp 'wildcards) '(wildcards))))))

     (defun sudo-reopen-file ()
       "Reopen file as root by prefixing its name with sudo-tramp-prefix and by clearing buffer-read-only"
       (interactive)
       (let*
           ((file-name (expand-file-name buffer-file-name))
            (sudo-name (sudo-file-name file-name)))
         (progn
           (setq buffer-file-name sudo-name)
           (rename-buffer sudo-name)
           (setq buffer-read-only nil)
           (message (concat "File name set to " sudo-name)))))

     (global-set-key (kbd "C-c o s") 'sudo-reopen-file)))

(add-to-list 'auto-mode-alist '("\\Dockerfile" . dockerfile-mode))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)))
;; Show syntax highlighting per language native mode in *.org
(setq org-src-fontify-natively t)
;; For languages with significant whitespace like Python:
(setq org-src-preserve-indentation t)
(setq org-confirm-babel-evaluate nil
      org-src-tab-acts-natively nil)

;; parinfer configs
(use-package parinfer
  :ensure t
  :bind
  (("C-," . parinfer-toggle-mode))
  :init
  (progn
    (setq parinfer-extensions
          '(defaults       ; should be included.
            pretty-parens  ; different paren styles for different modes.
            evil           ; If you use Evil.
            lispy          ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
            paredit        ; Introduce some paredit commands.
            smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
            smart-yank))   ; Yank behavior depend on mode.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))


(global-set-key (kbd "C-x |") 'transpose-frame)

(push '("\\.pb.go\\'" . protobuf-mode) auto-mode-alist)

;; lean-mode
;; (setq lean-rootdir "~/src/leanprover/lean")
;; (setq lean-emacs-path "~/projects/lean/src/emacs")

;; (setq lean-mode-required-packages '(company dash dash-functional f
;;                                             flycheck let-alist s seq))
;; (let ((need-to-refresh t)git clone https://github.com/ProofGeneral/PG ~/.emacs.d/lisp/PG)
;;   (dolist (p lean-mode-required-packages)
;;     (when (not (package-installed-p p))
;;       (when need-to-refresh
;;         (package-refresh-contents)
;;         (setq need-to-refresh nil))
;;       (package-install p))))

;; (setq load-path (cons lean-emacs-path load-path))

;; (require 'lean-mode)

;; pact-mode
(add-to-list 'load-path "/home/brian/.live-packs/brian-pack/lib/pact-mode/")
(require 'pact-mode)
;; (require 'pact-flycheck)

(push '("\\.wppl\\'" . js2-mode) auto-mode-alist)

;; proof-general
(load "/home/brian/.live-packs/brian-pack/lib/proofgeneral/generic/proof-site")

;; .ovpn are conf-mode files
(push '("\\.ovpn\\'" . conf-mode) auto-mode-alist)
