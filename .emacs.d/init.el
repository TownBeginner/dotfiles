;; loa-pathを追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((defaultly-directory
               (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のサブディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

(require 'init-loader)
(init-loader-load "~/.emacs.d/conf") ; 設定ファイルがあるディレクトリを指定e

(global-set-key (kbd "C-m") 'newline-and-indent)
(global-set-key (kbd "C-c l") 'toggle-truncate-lines)
(global-set-key (kbd "C-t") 'other-window)
(add-to-list 'exec-path "/opt/local/bin")
(add-to-list 'exec-path "/usr/local/bin")
(setq mac-command-key-is-meta t)
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))
(column-number-mode t)
;;ファイルサイズを表示
(size-indication-mode t)
;;時計を表示
;; (setq display-time-day-and-date t) ;曜日・月・日を表示
;; (setq display-time-24hr-format t) ;24時表示
(display-time-mode t)
;; バッテリー残量を表示
(display-battery-mode t)

;;リージョン内の行数と文字数をモードラインに表示する(範囲指定時のみ)
;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
(defun count-lines-and-chars ()
  (if mark-active
    (format "%d lines,%d chars "
            (count-lines (region-beginning) (region-end))
            (- (region-end) (region-beginning))))
(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))
(setq frame-title-format "%f")
(global-linum-mode t)
(setq-default tab-width 4)
(add-hook 'c-mode-common-hook
		  (lambda ()
			(c-set-style "bsd")))
(set-face-background 'region "darkgreen")
(when (require 'color-theme nil t)
  (color-theme-initialize))
