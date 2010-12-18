#!/bin/bash

context integrals-context.tex
pdflatex --jobname=integrals-pdflatex integrals-latex.tex
xelatex --jobname=integrals-xelatex integrals-latex.tex
lualatex --jobname=integrals-lualatex integrals-latex.tex
