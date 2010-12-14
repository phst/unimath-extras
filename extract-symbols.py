#!/usr/bin/env python3.1
#
# Copyright (c) 2010, Philipp Stephani
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import logging
import unicodedata
import re
import subprocess


def kpsewhich(name):
    return subprocess.check_output(["kpsewhich", name]).decode().rstrip()


class TableEntry:
    def __init__(self, cls, code):
        self.cls = cls
        self.code = code


table_line_re = re.compile(r'\\UnicodeMathSymbol\{"([0-9A-F]{5})\}'
                           r'\{(\\[A-Za-z]+)\s*\}\{\\math([a-z]+)\}')
latex_to_int_class = {"ord": "ordinary",
                      "op": "operator",
                      "bin": "binary",
                      "rel": "relation",
                      "punct": "punctuation",
                      "open": "open",
                      "close": "close",
                      "alpha": "variable",
                      "accent": "accent",
                      "over": "delimiter",
                      "under": "delimiter",
                      "fence": "ordinary"}

def read_table():
    path = kpsewhich("unicode-math-table.tex")
    result = {}
    with open(path, "rt") as stream:
        for line in stream:
            if line:
                match = table_line_re.match(line)
                if match:
                    code = int(match.group(1), 16)
                    command = match.group(2)
                    cls = latex_to_int_class[match.group(3)]
                    result[command] = TableEntry(cls, code)
                else:
                    logging.warn("Unrecognized line %s", line)
    return result


def read_safe_symbols():
    with open("old-symbols.lst", "rt") as stream:
        return frozenset(line.strip() for line in stream)


def format_code(code):
    char = chr(code)
    category = unicodedata.category(char)
    if category[0] in "LNPS":
        return '"{0}"'.format(char)
    else:
        return "0x{0:04X}".format(code)


def format_lua_key(name):
    if len(name) == 2:
        return r'   ["\{0}"]'.format(name)
    else:
        return "   {0}".format(name[1:])


def format_lua_value(entry, safe):
    code = format_code(entry.code)
    if entry.cls == "ordinary" and not safe:
        return code
    else:
        lines = ['      class = "{0}"'.format(entry.cls),
                 "      char = {0}".format(code)]
        if safe:
            lines.append("      safe = true")
        return "{\n" + ",\n".join(lines) + "\n   }"


def get_code(entry):
    return entry[1].code


def write_data(table, safe_symbols):
    for key, value in sorted(table.items(), key=get_code):
        safe = key in safe_symbols
        lua_key = format_lua_key(key)
        lua_value = format_lua_value(value, safe)
        print("{0} = {1},".format(lua_key, lua_value))


def main():
    logging.basicConfig(level=logging.INFO)
    table = read_table()
    safe_symbols = read_safe_symbols()
    write_data(table, safe_symbols)


if __name__ == "__main__":
    main()
