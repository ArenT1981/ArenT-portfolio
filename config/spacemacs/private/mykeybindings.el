;; General keybindings
;; ==================================================================
;; yasnippets template expansion - CAPS lock key rebound in .Xmodmap at OS level 
(global-set-key '[8711] 'yas-expand)
;;(global-set-key (kbd "s-o") 'org-attach-open) TODO!!! Clashes
;; ==================================================================
;; zetteldeft/deft quick key bindings
;; ==================================================================
(global-unset-key (kbd "C-`"))
(global-set-key (kbd "C-`") 'zd-find-file)
;;(exwm-input-set-key (kbd "C-`") 'zd-find-file)
;; quick create new markdown note
(global-unset-key (kbd "C-\\"))
(global-set-key (kbd "C-\\") 'zd-new-file)
;;(exwm-input-set-key (kbd "C-\\") 'zd-new-file)
;; search in main deft menu
(global-unset-key (kbd "C-¬"))
(global-set-key (kbd "C-¬") 'deft)
;;(exwm-input-set-key (kbd "C-¬") 'deft)
;; ==================================================================
;; zetteldeft spacemacs key bindings
;; ==================================================================
;; Prefix
(spacemacs/declare-prefix "d" "deft")
;; Launch deft
(spacemacs/set-leader-keys "dd" 'deft)
(spacemacs/set-leader-keys "dD" 'zd-deft-new-search)
;; SEARCH
;; Search thing at point
(spacemacs/set-leader-keys "ds" 'zd-search-at-point)
;; Search current file id
(spacemacs/set-leader-keys "dc" 'zd-search-current-id)
;; Jump & search with avy 
;; search link as filename
(spacemacs/set-leader-keys "df" 'zd-avy-file-search)
(spacemacs/set-leader-keys "dF" 'zd-avy-file-search-ace-window)
;; search link as contents
(spacemacs/set-leader-keys "dl" 'zd-avy-link-search)
;; search tag as contents
(spacemacs/set-leader-keys "dt" 'zd-avy-tag-search)
;; find all tags
(spacemacs/set-leader-keys "dT" 'zd-tag-buffer)
;; LINKS
;; Insert link from filename
(spacemacs/set-leader-keys "di" 'zd-find-file-id-insert)
;; Insert link with full filename
(spacemacs/set-leader-keys "dI" 'zd-find-file-full-title-insert)
;; FILES
;; Open file
(spacemacs/set-leader-keys "do" 'zd-find-file)
;; Create new file
(spacemacs/set-leader-keys "dn" 'zd-new-file)
(spacemacs/set-leader-keys "dN" 'zd-new-file-and-link)
;; Rename file
(spacemacs/set-leader-keys "dr" 'zd-file-rename)
;; UTILITIES
(spacemacs/set-leader-keys "dR" 'deft-refresh)
;; ==================================================================
;; ibuffer is much better buffer menu. mark with 'm', unmark with 'u', close with 'D', save with 'S', '*u' mark unsaved
;; ==================================================================
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-\=") 'checkbox-toggle)
;; easy window moving with buffer-move
;;(exwm-input-set-key (kbd "C-s-k") 'buf-move-up)
;;(exwm-input-set-key (kbd "C-s-j") 'buf-move-down)
;;(exwm-input-set-key (kbd "C-s-l") 'buf-move-right)
;;(exwm-input-set-key (kbd "C-s-h") 'buf-move-left)
;; easy window switching with windmove
;;(exwm-input-set-key (kbd "s-k") 'windmove-up)
;;(exwm-input-set-key (kbd "s-j") 'windmove-down)
;;(exwm-input-set-key (kbd "s-l") 'windmove-right)
;;(exwm-input-set-key (kbd "s-h") 'windmove-left)
;; awesome golden ratio resize function
;;(exwm-input-set-key (kbd "s-'") 'golden-ratio)
;; access any EXMW buffer
;;(exwm-input-set-key (kbd "s-b") 'exwm-workspace-switch-to-buffer)
;; ==================================================================
;; easily move entire lines up/down with handy move-text package - bind to m-<up>/<down>
;; ==================================================================
(move-text-default-bindings) 
;; ==================================================================
;; multiple cursors - working with evil-mc backend in spacemacs
;; ==================================================================
(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)
;; ==================================================================
;; some mouse wheel/mouse settings nice keybindings
;; ==================================================================
(global-set-key [(control mouse-4)] (lambda () (interactive) (text-scale-increase 1)))
(global-set-key [(control mouse-5)] (lambda () (interactive) (text-scale-decrease 1)))

(add-hook
 'pdf-view-mode-hook
 (lambda ()
   (local-set-key [mouse-4] #'pdf-view-previous-line-or-previous-page)
   (local-set-key [mouse-5] #'pdf-view-next-line-or-next-page)
   (local-set-key [(control mouse-4)] (lambda () (interactive) (pdf-view-enlarge 1.25)))
   (local-set-key [(control mouse-5)] (lambda () (interactive) (pdf-view-enlarge 0.8)))))

(add-hook
 'image-mode-hook
 (lambda ()
   (local-set-key [mouse-4] (lambda () (interactive) (image-previous-line 1)))
   (local-set-key [mouse-5] (lambda () (interactive) (image-next-line 1)))
   (local-set-key [(control mouse-4)] (lambda () (interactive) (image-increase-size 1)))
   (local-set-key [(control mouse-5)] (lambda () (interactive) (image-decrease-size 1)))))

;; enable mouse-drag swap buffers - nice!
(defun th/swap-window-buffers-by-dnd (drag-event)
  "Swaps the buffers displayed in the DRAG-EVENT's start and end window."

    (interactive "e")
    (let ((start-win (cl-caadr drag-event))
        (end-win   (cl-caaddr drag-event)))
     (when (and (windowp start-win)
               (windowp end-win)
               (not (eq start-win end-win))
               (not (memq (minibuffer-window)
                          (list start-win end-win))))
      (let ((bs (window-buffer start-win))
            (be (window-buffer end-win)))
        (unless (eq bs be)
          (set-window-buffer start-win be)
          (set-window-buffer end-win bs))))))

(global-set-key (kbd "<C-S-drag-mouse-1>") #'th/swap-window-buffers-by-dnd)
;; ==================================================================
;; exwm bindings
;; toggle between line/char mode

;; application launchers
;; ==================================================================
(defun launch-terminal ()
  (interactive)
 (start-process-shell-command "urxvt" nil "urxvt"))

(defun launch-firefox ()
  (interactive)
  (start-process-shell-command "firefox" nil "firefox"))

(defun launch-calibre ()
  (interactive)
  (start-process-shell-command "calibre" nil "CALIBRE_USE_SYSTEM_THEME=1 calibre"))

(defun launch-keepassxc ()
  (interactive)
  (start-process-shell-command "keepassxc" nil "keepassxc"))

(defun launch-spacefm ()
  (interactive)
  (start-process-shell-command "spacefm" nil "spacefm"))

(defun launch-dia ()
  (interactive)
  (start-process-shell-command "dia" nil "dia"))

(defun launch-mtpaint ()
  (interactive)
  (start-process-shell-command "mtpaint" nil "mtpaint"))

(defun launch-worker()
  (interactive)
  (start-process-shell-command "worker" nil "worker"))

(defun launch-LINE()
  (interactive)
  (start-process-shell-command "LINE" nil "startline.sh"))

(defun launch-signal()
  (interactive)
  (start-process-shell-command "signal" nil "signal-desktop"))

(defun launch-GIMP()
  (interactive)
  (start-process-shell-command "GIMP" nil "gimp"))

(defun launch-geeqie()
  (interactive)
  (start-process-shell-command "geeqie" nil "geeqie"))

(defun launch-intellij()
  (interactive)
  (start-process-shell-command "intellij" nil "idea-ce"))

(defun launch-freeplane()
  (interactive)
  (start-process-shell-command "freeplane" nil "freeplane"))

(defun launch-vue()
  (interactive)
  (start-process-shell-command "vue" nil "vue"))

(defun launch-yed()
  (interactive)
  (start-process-shell-command "yed" nil "yed"))

(defun launch-libreoffice()
  (interactive)
  (start-process-shell-command "libreoffice" nil "libreoffice"))

(defun launch-zotero()
  (interactive)
  (start-process-shell-command "zotero" nil "zotero"))

(defun launch-gtop()
  (interactive)
  (start-process-shell-command "gtop" nil "xterm -e gtop"))

(defun launch-htop()
  (interactive)
  (start-process-shell-command "htop" nil "xterm -e htop -t"))

(defun launch-baobab()
  (interactive)
  (start-process-shell-command "baobab" nil "baobab"))

(defun launch-bmon()
  (interactive)
  (start-process-shell-command "bmon" nil "xterm -e bmon"))

(defun launch-xkill()
  (interactive)
  (start-process-shell-command "xkill" nil "xkill"))

(defun launch-mc()
  (interactive)
  (start-process-shell-command "mc" nil "xterm -e mc"))

(defun launch-xclipboard()
  (interactive)
  (start-process-shell-command "xclipboard" nil "xclipboard"))

(defun launch-systemview()
  (interactive)
  (launch-terminal)
  (split-window-right-and-focus)
  (start-process-shell-command "htop" nil "xterm -e htop -t")
  (split-window-below-and-focus)
  (start-process-shell-command "bmon" nil "xterm -e bmon"))

;; convenient window splitting launchers
;; ==================================================================

(defun launch-1way-deletewin()
  (interactive)
  (delete-window)
  (delete-window)
  (delete-window)
  (delete-window)
  (delete-window)
  (delete-window)
  (delete-window))

(defun launch-2wayVS()
  (interactive)
  (split-window-right))

(defun launch-3waySR()
  (interactive)
  (split-window-right-and-focus)
  (split-window-below-and-focus))

(defun launch-4wayCS()
  (interactive)
  (split-window-right)
  (split-window-below-and-focus)
  (windmove-right)
  (split-window-below-and-focus))

(defun launch-3wayHS()
  (interactive)
  (split-window-below)
  (split-window-below))

(defun launch-3wayHVS()
  (interactive)
  (split-window-below-and-focus)
  (split-window-right))

(defun launch-4way3R()
  (interactive)
  (split-window-right-and-focus)
  (split-window)
  (split-window))

(defun launch-5way()
  (interactive)
  (split-window-right)
  (split-window-below-and-focus)
  (windmove-right)
  (split-window-below)
  (split-window-below))

;; bind all the above functions to exwm keys 
;; ==================================================================

;;(exwm-input-set-key (kbd "s-# t") 'launch-terminal)
;;(exwm-input-set-key (kbd "s-# f") 'launch-firefox)
;;(exwm-input-set-key (kbd "s-# c") 'launch-calibre)
;;(exwm-input-set-key (kbd "s-# k") 'launch-keepassxc)
;;(exwm-input-set-key (kbd "s-# m") 'launch-spacefm)
;;(exwm-input-set-key (kbd "s-# d") 'launch-dia)
;;(exwm-input-set-key (kbd "s-# p") 'launch-mtpaint)
;;(exwm-input-set-key (kbd "s-# w") 'launch-worker)
;;(exwm-input-set-key (kbd "s-# l") 'launch-LINE)
;;(exwm-input-set-key (kbd "s-# a") 'launch-signal)
;;(exwm-input-set-key (kbd "s-# g") 'launch-GIMP)
;;(exwm-input-set-key (kbd "s-# q") 'launch-geeqie)
;;(exwm-input-set-key (kbd "s-# i") 'launch-intellij)
;;(exwm-input-set-key (kbd "s-# e") 'launch-freeplane)
;;(exwm-input-set-key (kbd "s-# v") 'launch-vue)
;;(exwm-input-set-key (kbd "s-# y") 'launch-yed)
;;(exwm-input-set-key (kbd "s-# o") 'launch-libreoffice)
;;(exwm-input-set-key (kbd "s-# z") 'launch-zotero)

;;(exwm-input-set-key (kbd "s-# s g") 'launch-gtop)
;;(exwm-input-set-key (kbd "s-# s h") 'launch-htop)
;;(exwm-input-set-key (kbd "s-# s b") 'launch-baobab)
;;(exwm-input-set-key (kbd "s-# s m") 'launch-bmon)
;;(exwm-input-set-key (kbd "s-# s c") 'launch-mc)
;;(exwm-input-set-key (kbd "s-# s k") 'launch-xkill)
;;(exwm-input-set-key (kbd "s-# s x") 'launch-xclipboard)
;;(exwm-input-set-key (kbd "s-# s S") 'launch-systemview)

;;(exwm-input-set-key (kbd "s-# SPC 1") 'launch-1way-deletewin)
;;(exwm-input-set-key (kbd "s-# SPC 2") 'launch-2wayVS)
;;(exwm-input-set-key (kbd "s-# SPC 3") 'launch-3waySR)
;;(exwm-input-set-key (kbd "s-# SPC 4") 'launch-4wayCS)
;;(exwm-input-set-key (kbd "s-# SPC 5") 'launch-3wayHS)
;;(exwm-input-set-key (kbd "s-# SPC 6") 'launch-3wayHVS)
;;(exwm-input-set-key (kbd "s-# SPC 7") 'launch-4way3R)
;;(exwm-input-set-key (kbd "s-# SPC 8") 'launch-5way)

;; ==================================================================

;; ==================================================================
;; easily move entire lines up/down with handy move-text package - bind to m-<up>/<down>
;; ==================================================================
(move-text-default-bindings) 
;; ==================================================================
;; multiple cursors - working with evil-mc backend in spacemacs
;; ==================================================================
(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)
;; ==================================================================
;; some mouse wheel/mouse settings nice keybindings
;; ==================================================================
(global-set-key [(control mouse-4)] (lambda () (interactive) (text-scale-increase 1)))
(global-set-key [(control mouse-5)] (lambda () (interactive) (text-scale-decrease 1)))

(add-hook
 'pdf-view-mode-hook
 (lambda ()
   (local-set-key [mouse-4] #'pdf-view-previous-line-or-previous-page)
   (local-set-key [mouse-5] #'pdf-view-next-line-or-next-page)
   (local-set-key [(control mouse-4)] (lambda () (interactive) (pdf-view-enlarge 1.25)))
   (local-set-key [(control mouse-5)] (lambda () (interactive) (pdf-view-enlarge 0.8)))))

(add-hook
 'image-mode-hook
 (lambda ()
   (local-set-key [mouse-4] (lambda () (interactive) (image-previous-line 1)))
   (local-set-key [mouse-5] (lambda () (interactive) (image-next-line 1)))
   (local-set-key [(control mouse-4)] (lambda () (interactive) (image-increase-size 1)))
   (local-set-key [(control mouse-5)] (lambda () (interactive) (image-decrease-size 1)))))

;; enable mouse-drag swap buffers - nice!
(defun th/swap-window-buffers-by-dnd (drag-event)
  "Swaps the buffers displayed in the DRAG-EVENT's start and end window."

    (interactive "e")
    (let ((start-win (cl-caadr drag-event))
        (end-win   (cl-caaddr drag-event)))
     (when (and (windowp start-win)
               (windowp end-win)
               (not (eq start-win end-win))
               (not (memq (minibuffer-window)
                          (list start-win end-win))))
      (let ((bs (window-buffer start-win))
            (be (window-buffer end-win)))
        (unless (eq bs be)
          (set-window-buffer start-win be)
          (set-window-buffer end-win bs))))))

(global-set-key (kbd "<C-S-drag-mouse-1>") #'th/swap-window-buffers-by-dnd)
;; ==================================================================
;; exwm bindings
;; toggle between line/char mode

;; application launchers
;; ==================================================================
(defun launch-terminal ()
  (interactive)
 (start-process-shell-command "urxvt" nil "urxvt"))

(defun launch-firefox ()
  (interactive)
  (start-process-shell-command "firefox" nil "firefox"))

(defun launch-keepassxc ()
  (interactive)
  (start-process-shell-command "keepassxc" nil "keepassxc"))

(defun launch-spacefm ()
  (interactive)
  (start-process-shell-command "spacefm" nil "spacefm"))

(defun launch-sylpheed ()
  (interactive)
  (start-process-shell-command "sylpheed" nil "sylpheed"))

(defun launch-dia ()
  (interactive)
  (start-process-shell-command "dia" nil "dia"))

(defun launch-mtpaint ()
  (interactive)
  (start-process-shell-command "mtpaint" nil "mtpaint"))

(defun launch-worker()
  (interactive)
  (start-process-shell-command "worker" nil "worker"))

(defun launch-LINE()
  (interactive)
  (start-process-shell-command "LINE" nil "startline.sh"))

(defun launch-GIMP()
  (interactive)
  (start-process-shell-command "GIMP" nil "gimp"))

(defun launch-geeqie()
  (interactive)
  (start-process-shell-command "geeqie" nil "geeqie"))

(defun launch-intellij()
  (interactive)
  (start-process-shell-command "intellij" nil "idea-ce"))

(defun launch-email()
  (interactive)
  (start-process-shell-command "getemail" nil "xterm -fa monaco -fs 15 -e \"get-email.sh\""))

(defun launch-freeplane()
  (interactive)
  (start-process-shell-command "freeplane" nil "freeplane"))

(defun launch-vue()
  (interactive)
  (start-process-shell-command "vue" nil "vue"))

(defun launch-yed()
  (interactive)
  (start-process-shell-command "yed" nil "yed"))

(defun launch-libreoffice()
  (interactive)
  (start-process-shell-command "libreoffice" nil "libreoffice"))

(defun launch-zotero()
  (interactive)
  (start-process-shell-command "zotero" nil "zotero"))

(defun launch-gtop()
  (interactive)
  (start-process-shell-command "gtop" nil "xterm -e gtop"))

(defun launch-htop()
  (interactive)
  (start-process-shell-command "htop" nil "xterm -e htop -t"))

(defun launch-baobab()
  (interactive)
  (start-process-shell-command "baobab" nil "baobab"))

(defun launch-bmon()
  (interactive)
  (start-process-shell-command "bmon" nil "xterm -e bmon"))

(defun launch-xkill()
  (interactive)
  (start-process-shell-command "xkill" nil "xkill"))

(defun launch-mc()
  (interactive)
  (start-process-shell-command "mc" nil "xterm -e mc"))

(defun launch-xclipboard()
  (interactive)
  (start-process-shell-command "xclipboard" nil "xclipboard"))

(defun launch-systemview()
  (interactive)
  (launch-terminal)
  (split-window-right-and-focus)
  (start-process-shell-command "htop" nil "xterm -e htop -t")
  (split-window-below-and-focus)
  (start-process-shell-command "bmon" nil "xterm -e bmon"))

;; convenient window splitting launchers
;; ==================================================================

(defun launch-1way-deletewin()
  (interactive)
  (delete-window)
  (delete-window)
  (delete-window)
  (delete-window)
  (delete-window)
  (delete-window)
  (delete-window))

(defun launch-2wayVS()
  (interactive)
  (split-window-right))

(defun launch-3waySR()
  (interactive)
  (split-window-right-and-focus)
  (split-window-below-and-focus))

(defun launch-4wayCS()
  (interactive)
  (split-window-right)
  (split-window-below-and-focus)
  (windmove-right)
  (split-window-below-and-focus))

(defun launch-3wayHS()
  (interactive)
  (split-window-below)
  (split-window-below))

(defun launch-3wayHVS()
  (interactive)
  (split-window-below-and-focus)
  (split-window-right))

(defun launch-4way3R()
  (interactive)
  (split-window-right-and-focus)
  (split-window)
  (split-window))

(defun launch-5way()
  (interactive)
  (split-window-right)
  (split-window-below-and-focus)
  (windmove-right)
  (split-window-below)
  (split-window-below))

;; bind all the above functions to exwm keys 
;; ==================================================================

;;(exwm-input-set-key (kbd "s-# t") 'launch-terminal)
;;(exwm-input-set-key (kbd "s-# f") 'launch-firefox)
;;(exwm-input-set-key (kbd "s-# k") 'launch-keepassxc)
;;(exwm-input-set-key (kbd "s-# m") 'launch-spacefm)
;;(exwm-input-set-key (kbd "s-# h") 'launch-sylpheed)
;;(exwm-input-set-key (kbd "s-# n")  'notmuch)
;;(exwm-input-set-key (kbd "s-# d") 'launch-dia)
;;(exwm-input-set-key (kbd "s-# p") 'launch-mtpaint)
;;(exwm-input-set-key (kbd "s-# w") 'launch-worker)
;;(exwm-input-set-key (kbd "s-# l") 'launch-LINE)
;;(exwm-input-set-key (kbd "s-# g") 'launch-GIMP)
;;(exwm-input-set-key (kbd "s-# q") 'launch-geeqie)
;;(exwm-input-set-key (kbd "s-# i") 'launch-intellij)
;;(exwm-input-set-key (kbd "s-# e") 'launch-email)
;;(exwm-input-set-key (kbd "s-# j") 'launch-freeplane)
;;(exwm-input-set-key (kbd "s-# v") 'launch-vue)
;;(exwm-input-set-key (kbd "s-# y") 'launch-yed)
;;(exwm-input-set-key (kbd "s-# o") 'launch-libreoffice)
;;(exwm-input-set-key (kbd "s-# z") 'launch-zotero)

;;(exwm-input-set-key (kbd "s-# s g") 'launch-gtop)
;;(exwm-input-set-key (kbd "s-# s h") 'launch-htop)
;;(exwm-input-set-key (kbd "s-# s b") 'launch-baobab)
;;(exwm-input-set-key (kbd "s-# s m") 'launch-bmon)
;;(exwm-input-set-key (kbd "s-# s c") 'launch-mc)
;;(exwm-input-set-key (kbd "s-# s k") 'launch-xkill)
;;(exwm-input-set-key (kbd "s-# s x") 'launch-xclipboard)
;;(exwm-input-set-key (kbd "s-# s S") 'launch-systemview)

;;(exwm-input-set-key (kbd "s-# SPC 1") 'launch-1way-deletewin)
;;(exwm-input-set-key (kbd "s-# SPC 2") 'launch-2wayVS)
;;(exwm-input-set-key (kbd "s-# SPC 3") 'launch-3waySR)
;;(exwm-input-set-key (kbd "s-# SPC 4") 'launch-4wayCS)
;;(exwm-input-set-key (kbd "s-# SPC 5") 'launch-3wayHS)
;;(exwm-input-set-key (kbd "s-# SPC 6") 'launch-3wayHVS)
;;(exwm-input-set-key (kbd "s-# SPC 7") 'launch-4way3R)
;;(exwm-input-set-key (kbd "s-# SPC 8") 'launch-5way)

;; ==================================================================
;; Some important/useful EXWM keybindings for use with X apps
;;(exwm-input-set-key (kbd "s-t") 'exwm-input-toggle-keyboard)
;;(exwm-input-set-key (kbd "s-f") 'exwm-floating-toggle-floating)
;; ==================================================================

(global-set-key (kbd "C-x p") 'ace-window)
