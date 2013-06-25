;; colors
(set-background-color "gray90")
(set-foreground-color "black")

(global-hl-line-mode t)
(set-face-background 'hl-line "gray83")

(defun fontify-frame (frame)
  (set-frame-parameter frame 'font "Monospace-10"))
;; Fontify current frame
(fontify-frame nil)
;; Fontify any future frames
(push 'fontify-frame after-make-frame-functions)

;; tool bar
(tool-bar-mode -1)

;; menu bar
(menu-bar-mode -1)

(desktop-save-mode 1)

;; yes = y
(fset 'yes-or-no-p 'y-or-n-p)

;;activate show paren
(show-paren-mode t)
(setq show-paren-style 'expression)

;; lines and rows number show
(require 'linum)
(linum-mode 1)
(global-linum-mode)
(column-number-mode 1)

;; region deleted by del
(delete-selection-mode 1)

(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;; tab
(setq default-tab-width 4)
(setq x-select-enable-clipboard t)

;;(setq yas/indent-line nil)

(modify-coding-system-alist 'file "\\.ch\\'" 'cp1251-unix)
(modify-coding-system-alist 'file "\\.prg\\'" 'cp1251-unix)
(modify-coding-system-alist 'file "\\.mac\\'" 'cp1251-unix)
(modify-coding-system-alist 'file "\\.scn\\'" 'cp1251-unix)
(modify-coding-system-alist 'file "\\.f2r\\'" 'cp1251-unix)
(modify-coding-system-alist 'file "\\.fil\\'" 'cp1251-unix)
(modify-coding-system-alist 'file "\\.ref\\'" 'cp1251-unix)
(modify-coding-system-alist 'file "\\.tlb\\'" 'cp1251-unix)
(modify-coding-system-alist 'file "\\.itm\\'" 'cp1251-unix)
(modify-coding-system-alist 'file "\\.ini\\'" 'cp1251-unix)
(modify-coding-system-alist 'file "\\.wgs\\'" 'cp1251-unix)
(modify-coding-system-alist 'file "\\.kazn\\'" 'cp1251-unix)


(add-to-list 'load-path (expand-file-name "~/.emacs.d/emacs-jabber-0.8.92/"))
(require 'jabber)
(require 'jabber-autoloads)


;;(load "~/.emacs.d/autosmiley.el")
;;(require 'autosmiley)
;;(load "~/.emacs.d/emacs-rc-autosmiley.el")
;;(add-hook 'jabber-chat-mode-hook 'autosmiley-mode)


(defun jabber-visit-history (jid)
  "Visit jabber history with JID in a new buffer.

Performs well only for small files. Expect to wait a few seconds
for large histories. Adapted from `jabber-chat-create-buffer'."
  (interactive (list (jabber-read-jid-completing "JID: ")))
  (let ((buffer (generate-new-buffer (format "*-jabber-history-%s-*"
                                             (jabber-jid-displayname jid)))))
    (switch-to-buffer buffer)
    (make-local-variable 'jabber-chat-ewoc)
    (setq jabber-chat-ewoc (ewoc-create #'jabber-chat-pp))
    (mapc 'jabber-chat-insert-backlog-entry
          (nreverse (jabber-history-query nil nil t t "."
                                          (jabber-history-filename jid))))
    (view-mode)))

;;(add-hook 'jabber-chat-mode-hook 'autosmiley-mode)

;;(add-to-list 'gnus-smiley-file-types "gif")
;;(setq smiley-base-directory (concat (getenv "HOME") "/.emacs.d/smileys/"))
;;(smiley-load-theme "kolobok")


;; Prevent annoying \"Active processes exist\" query when you quit Emacs.
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  (flet ((process-list ())) ad-do-it))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "/tmp/emacs/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "/tmp/emacs/"))))
 '(current-language-environment "UTF-8")
 '(inhibit-startup-screen t)
 '(jabber-account-list (quote (("NAME@DOMAIN" (:network-server . "DOMAIN") (:connection-type . ssl) (:password . "PSWD_HERE") ))))
 '(jabber-default-status "emacs everywhere")
 '(jabber-alert-message-hooks (quote (jabber-message-libnotify jabber-message-echo jabber-message-scroll)))
 '(jabber-alert-presence-hooks nil)
 '(jabber-auto-reconnect t)
 '(jabber-display-menu t)
 '(jabber-autoaway-verbose t)
 '(jabber-keepalive-interval 200)
 '(jabber-keepalive-timeout 20)
 '(jabber-history-enabled t)
 '(jabber-use-global-history nil)
 '(jabber-backlog-number 40)
 '(jabber-backlog-days 30)
)

(defvar libnotify-program "/usr/bin/notify-send")

(defun notify-send (title message)
  (start-process "notify" " notify"
         libnotify-program "--expire-time=4000" title message))

(defun libnotify-jabber-notify (from buf text proposed-alert)
  "(jabber.el hook) Notify of new Jabber chat messages via libnotify"
  (when (or jabber-message-alert-same-buffer
            (not (memq (selected-window) (get-buffer-window-list buf))))
    (if (jabber-muc-sender-p from)
        (notify-send (format "(PM) %s"
                       (jabber-jid-displayname (jabber-jid-user from)))
               (format "%s: %s" (jabber-jid-resource from) text)))
      (notify-send (format "%s" (jabber-jid-displayname from))
             text)))

(add-hook 'jabber-alert-message-hooks 'libnotify-jabber-notify)


;; link appears nicely
(add-hook 'jabber-chat-mode-hook 'goto-address)

(jabber-roster-toggle-binding-display)
(jabber-roster-toggle-offline-display)

(global-set-key "\C-x\C-a" 'jabber-activity-switch-to)

;; '(jabber-default-show "")
;; '(jabber-version-show t)
;; '(jabber-silent-mode t)

'(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))


;; language bindings
(setq auto-mode-alist
      (append
       '(
         ( "\\.el$". lisp-mode)
         ( "\\.js$". js-mode)
         ( "\\.emacs". emacs-lisp-mode)
         ( "\\.conf$". conf-mode)
         ( "\\.cpp$". c++-mode)
         ( "\\.py$". python-mode)
         ( "\\.rb$". ruby-mode)
         ( "\\.php$". php-mode)
         ( "\\.conf$". conf-mode)
         ( "\\.cnf$". conf-mode)
         ( "\\.emacs". emacs-lisp-mode)
         ( "\\.js$". espresso-mode)
         ( "\\.xml$". xml-mode)
         ( "\\.html$". html-mode)
         ( "\\.css$". css-mode)
         ( "\\.prg$". xbase-mode)
         ( "\\.scn$". xbase-mode)
         ( "\\.mac$". xbase-mode)
         ( "\\.f2r$". xbase-mode)
         ( "\\.erl$". erlang-mode)
   )))

;;

;; create the autosave dir if necessary, since emacs won't.
(make-directory "/tmp/emacs/" t)
(add-to-list 'backup-directory-alist
             (cons ".*" "/tmp/emacs"))

(add-to-list 'load-path "~/.emacs.d/")

;(load "xbase")

(add-to-list 'load-path (expand-file-name "~/.emacs.d/column-marker"))
(require 'column-marker)
(add-hook 'xbase-mode-hook (lambda () (interactive) (column-marker-3 79)))
(add-hook 'javascript-mode-hook (lambda () (interactive) (column-marker-3 79)))
(add-hook 'python-mode-hook (lambda () (interactive) (column-marker-3 79)))

(defun insert-second-hook ()
  (interactive)
  (insert "()")
  (goto-char (- (point) 1))
)
(global-set-key (kbd "\(") 'insert-second-hook)

;; geometry and position
(set-frame-height (selected-frame) 680)
(set-frame-width (selected-frame) 118)
;;(set-frame-position (selected-frame) 1024 0)

;; after save events
;;; убивать пробелы в конце строк
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;;; замена табов пробелами
(add-hook 'before-save-hook '(lambda () (untabify (point-min) (point-max))))

;;(put 'upcase-region 'disabled nil)

;; global shortcut
(global-set-key [?\C-,] 'previous-buffer)
(global-set-key [?\C-.] 'next-buffer)
(global-set-key [?\C-'] 'toggle-truncate-lines)
(global-set-key [?\C-:] 'kill-this-buffer)

;;(global-set-key "\C-cs" 'shell)

;;(global-set-key [f5] 'call-last-kbd-macro)
;;(global-set-key [f8] 'linum-mode)
;;(global-set-key [f11] 'ibuffer)
;;(global-set-key [f10] 'bookmark-bmenu-list)


;; eng => ru
(load "eik")
(global-set-key [f9] 'eik/tr)

;;(require 'highlight-symbol)

;;(setenv "PS1" "\\e[0;32m◆\\u@\\H \\D{%Y-%m-%d} \\t\\e[0;30m\\w\\n")

(require 'uniquify)
(require 'minimap)
(require 'ido)

;;(add-to-list 'load-path "~/.emacs.d/magit")
;;(load "magit")


(setq ido-save-directory-list-file (concat (getenv "HOME") "/.emacs.d/ido/ido.last"))
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode t)

(add-to-list 'load-path "~/.emacs.d/ido")
(require 'ido-hacks)

(require 'saveplace)
(setq-default save-place t)

(require 'undo-tree)

(require 'diff-hl)

;(add-to-list 'load-path "~/.emacs.d/yasnippet")
;(require 'yasnippet)
;(yas/initialize)
;(yas/load-directory "~/.emacs.d/yasnippet/snippets")

;;(global-set-key [(control f3)] 'highlight-symbol-at-point)
;;(global-set-key [f3] 'highlight-symbol-next)
;;;(global-set-key [(shift f3)] 'highlight-symbol-prev)
;;(global-set-key [(meta f3)] 'highlight-symbol-prev)

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(jabber-title-medium ((t (:inherit variable-pitch :weight bold :height 2.0 :width condensed))))
 '(jabber-title-small ((t (:inherit variable-pitch :weight bold :height 1.0 :width condensed)))))

(defun copy-buffer-file-name-as-kill(choice)
  "Copy the buffer-file-name to the kill-ring"
  (interactive "cCopy Buffer Name (f) full, (d) directory, (n) name")
  (let ((new-kill-string)
        (name (if (eq major-mode 'dired-mode)
                  (dired-get-filename)
                (or (buffer-file-name) ""))))
    (cond ((eq choice ?f)
           (setq new-kill-string name))
          ((eq choice ?d)
           (setq new-kill-string (file-name-directory name)))
          ((eq choice ?n)
           (setq new-kill-string (file-name-nondirectory name)))
          (t (message "Quit")))
    (when new-kill-string
      (message "%s copied" new-kill-string)
      (kill-new new-kill-string))))

;; setting for auto-close brackets for electric-pair-mode regardless of current major mode syntax table
(setq electric-pair-pairs '(
                            (?\" . ?\")
                            (?\{ . ?\})
                            (?\[ . ?\])
                            ) )

(require 'dired+)
(define-key ctl-x-map   "d" 'diredp-dired-files)
(define-key ctl-x-4-map "d" 'diredp-dired-files-other-window)

(jabber-connect-all)


(require 'pymacs)
 (pymacs-load "ropemacs" "rope-")

(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)

(setq ropemacs-enable-autoimport 't)

;;
;; end of .emacs
;;
;;
