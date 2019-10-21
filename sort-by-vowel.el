;;; sort-by-vowel.el --- sort lines by vowels in an Emacs buffer -*- lexical-binding: t -*-

;; Copyright (C) 2019 Norman Walsh

;; Author: Norman Walsh <ndw@nwalsh.com>
;; Maintainer: Norman Walsh <ndw@nwalsh.com>
;; Created: 2019-10-21
;; Version: 1.0.0
;; Keywords: sort
;; Homepage: https://github.com/ndw/sort-by-vowel

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides a (somewhat crudely implemented) function to
;; sort lines of text according to the vowels each line contains.
;; See https://twitter.com/docum3nt/status/1186247315109101569 and
;; https://twitter.com/kyleconrau/status/1186008215752007680

;;; Code:

(require 'sort)

(defvar sort-by-vowel-list '("a" "e" "i" "o" "u"))

(defun sort-by-vowel (reverse beg end)
  "Sort lines in region alphabetically by vowels; \
argument means descending order.
   Called from a program, there are three arguments:
   REVERSE (non-nil means reverse order),\
   BEG and END (region to sort).
   The variable `sort-fold-case' determines\
   whether alphabetic case affects the sort order."
  (interactive "P\nr")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (let ((inhibit-field-text-motion t))
        (sort-subr reverse 'forward-line 'end-of-line nil nil 'sbv--vowel-sort)))))

(defun sbv--vowel-sort (line1 line2)
  "Return t if LINE1 should be sorted before LINE2 \
based on the vowels in each line.
This code assumes that LINE1 and LINE2 are cons cells that refer to regions
of the current buffer."
  (let ((astr (sbv--get-vowels line1))
        (bstr (sbv--get-vowels line2)))
    (if sort-fold-case
        (string< (downcase astr) (downcase bstr))
      (string< astr bstr))))

(defun sbv--get-vowels (region)
  "Return the vowels in REGION.
This code assumes that REGION is a cons cell that refers to a region
of the current buffer. What constitutes a vowel is determined by
the characters in sort-by-vowel-list."
  (let ((vowels "")
        (char "")
        (pos (car region)))
    (while (< pos (cdr region))
      (progn
        (setq char (buffer-substring-no-properties pos (1+ pos)))
        (if (member (downcase char) sort-by-vowel-list)
            (setq vowels (concat vowels char)))
        (setq pos (1+ pos))))
    vowels))

(provide 'sort-by-vowel)

;;; sort-by-vowel.el ends here
