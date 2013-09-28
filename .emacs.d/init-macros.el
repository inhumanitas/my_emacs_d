;; converts link to changest to nice view for redmine
(fset 'redmine-do-link
   [end C-S-left C-insert home ?\" S-insert ?\" ?: home S-end C-insert])

(fset 'make_revision
   [?\C-e C-S-left C-insert home ?c ?o ?m ?m ?i ?t ?: ?\" ?\" ?: left left S-insert end return ?r ?e ?v ?: S-insert S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left S-left backspace S-up S-up S-home C-insert])


(global-set-key (kbd "C-c <insert>")  'redmine-do-link)
