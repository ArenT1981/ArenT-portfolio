;; ============= org-mode config ===============

;; (require 'org-protocol)
;; (require 'minimap)

;; org-mode files for agenda dispatcher
(with-eval-after-load 'org (setq org-agenda-files (quote("~/Documents/emacs/org"))))
(with-eval-after-load 'org (setq org-default-notes-file (concat org-directory "INBOX.org")))

;; org-mode custom todo faces
(with-eval-after-load 'org (setq org-todo-keyword-faces
                                     '(("TODO" . "red") ("STARTED" . "yellow")
                                       ("CANCELLED" . "black")
                                       ("WAITING" . "orange") ("MIGRATED" . "grey"))))
;; custom todo sequence 
(with-eval-after-load 'org (setq org-todo-keywords
                                     '((sequence "TODO" "STARTED" "WAITING" "|" "DONE" "CANCELLED" "MIGRATED"))))

;; include calendar/diary entires
(with-eval-after-load 'org (setq org-agenda-include-diary t))

;; hopefully fix org-projectile bug/issue
(require 'org-projectile)
(setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
