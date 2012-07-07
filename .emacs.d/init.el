(global-set-key (kbd "C-m") 'newline-and-indent)
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)
(define-key global-map (kbd "C-t") 'other-window)

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
(init-loader-load "~/.emacs.d/conf") ; 設定ファイルがあるディレクトリを指定

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
            (- (region-end) (region-beginning)))
    ;;これだとエコーエリアがちらつく
    ;;(count-lines-region (region-beginning) (region-end))
    ""))
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
  (color-theme-initialize)
  ;; テーマをhoberに変更
  (color-theme-hober))
  ;; asciiフォントをMenloに
  (set-face-attribute 'default nil
					  :family "Menlo"
					  :height 120)



;; (set-fontset-font
;;   nil '(#x3040 , #x30ff)
;;  (font-spec :family "NfMotoyaCedar"))

 (setq face-font-rescale-alist
	   '((".*Menlo.*" , 1.0)
		 (".*Hiragino_Mincho_Pro.*" , 1.2)
 		 (".*nfmotoyacedar-bold.*" , 1.2)
 		 (".*nfmotoyacedar-medium.*" , 1.2)
		 ("-cdac$" , 1.3)))

(defface my-hl-line-face
   ;; 背景がdarkならば背景色を紺に
  '((((class color) (background dark))
	 (:background "NavyBlue" t))
	;; 背景がlightならば背景色を緑に
	(((class color) (background light))
	 (:background "LightGoldenrodYellow" t))
	(t (:bold t)))
   "hl-line's my face")
 (setq hl-line-face 'my-hl-line-face)
 (global-hl-line-mode t)

;; paren-mode: 対応する括弧を強調して表示する
 (setq show-paren-delay 0) ;表示までの秒数。初期値は0.125
 (show-paren-mode t) ;有効化
;; parenのスタイル: expressionは括弧内も強調表示
 (setq show-paren-style 'expression)
 ;; フェイスを変更する
 (set-face-background 'show-paren-match-face nil)
 (set-face-underline-p 'show-paren-match-face "yellow")
;; バックアップとオートセーブファイルを~/.emacs.d/backups/へ集める
(add-to-list 'backup-directory-alist
			 (cons "." "~/.emacs.d/backups/"))
(setq auto-save-file-name-transforms
	  `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

;; ファイルが #! から始まる場合、+xをつけて保存する
(add-hook 'after-save-hook
		  'executable-make-buffer-file-executable-if-script-p)

;; emacs-lisp-modeのフックをセット
(add-hook 'emacs-lisp-mode-hook
		  '(lambda ()
			 (when (require 'eldoc nil t)
			   (setq eldoc-idle-delay 0.2)
			   (setq eldoc-echo-area-use-multiline-p t)
			   (turn-on-eldoc-mode))))

;; emacs-lisp-mode-hook用の関数を定義
(defun elisp-mode-hooks ()
  "lisp-mode-hooks"
  (when (require 'eldoc nil t)
	(setq eldoc-idle-delay 0.2)
	(setq eldoc-echo-area-use-multiple-p t)
	(turn-on-eldoc-mode)))

;; emacs-lisp-modeのフックをセット
 (add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)

;; auto-installの設定
 (when (require 'auto-install nil t)
   ;; インストールディレクトリを設定する 初期値は ~/.emacs.d/auto-install/
   (setq auto-install-directory "~/.emacs.d/elisp")
   ;; EmacsWikiに登録されているelispの名前を取得する
   (auto-install-update-emacswiki-package-name t)
   ;; 必要であればプロキシの設定を行う
   ;; (setq url-proxy-services '(("http" . "localhost:8339")))
   ;; install-elispの関数を利用可能にする
   (auto-install-compatibility-setup))

;; redo+の設定
 (when (require 'redo+ nil t)
  ;; C-' にredoを割り当てる
  (global-set-key (kbd "C-'") 'redo)
  ;;日本語キーボードの場合、C-. などがよいかも
  ;; (global-set-key (kbd "C-.") 'redo)
)

;; package.elの設定
 (when (require 'package nil t)
 ;; パッケージリポジトリにMarmaladeと開発者運営のELPAを追加
 (add-to-list 'package-archives
	      '("marmalade" , "http://marmalade-repo.org/packages/"))
 (add-to-list 'package-archives '("ELPA" , "http://tromey.com/elpa"))
 ;; インストールしたパッケージにロードパスを通して読み込む
 (package-initialize))
