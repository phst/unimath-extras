#!/usr/bin/env python3
#
# Copyright (c) 2010, Philipp Stephani <st_philipp@yahoo.de>
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import sys
import operator
import functools
import re
import errno
import subprocess


files = ("latex.ltx", "fontmath.ltx",
         "amsmath.sty", "amstext.sty", "amsgen.sty", "amsbsy.sty",
         "amsopn.sty", "amsfonts.sty", "amssymb.sty",
         "mathtools.sty", "mhsetup.sty")
symbol_rgx = re.compile(r"\\[A-Za-z@]+|\\[^A-Za-z@]")
public_symbol_rgx = re.compile(r"\\[A-Za-z]+|\\[^A-Za-z]")


def get_known_symbols():
    known = read_symbols("known-symbols.lst")
    public = union(map(list_public_symbols, files))
    dangerous = read_symbols("dangerous-symbols.lst")
    return (known | public) - dangerous


def get_table_symbols():
    subprocess.check_call(["tex", "extract-symbols.tex"])
    return read_symbols("table-symbols.lst")


def list_public_symbols(filename):
    path = kpsewhich(filename)
    if path is None:
        return frozenset()
    with open(path, "rt", encoding="ASCII") as stream:
        return frozenset(symbol for symbol in symbol_rgx.findall(stream.read())
                         if public_symbol_rgx.match(symbol))


def read_symbols(filename):
    try:
        with open(filename, "rt", encoding="ASCII") as stream:
            return frozenset(symbol.rstrip("\n") for symbol in stream)
    except IOError as exc:
        if exc.errno == errno.ENOENT:
            return frozenset()
        else:
            raise


def write_symbols(filename, symbols):
    with open(filename, "wt", encoding="ASCII") as stream:
        for symbol in sorted(symbols):
            stream.write(symbol + "\n")


def kpsewhich(name):
    process = subprocess.Popen(["kpsewhich", name], stdout=subprocess.PIPE)
    stdout, stderr = process.communicate()
    if process.returncode == 0:
        return stdout.decode(sys.getfilesystemencoding()).rstrip("\n")
    else:
        return None


def union(iterable):
    return functools.reduce(operator.or_, iterable)


def main():
    known_symbols = get_known_symbols()
    table_symbols = get_table_symbols()
    old_symbols = table_symbols & known_symbols
    new_symbols = table_symbols - known_symbols
    write_symbols("old-symbols.lst", old_symbols)
    write_symbols("new-symbols.lst", new_symbols)


if __name__ == "__main__":
    main()
