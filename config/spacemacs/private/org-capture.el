(with-eval-after-load 'org (setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Documents/emacs/org/INBOX.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("b" "Bookmark" entry (file+headline "~/Documents/emacs/org/INBOX.org" "Bookmarks")
         "* %c %?\n:PROPERTIES: \n:Category: \n:CREATED: %U \n:END:\n")
        ("i" "Idea" entry (file+headline "~/Documents/emacs/org/INBOX.org" "Idea")
         "* %?\n:PROPERTIES: \n:CREATED: %U\n:END:\n")
        ("l" "Look into" entry (file+headline "~/Documents/emacs/org/INBOX.org" "Look Into")
         "* %?\n:PROPERTIES: \n:CREATED: %U\n:END:\n")
        ("w" "Workout" entry (file+datetree "~/Documents/emacs/org/workouts.org")
         "* Description: %?\n* Notes: \n* Intensity: \n:PROPERTIES: \n:TYPE: \n:LOCATION: \n:DURATION: \n:KCAL: \n:AEROBIC_TE: \n:ANAEROBIC_TE: \n:END: \n")
        ("r" "Book" entry (file+datetree "~/Documents/emacs/org/readinglist.org")
         "* Description: %?\n* Notes: \n:PROPERTIES: \n:BOOK_TITLE: \n:AUTHOR: \n:GENRE: \n:END:\n")
        ("c" "Contact" entry (file+headline "~/Documents/emacs/org/contacts.org" "Contacts")
         "* %?\n:PROPERTIES: \n:NICKNAME: \n:FIRSTNAME: \n:SURNAME: \n:PHOTO: \n:BIRTHDAY: \n:ADDRESS: \n:CITY: \n:COUNTRY: \n:MOB_PHONE: \n:WORK_PHONE: \n:EMAIL: \n:WWW: \n:IM_INFO: \n:CREATED: %U\n:END: \n** Notes: \n
")
       )

))

;; (with-eval-after-load 'org (setq org-insert-heading-respect-content t))
(with-eval-after-load 'org (setq org-startup-with-inline-images t))

(with-eval-after-load 'org (setq org-refile-targets
                                 '(
                                   ("~/Documents/emacs/org/bookmarks.org" :maxlevel . 10)
                                   ("~/Documents/emacs/org/lookinto.org" :maxlevel . 10)
                                   ("~/Documents/emacs/org/reference.org" :maxlevel . 10)
                                   ("~/Documents/emacs/org/thoughts.org" :maxlevel . 10)
                                   ("~/Documents/emacs/org/weekplanning.org" :maxlevel . 10)
                                   ("~/Documents/emacs/org/teaching.org" :maxlevel . 10)
                                   )
                                 ))

(with-eval-after-load 'org (setq org-outline-path-complete-in-steps nil))         ; Refile in a single go
(with-eval-after-load 'org (setq org-refile-use-outline-path t))                  ; Show full paths fo


(with-eval-after-load 'org (require 'org-attach))

(with-eval-after-load 'org (setq org-link-abbrev-alist '(("att" . org-attach-expand-link))))
