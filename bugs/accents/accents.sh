#!/bin/bash

context accents-context.tex
pdflatex --jobname=accents-pdflatex accents-latex.tex
xelatex --jobname=accents-xelatex accents-latex.tex
lualatex --jobname=accents-lualatex accents-latex.tex
