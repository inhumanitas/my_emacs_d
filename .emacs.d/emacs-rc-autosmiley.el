;;; emacs-rc-autosmiley.el ---

;; Copyright (C) Sergei Lebedev
;;
;; Author: Sergei Lebedev <superbobry@gmail.com>
;; Keywords:
;; Requirements:
;; Status: not intended to be distributed yet


;; Smiley.el extension functions
;;
;; TODO: scan base directory and get availible PACK values
;; TODO: scan pack directory and add file extensions to `gnus-smiley-file-types
;; automatically

(require 'xml)


(defvar smiley-base-directory nil
  "Directory containing smiley packs (folders).")


(defun smiley-parse-node (node)
  "Extracts smiley data of type (REGEXP 1 FILENAME) from a node."
  (when (listp node)
    (let* ((filename
            (cdr (assq 'file (xml-node-attributes node))))
           (smilies
            (mapcar
             (lambda (data) (car (last data)))
             (xml-get-children node 'string))))
       (list
        (concat (regexp-opt smilies "\(") "\W")
        1 filename)
       )))


(defun smiley-parse-file (filename)
  "Returns smiley data list for smiley-regexp-alist."
  (let ((root (xml-parse-file filename)))
    (mapcar 'smiley-parse-node
            (xml-get-children
             (car root) ;; we skip <messaging-emoticon-map>
             'emoticon))
    ))


(defun smiley-load-theme (pack)
  "Loads smiley theme PACK into smiley.el.
  Each theme should be a folder inside smiley-data-directory. For example
  smiley-data-directory is set to '/home/bobry/.emacs.d/smileys, so possible
  directory structure could be:
  .
  |-- default
  |-- kolobok
  `-- tango
  default, kolobok and tango are valid PACK values."
  (interactive "sTheme: ")
  (when smiley-base-directory
    (let* ((smiley-dir (format "%s/%s/" smiley-base-directory pack ))
          (smiley-path (concat smiley-dir "emoticons.xml")))
      (when (file-exists-p smiley-path)
        (setq
         smiley-style 'low-color ;; this is done for compatibility reasons
         smiley-data-directory smiley-dir
         smiley-regexp-alist (smiley-parse-file smiley-path))
        (smiley-update-cache))
      )))


;; Smiley

(require 'autosmiley)

(add-to-list 'gnus-smiley-file-types "gif")
(setq smiley-base-directory (concat (getenv "HOME") "/.emacs.d/smileys/"))
(smiley-load-theme "kolobok")

(autosmiley-mode)

:-
;; Test block:
;; :)  :)))  :-) :-))) =) =))) +) +)))
;; This should not be parsed --> test:) =-) +-)
;; O:-) O:) O=) O+) 0:-) 0:) 0=) 0+)
;; :( :((( :-( :-((( +( +((( =( =(((
;; ;-) ;-))) ;) ;))) ^_~
;; :-P :P +P =P :-p :p +p =p :-b :b +b =b
;; 8-) 8-))) 8) 8))) B-) B-))) B) B)))
;; :-D :-DDD :D :DDD +D +DDD =D =DDD
;; :-[ :[
;; =-O =O =-0 =0 O_O O_o o_O O_0 o_0 0_O 0_o 0_0
;; :-* :* :-{} :{} +{} ={} ^.^
;; :-'( :-'((( :'-( :'-((( :'( :'(((
;; :-X :-x X: x: :-# :#
;; >:o >:O >+o >+O >=O >=o :-@
;; :-| :| =|
;; :- :-/ : :/ *BEEE*
;; *JOKINGLY* 8P 8p
;; ]:-> }:-> ]:> }:> >:-] >:] *DIABLO*
;; [:-} [:}
;; *KISSED*
;; :-! ;-! :! ;! :-~ ;-~
;; *TIRED* |-0
;; *STOP*
;; *KISSING*
;; @}-> @]-:--< @>}--`---
;; *THUMBS UP* *GOOD* *THUMBS_UP*
;; *DRINK*
;; *IN_LOVE*
;; @=
;; *HELP*
;; m/
;; %-) %-))) %) %))) :$ :$$$


;;; emacs-rc-autosmiley.el ends here
