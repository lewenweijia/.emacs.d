;;; stante-markdown.el --- Stante Pede Modules: Markdown support
;;
;; Copyright (c) 2012, 2013 Sebastian Wiesner
;;
;; Author: Sebastian Wiesner <lunaryorn@gmail.com>
;; URL: https://gihub.com/lunaryorn/stante-pede.git
;; Keywords: extensions

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation; either version 3 of the License, or (at your option) any later
;; version.

;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.

;; You should have received a copy of the GNU General Public License along with
;; GNU Emacs; see the file COPYING.  If not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
;; USA.


;;; Commentary:

;; Provide support for editing and previewing markdown.
;;
;; Markdown editing is provided by `markdown-mode' from
;; https://github.com/milkypostman/markdown-mode.

;; Markdown processor
;; ------------------
;;
;; Search for the following markdown processors in `exec-path':
;;
;; - kramdown (http://kramdown.rubyforge.org/)
;; - markdown2 (https://github.com/trentm/python-markdown2)
;; - pandoc (http://johnmacfarlane.net/pandoc/index.html)
;;
;; If none of the above is found, emit a warning message and fall back to the
;; default "markdown" utility.


;;; Code:

(eval-when-compile
  (require 'markdown-mode))
(require 'stante-text)
(require 'dash)

(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))

(defvar stante-markdown-commands
  '(("kramdown")
    ("markdown2" "-x" "fenced-code-blocks")
    ("pandoc"))
  "Supported markdown commands.")

(defun stante-find-markdown-processor ()
  "Find a suitable markdown processor.

Search for a suitable markdown processor using
`stante-markdown-commands' and set `markdown-command' properly.

Return the new `markdown-command' or signal an error if no
suitable processor was found."
  (interactive)
  ;; Clear previous command
  (setq markdown-command
        (mapconcat #'shell-quote-argument
                   (--first (executable-find (car it)) stante-markdown-commands)
                   " "))
  (unless markdown-command
    (error "No markdown processor found"))
  markdown-command)

(after 'markdown-mode
  (stante-find-markdown-processor)
  ;; Disable auto-filling and highlighting of overlong lines, because line
  ;; breaks are significant in `gfm-mode'.
  (add-hook 'gfm-mode-hook 'turn-off-auto-fill)
  (add-hook 'gfm-mode-hook 'stante-whitespace-mode-no-overlong-lines))

(provide 'stante-markdown)

;;; stante-markdown.el ends here
