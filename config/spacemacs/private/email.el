;; allow extra arguments so that msmtp works 
(setq message-sendmail-f-is-evil 't)

;;need to tell msmtp which account we're using
;; not needed in recent versions of msmtp?
;;(setq message-sendmail-extra-arguments '("--read-envelope-from"))

(setq message-send-mail-function 'message-send-mail-with-sendmail)

;; ensure message header with "from" value is present for identity parsing
(setq mail-specify-envelope-from 't)
(setq message-sendmail-envelope-from 'header)
(setq mail-envelope-from 'header)

