``overwrite-safe-syms.py``
==========================

Finds out which symbols from the Unicode math table have already been defined by the LaTeX kernel or standard packages such as ``amsmath``.
These symbols can be considered safe for overwriting.
Overwriting other symbols might yield surprising results, and shouldn’t be done without warning.

The list of “safe” symbols is written to the file ``old-symbols.lst``; the list of “unsafe” symbols is written to the file ``new-symbols.lst``.
The file ``known-symbols.lst`` may contain a list of known symbols that are missed in the automatical search.

