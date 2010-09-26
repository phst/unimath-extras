#!/bin/bash

set -e

tex unicode-math-cmds.tex
sort -f -o unicode-math-cmds.lst unicode-math-cmds.tmp
