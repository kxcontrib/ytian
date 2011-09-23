
; kdb mode for emacs with inferior buffer support
;	shortcuts: 
;	Ctrl-C q    ; start a q shell within emacs
;	Ctrl-C l    ;  send current line to the inferior q process to evaluate
;	Ctrl-C r    ;  send highlighted region to the inferior q process to evaluate
;	Ctrl-C f    ;  send the current file opened in the buffer to the inferior q process to evaluate
;	Ctrl-C s   ;  show the value of the highlighted variable in the inferior q shell
;	you can still copy and paste by swith buffers, but with the above shortcuts, hopefully you don't have to.

(require 'comint)

(defconst *Q* "/home/ytian/q/q")

(defun start-q ()
  (interactive)
  (apply 'make-comint "q" *Q* nil '())
  (delete-other-windows)
  (switch-to-buffer-other-window "*q*")
  (other-window -1))


(defun q-eval-line ()
  (interactive)
  (setq lineStr (thing-at-point 'line))
  (comint-send-string (get-buffer-process "*q*") lineStr)
  (comint-send-string (get-buffer-process "*q*") "\n" )
  (switch-to-buffer-other-window "*q*")
  (other-window -1))

(defun q-eval-symbol ()
  (interactive)
  (setq symbolStr (thing-at-point 'symbol))
  (comint-send-string (get-buffer-process "*q*") symbolStr)
  (comint-send-string (get-buffer-process "*q*") "\n" )
  (switch-to-buffer-other-window "*q*")
  (other-window -1))

(defun q-eval-region ()
  (interactive)
  (setq regionStr (buffer-substring (mark) (point)))
  (setq regionStr (mapconcat 'identity
                   (split-string regionStr "\n") ""))
  (comint-send-string (get-buffer-process "*q*") regionStr)
  (comint-send-string (get-buffer-process "*q*") "\n" )
  (switch-to-buffer-other-window "*q*")
  (other-window -1))


(defun q-eval-file ()
  (interactive)
  (setq lfileStr (concat "\\l " (buffer-file-name)))
  (comint-send-string (get-buffer-process "*q*") lfileStr)
  (comint-send-string (get-buffer-process "*q*") "\n" )
  (switch-to-buffer-other-window "*q*")
  (other-window -1))

(global-set-key (kbd "C-c q") 'start-q)
(global-set-key (kbd "C-c l") 'q-eval-line)
(global-set-key (kbd "C-c s") 'q-eval-symbol)
(global-set-key (kbd "C-c r") 'q-eval-region)
(global-set-key (kbd "C-c f") 'q-eval-file)




