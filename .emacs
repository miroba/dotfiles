(setq package-enable-at-startup nil) (package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (material-light)))
 '(custom-safe-themes
   (quote
    ("0aa12caf6127772c1a38f7966de8258e7a0651fb6f7220d0bbb3a0232fba967f" "54159ea82516378faa7c4d25fb549b843effb1eb932f0925dce1348de7a659ba" "cb978b7187ea7ac2a3e6bb614d24988301cb5c2c9d1f930dce117792b21ea135" "51867fa64534ff7ca87fdc1537fbfffc168fa4673e3980850436dc87e31ef426" "9e7cc7f1db252d6fe0c7cc25d72d768712a97cda1f77bf63f0c1fd7be5dee7f4" default)))
 '(org-babel-load-languages (quote ((matlab . t) (python . t) (emacs-lisp . t))))
 '(org-confirm-babel-evaluate nil)
 '(org-export-backends (quote (ascii html icalendar latex md odt koma-letter)))
 '(org-latex-classes
   (quote
    (("beamer" "\\documentclass[presentation]{beamer}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("article" "\\documentclass[11pt]{article}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
     ("report" "\\documentclass[11pt]{report}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("book" "\\documentclass[11pt]{book}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("koma-report" "\\documentclass[ngerman,fontsize=12pt,oneside]{scrreprt}                                                \\usepackage{selinput}\\SelectInputMappings{adieresis={ä},germandbls={ß}}
\\usepackage[T1]{fontenc}
\\usepackage{babel}"
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")))))
 '(org-log-into-drawer nil)
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.org/packages/"))))
 '(send-mail-function (quote smtpmail-send-it))
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight normal :height 120 :width normal)))))

;;----------------------------------------------------------------------
;; Below Set by me:
;;----------------------------------------------------------------------
;; Fix for German keyboard
(require 'iso-transl)

;; change all prompts to y or n
(fset 'yes-or-no-p 'y-or-n-p)

;; no useless bars
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;;disable splash screen and startup message
(setq inhibit-startup-message t) 
(setq initial-scratch-message nil)
;;----------------------------------------------------------------------
;; orgmode
;;----------------------------------------------------------------------
;; scale equations
;;(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
;; Automatic latex image toggling when cursor is on a fragment
(defvar org-latex-fragment-last nil
  "Holds last fragment/environment you were on.")

(defun org-latex-fragment-toggle ()
  "Toggle a latex fragment image "
  (and (eq 'org-mode major-mode)
       (let* ((el (org-element-context))
              (el-type (car el)))
         (cond
          ;; were on a fragment and now on a new fragment
          ((and
            ;; fragment we were on
            org-latex-fragment-last
            ;; and are on a fragment now
            (or
             (eq 'latex-fragment el-type)
             (eq 'latex-environment el-type))
            ;; but not on the last one this is a little tricky. as you edit the
            ;; fragment, it is not equal to the last one. We use the begin
            ;; property which is less likely to change for the comparison.
            (not (= (org-element-property :begin el)
                    (org-element-property :begin org-latex-fragment-last))))
           ;; go back to last one and put image back
           (save-excursion
             (goto-char (org-element-property :begin org-latex-fragment-last))
             (org-preview-latex-fragment))
           ;; now remove current image
           (goto-char (org-element-property :begin el))
           (let ((ov (loop for ov in org-latex-fragment-image-overlays
                           if
                           (and
                            (<= (overlay-start ov) (point))
                            (>= (overlay-end ov) (point)))
                           return ov)))
             (when ov
               (delete-overlay ov)))
           ;; and save new fragment
           (setq org-latex-fragment-last el))

          ;; were on a fragment and now are not on a fragment
          ((and
            ;; not on a fragment now
            (not (or
                  (eq 'latex-fragment el-type)
                  (eq 'latex-environment el-type)))
            ;; but we were on one
            org-latex-fragment-last)
           ;; put image back on
           (save-excursion
             (goto-char (org-element-property :begin org-latex-fragment-last))
             (org-preview-latex-fragment))
           ;; unset last fragment
           (setq org-latex-fragment-last nil))

          ;; were not on a fragment, and now are
          ((and
            ;; we were not one one
            (not org-latex-fragment-last)
            ;; but now we are
            (or
             (eq 'latex-fragment el-type)
             (eq 'latex-environment el-type)))
           (goto-char (org-element-property :begin el))
           ;; remove image
           (let ((ov (loop for ov in org-latex-fragment-image-overlays
                           if
                           (and
                            (<= (overlay-start ov) (point))
                            (>= (overlay-end ov) (point)))
                           return ov)))
             (when ov
               (delete-overlay ov)))
           (setq org-latex-fragment-last el))))))


(add-hook 'post-command-hook 'org-latex-fragment-toggle)
;;----------------------------------------------------------------------
;; Programming languages
;;----------------------------------------------------------------------

;; matlab-emacs
(add-to-list 'load-path "~/Builds/Emacs/matlab-emacs")
(load-library "matlab-load")

;; python
;; jedi (autocompletion)
(autoload 'jedi:setup "jedi" nil t)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)
(setq jedi:complete-on-dot t)

;;----------------------------------------------------------------------
;; swiper
;;-----------------------------------------------------------------------
;; use swiper for search in text. bound to C-s
(global-set-key (kbd "C-s") 'swiper)
;; fancy colors ^^
(setq ivy-display-style 'fancy)
;; maybe add this too
;; http://pragmaticemacs.com/emacs/dont-search-swipe/
;;----------------------------------------------------------------------
;; ivy
;;-----------------------------------------------------------------------
;; enabel ivy-mode
(ivy-mode 1)
;;----------------------------------------------------------------------
;; projectile
;;-----------------------------------------------------------------------
;; enable projectile globally
(projectile-global-mode)
;; set ivy for completion
(setq projectile-completion-system 'ivy)
;;----------------------------------------------------------------------
;; magit
;;-----------------------------------------------------------------------
;; set f5 as shortcut for magit-status
(global-set-key [(f5)] 'magit-status)
;; set ivy for completion
(setq magit-completing-read-function 'ivy-completing-read)
;;----------------------------------------------------------------------
;; Mail with mu4e and mu4e-multi
;;-----------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/elpa/mu4e-maildirs-extension-20150403.903")
;; load the packages
(require 'mu4e)
(require 'mu4e-maildirs-extension)
(mu4e-maildirs-extension)

;; mu4e settings--------------------------------------------------
;; shortcut to mu4e
(global-set-key [(f4)] 'mu4e)

;; set maildir
(setq mu4e-maildir "/home/mrb/.Mail")

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;; Use fancy chars
(setq mu4e-use-fancy-chars t)

;; show images
(setq mu4e-show-images t)
;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

;; spell check TODO check if this is working like you want!!
(add-hook 'mu4e-compose-mode-hook
        (defun my-do-compose-stuff ()
           "My settings for message composition."
           (set-fill-column 72)
           (flyspell-mode)))

;; retrieving and indexing mails (handled by mbsync and mu)
(setq mu4e-get-mail-command "mbsync -a"
      mu4e-update-interval 600)          ;; update every 10 minutes
;; required for mbsync. wouldn't sync otherways after moving messages
(setq mu4e-change-filenames-when-moving t)
;; notification message
(add-hook 'mu4e-index-updated-hook
  (defun new-mail-sound ()
    (shell-command "notify-send "Neue Mails"")))

;; sending mail
(setq message-send-mail-function 'message-send-mail-with-sendmail
      sendmail-program "/usr/bin/msmtp"
      user-full-name "Michael Bauer")

;; shortcutsthe maildirs you use frequently; access them with 'j' ('jump')
(setq   mu4e-maildir-shortcuts
    '(("/Mail/Inbox"     . ?m)
      ("/Arcor/Inbox"       . ?a)
      ("/Uni/Inbox"        . ?u)))

;; account settings-------------------------------------------------- 

;; DELETE
;; (setq mu4e-multi-account-alist
;;       '(("Mail"
;;          (user-mail-address . "michael_bauer@mail.de")
;;          (mu4e-drafts-folder . "/Mail/Drafts")
;;          (mu4e-follow-up-folder . "/Mail/FollowUp")
;;          (mu4e-hold-folder . "/Mail/Hold")
;;          (mu4e-refile-folder . "/Mail/Archived")
;;          (mu4e-sent-folder . "/Mail/Sent")
;;          (mu4e-trash-folder . "/Mail/Trash"))
;;       ("Uni"
;;          (user-mail-address . "michael.bauer1@tu-dresden.de")
;;          (mu4e-drafts-folder . "/Uni/saved-messages")
;;          (mu4e-follow-up-folder . "/Uni/FollowUp")
;;          (mu4e-hold-folder . "/Uni/Hold")
;;          (mu4e-refile-folder . "/Uni/Archived")
;;          (mu4e-sent-folder . "/Uni/sent-mail")
;;          (mu4e-trash-folder . "/Uni/Trash"))
;;       ("Arcor"
;;          (user-mail-address . "mrbauer@arcor.de")
;;          (mu4e-drafts-folder . "/Arcor/Drafts")
;;          (mu4e-follow-up-folder . "/Arcor/FollowUp")
;;          (mu4e-hold-folder . "/Arcor/Hold")
;;          (mu4e-refile-folder . "/Arcor/Archived")
;;          (mu4e-sent-folder . "/Arcor/SentMail")
;;          (mu4e-trash-folder . "/Arcor/Trash"))))

;; DELETE      
;; mu4e-multi settings--------------------------------------------------
;; mu4e-multi GTD-folder commands
;; ;; Creates `mu4e-multi-mark-for-hold' command.
;; (mu4e-multi-make-mark-for-command mu4e-hold-folder)
;; ;; Creates `mu4e-multi-mark-for-follow-up' command.
;; (mu4e-multi-make-mark-for-command mu4e-follow-up-folder)
;; ;; set marks
;; (define-key 'mu4e-headers-mode-map "h" 'mu4e-multi-mark-for-hold)
;; (define-key 'mu4e-headers-mode-map "f" 'mu4e-multi-mark-for-follow-up)

;; ;; mu4e-multi wrapper for composing
;; (global-set-key (kbd "C-x m") 'mu4e-multi-compose-new)
;; ;; msmtp integration
;; (add-hook 'message-send-mail-hook 'mu4e-multi-smtpmail-set-msmtp-account)

;; ;; enable mu4e-multi
;; (mu4e-multi-disable)
