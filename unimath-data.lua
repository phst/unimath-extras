module("unimath.data")

-- Tables that map the fixed style commands to internal style names.  The keys
-- are TeX command names (without leading backslash), the values are either
-- strings containing valid Lua names or tables with members "name" and "safe".
families = {
   mathup = "upright",
   mathrm = {
      name = "text_upright",
      safe = true
   },
   mathbfup = "text_bold",
   mathit = {
      name = "text_italic",
      safe = true
   }
}

mappings = {
   mathliteral = "literal",
   mathbbit = "doublestruck_italic",
   boldsymbol = "bold",
   mathnormal = {
      name = "italic",
      safe = true
   },
   mathbfit = "bold_italic",
   mathscr = "script",
   mathbfscr = "script_bold",
   mathfrak = "fraktur",
   mathbb = "doublestruck",
   mathbffrak = "fraktur_bold",
   mathsfup = "sansserif",
   mathbfsfup = "sansserif_bold",
   mathsfit = "sansserif_italic",
   mathbfsfit = "sansserif_bold_italic",
   mathtt = {
      name = "monospace",
      safe = true
   },
   mathcal = {
      name = "calligraphic",
      safe = true
   }
}

-- The default family, mapping, and style
default_family = "upright"
default_mapping = "literal"
default_style = "upright"

-- Table that maps characters and commands to Unicode math definitions.  The
-- keys are either strings consisting of a single character, numbers denoting
-- Unicode scalar values, or strings denoting TeX control sequence names (with
-- or without leading backslash), which represent either the mathematical codes
-- of characters or mathematical character definitions, henceforth collectively
-- called “entities.”  One-letter control sequence names must be distinguished
-- from one-string characters by prefixing them with a backslash.
--
-- Let ε be the entity described by a certain key in the table, and let ζ be
-- the corresponding value.  Then one and only one of the following rules must
-- be fulfilled:
--
-- 1.  ζ is a table which contains an entry whose key is the string "class" and
--     whose value is one of the strings "ordinary", "binary", "relation", and
--     "punctuation" and an entry whose key is the string "char" and whose
--     value is either a string consisting of a single character or a number
--     denoting a Unicode scalar value.  Let φ be the family denoted by
--     ζ.family or, if that is nil, by the module variable default_family.  If
--     ε is a character code, ζ.delimiter may be nil, a Boolean value, a string
--     consisting of a single character, or a number denoting a Unicode scalar
--     value; if it is true, let δ = ε; if it is a string consisting of a
--     single character, or a number denoting a Unicode scalar value, let δ =
--     ζ.delimiter; otherwise let δ = −1.  Then the entity ε will be defined
--     having the class denoted by ζ.class, the family φ, the mathematical code
--     denoted by ζ.char, and, if applicable, the demimiter code denoted by δ.
--
-- 2.  ζ is either a string consisting of a single character or a number
--     denoting a Unicode scalar value.  Then rule 1 is applied as if ζ were a
--     table containing an entry whose key were the string "class" and whose
--     value were the string "ordinary" and an entry whose key were the string
--     "char" and whose value were ζ.
--
-- 3.  ε is a character code, and ζ is a table which contains an entry whose key
--     is the string "class" and whose value is one of the strings "ordinary",
--     "binary", "relation", and "punctuation", but no entry whose key is the
--     string "char".  Then rule 1 is applied as if ζ.char were equal to the
--     character denoted by ε.
--
-- 4.  ε is a character code, and ζ is one of the strings "ordinary", "binary",
--     "relation", and "punctuation".  Then rule 1 is applied as if ζ were a
--     table containing an entry whose key were the string "class" and whose
--     value were ζ and an entry whose key were the string "char" and whose
--     value were equal to the character denoted by ε.
--
-- 5.  ε is a character code, and ζ is true.  Then rule 1 is applied as if ζ
--     were a table containing an entry whose key were the string "class" and
--     whose value were the string "ordinary" and an entry whose key were the
--     string "char" and whose value were equal to the character denoted by ε.
--
-- 6.  ζ is a table, and ζ.class is the string "operator".  Let φ be the family
--     denoted by ζ.family or, if that is nil, by the module variable
--     default_family.  Either ε must be a character code, or ζ.char must be a
--     string consisting of a single character or a number denoting a Unicode
--     scalar value.  Let μ be the character code denoted by ζ.char or, if that
--     is nil, the character code denoted by ε.  ζ.limits must be either nil or
--     one of the strings "never", "always", "display", "name", "sum",
--     "integral".  Let λ be ζ.limits or, if that is nil, the string "display".
--     Then ε is to be defined as a mathematical character with class 1
--     (operator), family φ, character code μ and limit specification λ, or a
--     macro expanding to such a character.
--
-- 7.  ε is a character code, and ζ is the string "operator".  Then rule 6 is
--     applied as if ζ were a table containing an entry whose key were the
--     string "class" and whose value were "operator" and an entry whose key
--     were the string "char" and whose value were equal to the character
--     denoted by ε.
--
-- 8.  ζ is a table, and ζ.class is one of the strings "open" or "close".  Let φ
--     be the family denoted by ζ.family or, if that is nil, by the module
--     variable default_family.  Either ε must be a character code, or ζ.char
--     must be a string consisting of a single character or a number denoting a
--     Unicode scalar value.  Let μ be the character code denoted by ζ.char or,
--     if that is nil, the character code denoted by ε.  ζ.delimiter must be
--     either nil or the number −1 or a string consisting of a single character
--     or a number denoting a Unicode scalar value.  If ζ.delimiter is nil, let
--     δ be the scalar value denoted by ε; if ζ.delimiter is the number −1, let
--     δ be −1; otherwise let δ be the scalar value denoted by ζ.delimiter.
--     Then ε is to be defined as a mathematical character with class ζ.class,
--     family φ, character code μ and delimiter code δ.
--
-- 9.  ε is a character code, and ζ is one of the strings "open" or "close".
--     Then rule 8 is applied as if ζ were a table containing an entry whose
--     key were the string "class" and whose value were ζ and an entry whose
--     key were the string "char" and whose value were equal to the character
--     denoted by ε.
--
-- 10. ζ is a table, and ζ.class is the string "variable".  Let σ be the style
--     denoted by ζ.style or, if that is nil, by the module variable
--     default_style.  If ζ.defer is true, then ζ.alphabet must be a string
--     which is a valid Lua name.  ζ.chars must be a table; each key in this
--     table must refer to a valid style name as defined in the module level
--     families and mappings tables, and each value must be a string consisting
--     of a single character or a number denoting a Unicode scalar value.
--     Then, for each style–code pair, ε is to be defined as a mathematical
--     character with class 7 (variable), with the default style being σ.  If
--     ζ.defer is true, the definition is deferred until a call to
--     \unimathsetup.
--
-- 11. ε is a character definition, ζ is a table, and ζ.class is the string
--     "accent".  ζ must contain at least one of the keys "top" and "bottom",
--     and they must, if present, map to a string consisting of a single
--     character or a number denoting a Unicode scalar value.  If the key "top"
--     is present, ζ may further contain a key "top_stretch" which must map to
--     a Boolean value.  If the key "bottom" is present, ζ may further contain
--     a key "bottom_stretch" which must map to a Boolean value.  Then ε is to
--     be defined as a macro expanding to a mathematical accent primitive which
--     typesets the top accent denoted by the "top" value (if any) and the
--     bottom accent denoted by the "bottom" value (if any), with
--     stretchability according to the corresponding "…_stretch" values or
--     false if not present.
--
-- 12. ε is a character definition, ζ is a table, and ζ.class is the string
--     "delimiter".
--
-- In addition of these mandatory rules, any number of the following optional
-- rules may hold:
--
-- * ε is a character definition, ζ is a table, and ζ.safe is true.  Then the
--   entity ε is assumed to be safe for overwriting.
characters = {
   -- hand-made ASCII symbols
   ["!"] = "punctuation",
   ['"'] = "ordinary",
   ["'"] = "ordinary",
   ["("] = "open",
   [")"] = "close",
   ["*"] = "binary",
   ["+"] = "binary",
   [","] = "punctuation",
   ["-"] = {
      class = "binary",
      char = "−"
   },
   ["."] = "ordinary",
   ["/"] = {
      class = "ordinary",
      delimiter = true
   },
   ["0"] = {
      class = "variable",
      style = "upright",
      chars = {
         upright = "0",
         doublestruck = "𝟘",
         sansserif = "𝟢",
         bold = "𝟬",
         monospace = "𝟶"
      }
   },
   ["1"] = {
      class = "variable",
      style = "upright",
      chars = {
         upright = "1",
         doublestruck = "𝟙",
         sansserif = "𝟣",
         bold = "𝟭",
         monospace = "𝟷"
      }
   },
   ["2"] = {
      class = "variable",
      style = "upright",
      chars = {
         upright = "2",
         doublestruck = "𝟚",
         sansserif = "𝟤",
         bold = "𝟮",
         monospace = "𝟸"
      }
   },
   ["3"] = {
      class = "variable",
      style = "upright",
      chars = {
         upright = "3",
         doublestruck = "𝟛",
         sansserif = "𝟥",
         bold = "𝟯",
         monospace = "𝟹"
      }
   },
   ["4"] = {
      class = "variable",
      style = "upright",
      chars = {
         upright = "4",
         doublestruck = "𝟜",
         sansserif = "𝟦",
         bold = "𝟰",
         monospace = "𝟺"
      }
   },
   ["5"] = {
      class = "variable",
      style = "upright",
      chars = {
         upright = "5",
         doublestruck = "𝟝",
         sansserif = "𝟧",
         bold = "𝟱",
         monospace = "𝟻"
      }
   },
   ["6"] = {
      class = "variable",
      style = "upright",
      chars = {
         upright = "6",
         doublestruck = "𝟞",
         sansserif = "𝟨",
         bold = "𝟲",
         monospace = "𝟼"
      }
   },
   ["7"] = {
      class = "variable",
      style = "upright",
      chars = {
         upright = "7",
         doublestruck = "𝟟",
         sansserif = "𝟩",
         bold = "𝟳",
         monospace = "𝟽"
      }
   },
   ["8"] = {
      class = "variable",
      style = "upright",
      chars = {
         upright = "8",
         doublestruck = "𝟠",
         sansserif = "𝟪",
         bold = "𝟴",
         monospace = "𝟾"
      }
   },
   ["9"] = {
      class = "variable",
      style = "upright",
      chars = {
         upright = "9",
         doublestruck = "𝟡",
         sansserif = "𝟫",
         bold = "𝟵",
         monospace = "𝟿"
      }
   },
   [":"] = "relation",
   colon = {
      class = "punctuation",
      char = ":"
   },
   [";"] = "punctuation",
   ["<"] = {
      class = "relation",
      delimiter = "⟨"
   },
   ["="] = "relation",
   [">"] = {
      class = "relation",
      delimiter = "⟩"
   },
   ["?"] = "punctuation",
   ["@"] = "ordinary",
   -- partially auto-generated Latin letters
   A = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "A",
         bold = "𝐀",
         italic = "𝐴",
         bold_italic = "𝑨",
         script = "𝒜",
         script_bold = "𝓐",
         fraktur = "𝔄",
         doublestruck = "𝔸",
         fraktur_bold = "𝕬",
         sansserif = "𝖠",
         sansserif_bold = "𝗔",
         sansserif_italic = "𝘈",
         sansserif_bold_italic = "𝘼",
         monospace = "𝙰"
      }
   },
   B = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "B",
         bold = "𝐁",
         italic = "𝐵",
         bold_italic = "𝑩",
         script = "ℬ",
         script_bold = "𝓑",
         fraktur = "𝔅",
         doublestruck = "𝔹",
         fraktur_bold = "𝕭",
         sansserif = "𝖡",
         sansserif_bold = "𝗕",
         sansserif_italic = "𝘉",
         sansserif_bold_italic = "𝘽",
         monospace = "𝙱"
      }
   },
   C = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "C",
         bold = "𝐂",
         italic = "𝐶",
         bold_italic = "𝑪",
         script = "𝒞",
         script_bold = "𝓒",
         fraktur = "ℭ",
         doublestruck = "ℂ",
         fraktur_bold = "𝕮",
         sansserif = "𝖢",
         sansserif_bold = "𝗖",
         sansserif_italic = "𝘊",
         sansserif_bold_italic = "𝘾",
         monospace = "𝙲"
      }
   },
   D = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "D",
         doublestruck_italic = "ⅅ",
         bold = "𝐃",
         italic = "𝐷",
         bold_italic = "𝑫",
         script = "𝒟",
         script_bold = "𝓓",
         fraktur = "𝔇",
         doublestruck = "𝔻",
         fraktur_bold = "𝕯",
         sansserif = "𝖣",
         sansserif_bold = "𝗗",
         sansserif_italic = "𝘋",
         sansserif_bold_italic = "𝘿",
         monospace = "𝙳"
      }
   },
   E = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "E",
         bold = "𝐄",
         italic = "𝐸",
         bold_italic = "𝑬",
         script = "ℰ",
         script_bold = "𝓔",
         fraktur = "𝔈",
         doublestruck = "𝔼",
         fraktur_bold = "𝕰",
         sansserif = "𝖤",
         sansserif_bold = "𝗘",
         sansserif_italic = "𝘌",
         sansserif_bold_italic = "𝙀",
         monospace = "𝙴"
      }
   },
   F = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "F",
         bold = "𝐅",
         italic = "𝐹",
         bold_italic = "𝑭",
         script = "ℱ",
         script_bold = "𝓕",
         fraktur = "𝔉",
         doublestruck = "𝔽",
         fraktur_bold = "𝕱",
         sansserif = "𝖥",
         sansserif_bold = "𝗙",
         sansserif_italic = "𝘍",
         sansserif_bold_italic = "𝙁",
         monospace = "𝙵"
      }
   },
   G = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "G",
         bold = "𝐆",
         italic = "𝐺",
         bold_italic = "𝑮",
         script = "𝒢",
         script_bold = "𝓖",
         fraktur = "𝔊",
         doublestruck = "𝔾",
         fraktur_bold = "𝕲",
         sansserif = "𝖦",
         sansserif_bold = "𝗚",
         sansserif_italic = "𝘎",
         sansserif_bold_italic = "𝙂",
         monospace = "𝙶"
      }
   },
   H = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "H",
         bold = "𝐇",
         italic = "𝐻",
         bold_italic = "𝑯",
         script = "ℋ",
         script_bold = "𝓗",
         fraktur = "ℌ",
         doublestruck = "ℍ",
         fraktur_bold = "𝕳",
         sansserif = "𝖧",
         sansserif_bold = "𝗛",
         sansserif_italic = "𝘏",
         sansserif_bold_italic = "𝙃",
         monospace = "𝙷"
      }
   },
   I = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "I",
         bold = "𝐈",
         italic = "𝐼",
         bold_italic = "𝑰",
         script = "ℐ",
         script_bold = "𝓘",
         fraktur = "ℑ",
         doublestruck = "𝕀",
         fraktur_bold = "𝕴",
         sansserif = "𝖨",
         sansserif_bold = "𝗜",
         sansserif_italic = "𝘐",
         sansserif_bold_italic = "𝙄",
         monospace = "𝙸"
      }
   },
   J = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "J",
         bold = "𝐉",
         italic = "𝐽",
         bold_italic = "𝑱",
         script = "𝒥",
         script_bold = "𝓙",
         fraktur = "𝔍",
         doublestruck = "𝕁",
         fraktur_bold = "𝕵",
         sansserif = "𝖩",
         sansserif_bold = "𝗝",
         sansserif_italic = "𝘑",
         sansserif_bold_italic = "𝙅",
         monospace = "𝙹"
      }
   },
   K = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "K",
         bold = "𝐊",
         italic = "𝐾",
         bold_italic = "𝑲",
         script = "𝒦",
         script_bold = "𝓚",
         fraktur = "𝔎",
         doublestruck = "𝕂",
         fraktur_bold = "𝕶",
         sansserif = "𝖪",
         sansserif_bold = "𝗞",
         sansserif_italic = "𝘒",
         sansserif_bold_italic = "𝙆",
         monospace = "𝙺"
      }
   },
   L = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "L",
         bold = "𝐋",
         italic = "𝐿",
         bold_italic = "𝑳",
         script = "ℒ",
         script_bold = "𝓛",
         fraktur = "𝔏",
         doublestruck = "𝕃",
         fraktur_bold = "𝕷",
         sansserif = "𝖫",
         sansserif_bold = "𝗟",
         sansserif_italic = "𝘓",
         sansserif_bold_italic = "𝙇",
         monospace = "𝙻"
      }
   },
   M = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "M",
         bold = "𝐌",
         italic = "𝑀",
         bold_italic = "𝑴",
         script = "ℳ",
         script_bold = "𝓜",
         fraktur = "𝔐",
         doublestruck = "𝕄",
         fraktur_bold = "𝕸",
         sansserif = "𝖬",
         sansserif_bold = "𝗠",
         sansserif_italic = "𝘔",
         sansserif_bold_italic = "𝙈",
         monospace = "𝙼"
      }
   },
   N = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "N",
         bold = "𝐍",
         italic = "𝑁",
         bold_italic = "𝑵",
         script = "𝒩",
         script_bold = "𝓝",
         fraktur = "𝔑",
         doublestruck = "ℕ",
         fraktur_bold = "𝕹",
         sansserif = "𝖭",
         sansserif_bold = "𝗡",
         sansserif_italic = "𝘕",
         sansserif_bold_italic = "𝙉",
         monospace = "𝙽"
      }
   },
   O = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "O",
         bold = "𝐎",
         italic = "𝑂",
         bold_italic = "𝑶",
         script = "𝒪",
         script_bold = "𝓞",
         fraktur = "𝔒",
         doublestruck = "𝕆",
         fraktur_bold = "𝕺",
         sansserif = "𝖮",
         sansserif_bold = "𝗢",
         sansserif_italic = "𝘖",
         sansserif_bold_italic = "𝙊",
         monospace = "𝙾"
      }
   },
   P = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "P",
         bold = "𝐏",
         italic = "𝑃",
         bold_italic = "𝑷",
         script = "𝒫",
         script_bold = "𝓟",
         fraktur = "𝔓",
         doublestruck = "ℙ",
         fraktur_bold = "𝕻",
         sansserif = "𝖯",
         sansserif_bold = "𝗣",
         sansserif_italic = "𝘗",
         sansserif_bold_italic = "𝙋",
         monospace = "𝙿"
      }
   },
   Q = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "Q",
         bold = "𝐐",
         italic = "𝑄",
         bold_italic = "𝑸",
         script = "𝒬",
         script_bold = "𝓠",
         fraktur = "𝔔",
         doublestruck = "ℚ",
         fraktur_bold = "𝕼",
         sansserif = "𝖰",
         sansserif_bold = "𝗤",
         sansserif_italic = "𝘘",
         sansserif_bold_italic = "𝙌",
         monospace = "𝚀"
      }
   },
   R = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "R",
         bold = "𝐑",
         italic = "𝑅",
         bold_italic = "𝑹",
         script = "ℛ",
         script_bold = "𝓡",
         fraktur = "ℜ",
         doublestruck = "ℝ",
         fraktur_bold = "𝕽",
         sansserif = "𝖱",
         sansserif_bold = "𝗥",
         sansserif_italic = "𝘙",
         sansserif_bold_italic = "𝙍",
         monospace = "𝚁"
      }
   },
   S = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "S",
         bold = "𝐒",
         italic = "𝑆",
         bold_italic = "𝑺",
         script = "𝒮",
         script_bold = "𝓢",
         fraktur = "𝔖",
         doublestruck = "𝕊",
         fraktur_bold = "𝕾",
         sansserif = "𝖲",
         sansserif_bold = "𝗦",
         sansserif_italic = "𝘚",
         sansserif_bold_italic = "𝙎",
         monospace = "𝚂"
      }
   },
   T = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "T",
         bold = "𝐓",
         italic = "𝑇",
         bold_italic = "𝑻",
         script = "𝒯",
         script_bold = "𝓣",
         fraktur = "𝔗",
         doublestruck = "𝕋",
         fraktur_bold = "𝕿",
         sansserif = "𝖳",
         sansserif_bold = "𝗧",
         sansserif_italic = "𝘛",
         sansserif_bold_italic = "𝙏",
         monospace = "𝚃"
      }
   },
   U = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "U",
         bold = "𝐔",
         italic = "𝑈",
         bold_italic = "𝑼",
         script = "𝒰",
         script_bold = "𝓤",
         fraktur = "𝔘",
         doublestruck = "𝕌",
         fraktur_bold = "𝖀",
         sansserif = "𝖴",
         sansserif_bold = "𝗨",
         sansserif_italic = "𝘜",
         sansserif_bold_italic = "𝙐",
         monospace = "𝚄"
      }
   },
   V = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "V",
         bold = "𝐕",
         italic = "𝑉",
         bold_italic = "𝑽",
         script = "𝒱",
         script_bold = "𝓥",
         fraktur = "𝔙",
         doublestruck = "𝕍",
         fraktur_bold = "𝖁",
         sansserif = "𝖵",
         sansserif_bold = "𝗩",
         sansserif_italic = "𝘝",
         sansserif_bold_italic = "𝙑",
         monospace = "𝚅"
      }
   },
   W = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "W",
         bold = "𝐖",
         italic = "𝑊",
         bold_italic = "𝑾",
         script = "𝒲",
         script_bold = "𝓦",
         fraktur = "𝔚",
         doublestruck = "𝕎",
         fraktur_bold = "𝖂",
         sansserif = "𝖶",
         sansserif_bold = "𝗪",
         sansserif_italic = "𝘞",
         sansserif_bold_italic = "𝙒",
         monospace = "𝚆"
      }
   },
   X = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "X",
         bold = "𝐗",
         italic = "𝑋",
         bold_italic = "𝑿",
         script = "𝒳",
         script_bold = "𝓧",
         fraktur = "𝔛",
         doublestruck = "𝕏",
         fraktur_bold = "𝖃",
         sansserif = "𝖷",
         sansserif_bold = "𝗫",
         sansserif_italic = "𝘟",
         sansserif_bold_italic = "𝙓",
         monospace = "𝚇"
      }
   },
   Y = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "Y",
         bold = "𝐘",
         italic = "𝑌",
         bold_italic = "𝒀",
         script = "𝒴",
         script_bold = "𝓨",
         fraktur = "𝔜",
         doublestruck = "𝕐",
         fraktur_bold = "𝖄",
         sansserif = "𝖸",
         sansserif_bold = "𝗬",
         sansserif_italic = "𝘠",
         sansserif_bold_italic = "𝙔",
         monospace = "𝚈"
      }
   },
   Z = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_capital",
      chars = {
         upright = "Z",
         bold = "𝐙",
         italic = "𝑍",
         bold_italic = "𝒁",
         script = "𝒵",
         script_bold = "𝓩",
         fraktur = "ℨ",
         doublestruck = "ℤ",
         fraktur_bold = "𝖅",
         sansserif = "𝖹",
         sansserif_bold = "𝗭",
         sansserif_italic = "𝘡",
         sansserif_bold_italic = "𝙕",
         monospace = "𝚉"
      }
   },
   ["["] = "open",
   lbrack = {
      class = "open",
      char = "[",
      safe = true
   },
   backslash = {
      class = "ordinary",
      char = "\\",
      safe = true
   },
   ["]"] = "close",
   rbrack = {
      class = "close",
      char = "]",
      safe = "true"
   },
   a = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "a",
         bold = "𝐚",
         italic = "𝑎",
         bold_italic = "𝒂",
         script = "𝒶",
         script_bold = "𝓪",
         fraktur = "𝔞",
         doublestruck = "𝕒",
         fraktur_bold = "𝖆",
         sansserif = "𝖺",
         sansserif_bold = "𝗮",
         sansserif_italic = "𝘢",
         sansserif_bold_italic = "𝙖",
         monospace = "𝚊"
      }
   },
   b = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "b",
         bold = "𝐛",
         italic = "𝑏",
         bold_italic = "𝒃",
         script = "𝒷",
         script_bold = "𝓫",
         fraktur = "𝔟",
         doublestruck = "𝕓",
         fraktur_bold = "𝖇",
         sansserif = "𝖻",
         sansserif_bold = "𝗯",
         sansserif_italic = "𝘣",
         sansserif_bold_italic = "𝙗",
         monospace = "𝚋"
      }
   },
   c = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "c",
         bold = "𝐜",
         italic = "𝑐",
         bold_italic = "𝒄",
         script = "𝒸",
         script_bold = "𝓬",
         fraktur = "𝔠",
         doublestruck = "𝕔",
         fraktur_bold = "𝖈",
         sansserif = "𝖼",
         sansserif_bold = "𝗰",
         sansserif_italic = "𝘤",
         sansserif_bold_italic = "𝙘",
         monospace = "𝚌"
      }
   },
   d = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "d",
         doublestruck_italic = "ⅆ",
         bold = "𝐝",
         italic = "𝑑",
         bold_italic = "𝒅",
         script = "𝒹",
         script_bold = "𝓭",
         fraktur = "𝔡",
         doublestruck = "𝕕",
         fraktur_bold = "𝖉",
         sansserif = "𝖽",
         sansserif_bold = "𝗱",
         sansserif_italic = "𝘥",
         sansserif_bold_italic = "𝙙",
         monospace = "𝚍"
      }
   },
   e = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "e",
         doublestruck_italic = "ⅇ",
         bold = "𝐞",
         italic = "𝑒",
         bold_italic = "𝒆",
         script = "ℯ",
         script_bold = "𝓮",
         fraktur = "𝔢",
         doublestruck = "𝕖",
         fraktur_bold = "𝖊",
         sansserif = "𝖾",
         sansserif_bold = "𝗲",
         sansserif_italic = "𝘦",
         sansserif_bold_italic = "𝙚",
         monospace = "𝚎"
      }
   },
   f = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "f",
         bold = "𝐟",
         italic = "𝑓",
         bold_italic = "𝒇",
         script = "𝒻",
         script_bold = "𝓯",
         fraktur = "𝔣",
         doublestruck = "𝕗",
         fraktur_bold = "𝖋",
         sansserif = "𝖿",
         sansserif_bold = "𝗳",
         sansserif_italic = "𝘧",
         sansserif_bold_italic = "𝙛",
         monospace = "𝚏"
      }
   },
   g = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "g",
         bold = "𝐠",
         italic = "𝑔",
         bold_italic = "𝒈",
         script = "ℊ",
         script_bold = "𝓰",
         fraktur = "𝔤",
         doublestruck = "𝕘",
         fraktur_bold = "𝖌",
         sansserif = "𝗀",
         sansserif_bold = "𝗴",
         sansserif_italic = "𝘨",
         sansserif_bold_italic = "𝙜",
         monospace = "𝚐"
      }
   },
   h = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "h",
         bold = "𝐡",
         italic = "ℎ",
         bold_italic = "𝒉",
         script = "𝒽",
         script_bold = "𝓱",
         fraktur = "𝔥",
         doublestruck = "𝕙",
         fraktur_bold = "𝖍",
         sansserif = "𝗁",
         sansserif_bold = "𝗵",
         sansserif_italic = "𝘩",
         sansserif_bold_italic = "𝙝",
         monospace = "𝚑"
      }
   },
   i = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "i",
         doublestruck_italic = "ⅈ",
         bold = "𝐢",
         italic = "𝑖",
         bold_italic = "𝒊",
         script = "𝒾",
         script_bold = "𝓲",
         fraktur = "𝔦",
         doublestruck = "𝕚",
         fraktur_bold = "𝖎",
         sansserif = "𝗂",
         sansserif_bold = "𝗶",
         sansserif_italic = "𝘪",
         sansserif_bold_italic = "𝙞",
         monospace = "𝚒"
      }
   },
   j = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "j",
         doublestruck_italic = "ⅉ",
         bold = "𝐣",
         italic = "𝑗",
         bold_italic = "𝒋",
         script = "𝒿",
         script_bold = "𝓳",
         fraktur = "𝔧",
         doublestruck = "𝕛",
         fraktur_bold = "𝖏",
         sansserif = "𝗃",
         sansserif_bold = "𝗷",
         sansserif_italic = "𝘫",
         sansserif_bold_italic = "𝙟",
         monospace = "𝚓"
      }
   },
   k = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "k",
         bold = "𝐤",
         italic = "𝑘",
         bold_italic = "𝒌",
         script = "𝓀",
         script_bold = "𝓴",
         fraktur = "𝔨",
         doublestruck = "𝕜",
         fraktur_bold = "𝖐",
         sansserif = "𝗄",
         sansserif_bold = "𝗸",
         sansserif_italic = "𝘬",
         sansserif_bold_italic = "𝙠",
         monospace = "𝚔"
      }
   },
   l = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "l",
         bold = "𝐥",
         italic = "𝑙",
         bold_italic = "𝒍",
         script = "𝓁",
         script_bold = "𝓵",
         fraktur = "𝔩",
         doublestruck = "𝕝",
         fraktur_bold = "𝖑",
         sansserif = "𝗅",
         sansserif_bold = "𝗹",
         sansserif_italic = "𝘭",
         sansserif_bold_italic = "𝙡",
         monospace = "𝚕"
      }
   },
   m = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "m",
         bold = "𝐦",
         italic = "𝑚",
         bold_italic = "𝒎",
         script = "𝓂",
         script_bold = "𝓶",
         fraktur = "𝔪",
         doublestruck = "𝕞",
         fraktur_bold = "𝖒",
         sansserif = "𝗆",
         sansserif_bold = "𝗺",
         sansserif_italic = "𝘮",
         sansserif_bold_italic = "𝙢",
         monospace = "𝚖"
      }
   },
   n = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "n",
         bold = "𝐧",
         italic = "𝑛",
         bold_italic = "𝒏",
         script = "𝓃",
         script_bold = "𝓷",
         fraktur = "𝔫",
         doublestruck = "𝕟",
         fraktur_bold = "𝖓",
         sansserif = "𝗇",
         sansserif_bold = "𝗻",
         sansserif_italic = "𝘯",
         sansserif_bold_italic = "𝙣",
         monospace = "𝚗"
      }
   },
   o = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "o",
         bold = "𝐨",
         italic = "𝑜",
         bold_italic = "𝒐",
         script = "ℴ",
         script_bold = "𝓸",
         fraktur = "𝔬",
         doublestruck = "𝕠",
         fraktur_bold = "𝖔",
         sansserif = "𝗈",
         sansserif_bold = "𝗼",
         sansserif_italic = "𝘰",
         sansserif_bold_italic = "𝙤",
         monospace = "𝚘"
      }
   },
   p = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "p",
         bold = "𝐩",
         italic = "𝑝",
         bold_italic = "𝒑",
         script = "𝓅",
         script_bold = "𝓹",
         fraktur = "𝔭",
         doublestruck = "𝕡",
         fraktur_bold = "𝖕",
         sansserif = "𝗉",
         sansserif_bold = "𝗽",
         sansserif_italic = "𝘱",
         sansserif_bold_italic = "𝙥",
         monospace = "𝚙"
      }
   },
   q = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "q",
         bold = "𝐪",
         italic = "𝑞",
         bold_italic = "𝒒",
         script = "𝓆",
         script_bold = "𝓺",
         fraktur = "𝔮",
         doublestruck = "𝕢",
         fraktur_bold = "𝖖",
         sansserif = "𝗊",
         sansserif_bold = "𝗾",
         sansserif_italic = "𝘲",
         sansserif_bold_italic = "𝙦",
         monospace = "𝚚"
      }
   },
   r = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "r",
         bold = "𝐫",
         italic = "𝑟",
         bold_italic = "𝒓",
         script = "𝓇",
         script_bold = "𝓻",
         fraktur = "𝔯",
         doublestruck = "𝕣",
         fraktur_bold = "𝖗",
         sansserif = "𝗋",
         sansserif_bold = "𝗿",
         sansserif_italic = "𝘳",
         sansserif_bold_italic = "𝙧",
         monospace = "𝚛"
      }
   },
   s = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "s",
         bold = "𝐬",
         italic = "𝑠",
         bold_italic = "𝒔",
         script = "𝓈",
         script_bold = "𝓼",
         fraktur = "𝔰",
         doublestruck = "𝕤",
         fraktur_bold = "𝖘",
         sansserif = "𝗌",
         sansserif_bold = "𝘀",
         sansserif_italic = "𝘴",
         sansserif_bold_italic = "𝙨",
         monospace = "𝚜"
      }
   },
   t = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "t",
         bold = "𝐭",
         italic = "𝑡",
         bold_italic = "𝒕",
         script = "𝓉",
         script_bold = "𝓽",
         fraktur = "𝔱",
         doublestruck = "𝕥",
         fraktur_bold = "𝖙",
         sansserif = "𝗍",
         sansserif_bold = "𝘁",
         sansserif_italic = "𝘵",
         sansserif_bold_italic = "𝙩",
         monospace = "𝚝"
      }
   },
   u = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "u",
         bold = "𝐮",
         italic = "𝑢",
         bold_italic = "𝒖",
         script = "𝓊",
         script_bold = "𝓾",
         fraktur = "𝔲",
         doublestruck = "𝕦",
         fraktur_bold = "𝖚",
         sansserif = "𝗎",
         sansserif_bold = "𝘂",
         sansserif_italic = "𝘶",
         sansserif_bold_italic = "𝙪",
         monospace = "𝚞"
      }
   },
   v = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "v",
         bold = "𝐯",
         italic = "𝑣",
         bold_italic = "𝒗",
         script = "𝓋",
         script_bold = "𝓿",
         fraktur = "𝔳",
         doublestruck = "𝕧",
         fraktur_bold = "𝖛",
         sansserif = "𝗏",
         sansserif_bold = "𝘃",
         sansserif_italic = "𝘷",
         sansserif_bold_italic = "𝙫",
         monospace = "𝚟"
      }
   },
   w = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "w",
         bold = "𝐰",
         italic = "𝑤",
         bold_italic = "𝒘",
         script = "𝓌",
         script_bold = "𝔀",
         fraktur = "𝔴",
         doublestruck = "𝕨",
         fraktur_bold = "𝖜",
         sansserif = "𝗐",
         sansserif_bold = "𝘄",
         sansserif_italic = "𝘸",
         sansserif_bold_italic = "𝙬",
         monospace = "𝚠"
      }
   },
   x = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "x",
         bold = "𝐱",
         italic = "𝑥",
         bold_italic = "𝒙",
         script = "𝓍",
         script_bold = "𝔁",
         fraktur = "𝔵",
         doublestruck = "𝕩",
         fraktur_bold = "𝖝",
         sansserif = "𝗑",
         sansserif_bold = "𝘅",
         sansserif_italic = "𝘹",
         sansserif_bold_italic = "𝙭",
         monospace = "𝚡"
      }
   },
   y = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "y",
         bold = "𝐲",
         italic = "𝑦",
         bold_italic = "𝒚",
         script = "𝓎",
         script_bold = "𝔂",
         fraktur = "𝔶",
         doublestruck = "𝕪",
         fraktur_bold = "𝖞",
         sansserif = "𝗒",
         sansserif_bold = "𝘆",
         sansserif_italic = "𝘺",
         sansserif_bold_italic = "𝙮",
         monospace = "𝚢"
      }
   },
   z = {
      class = "variable",
      style = "italic",
      defer = true,
      alphabet = "latin_small",
      chars = {
         upright = "z",
         bold = "𝐳",
         italic = "𝑧",
         bold_italic = "𝒛",
         script = "𝓏",
         script_bold = "𝔃",
         fraktur = "𝔷",
         doublestruck = "𝕫",
         fraktur_bold = "𝖟",
         sansserif = "𝗓",
         sansserif_bold = "𝘇",
         sansserif_italic = "𝘻",
         sansserif_bold_italic = "𝙯",
         monospace = "𝚣"
      }
   },
   ["\\{"] = {
      class = "open",
      char = "{"
   },
   lbrace = {
      class = "open",
      char = "{"
   },
   ["|"] = {
      class = "relation",
      delimiter = true
   },
   mid = {
      class = "relation",
      char = "|"
   },
   ["\\}"] = {
      class = "close",
      char = "}"
   },
   lbrace = {
      class = "close",
      char = "}"
   },
   ["×"] = "binary",
   times = {
      class = "binary",
      char = "×"
   },
   narrowhat = {
      class = "accent",
      top = 0x0302
   },
   widehat = {
      class = "accent",
      top = 0x0302,
      top_stretch = true
   },
   narrowleftharpoon = {
      class = "accent",
      top = 0x20D0
   },
   wideleftharpoon = {
      class = "accent",
      top = 0x20D0,
      top_stretch = true
   },
   sum = {
      class = "operator",
      char = "∑",
      limits = "sum"
   },
   -- partially auto-generated symbols from math table
   exclam = {
      class = "punctuation",
      char = "!"
   },
   octothorpe = "#",
   mathdollar = {
      class = "ordinary",
      char = "$",
      safe = true
   },
   percent = "%",
   ampersand = "&",
   lparen = {
      class = "open",
      char = "(",
      safe = true
   },
   rparen = {
      class = "close",
      char = ")",
      safe = true
   },
   plus = {
      class = "binary",
      char = "+"
   },
   comma = {
      class = "punctuation",
      char = ","
   },
   period = {
      class = "variable",
      char = "."
   },
   mathslash = "/",
   mathcolon = {
      class = "punctuation",
      char = ":"
   },
   semicolon = {
      class = "punctuation",
      char = ";"
   },
   less = {
      class = "relation",
      char = "<"
   },
   equal = {
      class = "relation",
      char = "="
   },
   greater = {
      class = "relation",
      char = ">"
   },
   question = "?",
   atsign = "@",
   lbrack = {
      class = "open",
      char = "[",
      safe = true
   },
   backslash = {
      class = "ordinary",
      char = "\\",
      safe = true
   },
   rbrack = {
      class = "close",
      char = "]",
      safe = true
   },
   lbrace = {
      class = "open",
      char = "{",
      safe = true
   },
   vert = {
      class = "ordinary",
      char = "|",
      safe = true
   },
   rbrace = {
      class = "close",
      char = "}",
      safe = true
   },
   sterling = "£",
   yen = {
      class = "ordinary",
      char = "¥",
      safe = true
   },
   neg = {
      class = "ordinary",
      char = "¬",
      safe = true
   },
   pm = {
      class = "binary",
      char = "±",
      safe = true
   },
   cdotp = {
      class = "binary",
      char = "·",
      safe = true
   },
   times = {
      class = "binary",
      char = "×",
      safe = true
   },
   matheth = {
      class = "variable",
      char = "ð"
   },
   div = {
      class = "binary",
      char = "÷",
      safe = true
   },
   Zbar = "Ƶ",
   grave = {
      class = "accent",
      char = 0x0300,
      safe = true
   },
   acute = {
      class = "accent",
      char = 0x0301,
      safe = true
   },
   hat = {
      class = "accent",
      char = 0x0302,
      safe = true
   },
   tilde = {
      class = "accent",
      char = 0x0303,
      safe = true
   },
   bar = {
      class = "accent",
      char = 0x0304,
      safe = true
   },
   overbar = {
      class = "accent",
      char = 0x0305
   },
   breve = {
      class = "accent",
      char = 0x0306,
      safe = true
   },
   dot = {
      class = "accent",
      char = 0x0307,
      safe = true
   },
   ddot = {
      class = "accent",
      char = 0x0308,
      safe = true
   },
   ovhook = {
      class = "accent",
      char = 0x0309
   },
   ocirc = {
      class = "accent",
      char = 0x030A
   },
   check = {
      class = "accent",
      char = 0x030C,
      safe = true
   },
   candra = {
      class = "accent",
      char = 0x0310
   },
   oturnedcomma = {
      class = "accent",
      char = 0x0312
   },
   ocommatopright = {
      class = "accent",
      char = 0x0315
   },
   droang = {
      class = "accent",
      char = 0x031A
   },
   wideutilde = {
      class = "accent",
      char = 0x0330
   },
   underbar = {
      class = "accent",
      char = 0x0331,
      safe = true
   },
   ["not"] = {
      class = "accent",
      char = 0x0338,
      safe = true
   },
   upAlpha = {
      class = "variable",
      char = "Α"
   },
   upBeta = {
      class = "variable",
      char = "Β"
   },
   upGamma = {
      class = "variable",
      char = "Γ"
   },
   upDelta = {
      class = "variable",
      char = "Δ"
   },
   upEpsilon = {
      class = "variable",
      char = "Ε"
   },
   upZeta = {
      class = "variable",
      char = "Ζ"
   },
   upEta = {
      class = "variable",
      char = "Η"
   },
   upTheta = {
      class = "variable",
      char = "Θ"
   },
   upIota = {
      class = "variable",
      char = "Ι"
   },
   upKappa = {
      class = "variable",
      char = "Κ"
   },
   upLambda = {
      class = "variable",
      char = "Λ"
   },
   upMu = {
      class = "variable",
      char = "Μ"
   },
   upNu = {
      class = "variable",
      char = "Ν"
   },
   upXi = {
      class = "variable",
      char = "Ξ"
   },
   upOmicron = {
      class = "variable",
      char = "Ο"
   },
   upPi = {
      class = "variable",
      char = "Π"
   },
   upRho = {
      class = "variable",
      char = "Ρ"
   },
   upSigma = {
      class = "variable",
      char = "Σ"
   },
   upTau = {
      class = "variable",
      char = "Τ"
   },
   upPhi = {
      class = "variable",
      char = "Φ"
   },
   upChi = {
      class = "variable",
      char = "Χ"
   },
   upPsi = {
      class = "variable",
      char = "Ψ"
   },
   upOmega = {
      class = "variable",
      char = "Ω"
   },
   upalpha = {
      class = "variable",
      char = "α"
   },
   upbeta = {
      class = "variable",
      char = "β"
   },
   upgamma = {
      class = "variable",
      char = "γ"
   },
   updelta = {
      class = "variable",
      char = "δ"
   },
   upepsilon = {
      class = "variable",
      char = "ε"
   },
   upzeta = {
      class = "variable",
      char = "ζ"
   },
   upeta = {
      class = "variable",
      char = "η"
   },
   uptheta = {
      class = "variable",
      char = "θ"
   },
   upiota = {
      class = "variable",
      char = "ι"
   },
   upkappa = {
      class = "variable",
      char = "κ"
   },
   uplambda = {
      class = "variable",
      char = "λ"
   },
   upmu = {
      class = "variable",
      char = "μ"
   },
   upnu = {
      class = "variable",
      char = "ν"
   },
   upxi = {
      class = "variable",
      char = "ξ"
   },
   upomicron = {
      class = "variable",
      char = "ο"
   },
   uppi = {
      class = "variable",
      char = "π"
   },
   uprho = {
      class = "variable",
      char = "ρ"
   },
   upvarsigma = {
      class = "variable",
      char = "ς"
   },
   upsigma = {
      class = "variable",
      char = "σ"
   },
   uptau = {
      class = "variable",
      char = "τ"
   },
   upupsilon = {
      class = "variable",
      char = "υ"
   },
   upvarphi = {
      class = "variable",
      char = "φ"
   },
   upchi = {
      class = "variable",
      char = "χ"
   },
   uppsi = {
      class = "variable",
      char = "ψ"
   },
   upomega = {
      class = "variable",
      char = "ω"
   },
   upvarbeta = {
      class = "variable",
      char = "ϐ"
   },
   upvartheta = {
      class = "variable",
      char = "ϑ"
   },
   upUpsilon = {
      class = "variable",
      char = "ϒ"
   },
   upphi = {
      class = "variable",
      char = "ϕ"
   },
   upvarpi = {
      class = "variable",
      char = "ϖ"
   },
   upoldKoppa = "Ϙ",
   upoldkoppa = "ϙ",
   upStigma = {
      class = "variable",
      char = "Ϛ"
   },
   upstigma = {
      class = "variable",
      char = "ϛ"
   },
   upDigamma = {
      class = "variable",
      char = "Ϝ"
   },
   updigamma = {
      class = "variable",
      char = "ϝ"
   },
   upKoppa = {
      class = "variable",
      char = "Ϟ"
   },
   upkoppa = {
      class = "variable",
      char = "ϟ"
   },
   upSampi = {
      class = "variable",
      char = "Ϡ"
   },
   upsampi = {
      class = "variable",
      char = "ϡ"
   },
   upvarkappa = {
      class = "variable",
      char = "ϰ"
   },
   upvarrho = {
      class = "variable",
      char = "ϱ"
   },
   upvarTheta = {
      class = "variable",
      char = "ϴ"
   },
   upvarepsilon = {
      class = "variable",
      char = "ϵ"
   },
   upbackepsilon = "϶",
   horizbar = "―",
   Vert = {
      class = "ordinary",
      char = "‖",
      safe = true
   },
   twolowline = "‗",
   dagger = {
      class = "binary",
      char = "†",
      safe = true
   },
   ddagger = {
      class = "binary",
      char = "‡",
      safe = true
   },
   smblkcircle = {
      class = "binary",
      char = "•"
   },
   enleadertwodots = "‥",
   unicodeellipsis = "…",
   prime = {
      class = "ordinary",
      char = "′",
      safe = true
   },
   dprime = "″",
   trprime = "‴",
   backprime = {
      class = "ordinary",
      char = "‵",
      safe = true
   },
   backdprime = "‶",
   backtrprime = "‷",
   caretinsert = "‸",
   Exclam = "‼",
   tieconcat = {
      class = "binary",
      char = "⁀"
   },
   hyphenbullet = "⁃",
   fracslash = {
      class = "binary",
      char = "⁄"
   },
   Question = "⁇",
   closure = {
      class = "relation",
      char = "⁐"
   },
   qprime = "⁗",
   euro = "€",
   leftharpoonaccent = {
      class = "accent",
      char = 0x20D0
   },
   rightharpoonaccent = {
      class = "accent",
      char = 0x20D1
   },
   vertoverlay = {
      class = "accent",
      char = 0x20D2
   },
   overleftarrow = {
      class = "accent",
      char = 0x20D6,
      safe = true
   },
   vec = {
      class = "accent",
      char = 0x20D7,
      safe = true
   },
   dddot = {
      class = "accent",
      char = 0x20DB,
      safe = true
   },
   ddddot = {
      class = "accent",
      char = 0x20DC,
      safe = true
   },
   enclosecircle = 0x20DD,
   enclosesquare = 0x20DE,
   enclosediamond = 0x20DF,
   overleftrightarrow = {
      class = "accent",
      char = 0x20E1,
      safe = true
   },
   enclosetriangle = 0x20E4,
   annuity = {
      class = "accent",
      char = 0x20E7
   },
   threeunderdot = {
      class = "accent",
      char = 0x20E8
   },
   widebridgeabove = {
      class = "accent",
      char = 0x20E9
   },
   underrightharpoondown = {
      class = "accent",
      char = 0x20EC
   },
   underleftharpoondown = {
      class = "accent",
      char = 0x20ED
   },
   underleftarrow = {
      class = "accent",
      char = 0x20EE,
      safe = true
   },
   underrightarrow = {
      class = "accent",
      char = 0x20EF,
      safe = true
   },
   asteraccent = {
      class = "accent",
      char = 0x20F0
   },
   BbbC = {
      class = "variable",
      char = "ℂ"
   },
   Eulerconst = "ℇ",
   mscrg = {
      class = "variable",
      char = "ℊ"
   },
   mscrH = {
      class = "variable",
      char = "ℋ"
   },
   mfrakH = {
      class = "variable",
      char = "ℌ"
   },
   BbbH = {
      class = "variable",
      char = "ℍ"
   },
   Planckconst = "ℎ",
   hslash = {
      class = "variable",
      char = "ℏ",
      safe = true
   },
   mscrI = {
      class = "variable",
      char = "ℐ"
   },
   Im = {
      class = "variable",
      char = "ℑ",
      safe = true
   },
   mscrL = {
      class = "variable",
      char = "ℒ"
   },
   ell = {
      class = "variable",
      char = "ℓ",
      safe = true
   },
   BbbN = {
      class = "variable",
      char = "ℕ"
   },
   wp = {
      class = "variable",
      char = "℘",
      safe = true
   },
   BbbP = {
      class = "variable",
      char = "ℙ"
   },
   BbbQ = {
      class = "variable",
      char = "ℚ"
   },
   mscrR = {
      class = "variable",
      char = "ℛ"
   },
   Re = {
      class = "variable",
      char = "ℜ",
      safe = true
   },
   BbbR = {
      class = "variable",
      char = "ℝ"
   },
   BbbZ = {
      class = "variable",
      char = "ℤ"
   },
   mho = {
      class = "ordinary",
      char = "℧",
      safe = true
   },
   mfrakZ = {
      class = "variable",
      char = "ℨ"
   },
   turnediota = {
      class = "variable",
      char = "℩"
   },
   Angstrom = {
      class = "variable",
      char = "Å"
   },
   mscrB = {
      class = "variable",
      char = "ℬ"
   },
   mfrakC = {
      class = "variable",
      char = "ℭ"
   },
   mscre = {
      class = "variable",
      char = "ℯ"
   },
   mscrE = {
      class = "variable",
      char = "ℰ"
   },
   mscrF = {
      class = "variable",
      char = "ℱ"
   },
   Finv = {
      class = "ordinary",
      char = "Ⅎ",
      safe = true
   },
   mscrM = {
      class = "variable",
      char = "ℳ"
   },
   mscro = {
      class = "variable",
      char = "ℴ"
   },
   aleph = {
      class = "variable",
      char = "ℵ",
      safe = true
   },
   beth = {
      class = "variable",
      char = "ℶ",
      safe = true
   },
   gimel = {
      class = "variable",
      char = "ℷ",
      safe = true
   },
   daleth = {
      class = "variable",
      char = "ℸ",
      safe = true
   },
   Bbbpi = "ℼ",
   Bbbgamma = {
      class = "variable",
      char = "ℽ"
   },
   BbbGamma = {
      class = "variable",
      char = "ℾ"
   },
   BbbPi = {
      class = "variable",
      char = "ℿ"
   },
   Bbbsum = {
      class = "operator",
      char = "⅀"
   },
   Game = {
      class = "ordinary",
      char = "⅁",
      safe = true
   },
   sansLturned = "⅂",
   sansLmirrored = "⅃",
   Yup = "⅄",
   mitBbbD = "ⅅ",
   mitBbbd = "ⅆ",
   mitBbbe = "ⅇ",
   mitBbbi = "ⅈ",
   mitBbbj = "ⅉ",
   PropertyLine = "⅊",
   upand = {
      class = "binary",
      char = "⅋"
   },
   leftarrow = {
      class = "relation",
      char = "←",
      safe = true
   },
   uparrow = {
      class = "relation",
      char = "↑",
      safe = true
   },
   rightarrow = {
      class = "relation",
      char = "→",
      safe = true
   },
   downarrow = {
      class = "relation",
      char = "↓",
      safe = true
   },
   leftrightarrow = {
      class = "relation",
      char = "↔",
      safe = true
   },
   updownarrow = {
      class = "relation",
      char = "↕",
      safe = true
   },
   nwarrow = {
      class = "relation",
      char = "↖",
      safe = true
   },
   nearrow = {
      class = "relation",
      char = "↗",
      safe = true
   },
   searrow = {
      class = "relation",
      char = "↘",
      safe = true
   },
   swarrow = {
      class = "relation",
      char = "↙",
      safe = true
   },
   nleftarrow = {
      class = "relation",
      char = "↚",
      safe = true
   },
   nrightarrow = {
      class = "relation",
      char = "↛",
      safe = true
   },
   leftwavearrow = {
      class = "relation",
      char = "↜"
   },
   rightwavearrow = {
      class = "relation",
      char = "↝"
   },
   twoheadleftarrow = {
      class = "relation",
      char = "↞",
      safe = true
   },
   twoheaduparrow = {
      class = "relation",
      char = "↟"
   },
   twoheadrightarrow = {
      class = "relation",
      char = "↠",
      safe = true
   },
   twoheaddownarrow = {
      class = "relation",
      char = "↡"
   },
   leftarrowtail = {
      class = "relation",
      char = "↢",
      safe = true
   },
   rightarrowtail = {
      class = "relation",
      char = "↣",
      safe = true
   },
   mapsfrom = {
      class = "relation",
      char = "↤"
   },
   mapsup = {
      class = "relation",
      char = "↥"
   },
   mapsto = {
      class = "relation",
      char = "↦",
      safe = true
   },
   mapsdown = {
      class = "relation",
      char = "↧"
   },
   updownarrowbar = "↨",
   hookleftarrow = {
      class = "relation",
      char = "↩",
      safe = true
   },
   hookrightarrow = {
      class = "relation",
      char = "↪",
      safe = true
   },
   looparrowleft = {
      class = "relation",
      char = "↫",
      safe = true
   },
   looparrowright = {
      class = "relation",
      char = "↬",
      safe = true
   },
   leftrightsquigarrow = {
      class = "relation",
      char = "↭",
      safe = true
   },
   nleftrightarrow = {
      class = "relation",
      char = "↮",
      safe = true
   },
   downzigzagarrow = {
      class = "relation",
      char = "↯"
   },
   Lsh = {
      class = "relation",
      char = "↰",
      safe = true
   },
   Rsh = {
      class = "relation",
      char = "↱",
      safe = true
   },
   Ldsh = {
      class = "relation",
      char = "↲"
   },
   Rdsh = {
      class = "relation",
      char = "↳"
   },
   linefeed = "↴",
   carriagereturn = "↵",
   curvearrowleft = {
      class = "relation",
      char = "↶",
      safe = true
   },
   curvearrowright = {
      class = "relation",
      char = "↷",
      safe = true
   },
   barovernorthwestarrow = "↸",
   barleftarrowrightarrowba = "↹",
   acwopencirclearrow = "↺",
   cwopencirclearrow = "↻",
   leftharpoonup = {
      class = "relation",
      char = "↼",
      safe = true
   },
   leftharpoondown = {
      class = "relation",
      char = "↽",
      safe = true
   },
   upharpoonright = {
      class = "relation",
      char = "↾",
      safe = true
   },
   upharpoonleft = {
      class = "relation",
      char = "↿",
      safe = true
   },
   rightharpoonup = {
      class = "relation",
      char = "⇀",
      safe = true
   },
   rightharpoondown = {
      class = "relation",
      char = "⇁",
      safe = true
   },
   downharpoonright = {
      class = "relation",
      char = "⇂",
      safe = true
   },
   downharpoonleft = {
      class = "relation",
      char = "⇃",
      safe = true
   },
   rightleftarrows = {
      class = "relation",
      char = "⇄",
      safe = true
   },
   updownarrows = {
      class = "relation",
      char = "⇅"
   },
   leftrightarrows = {
      class = "relation",
      char = "⇆",
      safe = true
   },
   leftleftarrows = {
      class = "relation",
      char = "⇇",
      safe = true
   },
   upuparrows = {
      class = "relation",
      char = "⇈",
      safe = true
   },
   rightrightarrows = {
      class = "relation",
      char = "⇉",
      safe = true
   },
   downdownarrows = {
      class = "relation",
      char = "⇊",
      safe = true
   },
   leftrightharpoons = {
      class = "relation",
      char = "⇋",
      safe = true
   },
   rightleftharpoons = {
      class = "relation",
      char = "⇌",
      safe = true
   },
   nLeftarrow = {
      class = "relation",
      char = "⇍",
      safe = true
   },
   nLeftrightarrow = {
      class = "relation",
      char = "⇎",
      safe = true
   },
   nRightarrow = {
      class = "relation",
      char = "⇏",
      safe = true
   },
   Leftarrow = {
      class = "relation",
      char = "⇐",
      safe = true
   },
   Uparrow = {
      class = "relation",
      char = "⇑",
      safe = true
   },
   Rightarrow = {
      class = "relation",
      char = "⇒",
      safe = true
   },
   Downarrow = {
      class = "relation",
      char = "⇓",
      safe = true
   },
   Leftrightarrow = {
      class = "relation",
      char = "⇔",
      safe = true
   },
   Updownarrow = {
      class = "relation",
      char = "⇕",
      safe = true
   },
   Nwarrow = {
      class = "relation",
      char = "⇖"
   },
   Nearrow = {
      class = "relation",
      char = "⇗"
   },
   Searrow = {
      class = "relation",
      char = "⇘"
   },
   Swarrow = {
      class = "relation",
      char = "⇙"
   },
   Lleftarrow = {
      class = "relation",
      char = "⇚",
      safe = true
   },
   Rrightarrow = {
      class = "relation",
      char = "⇛",
      safe = true
   },
   leftsquigarrow = {
      class = "relation",
      char = "⇜"
   },
   rightsquigarrow = {
      class = "relation",
      char = "⇝",
      safe = true
   },
   nHuparrow = "⇞",
   nHdownarrow = "⇟",
   leftdasharrow = "⇠",
   updasharrow = "⇡",
   rightdasharrow = "⇢",
   downdasharrow = "⇣",
   barleftarrow = {
      class = "relation",
      char = "⇤"
   },
   rightarrowbar = {
      class = "relation",
      char = "⇥"
   },
   leftwhitearrow = "⇦",
   upwhitearrow = "⇧",
   rightwhitearrow = "⇨",
   downwhitearrow = "⇩",
   whitearrowupfrombar = "⇪",
   circleonrightarrow = {
      class = "relation",
      char = "⇴"
   },
   downuparrows = {
      class = "relation",
      char = "⇵"
   },
   rightthreearrows = {
      class = "relation",
      char = "⇶"
   },
   nvleftarrow = {
      class = "relation",
      char = "⇷"
   },
   nvrightarrow = {
      class = "relation",
      char = "⇸"
   },
   nvleftrightarrow = {
      class = "relation",
      char = "⇹"
   },
   nVleftarrow = {
      class = "relation",
      char = "⇺"
   },
   nVrightarrow = {
      class = "relation",
      char = "⇻"
   },
   nVleftrightarrow = {
      class = "relation",
      char = "⇼"
   },
   leftarrowtriangle = {
      class = "relation",
      char = "⇽"
   },
   rightarrowtriangle = {
      class = "relation",
      char = "⇾"
   },
   leftrightarrowtriangle = {
      class = "relation",
      char = "⇿"
   },
   forall = {
      class = "ordinary",
      char = "∀",
      safe = true
   },
   complement = {
      class = "ordinary",
      char = "∁",
      safe = true
   },
   partial = {
      class = "ordinary",
      char = "∂",
      safe = true
   },
   exists = {
      class = "ordinary",
      char = "∃",
      safe = true
   },
   nexists = {
      class = "ordinary",
      char = "∄",
      safe = true
   },
   varnothing = {
      class = "ordinary",
      char = "∅",
      safe = true
   },
   increment = "∆",
   nabla = {
      class = "ordinary",
      char = "∇",
      safe = true
   },
   ["in"] = {
      class = "relation",
      char = "∈",
      safe = true
   },
   notin = {
      class = "relation",
      char = "∉",
      safe = true
   },
   smallin = {
      class = "relation",
      char = "∊"
   },
   ni = {
      class = "relation",
      char = "∋",
      safe = true
   },
   nni = {
      class = "relation",
      char = "∌"
   },
   smallni = {
      class = "relation",
      char = "∍"
   },
   QED = "∎",
   prod = {
      class = "operator",
      char = "∏",
      safe = true
   },
   coprod = {
      class = "operator",
      char = "∐",
      safe = true
   },
   sum = {
      class = "operator",
      char = "∑",
      safe = true
   },
   minus = {
      class = "binary",
      char = "−"
   },
   mp = {
      class = "binary",
      char = "∓",
      safe = true
   },
   dotplus = {
      class = "binary",
      char = "∔",
      safe = true
   },
   divslash = {
      class = "binary",
      char = "∕"
   },
   smallsetminus = {
      class = "binary",
      char = "∖",
      safe = true
   },
   ast = {
      class = "binary",
      char = "∗",
      safe = true
   },
   vysmwhtcircle = {
      class = "binary",
      char = "∘"
   },
   vysmblkcircle = {
      class = "binary",
      char = "∙"
   },
   sqrt = {
      class = "open",
      char = "√",
      safe = true
   },
   cuberoot = {
      class = "open",
      char = "∛"
   },
   fourthroot = {
      class = "open",
      char = "∜"
   },
   propto = {
      class = "relation",
      char = "∝",
      safe = true
   },
   infty = {
      class = "ordinary",
      char = "∞",
      safe = true
   },
   rightangle = "∟",
   angle = {
      class = "ordinary",
      char = "∠",
      safe = true
   },
   measuredangle = {
      class = "ordinary",
      char = "∡",
      safe = true
   },
   sphericalangle = {
      class = "ordinary",
      char = "∢",
      safe = true
   },
   mid = {
      class = "relation",
      char = "∣",
      safe = true
   },
   nmid = {
      class = "relation",
      char = "∤",
      safe = true
   },
   parallel = {
      class = "relation",
      char = "∥",
      safe = true
   },
   nparallel = {
      class = "relation",
      char = "∦",
      safe = true
   },
   wedge = {
      class = "binary",
      char = "∧",
      safe = true
   },
   vee = {
      class = "binary",
      char = "∨",
      safe = true
   },
   cap = {
      class = "binary",
      char = "∩",
      safe = true
   },
   cup = {
      class = "binary",
      char = "∪",
      safe = true
   },
   int = {
      class = "operator",
      char = "∫",
      safe = true
   },
   iint = {
      class = "operator",
      char = "∬",
      safe = true
   },
   iiint = {
      class = "operator",
      char = "∭",
      safe = true
   },
   oint = {
      class = "operator",
      char = "∮",
      safe = true
   },
   oiint = {
      class = "operator",
      char = "∯"
   },
   oiiint = {
      class = "operator",
      char = "∰"
   },
   intclockwise = {
      class = "operator",
      char = "∱"
   },
   varointclockwise = {
      class = "operator",
      char = "∲"
   },
   ointctrclockwise = {
      class = "operator",
      char = "∳"
   },
   therefore = {
      class = "ordinary",
      char = "∴",
      safe = true
   },
   because = {
      class = "ordinary",
      char = "∵",
      safe = true
   },
   mathratio = {
      class = "relation",
      char = "∶"
   },
   Colon = {
      class = "relation",
      char = "∷"
   },
   dotminus = {
      class = "binary",
      char = "∸"
   },
   dashcolon = {
      class = "relation",
      char = "∹"
   },
   dotsminusdots = {
      class = "relation",
      char = "∺"
   },
   kernelcontraction = {
      class = "relation",
      char = "∻"
   },
   sim = {
      class = "relation",
      char = "∼",
      safe = true
   },
   backsim = {
      class = "relation",
      char = "∽",
      safe = true
   },
   invlazys = {
      class = "binary",
      char = "∾"
   },
   sinewave = "∿",
   wr = {
      class = "binary",
      char = "≀",
      safe = true
   },
   nsim = {
      class = "relation",
      char = "≁",
      safe = true
   },
   eqsim = {
      class = "relation",
      char = "≂",
      safe = true
   },
   simeq = {
      class = "relation",
      char = "≃",
      safe = true
   },
   nsime = {
      class = "relation",
      char = "≄"
   },
   cong = {
      class = "relation",
      char = "≅",
      safe = true
   },
   simneqq = {
      class = "relation",
      char = "≆"
   },
   ncong = {
      class = "relation",
      char = "≇",
      safe = true
   },
   approx = {
      class = "relation",
      char = "≈",
      safe = true
   },
   napprox = {
      class = "relation",
      char = "≉"
   },
   approxeq = {
      class = "relation",
      char = "≊",
      safe = true
   },
   approxident = {
      class = "relation",
      char = "≋"
   },
   backcong = {
      class = "relation",
      char = "≌"
   },
   asymp = {
      class = "relation",
      char = "≍",
      safe = true
   },
   Bumpeq = {
      class = "relation",
      char = "≎",
      safe = true
   },
   bumpeq = {
      class = "relation",
      char = "≏",
      safe = true
   },
   doteq = {
      class = "relation",
      char = "≐",
      safe = true
   },
   Doteq = {
      class = "relation",
      char = "≑",
      safe = true
   },
   fallingdotseq = {
      class = "relation",
      char = "≒",
      safe = true
   },
   risingdotseq = {
      class = "relation",
      char = "≓",
      safe = true
   },
   coloneq = {
      class = "relation",
      char = "≔"
   },
   eqcolon = {
      class = "relation",
      char = "≕"
   },
   eqcirc = {
      class = "relation",
      char = "≖",
      safe = true
   },
   circeq = {
      class = "relation",
      char = "≗",
      safe = true
   },
   arceq = {
      class = "relation",
      char = "≘"
   },
   wedgeq = {
      class = "relation",
      char = "≙"
   },
   veeeq = {
      class = "relation",
      char = "≚"
   },
   stareq = {
      class = "relation",
      char = "≛"
   },
   triangleq = {
      class = "relation",
      char = "≜",
      safe = true
   },
   eqdef = {
      class = "relation",
      char = "≝"
   },
   measeq = {
      class = "relation",
      char = "≞"
   },
   questeq = {
      class = "relation",
      char = "≟"
   },
   ne = {
      class = "relation",
      char = "≠",
      safe = true
   },
   equiv = {
      class = "relation",
      char = "≡",
      safe = true
   },
   nequiv = {
      class = "relation",
      char = "≢"
   },
   Equiv = {
      class = "relation",
      char = "≣"
   },
   leq = {
      class = "relation",
      char = "≤",
      safe = true
   },
   geq = {
      class = "relation",
      char = "≥",
      safe = true
   },
   leqq = {
      class = "relation",
      char = "≦",
      safe = true
   },
   geqq = {
      class = "relation",
      char = "≧",
      safe = true
   },
   lneqq = {
      class = "relation",
      char = "≨",
      safe = true
   },
   gneqq = {
      class = "relation",
      char = "≩",
      safe = true
   },
   ll = {
      class = "relation",
      char = "≪",
      safe = true
   },
   gg = {
      class = "relation",
      char = "≫",
      safe = true
   },
   between = {
      class = "relation",
      char = "≬",
      safe = true
   },
   nasymp = {
      class = "relation",
      char = "≭"
   },
   nless = {
      class = "relation",
      char = "≮",
      safe = true
   },
   ngtr = {
      class = "relation",
      char = "≯",
      safe = true
   },
   nleq = {
      class = "relation",
      char = "≰",
      safe = true
   },
   ngeq = {
      class = "relation",
      char = "≱",
      safe = true
   },
   lesssim = {
      class = "relation",
      char = "≲",
      safe = true
   },
   gtrsim = {
      class = "relation",
      char = "≳",
      safe = true
   },
   nlesssim = {
      class = "relation",
      char = "≴"
   },
   ngtrsim = {
      class = "relation",
      char = "≵"
   },
   lessgtr = {
      class = "relation",
      char = "≶",
      safe = true
   },
   gtrless = {
      class = "relation",
      char = "≷",
      safe = true
   },
   nlessgtr = {
      class = "relation",
      char = "≸"
   },
   ngtrless = {
      class = "relation",
      char = "≹"
   },
   prec = {
      class = "relation",
      char = "≺",
      safe = true
   },
   succ = {
      class = "relation",
      char = "≻",
      safe = true
   },
   preccurlyeq = {
      class = "relation",
      char = "≼",
      safe = true
   },
   succcurlyeq = {
      class = "relation",
      char = "≽",
      safe = true
   },
   precsim = {
      class = "relation",
      char = "≾",
      safe = true
   },
   succsim = {
      class = "relation",
      char = "≿",
      safe = true
   },
   nprec = {
      class = "relation",
      char = "⊀",
      safe = true
   },
   nsucc = {
      class = "relation",
      char = "⊁",
      safe = true
   },
   subset = {
      class = "relation",
      char = "⊂",
      safe = true
   },
   supset = {
      class = "relation",
      char = "⊃",
      safe = true
   },
   nsubset = {
      class = "relation",
      char = "⊄"
   },
   nsupset = {
      class = "relation",
      char = "⊅"
   },
   subseteq = {
      class = "relation",
      char = "⊆",
      safe = true
   },
   supseteq = {
      class = "relation",
      char = "⊇",
      safe = true
   },
   nsubseteq = {
      class = "relation",
      char = "⊈",
      safe = true
   },
   nsupseteq = {
      class = "relation",
      char = "⊉",
      safe = true
   },
   subsetneq = {
      class = "relation",
      char = "⊊",
      safe = true
   },
   supsetneq = {
      class = "relation",
      char = "⊋",
      safe = true
   },
   cupleftarrow = {
      class = "binary",
      char = "⊌"
   },
   cupdot = {
      class = "binary",
      char = "⊍"
   },
   uplus = {
      class = "binary",
      char = "⊎",
      safe = true
   },
   sqsubset = {
      class = "relation",
      char = "⊏",
      safe = true
   },
   sqsupset = {
      class = "relation",
      char = "⊐",
      safe = true
   },
   sqsubseteq = {
      class = "relation",
      char = "⊑",
      safe = true
   },
   sqsupseteq = {
      class = "relation",
      char = "⊒",
      safe = true
   },
   sqcap = {
      class = "binary",
      char = "⊓",
      safe = true
   },
   sqcup = {
      class = "binary",
      char = "⊔",
      safe = true
   },
   oplus = {
      class = "binary",
      char = "⊕",
      safe = true
   },
   ominus = {
      class = "binary",
      char = "⊖",
      safe = true
   },
   otimes = {
      class = "binary",
      char = "⊗",
      safe = true
   },
   oslash = {
      class = "binary",
      char = "⊘",
      safe = true
   },
   odot = {
      class = "binary",
      char = "⊙",
      safe = true
   },
   circledcirc = {
      class = "binary",
      char = "⊚",
      safe = true
   },
   circledast = {
      class = "binary",
      char = "⊛",
      safe = true
   },
   circledequal = {
      class = "binary",
      char = "⊜"
   },
   circleddash = {
      class = "binary",
      char = "⊝",
      safe = true
   },
   boxplus = {
      class = "binary",
      char = "⊞",
      safe = true
   },
   boxminus = {
      class = "binary",
      char = "⊟",
      safe = true
   },
   boxtimes = {
      class = "binary",
      char = "⊠",
      safe = true
   },
   boxdot = {
      class = "binary",
      char = "⊡",
      safe = true
   },
   vdash = {
      class = "relation",
      char = "⊢",
      safe = true
   },
   dashv = {
      class = "relation",
      char = "⊣",
      safe = true
   },
   top = {
      class = "ordinary",
      char = "⊤",
      safe = true
   },
   bot = {
      class = "ordinary",
      char = "⊥",
      safe = true
   },
   assert = {
      class = "relation",
      char = "⊦"
   },
   models = {
      class = "relation",
      char = "⊧",
      safe = true
   },
   vDash = {
      class = "relation",
      char = "⊨",
      safe = true
   },
   Vdash = {
      class = "relation",
      char = "⊩",
      safe = true
   },
   Vvdash = {
      class = "relation",
      char = "⊪",
      safe = true
   },
   VDash = {
      class = "relation",
      char = "⊫"
   },
   nvdash = {
      class = "relation",
      char = "⊬",
      safe = true
   },
   nvDash = {
      class = "relation",
      char = "⊭",
      safe = true
   },
   nVdash = {
      class = "relation",
      char = "⊮",
      safe = true
   },
   nVDash = {
      class = "relation",
      char = "⊯",
      safe = true
   },
   prurel = {
      class = "relation",
      char = "⊰"
   },
   scurel = {
      class = "relation",
      char = "⊱"
   },
   vartriangleleft = {
      class = "relation",
      char = "⊲",
      safe = true
   },
   vartriangleright = {
      class = "relation",
      char = "⊳",
      safe = true
   },
   trianglelefteq = {
      class = "relation",
      char = "⊴",
      safe = true
   },
   trianglerighteq = {
      class = "relation",
      char = "⊵",
      safe = true
   },
   origof = {
      class = "relation",
      char = "⊶"
   },
   imageof = {
      class = "relation",
      char = "⊷"
   },
   multimap = {
      class = "relation",
      char = "⊸",
      safe = true
   },
   hermitmatrix = "⊹",
   intercal = {
      class = "binary",
      char = "⊺",
      safe = true
   },
   veebar = {
      class = "binary",
      char = "⊻",
      safe = true
   },
   barwedge = {
      class = "binary",
      char = "⊼",
      safe = true
   },
   barvee = {
      class = "binary",
      char = "⊽"
   },
   measuredrightangle = "⊾",
   varlrtriangle = "⊿",
   bigwedge = {
      class = "operator",
      char = "⋀",
      safe = true
   },
   bigvee = {
      class = "operator",
      char = "⋁",
      safe = true
   },
   bigcap = {
      class = "operator",
      char = "⋂",
      safe = true
   },
   bigcup = {
      class = "operator",
      char = "⋃",
      safe = true
   },
   smwhtdiamond = {
      class = "binary",
      char = "⋄"
   },
   cdot = {
      class = "binary",
      char = "⋅",
      safe = true
   },
   star = {
      class = "binary",
      char = "⋆",
      safe = true
   },
   divideontimes = {
      class = "binary",
      char = "⋇",
      safe = true
   },
   bowtie = {
      class = "relation",
      char = "⋈",
      safe = true
   },
   ltimes = {
      class = "binary",
      char = "⋉",
      safe = true
   },
   rtimes = {
      class = "binary",
      char = "⋊",
      safe = true
   },
   leftthreetimes = {
      class = "binary",
      char = "⋋",
      safe = true
   },
   rightthreetimes = {
      class = "binary",
      char = "⋌",
      safe = true
   },
   backsimeq = {
      class = "relation",
      char = "⋍",
      safe = true
   },
   curlyvee = {
      class = "binary",
      char = "⋎",
      safe = true
   },
   curlywedge = {
      class = "binary",
      char = "⋏",
      safe = true
   },
   Subset = {
      class = "relation",
      char = "⋐",
      safe = true
   },
   Supset = {
      class = "relation",
      char = "⋑",
      safe = true
   },
   Cap = {
      class = "binary",
      char = "⋒",
      safe = true
   },
   Cup = {
      class = "binary",
      char = "⋓",
      safe = true
   },
   pitchfork = {
      class = "relation",
      char = "⋔",
      safe = true
   },
   equalparallel = {
      class = "relation",
      char = "⋕"
   },
   lessdot = {
      class = "relation",
      char = "⋖",
      safe = true
   },
   gtrdot = {
      class = "relation",
      char = "⋗",
      safe = true
   },
   lll = {
      class = "relation",
      char = "⋘",
      safe = true
   },
   ggg = {
      class = "relation",
      char = "⋙",
      safe = true
   },
   lesseqgtr = {
      class = "relation",
      char = "⋚",
      safe = true
   },
   gtreqless = {
      class = "relation",
      char = "⋛",
      safe = true
   },
   eqless = {
      class = "relation",
      char = "⋜"
   },
   eqgtr = {
      class = "relation",
      char = "⋝"
   },
   curlyeqprec = {
      class = "relation",
      char = "⋞",
      safe = true
   },
   curlyeqsucc = {
      class = "relation",
      char = "⋟",
      safe = true
   },
   npreccurlyeq = {
      class = "relation",
      char = "⋠"
   },
   nsucccurlyeq = {
      class = "relation",
      char = "⋡"
   },
   nsqsubseteq = {
      class = "relation",
      char = "⋢"
   },
   nsqsupseteq = {
      class = "relation",
      char = "⋣"
   },
   sqsubsetneq = {
      class = "relation",
      char = "⋤"
   },
   sqsupsetneq = {
      class = "relation",
      char = "⋥"
   },
   lnsim = {
      class = "relation",
      char = "⋦",
      safe = true
   },
   gnsim = {
      class = "relation",
      char = "⋧",
      safe = true
   },
   precnsim = {
      class = "relation",
      char = "⋨",
      safe = true
   },
   succnsim = {
      class = "relation",
      char = "⋩",
      safe = true
   },
   ntriangleleft = {
      class = "relation",
      char = "⋪",
      safe = true
   },
   ntriangleright = {
      class = "relation",
      char = "⋫",
      safe = true
   },
   ntrianglelefteq = {
      class = "relation",
      char = "⋬",
      safe = true
   },
   ntrianglerighteq = {
      class = "relation",
      char = "⋭",
      safe = true
   },
   vdots = {
      class = "relation",
      char = "⋮",
      safe = true
   },
   unicodecdots = "⋯",
   adots = {
      class = "relation",
      char = "⋰"
   },
   ddots = {
      class = "relation",
      char = "⋱",
      safe = true
   },
   disin = {
      class = "relation",
      char = "⋲"
   },
   varisins = {
      class = "relation",
      char = "⋳"
   },
   isins = {
      class = "relation",
      char = "⋴"
   },
   isindot = {
      class = "relation",
      char = "⋵"
   },
   varisinobar = {
      class = "relation",
      char = "⋶"
   },
   isinobar = {
      class = "relation",
      char = "⋷"
   },
   isinvb = {
      class = "relation",
      char = "⋸"
   },
   isinE = {
      class = "relation",
      char = "⋹"
   },
   nisd = {
      class = "relation",
      char = "⋺"
   },
   varnis = {
      class = "relation",
      char = "⋻"
   },
   nis = {
      class = "relation",
      char = "⋼"
   },
   varniobar = {
      class = "relation",
      char = "⋽"
   },
   niobar = {
      class = "relation",
      char = "⋾"
   },
   bagmember = {
      class = "relation",
      char = "⋿"
   },
   diameter = "⌀",
   house = "⌂",
   varbarwedge = {
      class = "binary",
      char = "⌅"
   },
   vardoublebarwedge = {
      class = "binary",
      char = "⌆"
   },
   lceil = {
      class = "open",
      char = "⌈",
      safe = true
   },
   rceil = {
      class = "close",
      char = "⌉",
      safe = true
   },
   lfloor = {
      class = "open",
      char = "⌊",
      safe = true
   },
   rfloor = {
      class = "close",
      char = "⌋",
      safe = true
   },
   invnot = "⌐",
   sqlozenge = "⌑",
   profline = "⌒",
   profsurf = "⌓",
   viewdata = "⌗",
   turnednot = "⌙",
   ulcorner = {
      class = "open",
      char = "⌜",
      safe = true
   },
   urcorner = {
      class = "close",
      char = "⌝",
      safe = true
   },
   llcorner = {
      class = "open",
      char = "⌞",
      safe = true
   },
   lrcorner = {
      class = "close",
      char = "⌟",
      safe = true
   },
   inttop = "⌠",
   intbottom = "⌡",
   frown = {
      class = "relation",
      char = "⌢",
      safe = true
   },
   smile = {
      class = "relation",
      char = "⌣",
      safe = true
   },
   varhexagonlrbonds = "⌬",
   conictaper = "⌲",
   topbot = "⌶",
   obar = {
      class = "binary",
      char = "⌽"
   },
   APLnotslash = {
      class = "relation",
      char = "⌿"
   },
   APLnotbackslash = "⍀",
   APLboxupcaret = "⍓",
   APLboxquestion = "⍰",
   rangledownzigzagarrow = "⍼",
   hexagon = "⎔",
   lparenuend = "⎛",
   lparenextender = "⎜",
   lparenlend = "⎝",
   rparenuend = "⎞",
   rparenextender = "⎟",
   rparenlend = "⎠",
   lbrackuend = "⎡",
   lbrackextender = "⎢",
   lbracklend = "⎣",
   rbrackuend = "⎤",
   rbrackextender = "⎥",
   rbracklend = "⎦",
   lbraceuend = "⎧",
   lbracemid = "⎨",
   lbracelend = "⎩",
   vbraceextender = "⎪",
   rbraceuend = "⎫",
   rbracemid = "⎬",
   rbracelend = "⎭",
   intextender = "⎮",
   harrowextender = "⎯",
   lmoustache = {
      class = "ordinary",
      char = "⎰",
      safe = true
   },
   rmoustache = {
      class = "ordinary",
      char = "⎱",
      safe = true
   },
   sumtop = "⎲",
   sumbottom = "⎳",
   overbracket = {
      class = "delimiter",
      char = "⎴",
      safe = true
   },
   underbracket = {
      class = "delimiter",
      char = "⎵",
      safe = true
   },
   bbrktbrk = "⎶",
   sqrtbottom = "⎷",
   lvboxline = "⎸",
   rvboxline = "⎹",
   varcarriagereturn = "⏎",
   overparen = {
      class = "delimiter",
      char = "⏜"
   },
   underparen = {
      class = "delimiter",
      char = "⏝"
   },
   overbrace = {
      class = "delimiter",
      char = "⏞",
      safe = true
   },
   underbrace = {
      class = "delimiter",
      char = "⏟",
      safe = true
   },
   obrbrak = "⏠",
   ubrbrak = "⏡",
   trapezium = "⏢",
   benzenr = "⏣",
   strns = "⏤",
   fltns = "⏥",
   accurrent = "⏦",
   elinters = "⏧",
   bdtriplevdash = "┆",
   blockuphalf = "▀",
   blocklowhalf = "▄",
   blockfull = "█",
   blocklefthalf = "▌",
   blockrighthalf = "▐",
   blockqtrshaded = "░",
   blockhalfshaded = "▒",
   blockthreeqtrshaded = "▓",
   mdlgblksquare = "■",
   mdlgwhtsquare = "□",
   squoval = "▢",
   blackinwhitesquare = "▣",
   squarehfill = "▤",
   squarevfill = "▥",
   squarehvfill = "▦",
   squarenwsefill = "▧",
   squareneswfill = "▨",
   squarecrossfill = "▩",
   smblksquare = "▪",
   smwhtsquare = "▫",
   hrectangleblack = "▬",
   hrectangle = "▭",
   vrectangleblack = "▮",
   vrectangle = "▯",
   parallelogramblack = "▰",
   parallelogram = "▱",
   bigblacktriangleup = "▲",
   bigtriangleup = {
      class = "binary",
      char = "△",
      safe = true
   },
   blacktriangle = {
      class = "ordinary",
      char = "▴",
      safe = true
   },
   vartriangle = {
      class = "relation",
      char = "▵",
      safe = true
   },
   blacktriangleright = {
      class = "ordinary",
      char = "▶",
      safe = true
   },
   triangleright = {
      class = "binary",
      char = "▷",
      safe = true
   },
   smallblacktriangleright = "▸",
   smalltriangleright = "▹",
   blackpointerright = "►",
   whitepointerright = "▻",
   bigblacktriangledown = "▼",
   bigtriangledown = {
      class = "ordinary",
      char = "▽",
      safe = true
   },
   blacktriangledown = {
      class = "ordinary",
      char = "▾",
      safe = true
   },
   triangledown = {
      class = "ordinary",
      char = "▿",
      safe = true
   },
   blacktriangleleft = {
      class = "ordinary",
      char = "◀",
      safe = true
   },
   triangleleft = {
      class = "binary",
      char = "◁",
      safe = true
   },
   smallblacktriangleleft = "◂",
   smalltriangleleft = "◃",
   blackpointerleft = "◄",
   whitepointerleft = "◅",
   mdlgblkdiamond = "◆",
   mdlgwhtdiamond = "◇",
   blackinwhitediamond = "◈",
   fisheye = "◉",
   mdlgwhtlozenge = "◊",
   mdlgwhtcircle = {
      class = "binary",
      char = "○"
   },
   dottedcircle = "◌",
   circlevertfill = "◍",
   bullseye = "◎",
   mdlgblkcircle = "●",
   circlelefthalfblack = "◐",
   circlerighthalfblack = "◑",
   circlebottomhalfblack = "◒",
   circletophalfblack = "◓",
   circleurquadblack = "◔",
   blackcircleulquadwhite = "◕",
   blacklefthalfcircle = "◖",
   blackrighthalfcircle = "◗",
   inversebullet = "◘",
   inversewhitecircle = "◙",
   invwhiteupperhalfcircle = "◚",
   invwhitelowerhalfcircle = "◛",
   ularc = "◜",
   urarc = "◝",
   lrarc = "◞",
   llarc = "◟",
   topsemicircle = "◠",
   botsemicircle = "◡",
   lrblacktriangle = "◢",
   llblacktriangle = "◣",
   ulblacktriangle = "◤",
   urblacktriangle = "◥",
   smwhtcircle = "◦",
   squareleftblack = "◧",
   squarerightblack = "◨",
   squareulblack = "◩",
   squarelrblack = "◪",
   boxbar = {
      class = "binary",
      char = "◫"
   },
   trianglecdot = "◬",
   triangleleftblack = "◭",
   trianglerightblack = "◮",
   lgwhtcircle = "◯",
   squareulquad = "◰",
   squarellquad = "◱",
   squarelrquad = "◲",
   squareurquad = "◳",
   circleulquad = "◴",
   circlellquad = "◵",
   circlelrquad = "◶",
   circleurquad = "◷",
   ultriangle = "◸",
   urtriangle = "◹",
   lltriangle = "◺",
   mdwhtsquare = "◻",
   mdblksquare = "◼",
   mdsmwhtsquare = "◽",
   mdsmblksquare = "◾",
   lrtriangle = "◿",
   bigstar = {
      class = "ordinary",
      char = "★",
      safe = true
   },
   bigwhitestar = "☆",
   astrosun = "☉",
   danger = "☡",
   blacksmiley = "☻",
   sun = "☼",
   rightmoon = "☽",
   leftmoon = "☾",
   female = "♀",
   male = "♂",
   spadesuit = {
      class = "ordinary",
      char = "♠",
      safe = true
   },
   heartsuit = {
      class = "ordinary",
      char = "♡",
      safe = true
   },
   diamondsuit = {
      class = "ordinary",
      char = "♢",
      safe = true
   },
   clubsuit = {
      class = "ordinary",
      char = "♣",
      safe = true
   },
   varspadesuit = "♤",
   varheartsuit = "♥",
   vardiamondsuit = "♦",
   varclubsuit = "♧",
   quarternote = "♩",
   eighthnote = "♪",
   twonotes = "♫",
   flat = {
      class = "ordinary",
      char = "♭",
      safe = true
   },
   natural = {
      class = "ordinary",
      char = "♮",
      safe = true
   },
   sharp = {
      class = "ordinary",
      char = "♯",
      safe = true
   },
   acidfree = "♾",
   dicei = "⚀",
   diceii = "⚁",
   diceiii = "⚂",
   diceiv = "⚃",
   dicev = "⚄",
   dicevi = "⚅",
   circledrightdot = "⚆",
   circledtwodots = "⚇",
   blackcircledrightdot = "⚈",
   blackcircledtwodots = "⚉",
   Hermaphrodite = "⚥",
   mdwhtcircle = "⚪",
   mdblkcircle = "⚫",
   mdsmwhtcircle = "⚬",
   neuter = "⚲",
   checkmark = {
      class = "ordinary",
      char = "✓",
      safe = true
   },
   maltese = {
      class = "ordinary",
      char = "✠",
      safe = true
   },
   circledstar = "✪",
   varstar = "✶",
   dingasterisk = "✽",
   draftingarrow = "➛",
   threedangle = "⟀",
   whiteinwhitetriangle = "⟁",
   perp = {
      class = "relation",
      char = "⟂",
      safe = true
   },
   subsetcirc = "⟃",
   supsetcirc = "⟄",
   lbag = {
      class = "open",
      char = "⟅"
   },
   rbag = {
      class = "close",
      char = "⟆"
   },
   veedot = {
      class = "binary",
      char = "⟇"
   },
   bsolhsub = {
      class = "relation",
      char = "⟈"
   },
   suphsol = {
      class = "relation",
      char = "⟉"
   },
   longdivision = {
      class = "open",
      char = "⟌"
   },
   diamondcdot = "⟐",
   wedgedot = {
      class = "binary",
      char = "⟑"
   },
   upin = {
      class = "relation",
      char = "⟒"
   },
   pullback = {
      class = "relation",
      char = "⟓"
   },
   pushout = {
      class = "relation",
      char = "⟔"
   },
   leftouterjoin = {
      class = "operator",
      char = "⟕"
   },
   rightouterjoin = {
      class = "operator",
      char = "⟖"
   },
   fullouterjoin = {
      class = "operator",
      char = "⟗"
   },
   bigbot = {
      class = "operator",
      char = "⟘"
   },
   bigtop = {
      class = "operator",
      char = "⟙"
   },
   DashVDash = {
      class = "relation",
      char = "⟚"
   },
   dashVdash = {
      class = "relation",
      char = "⟛"
   },
   multimapinv = {
      class = "relation",
      char = "⟜"
   },
   vlongdash = {
      class = "relation",
      char = "⟝"
   },
   longdashv = {
      class = "relation",
      char = "⟞"
   },
   cirbot = {
      class = "relation",
      char = "⟟"
   },
   lozengeminus = {
      class = "binary",
      char = "⟠"
   },
   concavediamond = {
      class = "binary",
      char = "⟡"
   },
   concavediamondtickleft = {
      class = "binary",
      char = "⟢"
   },
   concavediamondtickright = {
      class = "binary",
      char = "⟣"
   },
   whitesquaretickleft = {
      class = "binary",
      char = "⟤"
   },
   whitesquaretickright = {
      class = "binary",
      char = "⟥"
   },
   lBrack = {
      class = "open",
      char = "⟦"
   },
   rBrack = {
      class = "close",
      char = "⟧"
   },
   langle = {
      class = "open",
      char = "⟨",
      safe = true
   },
   rangle = {
      class = "close",
      char = "⟩",
      safe = true
   },
   lAngle = {
      class = "open",
      char = "⟪"
   },
   rAngle = {
      class = "close",
      char = "⟫"
   },
   UUparrow = {
      class = "relation",
      char = "⟰"
   },
   DDownarrow = {
      class = "relation",
      char = "⟱"
   },
   acwgapcirclearrow = {
      class = "relation",
      char = "⟲"
   },
   cwgapcirclearrow = {
      class = "relation",
      char = "⟳"
   },
   rightarrowonoplus = {
      class = "relation",
      char = "⟴"
   },
   longleftarrow = {
      class = "relation",
      char = "⟵",
      safe = true
   },
   longrightarrow = {
      class = "relation",
      char = "⟶",
      safe = true
   },
   longleftrightarrow = {
      class = "relation",
      char = "⟷",
      safe = true
   },
   Longleftarrow = {
      class = "relation",
      char = "⟸",
      safe = true
   },
   Longrightarrow = {
      class = "relation",
      char = "⟹",
      safe = true
   },
   Longleftrightarrow = {
      class = "relation",
      char = "⟺",
      safe = true
   },
   longmapsfrom = {
      class = "relation",
      char = "⟻"
   },
   longmapsto = {
      class = "relation",
      char = "⟼",
      safe = true
   },
   Longmapsfrom = {
      class = "relation",
      char = "⟽"
   },
   Longmapsto = {
      class = "relation",
      char = "⟾"
   },
   longrightsquigarrow = {
      class = "relation",
      char = "⟿"
   },
   nvtwoheadrightarrow = {
      class = "relation",
      char = "⤀"
   },
   nVtwoheadrightarrow = {
      class = "relation",
      char = "⤁"
   },
   nvLeftarrow = {
      class = "relation",
      char = "⤂"
   },
   nvRightarrow = {
      class = "relation",
      char = "⤃"
   },
   nvLeftrightarrow = {
      class = "relation",
      char = "⤄"
   },
   twoheadmapsto = {
      class = "relation",
      char = "⤅"
   },
   Mapsfrom = {
      class = "relation",
      char = "⤆"
   },
   Mapsto = {
      class = "relation",
      char = "⤇"
   },
   downarrowbarred = {
      class = "relation",
      char = "⤈"
   },
   uparrowbarred = {
      class = "relation",
      char = "⤉"
   },
   Uuparrow = {
      class = "relation",
      char = "⤊"
   },
   Ddownarrow = {
      class = "relation",
      char = "⤋"
   },
   leftbkarrow = {
      class = "relation",
      char = "⤌"
   },
   rightbkarrow = {
      class = "relation",
      char = "⤍"
   },
   leftdbkarrow = {
      class = "relation",
      char = "⤎"
   },
   dbkarow = {
      class = "relation",
      char = "⤏"
   },
   drbkarow = {
      class = "relation",
      char = "⤐"
   },
   rightdotarrow = {
      class = "relation",
      char = "⤑"
   },
   baruparrow = {
      class = "relation",
      char = "⤒"
   },
   downarrowbar = {
      class = "relation",
      char = "⤓"
   },
   nvrightarrowtail = {
      class = "relation",
      char = "⤔"
   },
   nVrightarrowtail = {
      class = "relation",
      char = "⤕"
   },
   twoheadrightarrowtail = {
      class = "relation",
      char = "⤖"
   },
   nvtwoheadrightarrowtail = {
      class = "relation",
      char = "⤗"
   },
   nVtwoheadrightarrowtail = {
      class = "relation",
      char = "⤘"
   },
   lefttail = {
      class = "relation",
      char = "⤙"
   },
   righttail = {
      class = "relation",
      char = "⤚"
   },
   leftdbltail = {
      class = "relation",
      char = "⤛"
   },
   rightdbltail = {
      class = "relation",
      char = "⤜"
   },
   diamondleftarrow = {
      class = "relation",
      char = "⤝"
   },
   rightarrowdiamond = {
      class = "relation",
      char = "⤞"
   },
   diamondleftarrowbar = {
      class = "relation",
      char = "⤟"
   },
   barrightarrowdiamond = {
      class = "relation",
      char = "⤠"
   },
   nwsearrow = {
      class = "relation",
      char = "⤡"
   },
   neswarrow = {
      class = "relation",
      char = "⤢"
   },
   hknwarrow = {
      class = "relation",
      char = "⤣"
   },
   hknearrow = {
      class = "relation",
      char = "⤤"
   },
   hksearow = {
      class = "relation",
      char = "⤥"
   },
   hkswarow = {
      class = "relation",
      char = "⤦"
   },
   tona = {
      class = "relation",
      char = "⤧"
   },
   toea = {
      class = "relation",
      char = "⤨"
   },
   tosa = {
      class = "relation",
      char = "⤩"
   },
   towa = {
      class = "relation",
      char = "⤪"
   },
   rdiagovfdiag = "⤫",
   fdiagovrdiag = "⤬",
   seovnearrow = "⤭",
   neovsearrow = "⤮",
   fdiagovnearrow = "⤯",
   rdiagovsearrow = "⤰",
   neovnwarrow = "⤱",
   nwovnearrow = "⤲",
   rightcurvedarrow = {
      class = "relation",
      char = "⤳"
   },
   uprightcurvearrow = "⤴",
   downrightcurvedarrow = "⤵",
   leftdowncurvedarrow = {
      class = "relation",
      char = "⤶"
   },
   rightdowncurvedarrow = {
      class = "relation",
      char = "⤷"
   },
   cwrightarcarrow = {
      class = "relation",
      char = "⤸"
   },
   acwleftarcarrow = {
      class = "relation",
      char = "⤹"
   },
   acwoverarcarrow = {
      class = "relation",
      char = "⤺"
   },
   acwunderarcarrow = {
      class = "relation",
      char = "⤻"
   },
   curvearrowrightminus = {
      class = "relation",
      char = "⤼"
   },
   curvearrowleftplus = {
      class = "relation",
      char = "⤽"
   },
   cwundercurvearrow = {
      class = "relation",
      char = "⤾"
   },
   ccwundercurvearrow = {
      class = "relation",
      char = "⤿"
   },
   acwcirclearrow = {
      class = "relation",
      char = "⥀"
   },
   cwcirclearrow = {
      class = "relation",
      char = "⥁"
   },
   rightarrowshortleftarrow = {
      class = "relation",
      char = "⥂"
   },
   leftarrowshortrightarrow = {
      class = "relation",
      char = "⥃"
   },
   shortrightarrowleftarrow = {
      class = "relation",
      char = "⥄"
   },
   rightarrowplus = {
      class = "relation",
      char = "⥅"
   },
   leftarrowplus = {
      class = "relation",
      char = "⥆"
   },
   rightarrowx = {
      class = "relation",
      char = "⥇"
   },
   leftrightarrowcircle = {
      class = "relation",
      char = "⥈"
   },
   twoheaduparrowcircle = {
      class = "relation",
      char = "⥉"
   },
   leftrightharpoonupdown = {
      class = "relation",
      char = "⥊"
   },
   leftrightharpoondownup = {
      class = "relation",
      char = "⥋"
   },
   updownharpoonrightleft = {
      class = "relation",
      char = "⥌"
   },
   updownharpoonleftright = {
      class = "relation",
      char = "⥍"
   },
   leftrightharpoonupup = {
      class = "relation",
      char = "⥎"
   },
   updownharpoonrightright = {
      class = "relation",
      char = "⥏"
   },
   leftrightharpoondowndown = {
      class = "relation",
      char = "⥐"
   },
   updownharpoonleftleft = {
      class = "relation",
      char = "⥑"
   },
   barleftharpoonup = {
      class = "relation",
      char = "⥒"
   },
   rightharpoonupbar = {
      class = "relation",
      char = "⥓"
   },
   barupharpoonright = {
      class = "relation",
      char = "⥔"
   },
   downharpoonrightbar = {
      class = "relation",
      char = "⥕"
   },
   barleftharpoondown = {
      class = "relation",
      char = "⥖"
   },
   rightharpoondownbar = {
      class = "relation",
      char = "⥗"
   },
   barupharpoonleft = {
      class = "relation",
      char = "⥘"
   },
   downharpoonleftbar = {
      class = "relation",
      char = "⥙"
   },
   leftharpoonupbar = {
      class = "relation",
      char = "⥚"
   },
   barrightharpoonup = {
      class = "relation",
      char = "⥛"
   },
   upharpoonrightbar = {
      class = "relation",
      char = "⥜"
   },
   bardownharpoonright = {
      class = "relation",
      char = "⥝"
   },
   leftharpoondownbar = {
      class = "relation",
      char = "⥞"
   },
   barrightharpoondown = {
      class = "relation",
      char = "⥟"
   },
   upharpoonleftbar = {
      class = "relation",
      char = "⥠"
   },
   bardownharpoonleft = {
      class = "relation",
      char = "⥡"
   },
   leftharpoonsupdown = {
      class = "relation",
      char = "⥢"
   },
   upharpoonsleftright = {
      class = "relation",
      char = "⥣"
   },
   rightharpoonsupdown = {
      class = "relation",
      char = "⥤"
   },
   downharpoonsleftright = {
      class = "relation",
      char = "⥥"
   },
   leftrightharpoonsup = {
      class = "relation",
      char = "⥦"
   },
   leftrightharpoonsdown = {
      class = "relation",
      char = "⥧"
   },
   rightleftharpoonsup = {
      class = "relation",
      char = "⥨"
   },
   rightleftharpoonsdown = {
      class = "relation",
      char = "⥩"
   },
   leftharpoonupdash = {
      class = "relation",
      char = "⥪"
   },
   dashleftharpoondown = {
      class = "relation",
      char = "⥫"
   },
   rightharpoonupdash = {
      class = "relation",
      char = "⥬"
   },
   dashrightharpoondown = {
      class = "relation",
      char = "⥭"
   },
   updownharpoonsleftright = {
      class = "relation",
      char = "⥮"
   },
   downupharpoonsleftright = {
      class = "relation",
      char = "⥯"
   },
   rightimply = {
      class = "relation",
      char = "⥰"
   },
   equalrightarrow = {
      class = "relation",
      char = "⥱"
   },
   similarrightarrow = {
      class = "relation",
      char = "⥲"
   },
   leftarrowsimilar = {
      class = "relation",
      char = "⥳"
   },
   rightarrowsimilar = {
      class = "relation",
      char = "⥴"
   },
   rightarrowapprox = {
      class = "relation",
      char = "⥵"
   },
   ltlarr = {
      class = "relation",
      char = "⥶"
   },
   leftarrowless = {
      class = "relation",
      char = "⥷"
   },
   gtrarr = {
      class = "relation",
      char = "⥸"
   },
   subrarr = {
      class = "relation",
      char = "⥹"
   },
   leftarrowsubset = {
      class = "relation",
      char = "⥺"
   },
   suplarr = {
      class = "relation",
      char = "⥻"
   },
   leftfishtail = {
      class = "relation",
      char = "⥼"
   },
   rightfishtail = {
      class = "relation",
      char = "⥽"
   },
   upfishtail = {
      class = "relation",
      char = "⥾"
   },
   downfishtail = {
      class = "relation",
      char = "⥿"
   },
   Vvert = "⦀",
   mdsmblkcircle = "⦁",
   typecolon = {
      class = "binary",
      char = "⦂"
   },
   lBrace = {
      class = "open",
      char = "⦃"
   },
   rBrace = {
      class = "close",
      char = "⦄"
   },
   lParen = {
      class = "open",
      char = "⦅"
   },
   rParen = {
      class = "close",
      char = "⦆"
   },
   llparenthesis = {
      class = "open",
      char = "⦇"
   },
   rrparenthesis = {
      class = "close",
      char = "⦈"
   },
   llangle = {
      class = "open",
      char = "⦉"
   },
   rrangle = {
      class = "close",
      char = "⦊"
   },
   lbrackubar = {
      class = "open",
      char = "⦋"
   },
   rbrackubar = {
      class = "close",
      char = "⦌"
   },
   lbrackultick = {
      class = "open",
      char = "⦍"
   },
   rbracklrtick = {
      class = "close",
      char = "⦎"
   },
   lbracklltick = {
      class = "open",
      char = "⦏"
   },
   rbrackurtick = {
      class = "close",
      char = "⦐"
   },
   langledot = {
      class = "open",
      char = "⦑"
   },
   rangledot = {
      class = "close",
      char = "⦒"
   },
   lparenless = {
      class = "open",
      char = "⦓"
   },
   rparengtr = {
      class = "close",
      char = "⦔"
   },
   Lparengtr = {
      class = "open",
      char = "⦕"
   },
   Rparenless = {
      class = "close",
      char = "⦖"
   },
   lblkbrbrak = {
      class = "open",
      char = "⦗"
   },
   rblkbrbrak = {
      class = "close",
      char = "⦘"
   },
   fourvdots = "⦙",
   vzigzag = "⦚",
   measuredangleleft = "⦛",
   rightanglesqr = "⦜",
   rightanglemdot = "⦝",
   angles = "⦞",
   angdnr = "⦟",
   gtlpar = "⦠",
   sphericalangleup = "⦡",
   turnangle = "⦢",
   revangle = "⦣",
   angleubar = "⦤",
   revangleubar = "⦥",
   wideangledown = "⦦",
   wideangleup = "⦧",
   measanglerutone = "⦨",
   measanglelutonw = "⦩",
   measanglerdtose = "⦪",
   measangleldtosw = "⦫",
   measangleurtone = "⦬",
   measangleultonw = "⦭",
   measangledrtose = "⦮",
   measangledltosw = "⦯",
   revemptyset = "⦰",
   emptysetobar = "⦱",
   emptysetocirc = "⦲",
   emptysetoarr = "⦳",
   emptysetoarrl = "⦴",
   circlehbar = {
      class = "binary",
      char = "⦵"
   },
   circledvert = {
      class = "binary",
      char = "⦶"
   },
   circledparallel = {
      class = "binary",
      char = "⦷"
   },
   obslash = {
      class = "binary",
      char = "⦸"
   },
   operp = {
      class = "binary",
      char = "⦹"
   },
   obot = "⦺",
   olcross = "⦻",
   odotslashdot = "⦼",
   uparrowoncircle = "⦽",
   circledwhitebullet = "⦾",
   circledbullet = "⦿",
   olessthan = {
      class = "binary",
      char = "⧀"
   },
   ogreaterthan = {
      class = "binary",
      char = "⧁"
   },
   cirscir = "⧂",
   cirE = "⧃",
   boxdiag = {
      class = "binary",
      char = "⧄"
   },
   boxbslash = {
      class = "binary",
      char = "⧅"
   },
   boxast = {
      class = "binary",
      char = "⧆"
   },
   boxcircle = {
      class = "binary",
      char = "⧇"
   },
   boxbox = {
      class = "binary",
      char = "⧈"
   },
   boxonbox = "⧉",
   triangleodot = "⧊",
   triangleubar = "⧋",
   triangles = "⧌",
   triangleserifs = {
      class = "binary",
      char = "⧍"
   },
   rtriltri = {
      class = "relation",
      char = "⧎"
   },
   ltrivb = {
      class = "relation",
      char = "⧏"
   },
   vbrtri = {
      class = "relation",
      char = "⧐"
   },
   lfbowtie = {
      class = "relation",
      char = "⧑"
   },
   rfbowtie = {
      class = "relation",
      char = "⧒"
   },
   fbowtie = {
      class = "relation",
      char = "⧓"
   },
   lftimes = {
      class = "relation",
      char = "⧔"
   },
   rftimes = {
      class = "relation",
      char = "⧕"
   },
   hourglass = {
      class = "binary",
      char = "⧖"
   },
   blackhourglass = {
      class = "binary",
      char = "⧗"
   },
   lvzigzag = {
      class = "open",
      char = "⧘"
   },
   rvzigzag = {
      class = "close",
      char = "⧙"
   },
   Lvzigzag = {
      class = "open",
      char = "⧚"
   },
   Rvzigzag = {
      class = "close",
      char = "⧛"
   },
   iinfin = "⧜",
   tieinfty = "⧝",
   nvinfty = "⧞",
   dualmap = {
      class = "relation",
      char = "⧟"
   },
   laplac = "⧠",
   lrtriangleeq = {
      class = "relation",
      char = "⧡"
   },
   shuffle = {
      class = "binary",
      char = "⧢"
   },
   eparsl = {
      class = "relation",
      char = "⧣"
   },
   smeparsl = {
      class = "relation",
      char = "⧤"
   },
   eqvparsl = {
      class = "relation",
      char = "⧥"
   },
   gleichstark = {
      class = "relation",
      char = "⧦"
   },
   thermod = "⧧",
   downtriangleleftblack = "⧨",
   downtrianglerightblack = "⧩",
   blackdiamonddownarrow = "⧪",
   mdlgblklozenge = {
      class = "binary",
      char = "⧫"
   },
   circledownarrow = "⧬",
   blackcircledownarrow = "⧭",
   errbarsquare = "⧮",
   errbarblacksquare = "⧯",
   errbardiamond = "⧰",
   errbarblackdiamond = "⧱",
   errbarcircle = "⧲",
   errbarblackcircle = "⧳",
   ruledelayed = {
      class = "relation",
      char = "⧴"
   },
   setminus = {
      class = "binary",
      char = "⧵",
      safe = true
   },
   dsol = {
      class = "binary",
      char = "⧶"
   },
   rsolbar = {
      class = "binary",
      char = "⧷"
   },
   xsol = {
      class = "operator",
      char = "⧸"
   },
   xbsol = {
      class = "operator",
      char = "⧹"
   },
   doubleplus = {
      class = "binary",
      char = "⧺"
   },
   tripleplus = {
      class = "binary",
      char = "⧻"
   },
   lcurvyangle = {
      class = "open",
      char = "⧼"
   },
   rcurvyangle = {
      class = "close",
      char = "⧽"
   },
   tplus = {
      class = "binary",
      char = "⧾"
   },
   tminus = {
      class = "binary",
      char = "⧿"
   },
   bigodot = {
      class = "operator",
      char = "⨀",
      safe = true
   },
   bigoplus = {
      class = "operator",
      char = "⨁",
      safe = true
   },
   bigotimes = {
      class = "operator",
      char = "⨂",
      safe = true
   },
   bigcupdot = {
      class = "operator",
      char = "⨃"
   },
   biguplus = {
      class = "operator",
      char = "⨄",
      safe = true
   },
   bigsqcap = {
      class = "operator",
      char = "⨅"
   },
   bigsqcup = {
      class = "operator",
      char = "⨆",
      safe = true
   },
   conjquant = {
      class = "operator",
      char = "⨇"
   },
   disjquant = {
      class = "operator",
      char = "⨈"
   },
   bigtimes = {
      class = "operator",
      char = "⨉",
      safe = true
   },
   modtwosum = "⨊",
   sumint = {
      class = "operator",
      char = "⨋"
   },
   iiiint = {
      class = "operator",
      char = "⨌",
      safe = true
   },
   intbar = {
      class = "operator",
      char = "⨍"
   },
   intBar = {
      class = "operator",
      char = "⨎"
   },
   fint = {
      class = "operator",
      char = "⨏"
   },
   cirfnint = {
      class = "operator",
      char = "⨐"
   },
   awint = {
      class = "operator",
      char = "⨑"
   },
   rppolint = {
      class = "operator",
      char = "⨒"
   },
   scpolint = {
      class = "operator",
      char = "⨓"
   },
   npolint = {
      class = "operator",
      char = "⨔"
   },
   pointint = {
      class = "operator",
      char = "⨕"
   },
   sqint = {
      class = "operator",
      char = "⨖"
   },
   intlarhk = {
      class = "operator",
      char = "⨗"
   },
   intx = {
      class = "operator",
      char = "⨘"
   },
   intcap = {
      class = "operator",
      char = "⨙"
   },
   intcup = {
      class = "operator",
      char = "⨚"
   },
   upint = {
      class = "operator",
      char = "⨛"
   },
   lowint = {
      class = "operator",
      char = "⨜"
   },
   Join = {
      class = "operator",
      char = "⨝",
      safe = true
   },
   bigtriangleleft = {
      class = "operator",
      char = "⨞"
   },
   zcmp = {
      class = "operator",
      char = "⨟"
   },
   zpipe = {
      class = "operator",
      char = "⨠"
   },
   zproject = {
      class = "operator",
      char = "⨡"
   },
   ringplus = {
      class = "binary",
      char = "⨢"
   },
   plushat = {
      class = "binary",
      char = "⨣"
   },
   simplus = {
      class = "binary",
      char = "⨤"
   },
   plusdot = {
      class = "binary",
      char = "⨥"
   },
   plussim = {
      class = "binary",
      char = "⨦"
   },
   plussubtwo = {
      class = "binary",
      char = "⨧"
   },
   plustrif = {
      class = "binary",
      char = "⨨"
   },
   commaminus = {
      class = "binary",
      char = "⨩"
   },
   minusdot = {
      class = "binary",
      char = "⨪"
   },
   minusfdots = {
      class = "binary",
      char = "⨫"
   },
   minusrdots = {
      class = "binary",
      char = "⨬"
   },
   opluslhrim = {
      class = "binary",
      char = "⨭"
   },
   oplusrhrim = {
      class = "binary",
      char = "⨮"
   },
   vectimes = {
      class = "binary",
      char = "⨯"
   },
   dottimes = {
      class = "binary",
      char = "⨰"
   },
   timesbar = {
      class = "binary",
      char = "⨱"
   },
   btimes = {
      class = "binary",
      char = "⨲"
   },
   smashtimes = {
      class = "binary",
      char = "⨳"
   },
   otimeslhrim = {
      class = "binary",
      char = "⨴"
   },
   otimesrhrim = {
      class = "binary",
      char = "⨵"
   },
   otimeshat = {
      class = "binary",
      char = "⨶"
   },
   Otimes = {
      class = "binary",
      char = "⨷"
   },
   odiv = {
      class = "binary",
      char = "⨸"
   },
   triangleplus = {
      class = "binary",
      char = "⨹"
   },
   triangleminus = {
      class = "binary",
      char = "⨺"
   },
   triangletimes = {
      class = "binary",
      char = "⨻"
   },
   intprod = {
      class = "binary",
      char = "⨼"
   },
   intprodr = {
      class = "binary",
      char = "⨽"
   },
   fcmp = {
      class = "binary",
      char = "⨾"
   },
   amalg = {
      class = "binary",
      char = "⨿",
      safe = true
   },
   capdot = {
      class = "binary",
      char = "⩀"
   },
   uminus = {
      class = "binary",
      char = "⩁"
   },
   barcup = {
      class = "binary",
      char = "⩂"
   },
   barcap = {
      class = "binary",
      char = "⩃"
   },
   capwedge = {
      class = "binary",
      char = "⩄"
   },
   cupvee = {
      class = "binary",
      char = "⩅"
   },
   cupovercap = {
      class = "binary",
      char = "⩆"
   },
   capovercup = {
      class = "binary",
      char = "⩇"
   },
   cupbarcap = {
      class = "binary",
      char = "⩈"
   },
   capbarcup = {
      class = "binary",
      char = "⩉"
   },
   twocups = {
      class = "binary",
      char = "⩊"
   },
   twocaps = {
      class = "binary",
      char = "⩋"
   },
   closedvarcup = {
      class = "binary",
      char = "⩌"
   },
   closedvarcap = {
      class = "binary",
      char = "⩍"
   },
   Sqcap = {
      class = "binary",
      char = "⩎"
   },
   Sqcup = {
      class = "binary",
      char = "⩏"
   },
   closedvarcupsmashprod = {
      class = "binary",
      char = "⩐"
   },
   wedgeodot = {
      class = "binary",
      char = "⩑"
   },
   veeodot = {
      class = "binary",
      char = "⩒"
   },
   Wedge = {
      class = "binary",
      char = "⩓"
   },
   Vee = {
      class = "binary",
      char = "⩔"
   },
   wedgeonwedge = {
      class = "binary",
      char = "⩕"
   },
   veeonvee = {
      class = "binary",
      char = "⩖"
   },
   bigslopedvee = {
      class = "binary",
      char = "⩗"
   },
   bigslopedwedge = {
      class = "binary",
      char = "⩘"
   },
   veeonwedge = {
      class = "relation",
      char = "⩙"
   },
   wedgemidvert = {
      class = "binary",
      char = "⩚"
   },
   veemidvert = {
      class = "binary",
      char = "⩛"
   },
   midbarwedge = {
      class = "binary",
      char = "⩜"
   },
   midbarvee = {
      class = "binary",
      char = "⩝"
   },
   doublebarwedge = {
      class = "binary",
      char = "⩞",
      safe = true
   },
   wedgebar = {
      class = "binary",
      char = "⩟"
   },
   wedgedoublebar = {
      class = "binary",
      char = "⩠"
   },
   varveebar = {
      class = "binary",
      char = "⩡"
   },
   doublebarvee = {
      class = "binary",
      char = "⩢"
   },
   veedoublebar = {
      class = "binary",
      char = "⩣"
   },
   dsub = {
      class = "binary",
      char = "⩤"
   },
   rsub = {
      class = "binary",
      char = "⩥"
   },
   eqdot = {
      class = "relation",
      char = "⩦"
   },
   dotequiv = {
      class = "relation",
      char = "⩧"
   },
   equivVert = {
      class = "relation",
      char = "⩨"
   },
   equivVvert = {
      class = "relation",
      char = "⩩"
   },
   dotsim = {
      class = "relation",
      char = "⩪"
   },
   simrdots = {
      class = "relation",
      char = "⩫"
   },
   simminussim = {
      class = "relation",
      char = "⩬"
   },
   congdot = {
      class = "relation",
      char = "⩭"
   },
   asteq = {
      class = "relation",
      char = "⩮"
   },
   hatapprox = {
      class = "relation",
      char = "⩯"
   },
   approxeqq = {
      class = "relation",
      char = "⩰"
   },
   eqqplus = {
      class = "binary",
      char = "⩱"
   },
   pluseqq = {
      class = "binary",
      char = "⩲"
   },
   eqqsim = {
      class = "relation",
      char = "⩳"
   },
   Coloneq = {
      class = "relation",
      char = "⩴",
      safe = true
   },
   eqeq = {
      class = "relation",
      char = "⩵"
   },
   eqeqeq = {
      class = "relation",
      char = "⩶"
   },
   ddotseq = {
      class = "relation",
      char = "⩷"
   },
   equivDD = {
      class = "relation",
      char = "⩸"
   },
   ltcir = {
      class = "relation",
      char = "⩹"
   },
   gtcir = {
      class = "relation",
      char = "⩺"
   },
   ltquest = {
      class = "relation",
      char = "⩻"
   },
   gtquest = {
      class = "relation",
      char = "⩼"
   },
   leqslant = {
      class = "relation",
      char = "⩽",
      safe = true
   },
   geqslant = {
      class = "relation",
      char = "⩾",
      safe = true
   },
   lesdot = {
      class = "relation",
      char = "⩿"
   },
   gesdot = {
      class = "relation",
      char = "⪀"
   },
   lesdoto = {
      class = "relation",
      char = "⪁"
   },
   gesdoto = {
      class = "relation",
      char = "⪂"
   },
   lesdotor = {
      class = "relation",
      char = "⪃"
   },
   gesdotol = {
      class = "relation",
      char = "⪄"
   },
   lessapprox = {
      class = "relation",
      char = "⪅",
      safe = true
   },
   gtrapprox = {
      class = "relation",
      char = "⪆",
      safe = true
   },
   lneq = {
      class = "relation",
      char = "⪇",
      safe = true
   },
   gneq = {
      class = "relation",
      char = "⪈",
      safe = true
   },
   lnapprox = {
      class = "relation",
      char = "⪉",
      safe = true
   },
   gnapprox = {
      class = "relation",
      char = "⪊",
      safe = true
   },
   lesseqqgtr = {
      class = "relation",
      char = "⪋",
      safe = true
   },
   gtreqqless = {
      class = "relation",
      char = "⪌",
      safe = true
   },
   lsime = {
      class = "relation",
      char = "⪍"
   },
   gsime = {
      class = "relation",
      char = "⪎"
   },
   lsimg = {
      class = "relation",
      char = "⪏"
   },
   gsiml = {
      class = "relation",
      char = "⪐"
   },
   lgE = {
      class = "relation",
      char = "⪑"
   },
   glE = {
      class = "relation",
      char = "⪒"
   },
   lesges = {
      class = "relation",
      char = "⪓"
   },
   gesles = {
      class = "relation",
      char = "⪔"
   },
   eqslantless = {
      class = "relation",
      char = "⪕",
      safe = true
   },
   eqslantgtr = {
      class = "relation",
      char = "⪖",
      safe = true
   },
   elsdot = {
      class = "relation",
      char = "⪗"
   },
   egsdot = {
      class = "relation",
      char = "⪘"
   },
   eqqless = {
      class = "relation",
      char = "⪙"
   },
   eqqgtr = {
      class = "relation",
      char = "⪚"
   },
   eqqslantless = {
      class = "relation",
      char = "⪛"
   },
   eqqslantgtr = {
      class = "relation",
      char = "⪜"
   },
   simless = {
      class = "relation",
      char = "⪝"
   },
   simgtr = {
      class = "relation",
      char = "⪞"
   },
   simlE = {
      class = "relation",
      char = "⪟"
   },
   simgE = {
      class = "relation",
      char = "⪠"
   },
   Lt = {
      class = "relation",
      char = "⪡"
   },
   Gt = {
      class = "relation",
      char = "⪢"
   },
   partialmeetcontraction = {
      class = "relation",
      char = "⪣"
   },
   glj = {
      class = "relation",
      char = "⪤"
   },
   gla = {
      class = "relation",
      char = "⪥"
   },
   ltcc = {
      class = "relation",
      char = "⪦"
   },
   gtcc = {
      class = "relation",
      char = "⪧"
   },
   lescc = {
      class = "relation",
      char = "⪨"
   },
   gescc = {
      class = "relation",
      char = "⪩"
   },
   smt = {
      class = "relation",
      char = "⪪"
   },
   lat = {
      class = "relation",
      char = "⪫"
   },
   smte = {
      class = "relation",
      char = "⪬"
   },
   late = {
      class = "relation",
      char = "⪭"
   },
   bumpeqq = {
      class = "relation",
      char = "⪮"
   },
   preceq = {
      class = "relation",
      char = "⪯",
      safe = true
   },
   succeq = {
      class = "relation",
      char = "⪰",
      safe = true
   },
   precneq = {
      class = "relation",
      char = "⪱"
   },
   succneq = {
      class = "relation",
      char = "⪲"
   },
   preceqq = {
      class = "relation",
      char = "⪳"
   },
   succeqq = {
      class = "relation",
      char = "⪴"
   },
   precneqq = {
      class = "relation",
      char = "⪵",
      safe = true
   },
   succneqq = {
      class = "relation",
      char = "⪶",
      safe = true
   },
   precapprox = {
      class = "relation",
      char = "⪷",
      safe = true
   },
   succapprox = {
      class = "relation",
      char = "⪸",
      safe = true
   },
   precnapprox = {
      class = "relation",
      char = "⪹",
      safe = true
   },
   succnapprox = {
      class = "relation",
      char = "⪺",
      safe = true
   },
   Prec = {
      class = "relation",
      char = "⪻"
   },
   Succ = {
      class = "relation",
      char = "⪼"
   },
   subsetdot = {
      class = "relation",
      char = "⪽"
   },
   supsetdot = {
      class = "relation",
      char = "⪾"
   },
   subsetplus = {
      class = "relation",
      char = "⪿"
   },
   supsetplus = {
      class = "relation",
      char = "⫀"
   },
   submult = {
      class = "relation",
      char = "⫁"
   },
   supmult = {
      class = "relation",
      char = "⫂"
   },
   subedot = {
      class = "relation",
      char = "⫃"
   },
   supedot = {
      class = "relation",
      char = "⫄"
   },
   subseteqq = {
      class = "relation",
      char = "⫅",
      safe = true
   },
   supseteqq = {
      class = "relation",
      char = "⫆",
      safe = true
   },
   subsim = {
      class = "relation",
      char = "⫇"
   },
   supsim = {
      class = "relation",
      char = "⫈"
   },
   subsetapprox = {
      class = "relation",
      char = "⫉"
   },
   supsetapprox = {
      class = "relation",
      char = "⫊"
   },
   subsetneqq = {
      class = "relation",
      char = "⫋",
      safe = true
   },
   supsetneqq = {
      class = "relation",
      char = "⫌",
      safe = true
   },
   lsqhook = {
      class = "relation",
      char = "⫍"
   },
   rsqhook = {
      class = "relation",
      char = "⫎"
   },
   csub = {
      class = "relation",
      char = "⫏"
   },
   csup = {
      class = "relation",
      char = "⫐"
   },
   csube = {
      class = "relation",
      char = "⫑"
   },
   csupe = {
      class = "relation",
      char = "⫒"
   },
   subsup = {
      class = "relation",
      char = "⫓"
   },
   supsub = {
      class = "relation",
      char = "⫔"
   },
   subsub = {
      class = "relation",
      char = "⫕"
   },
   supsup = {
      class = "relation",
      char = "⫖"
   },
   suphsub = {
      class = "relation",
      char = "⫗"
   },
   supdsub = {
      class = "relation",
      char = "⫘"
   },
   forkv = {
      class = "relation",
      char = "⫙"
   },
   topfork = {
      class = "relation",
      char = "⫚"
   },
   mlcp = {
      class = "relation",
      char = "⫛"
   },
   forks = {
      class = "relation",
      char = "⫝̸"
   },
   forksnot = {
      class = "relation",
      char = "⫝"
   },
   shortlefttack = {
      class = "relation",
      char = "⫞"
   },
   shortdowntack = {
      class = "relation",
      char = "⫟"
   },
   shortuptack = {
      class = "relation",
      char = "⫠"
   },
   perps = "⫡",
   vDdash = {
      class = "relation",
      char = "⫢"
   },
   dashV = {
      class = "relation",
      char = "⫣"
   },
   Dashv = {
      class = "relation",
      char = "⫤"
   },
   DashV = {
      class = "relation",
      char = "⫥"
   },
   varVdash = {
      class = "relation",
      char = "⫦"
   },
   Barv = {
      class = "relation",
      char = "⫧"
   },
   vBar = {
      class = "relation",
      char = "⫨"
   },
   vBarv = {
      class = "relation",
      char = "⫩"
   },
   barV = {
      class = "relation",
      char = "⫪"
   },
   Vbar = {
      class = "relation",
      char = "⫫"
   },
   Not = {
      class = "relation",
      char = "⫬"
   },
   bNot = {
      class = "relation",
      char = "⫭"
   },
   revnmid = {
      class = "relation",
      char = "⫮"
   },
   cirmid = {
      class = "relation",
      char = "⫯"
   },
   midcir = {
      class = "relation",
      char = "⫰"
   },
   topcir = "⫱",
   nhpar = {
      class = "relation",
      char = "⫲"
   },
   parsim = {
      class = "relation",
      char = "⫳"
   },
   interleave = {
      class = "binary",
      char = "⫴"
   },
   nhVvert = {
      class = "binary",
      char = "⫵"
   },
   threedotcolon = {
      class = "binary",
      char = "⫶"
   },
   lllnest = {
      class = "relation",
      char = "⫷"
   },
   gggnest = {
      class = "relation",
      char = "⫸"
   },
   leqqslant = {
      class = "relation",
      char = "⫹"
   },
   geqqslant = {
      class = "relation",
      char = "⫺"
   },
   trslash = {
      class = "binary",
      char = "⫻"
   },
   biginterleave = {
      class = "operator",
      char = "⫼"
   },
   sslash = {
      class = "binary",
      char = "⫽"
   },
   talloblong = {
      class = "binary",
      char = "⫾"
   },
   bigtalloblong = {
      class = "operator",
      char = "⫿"
   },
   squaretopblack = "⬒",
   squarebotblack = "⬓",
   squareurblack = "⬔",
   squarellblack = "⬕",
   diamondleftblack = "⬖",
   diamondrightblack = "⬗",
   diamondtopblack = "⬘",
   diamondbotblack = "⬙",
   dottedsquare = "⬚",
   lgblksquare = "⬛",
   lgwhtsquare = "⬜",
   vysmblksquare = "⬝",
   vysmwhtsquare = "⬞",
   pentagonblack = "⬟",
   pentagon = "⬠",
   varhexagon = "⬡",
   varhexagonblack = "⬢",
   hexagonblack = "⬣",
   lgblkcircle = "⬤",
   mdblkdiamond = "⬥",
   mdwhtdiamond = "⬦",
   mdblklozenge = "⬧",
   mdwhtlozenge = "⬨",
   smblkdiamond = "⬩",
   smblklozenge = "⬪",
   smwhtlozenge = "⬫",
   blkhorzoval = "⬬",
   whthorzoval = "⬭",
   blkvertoval = "⬮",
   whtvertoval = "⬯",
   circleonleftarrow = {
      class = "relation",
      char = "⬰"
   },
   leftthreearrows = {
      class = "relation",
      char = "⬱"
   },
   leftarrowonoplus = {
      class = "relation",
      char = "⬲"
   },
   longleftsquigarrow = {
      class = "relation",
      char = "⬳"
   },
   nvtwoheadleftarrow = {
      class = "relation",
      char = "⬴"
   },
   nVtwoheadleftarrow = {
      class = "relation",
      char = "⬵"
   },
   twoheadmapsfrom = {
      class = "relation",
      char = "⬶"
   },
   twoheadleftdbkarrow = {
      class = "relation",
      char = "⬷"
   },
   leftdotarrow = {
      class = "relation",
      char = "⬸"
   },
   nvleftarrowtail = {
      class = "relation",
      char = "⬹"
   },
   nVleftarrowtail = {
      class = "relation",
      char = "⬺"
   },
   twoheadleftarrowtail = {
      class = "relation",
      char = "⬻"
   },
   nvtwoheadleftarrowtail = {
      class = "relation",
      char = "⬼"
   },
   nVtwoheadleftarrowtail = {
      class = "relation",
      char = "⬽"
   },
   leftarrowx = {
      class = "relation",
      char = "⬾"
   },
   leftcurvedarrow = {
      class = "relation",
      char = "⬿"
   },
   equalleftarrow = {
      class = "relation",
      char = "⭀"
   },
   bsimilarleftarrow = {
      class = "relation",
      char = "⭁"
   },
   leftarrowbackapprox = {
      class = "relation",
      char = "⭂"
   },
   rightarrowgtr = {
      class = "relation",
      char = "⭃"
   },
   rightarrowsupset = {
      class = "relation",
      char = "⭄"
   },
   LLeftarrow = {
      class = "relation",
      char = "⭅"
   },
   RRightarrow = {
      class = "relation",
      char = "⭆"
   },
   bsimilarrightarrow = {
      class = "relation",
      char = "⭇"
   },
   rightarrowbackapprox = {
      class = "relation",
      char = "⭈"
   },
   similarleftarrow = {
      class = "relation",
      char = "⭉"
   },
   leftarrowapprox = {
      class = "relation",
      char = "⭊"
   },
   leftarrowbsimilar = {
      class = "relation",
      char = "⭋"
   },
   rightarrowbsimilar = {
      class = "relation",
      char = "⭌"
   },
   medwhitestar = "⭐",
   medblackstar = "⭑",
   smwhitestar = "⭒",
   rightpentagonblack = "⭓",
   rightpentagon = "⭔",
   postalmark = "〒",
   lbrbrak = {
      class = "open",
      char = "〔"
   },
   rbrbrak = {
      class = "close",
      char = "〕"
   },
   Lbrbrak = {
      class = "open",
      char = "〘"
   },
   Rbrbrak = {
      class = "close",
      char = "〙"
   },
   hzigzag = "〰",
   mbfA = {
      class = "variable",
      char = "𝐀"
   },
   mbfB = {
      class = "variable",
      char = "𝐁"
   },
   mbfC = {
      class = "variable",
      char = "𝐂"
   },
   mbfD = {
      class = "variable",
      char = "𝐃"
   },
   mbfE = {
      class = "variable",
      char = "𝐄"
   },
   mbfF = {
      class = "variable",
      char = "𝐅"
   },
   mbfG = {
      class = "variable",
      char = "𝐆"
   },
   mbfH = {
      class = "variable",
      char = "𝐇"
   },
   mbfI = {
      class = "variable",
      char = "𝐈"
   },
   mbfJ = {
      class = "variable",
      char = "𝐉"
   },
   mbfK = {
      class = "variable",
      char = "𝐊"
   },
   mbfL = {
      class = "variable",
      char = "𝐋"
   },
   mbfM = {
      class = "variable",
      char = "𝐌"
   },
   mbfN = {
      class = "variable",
      char = "𝐍"
   },
   mbfO = {
      class = "variable",
      char = "𝐎"
   },
   mbfP = {
      class = "variable",
      char = "𝐏"
   },
   mbfQ = {
      class = "variable",
      char = "𝐐"
   },
   mbfR = {
      class = "variable",
      char = "𝐑"
   },
   mbfS = {
      class = "variable",
      char = "𝐒"
   },
   mbfT = {
      class = "variable",
      char = "𝐓"
   },
   mbfU = {
      class = "variable",
      char = "𝐔"
   },
   mbfV = {
      class = "variable",
      char = "𝐕"
   },
   mbfW = {
      class = "variable",
      char = "𝐖"
   },
   mbfX = {
      class = "variable",
      char = "𝐗"
   },
   mbfY = {
      class = "variable",
      char = "𝐘"
   },
   mbfZ = {
      class = "variable",
      char = "𝐙"
   },
   mbfa = {
      class = "variable",
      char = "𝐚"
   },
   mbfb = {
      class = "variable",
      char = "𝐛"
   },
   mbfc = {
      class = "variable",
      char = "𝐜"
   },
   mbfd = {
      class = "variable",
      char = "𝐝"
   },
   mbfe = {
      class = "variable",
      char = "𝐞"
   },
   mbff = {
      class = "variable",
      char = "𝐟"
   },
   mbfg = {
      class = "variable",
      char = "𝐠"
   },
   mbfh = {
      class = "variable",
      char = "𝐡"
   },
   mbfi = {
      class = "variable",
      char = "𝐢"
   },
   mbfj = {
      class = "variable",
      char = "𝐣"
   },
   mbfk = {
      class = "variable",
      char = "𝐤"
   },
   mbfl = {
      class = "variable",
      char = "𝐥"
   },
   mbfm = {
      class = "variable",
      char = "𝐦"
   },
   mbfn = {
      class = "variable",
      char = "𝐧"
   },
   mbfo = {
      class = "variable",
      char = "𝐨"
   },
   mbfp = {
      class = "variable",
      char = "𝐩"
   },
   mbfq = {
      class = "variable",
      char = "𝐪"
   },
   mbfr = {
      class = "variable",
      char = "𝐫"
   },
   mbfs = {
      class = "variable",
      char = "𝐬"
   },
   mbft = {
      class = "variable",
      char = "𝐭"
   },
   mbfu = {
      class = "variable",
      char = "𝐮"
   },
   mbfv = {
      class = "variable",
      char = "𝐯"
   },
   mbfw = {
      class = "variable",
      char = "𝐰"
   },
   mbfx = {
      class = "variable",
      char = "𝐱"
   },
   mbfy = {
      class = "variable",
      char = "𝐲"
   },
   mbfz = {
      class = "variable",
      char = "𝐳"
   },
   mitA = {
      class = "variable",
      char = "𝐴"
   },
   mitB = {
      class = "variable",
      char = "𝐵"
   },
   mitC = {
      class = "variable",
      char = "𝐶"
   },
   mitD = {
      class = "variable",
      char = "𝐷"
   },
   mitE = {
      class = "variable",
      char = "𝐸"
   },
   mitF = {
      class = "variable",
      char = "𝐹"
   },
   mitG = {
      class = "variable",
      char = "𝐺"
   },
   mitH = {
      class = "variable",
      char = "𝐻"
   },
   mitI = {
      class = "variable",
      char = "𝐼"
   },
   mitJ = {
      class = "variable",
      char = "𝐽"
   },
   mitK = {
      class = "variable",
      char = "𝐾"
   },
   mitL = {
      class = "variable",
      char = "𝐿"
   },
   mitM = {
      class = "variable",
      char = "𝑀"
   },
   mitN = {
      class = "variable",
      char = "𝑁"
   },
   mitO = {
      class = "variable",
      char = "𝑂"
   },
   mitP = {
      class = "variable",
      char = "𝑃"
   },
   mitQ = {
      class = "variable",
      char = "𝑄"
   },
   mitR = {
      class = "variable",
      char = "𝑅"
   },
   mitS = {
      class = "variable",
      char = "𝑆"
   },
   mitT = {
      class = "variable",
      char = "𝑇"
   },
   mitU = {
      class = "variable",
      char = "𝑈"
   },
   mitV = {
      class = "variable",
      char = "𝑉"
   },
   mitW = {
      class = "variable",
      char = "𝑊"
   },
   mitX = {
      class = "variable",
      char = "𝑋"
   },
   mitY = {
      class = "variable",
      char = "𝑌"
   },
   mitZ = {
      class = "variable",
      char = "𝑍"
   },
   mita = {
      class = "variable",
      char = "𝑎"
   },
   mitb = {
      class = "variable",
      char = "𝑏"
   },
   mitc = {
      class = "variable",
      char = "𝑐"
   },
   mitd = {
      class = "variable",
      char = "𝑑"
   },
   mite = {
      class = "variable",
      char = "𝑒"
   },
   mitf = {
      class = "variable",
      char = "𝑓"
   },
   mitg = {
      class = "variable",
      char = "𝑔"
   },
   miti = {
      class = "variable",
      char = "𝑖"
   },
   mitj = {
      class = "variable",
      char = "𝑗"
   },
   mitk = {
      class = "variable",
      char = "𝑘"
   },
   mitl = {
      class = "variable",
      char = "𝑙"
   },
   mitm = {
      class = "variable",
      char = "𝑚"
   },
   mitn = {
      class = "variable",
      char = "𝑛"
   },
   mito = {
      class = "variable",
      char = "𝑜"
   },
   mitp = {
      class = "variable",
      char = "𝑝"
   },
   mitq = {
      class = "variable",
      char = "𝑞"
   },
   mitr = {
      class = "variable",
      char = "𝑟"
   },
   mits = {
      class = "variable",
      char = "𝑠"
   },
   mitt = {
      class = "variable",
      char = "𝑡"
   },
   mitu = {
      class = "variable",
      char = "𝑢"
   },
   mitv = {
      class = "variable",
      char = "𝑣"
   },
   mitw = {
      class = "variable",
      char = "𝑤"
   },
   mitx = {
      class = "variable",
      char = "𝑥"
   },
   mity = {
      class = "variable",
      char = "𝑦"
   },
   mitz = {
      class = "variable",
      char = "𝑧"
   },
   mbfitA = {
      class = "variable",
      char = "𝑨"
   },
   mbfitB = {
      class = "variable",
      char = "𝑩"
   },
   mbfitC = {
      class = "variable",
      char = "𝑪"
   },
   mbfitD = {
      class = "variable",
      char = "𝑫"
   },
   mbfitE = {
      class = "variable",
      char = "𝑬"
   },
   mbfitF = {
      class = "variable",
      char = "𝑭"
   },
   mbfitG = {
      class = "variable",
      char = "𝑮"
   },
   mbfitH = {
      class = "variable",
      char = "𝑯"
   },
   mbfitI = {
      class = "variable",
      char = "𝑰"
   },
   mbfitJ = {
      class = "variable",
      char = "𝑱"
   },
   mbfitK = {
      class = "variable",
      char = "𝑲"
   },
   mbfitL = {
      class = "variable",
      char = "𝑳"
   },
   mbfitM = {
      class = "variable",
      char = "𝑴"
   },
   mbfitN = {
      class = "variable",
      char = "𝑵"
   },
   mbfitO = {
      class = "variable",
      char = "𝑶"
   },
   mbfitP = {
      class = "variable",
      char = "𝑷"
   },
   mbfitQ = {
      class = "variable",
      char = "𝑸"
   },
   mbfitR = {
      class = "variable",
      char = "𝑹"
   },
   mbfitS = {
      class = "variable",
      char = "𝑺"
   },
   mbfitT = {
      class = "variable",
      char = "𝑻"
   },
   mbfitU = {
      class = "variable",
      char = "𝑼"
   },
   mbfitV = {
      class = "variable",
      char = "𝑽"
   },
   mbfitW = {
      class = "variable",
      char = "𝑾"
   },
   mbfitX = {
      class = "variable",
      char = "𝑿"
   },
   mbfitY = {
      class = "variable",
      char = "𝒀"
   },
   mbfitZ = {
      class = "variable",
      char = "𝒁"
   },
   mbfita = {
      class = "variable",
      char = "𝒂"
   },
   mbfitb = {
      class = "variable",
      char = "𝒃"
   },
   mbfitc = {
      class = "variable",
      char = "𝒄"
   },
   mbfitd = {
      class = "variable",
      char = "𝒅"
   },
   mbfite = {
      class = "variable",
      char = "𝒆"
   },
   mbfitf = {
      class = "variable",
      char = "𝒇"
   },
   mbfitg = {
      class = "variable",
      char = "𝒈"
   },
   mbfith = {
      class = "variable",
      char = "𝒉"
   },
   mbfiti = {
      class = "variable",
      char = "𝒊"
   },
   mbfitj = {
      class = "variable",
      char = "𝒋"
   },
   mbfitk = {
      class = "variable",
      char = "𝒌"
   },
   mbfitl = {
      class = "variable",
      char = "𝒍"
   },
   mbfitm = {
      class = "variable",
      char = "𝒎"
   },
   mbfitn = {
      class = "variable",
      char = "𝒏"
   },
   mbfito = {
      class = "variable",
      char = "𝒐"
   },
   mbfitp = {
      class = "variable",
      char = "𝒑"
   },
   mbfitq = {
      class = "variable",
      char = "𝒒"
   },
   mbfitr = {
      class = "variable",
      char = "𝒓"
   },
   mbfits = {
      class = "variable",
      char = "𝒔"
   },
   mbfitt = {
      class = "variable",
      char = "𝒕"
   },
   mbfitu = {
      class = "variable",
      char = "𝒖"
   },
   mbfitv = {
      class = "variable",
      char = "𝒗"
   },
   mbfitw = {
      class = "variable",
      char = "𝒘"
   },
   mbfitx = {
      class = "variable",
      char = "𝒙"
   },
   mbfity = {
      class = "variable",
      char = "𝒚"
   },
   mbfitz = {
      class = "variable",
      char = "𝒛"
   },
   mscrA = {
      class = "variable",
      char = "𝒜"
   },
   mscrC = {
      class = "variable",
      char = "𝒞"
   },
   mscrD = {
      class = "variable",
      char = "𝒟"
   },
   mscrG = {
      class = "variable",
      char = "𝒢"
   },
   mscrJ = {
      class = "variable",
      char = "𝒥"
   },
   mscrK = {
      class = "variable",
      char = "𝒦"
   },
   mscrN = {
      class = "variable",
      char = "𝒩"
   },
   mscrO = {
      class = "variable",
      char = "𝒪"
   },
   mscrP = {
      class = "variable",
      char = "𝒫"
   },
   mscrQ = {
      class = "variable",
      char = "𝒬"
   },
   mscrS = {
      class = "variable",
      char = "𝒮"
   },
   mscrT = {
      class = "variable",
      char = "𝒯"
   },
   mscrU = {
      class = "variable",
      char = "𝒰"
   },
   mscrV = {
      class = "variable",
      char = "𝒱"
   },
   mscrW = {
      class = "variable",
      char = "𝒲"
   },
   mscrX = {
      class = "variable",
      char = "𝒳"
   },
   mscrY = {
      class = "variable",
      char = "𝒴"
   },
   mscrZ = {
      class = "variable",
      char = "𝒵"
   },
   mscra = {
      class = "variable",
      char = "𝒶"
   },
   mscrb = {
      class = "variable",
      char = "𝒷"
   },
   mscrc = {
      class = "variable",
      char = "𝒸"
   },
   mscrd = {
      class = "variable",
      char = "𝒹"
   },
   mscrf = {
      class = "variable",
      char = "𝒻"
   },
   mscrh = {
      class = "variable",
      char = "𝒽"
   },
   mscri = {
      class = "variable",
      char = "𝒾"
   },
   mscrj = {
      class = "variable",
      char = "𝒿"
   },
   mscrk = {
      class = "variable",
      char = "𝓀"
   },
   mscrl = {
      class = "variable",
      char = "𝓁"
   },
   mscrm = {
      class = "variable",
      char = "𝓂"
   },
   mscrn = {
      class = "variable",
      char = "𝓃"
   },
   mscrp = {
      class = "variable",
      char = "𝓅"
   },
   mscrq = {
      class = "variable",
      char = "𝓆"
   },
   mscrr = {
      class = "variable",
      char = "𝓇"
   },
   mscrs = {
      class = "variable",
      char = "𝓈"
   },
   mscrt = {
      class = "variable",
      char = "𝓉"
   },
   mscru = {
      class = "variable",
      char = "𝓊"
   },
   mscrv = {
      class = "variable",
      char = "𝓋"
   },
   mscrw = {
      class = "variable",
      char = "𝓌"
   },
   mscrx = {
      class = "variable",
      char = "𝓍"
   },
   mscry = {
      class = "variable",
      char = "𝓎"
   },
   mscrz = {
      class = "variable",
      char = "𝓏"
   },
   mbfscrA = {
      class = "variable",
      char = "𝓐"
   },
   mbfscrB = {
      class = "variable",
      char = "𝓑"
   },
   mbfscrC = {
      class = "variable",
      char = "𝓒"
   },
   mbfscrD = {
      class = "variable",
      char = "𝓓"
   },
   mbfscrE = {
      class = "variable",
      char = "𝓔"
   },
   mbfscrF = {
      class = "variable",
      char = "𝓕"
   },
   mbfscrG = {
      class = "variable",
      char = "𝓖"
   },
   mbfscrH = {
      class = "variable",
      char = "𝓗"
   },
   mbfscrI = {
      class = "variable",
      char = "𝓘"
   },
   mbfscrJ = {
      class = "variable",
      char = "𝓙"
   },
   mbfscrK = {
      class = "variable",
      char = "𝓚"
   },
   mbfscrL = {
      class = "variable",
      char = "𝓛"
   },
   mbfscrM = {
      class = "variable",
      char = "𝓜"
   },
   mbfscrN = {
      class = "variable",
      char = "𝓝"
   },
   mbfscrO = {
      class = "variable",
      char = "𝓞"
   },
   mbfscrP = {
      class = "variable",
      char = "𝓟"
   },
   mbfscrQ = {
      class = "variable",
      char = "𝓠"
   },
   mbfscrR = {
      class = "variable",
      char = "𝓡"
   },
   mbfscrS = {
      class = "variable",
      char = "𝓢"
   },
   mbfscrT = {
      class = "variable",
      char = "𝓣"
   },
   mbfscrU = {
      class = "variable",
      char = "𝓤"
   },
   mbfscrV = {
      class = "variable",
      char = "𝓥"
   },
   mbfscrW = {
      class = "variable",
      char = "𝓦"
   },
   mbfscrX = {
      class = "variable",
      char = "𝓧"
   },
   mbfscrY = {
      class = "variable",
      char = "𝓨"
   },
   mbfscrZ = {
      class = "variable",
      char = "𝓩"
   },
   mbfscra = {
      class = "variable",
      char = "𝓪"
   },
   mbfscrb = {
      class = "variable",
      char = "𝓫"
   },
   mbfscrc = {
      class = "variable",
      char = "𝓬"
   },
   mbfscrd = {
      class = "variable",
      char = "𝓭"
   },
   mbfscre = {
      class = "variable",
      char = "𝓮"
   },
   mbfscrf = {
      class = "variable",
      char = "𝓯"
   },
   mbfscrg = {
      class = "variable",
      char = "𝓰"
   },
   mbfscrh = {
      class = "variable",
      char = "𝓱"
   },
   mbfscri = {
      class = "variable",
      char = "𝓲"
   },
   mbfscrj = {
      class = "variable",
      char = "𝓳"
   },
   mbfscrk = {
      class = "variable",
      char = "𝓴"
   },
   mbfscrl = {
      class = "variable",
      char = "𝓵"
   },
   mbfscrm = {
      class = "variable",
      char = "𝓶"
   },
   mbfscrn = {
      class = "variable",
      char = "𝓷"
   },
   mbfscro = {
      class = "variable",
      char = "𝓸"
   },
   mbfscrp = {
      class = "variable",
      char = "𝓹"
   },
   mbfscrq = {
      class = "variable",
      char = "𝓺"
   },
   mbfscrr = {
      class = "variable",
      char = "𝓻"
   },
   mbfscrs = {
      class = "variable",
      char = "𝓼"
   },
   mbfscrt = {
      class = "variable",
      char = "𝓽"
   },
   mbfscru = {
      class = "variable",
      char = "𝓾"
   },
   mbfscrv = {
      class = "variable",
      char = "𝓿"
   },
   mbfscrw = {
      class = "variable",
      char = "𝔀"
   },
   mbfscrx = {
      class = "variable",
      char = "𝔁"
   },
   mbfscry = {
      class = "variable",
      char = "𝔂"
   },
   mbfscrz = {
      class = "variable",
      char = "𝔃"
   },
   mfrakA = {
      class = "variable",
      char = "𝔄"
   },
   mfrakB = {
      class = "variable",
      char = "𝔅"
   },
   mfrakD = {
      class = "variable",
      char = "𝔇"
   },
   mfrakE = {
      class = "variable",
      char = "𝔈"
   },
   mfrakF = {
      class = "variable",
      char = "𝔉"
   },
   mfrakG = {
      class = "variable",
      char = "𝔊"
   },
   mfrakJ = {
      class = "variable",
      char = "𝔍"
   },
   mfrakK = {
      class = "variable",
      char = "𝔎"
   },
   mfrakL = {
      class = "variable",
      char = "𝔏"
   },
   mfrakM = {
      class = "variable",
      char = "𝔐"
   },
   mfrakN = {
      class = "variable",
      char = "𝔑"
   },
   mfrakO = {
      class = "variable",
      char = "𝔒"
   },
   mfrakP = {
      class = "variable",
      char = "𝔓"
   },
   mfrakQ = {
      class = "variable",
      char = "𝔔"
   },
   mfrakS = {
      class = "variable",
      char = "𝔖"
   },
   mfrakT = {
      class = "variable",
      char = "𝔗"
   },
   mfrakU = {
      class = "variable",
      char = "𝔘"
   },
   mfrakV = {
      class = "variable",
      char = "𝔙"
   },
   mfrakW = {
      class = "variable",
      char = "𝔚"
   },
   mfrakX = {
      class = "variable",
      char = "𝔛"
   },
   mfrakY = {
      class = "variable",
      char = "𝔜"
   },
   mfraka = {
      class = "variable",
      char = "𝔞"
   },
   mfrakb = {
      class = "variable",
      char = "𝔟"
   },
   mfrakc = {
      class = "variable",
      char = "𝔠"
   },
   mfrakd = {
      class = "variable",
      char = "𝔡"
   },
   mfrake = {
      class = "variable",
      char = "𝔢"
   },
   mfrakf = {
      class = "variable",
      char = "𝔣"
   },
   mfrakg = {
      class = "variable",
      char = "𝔤"
   },
   mfrakh = {
      class = "variable",
      char = "𝔥"
   },
   mfraki = {
      class = "variable",
      char = "𝔦"
   },
   mfrakj = {
      class = "variable",
      char = "𝔧"
   },
   mfrakk = {
      class = "variable",
      char = "𝔨"
   },
   mfrakl = {
      class = "variable",
      char = "𝔩"
   },
   mfrakm = {
      class = "variable",
      char = "𝔪"
   },
   mfrakn = {
      class = "variable",
      char = "𝔫"
   },
   mfrako = {
      class = "variable",
      char = "𝔬"
   },
   mfrakp = {
      class = "variable",
      char = "𝔭"
   },
   mfrakq = {
      class = "variable",
      char = "𝔮"
   },
   mfrakr = {
      class = "variable",
      char = "𝔯"
   },
   mfraks = {
      class = "variable",
      char = "𝔰"
   },
   mfrakt = {
      class = "variable",
      char = "𝔱"
   },
   mfraku = {
      class = "variable",
      char = "𝔲"
   },
   mfrakv = {
      class = "variable",
      char = "𝔳"
   },
   mfrakw = {
      class = "variable",
      char = "𝔴"
   },
   mfrakx = {
      class = "variable",
      char = "𝔵"
   },
   mfraky = {
      class = "variable",
      char = "𝔶"
   },
   mfrakz = {
      class = "variable",
      char = "𝔷"
   },
   BbbA = {
      class = "variable",
      char = "𝔸"
   },
   BbbB = {
      class = "variable",
      char = "𝔹"
   },
   BbbD = {
      class = "variable",
      char = "𝔻"
   },
   BbbE = {
      class = "variable",
      char = "𝔼"
   },
   BbbF = {
      class = "variable",
      char = "𝔽"
   },
   BbbG = {
      class = "variable",
      char = "𝔾"
   },
   BbbI = {
      class = "variable",
      char = "𝕀"
   },
   BbbJ = {
      class = "variable",
      char = "𝕁"
   },
   BbbK = {
      class = "variable",
      char = "𝕂"
   },
   BbbL = {
      class = "variable",
      char = "𝕃"
   },
   BbbM = {
      class = "variable",
      char = "𝕄"
   },
   BbbO = {
      class = "variable",
      char = "𝕆"
   },
   BbbS = {
      class = "variable",
      char = "𝕊"
   },
   BbbT = {
      class = "variable",
      char = "𝕋"
   },
   BbbU = {
      class = "variable",
      char = "𝕌"
   },
   BbbV = {
      class = "variable",
      char = "𝕍"
   },
   BbbW = {
      class = "variable",
      char = "𝕎"
   },
   BbbX = {
      class = "variable",
      char = "𝕏"
   },
   BbbY = {
      class = "variable",
      char = "𝕐"
   },
   Bbba = {
      class = "variable",
      char = "𝕒"
   },
   Bbbb = {
      class = "variable",
      char = "𝕓"
   },
   Bbbc = {
      class = "variable",
      char = "𝕔"
   },
   Bbbd = {
      class = "variable",
      char = "𝕕"
   },
   Bbbe = {
      class = "variable",
      char = "𝕖"
   },
   Bbbf = {
      class = "variable",
      char = "𝕗"
   },
   Bbbg = {
      class = "variable",
      char = "𝕘"
   },
   Bbbh = {
      class = "variable",
      char = "𝕙"
   },
   Bbbi = {
      class = "variable",
      char = "𝕚"
   },
   Bbbj = {
      class = "variable",
      char = "𝕛"
   },
   Bbbk = {
      class = "variable",
      char = "𝕜",
      safe = true
   },
   Bbbl = {
      class = "variable",
      char = "𝕝"
   },
   Bbbm = {
      class = "variable",
      char = "𝕞"
   },
   Bbbn = {
      class = "variable",
      char = "𝕟"
   },
   Bbbo = {
      class = "variable",
      char = "𝕠"
   },
   Bbbp = {
      class = "variable",
      char = "𝕡"
   },
   Bbbq = {
      class = "variable",
      char = "𝕢"
   },
   Bbbr = {
      class = "variable",
      char = "𝕣"
   },
   Bbbs = {
      class = "variable",
      char = "𝕤"
   },
   Bbbt = {
      class = "variable",
      char = "𝕥"
   },
   Bbbu = {
      class = "variable",
      char = "𝕦"
   },
   Bbbv = {
      class = "variable",
      char = "𝕧"
   },
   Bbbw = {
      class = "variable",
      char = "𝕨"
   },
   Bbbx = {
      class = "variable",
      char = "𝕩"
   },
   Bbby = {
      class = "variable",
      char = "𝕪"
   },
   Bbbz = {
      class = "variable",
      char = "𝕫"
   },
   mbffrakA = {
      class = "variable",
      char = "𝕬"
   },
   mbffrakB = {
      class = "variable",
      char = "𝕭"
   },
   mbffrakC = {
      class = "variable",
      char = "𝕮"
   },
   mbffrakD = {
      class = "variable",
      char = "𝕯"
   },
   mbffrakE = {
      class = "variable",
      char = "𝕰"
   },
   mbffrakF = {
      class = "variable",
      char = "𝕱"
   },
   mbffrakG = {
      class = "variable",
      char = "𝕲"
   },
   mbffrakH = {
      class = "variable",
      char = "𝕳"
   },
   mbffrakI = {
      class = "variable",
      char = "𝕴"
   },
   mbffrakJ = {
      class = "variable",
      char = "𝕵"
   },
   mbffrakK = {
      class = "variable",
      char = "𝕶"
   },
   mbffrakL = {
      class = "variable",
      char = "𝕷"
   },
   mbffrakM = {
      class = "variable",
      char = "𝕸"
   },
   mbffrakN = {
      class = "variable",
      char = "𝕹"
   },
   mbffrakO = {
      class = "variable",
      char = "𝕺"
   },
   mbffrakP = {
      class = "variable",
      char = "𝕻"
   },
   mbffrakQ = {
      class = "variable",
      char = "𝕼"
   },
   mbffrakR = {
      class = "variable",
      char = "𝕽"
   },
   mbffrakS = {
      class = "variable",
      char = "𝕾"
   },
   mbffrakT = {
      class = "variable",
      char = "𝕿"
   },
   mbffrakU = {
      class = "variable",
      char = "𝖀"
   },
   mbffrakV = {
      class = "variable",
      char = "𝖁"
   },
   mbffrakW = {
      class = "variable",
      char = "𝖂"
   },
   mbffrakX = {
      class = "variable",
      char = "𝖃"
   },
   mbffrakY = {
      class = "variable",
      char = "𝖄"
   },
   mbffrakZ = {
      class = "variable",
      char = "𝖅"
   },
   mbffraka = {
      class = "variable",
      char = "𝖆"
   },
   mbffrakb = {
      class = "variable",
      char = "𝖇"
   },
   mbffrakc = {
      class = "variable",
      char = "𝖈"
   },
   mbffrakd = {
      class = "variable",
      char = "𝖉"
   },
   mbffrake = {
      class = "variable",
      char = "𝖊"
   },
   mbffrakf = {
      class = "variable",
      char = "𝖋"
   },
   mbffrakg = {
      class = "variable",
      char = "𝖌"
   },
   mbffrakh = {
      class = "variable",
      char = "𝖍"
   },
   mbffraki = {
      class = "variable",
      char = "𝖎"
   },
   mbffrakj = {
      class = "variable",
      char = "𝖏"
   },
   mbffrakk = {
      class = "variable",
      char = "𝖐"
   },
   mbffrakl = {
      class = "variable",
      char = "𝖑"
   },
   mbffrakm = {
      class = "variable",
      char = "𝖒"
   },
   mbffrakn = {
      class = "variable",
      char = "𝖓"
   },
   mbffrako = {
      class = "variable",
      char = "𝖔"
   },
   mbffrakp = {
      class = "variable",
      char = "𝖕"
   },
   mbffrakq = {
      class = "variable",
      char = "𝖖"
   },
   mbffrakr = {
      class = "variable",
      char = "𝖗"
   },
   mbffraks = {
      class = "variable",
      char = "𝖘"
   },
   mbffrakt = {
      class = "variable",
      char = "𝖙"
   },
   mbffraku = {
      class = "variable",
      char = "𝖚"
   },
   mbffrakv = {
      class = "variable",
      char = "𝖛"
   },
   mbffrakw = {
      class = "variable",
      char = "𝖜"
   },
   mbffrakx = {
      class = "variable",
      char = "𝖝"
   },
   mbffraky = {
      class = "variable",
      char = "𝖞"
   },
   mbffrakz = {
      class = "variable",
      char = "𝖟"
   },
   msansA = {
      class = "variable",
      char = "𝖠"
   },
   msansB = {
      class = "variable",
      char = "𝖡"
   },
   msansC = {
      class = "variable",
      char = "𝖢"
   },
   msansD = {
      class = "variable",
      char = "𝖣"
   },
   msansE = {
      class = "variable",
      char = "𝖤"
   },
   msansF = {
      class = "variable",
      char = "𝖥"
   },
   msansG = {
      class = "variable",
      char = "𝖦"
   },
   msansH = {
      class = "variable",
      char = "𝖧"
   },
   msansI = {
      class = "variable",
      char = "𝖨"
   },
   msansJ = {
      class = "variable",
      char = "𝖩"
   },
   msansK = {
      class = "variable",
      char = "𝖪"
   },
   msansL = {
      class = "variable",
      char = "𝖫"
   },
   msansM = {
      class = "variable",
      char = "𝖬"
   },
   msansN = {
      class = "variable",
      char = "𝖭"
   },
   msansO = {
      class = "variable",
      char = "𝖮"
   },
   msansP = {
      class = "variable",
      char = "𝖯"
   },
   msansQ = {
      class = "variable",
      char = "𝖰"
   },
   msansR = {
      class = "variable",
      char = "𝖱"
   },
   msansS = {
      class = "variable",
      char = "𝖲"
   },
   msansT = {
      class = "variable",
      char = "𝖳"
   },
   msansU = {
      class = "variable",
      char = "𝖴"
   },
   msansV = {
      class = "variable",
      char = "𝖵"
   },
   msansW = {
      class = "variable",
      char = "𝖶"
   },
   msansX = {
      class = "variable",
      char = "𝖷"
   },
   msansY = {
      class = "variable",
      char = "𝖸"
   },
   msansZ = {
      class = "variable",
      char = "𝖹"
   },
   msansa = {
      class = "variable",
      char = "𝖺"
   },
   msansb = {
      class = "variable",
      char = "𝖻"
   },
   msansc = {
      class = "variable",
      char = "𝖼"
   },
   msansd = {
      class = "variable",
      char = "𝖽"
   },
   msanse = {
      class = "variable",
      char = "𝖾"
   },
   msansf = {
      class = "variable",
      char = "𝖿"
   },
   msansg = {
      class = "variable",
      char = "𝗀"
   },
   msansh = {
      class = "variable",
      char = "𝗁"
   },
   msansi = {
      class = "variable",
      char = "𝗂"
   },
   msansj = {
      class = "variable",
      char = "𝗃"
   },
   msansk = {
      class = "variable",
      char = "𝗄"
   },
   msansl = {
      class = "variable",
      char = "𝗅"
   },
   msansm = {
      class = "variable",
      char = "𝗆"
   },
   msansn = {
      class = "variable",
      char = "𝗇"
   },
   msanso = {
      class = "variable",
      char = "𝗈"
   },
   msansp = {
      class = "variable",
      char = "𝗉"
   },
   msansq = {
      class = "variable",
      char = "𝗊"
   },
   msansr = {
      class = "variable",
      char = "𝗋"
   },
   msanss = {
      class = "variable",
      char = "𝗌"
   },
   msanst = {
      class = "variable",
      char = "𝗍"
   },
   msansu = {
      class = "variable",
      char = "𝗎"
   },
   msansv = {
      class = "variable",
      char = "𝗏"
   },
   msansw = {
      class = "variable",
      char = "𝗐"
   },
   msansx = {
      class = "variable",
      char = "𝗑"
   },
   msansy = {
      class = "variable",
      char = "𝗒"
   },
   msansz = {
      class = "variable",
      char = "𝗓"
   },
   mbfsansA = {
      class = "variable",
      char = "𝗔"
   },
   mbfsansB = {
      class = "variable",
      char = "𝗕"
   },
   mbfsansC = {
      class = "variable",
      char = "𝗖"
   },
   mbfsansD = {
      class = "variable",
      char = "𝗗"
   },
   mbfsansE = {
      class = "variable",
      char = "𝗘"
   },
   mbfsansF = {
      class = "variable",
      char = "𝗙"
   },
   mbfsansG = {
      class = "variable",
      char = "𝗚"
   },
   mbfsansH = {
      class = "variable",
      char = "𝗛"
   },
   mbfsansI = {
      class = "variable",
      char = "𝗜"
   },
   mbfsansJ = {
      class = "variable",
      char = "𝗝"
   },
   mbfsansK = {
      class = "variable",
      char = "𝗞"
   },
   mbfsansL = {
      class = "variable",
      char = "𝗟"
   },
   mbfsansM = {
      class = "variable",
      char = "𝗠"
   },
   mbfsansN = {
      class = "variable",
      char = "𝗡"
   },
   mbfsansO = {
      class = "variable",
      char = "𝗢"
   },
   mbfsansP = {
      class = "variable",
      char = "𝗣"
   },
   mbfsansQ = {
      class = "variable",
      char = "𝗤"
   },
   mbfsansR = {
      class = "variable",
      char = "𝗥"
   },
   mbfsansS = {
      class = "variable",
      char = "𝗦"
   },
   mbfsansT = {
      class = "variable",
      char = "𝗧"
   },
   mbfsansU = {
      class = "variable",
      char = "𝗨"
   },
   mbfsansV = {
      class = "variable",
      char = "𝗩"
   },
   mbfsansW = {
      class = "variable",
      char = "𝗪"
   },
   mbfsansX = {
      class = "variable",
      char = "𝗫"
   },
   mbfsansY = {
      class = "variable",
      char = "𝗬"
   },
   mbfsansZ = {
      class = "variable",
      char = "𝗭"
   },
   mbfsansa = {
      class = "variable",
      char = "𝗮"
   },
   mbfsansb = {
      class = "variable",
      char = "𝗯"
   },
   mbfsansc = {
      class = "variable",
      char = "𝗰"
   },
   mbfsansd = {
      class = "variable",
      char = "𝗱"
   },
   mbfsanse = {
      class = "variable",
      char = "𝗲"
   },
   mbfsansf = {
      class = "variable",
      char = "𝗳"
   },
   mbfsansg = {
      class = "variable",
      char = "𝗴"
   },
   mbfsansh = {
      class = "variable",
      char = "𝗵"
   },
   mbfsansi = {
      class = "variable",
      char = "𝗶"
   },
   mbfsansj = {
      class = "variable",
      char = "𝗷"
   },
   mbfsansk = {
      class = "variable",
      char = "𝗸"
   },
   mbfsansl = {
      class = "variable",
      char = "𝗹"
   },
   mbfsansm = {
      class = "variable",
      char = "𝗺"
   },
   mbfsansn = {
      class = "variable",
      char = "𝗻"
   },
   mbfsanso = {
      class = "variable",
      char = "𝗼"
   },
   mbfsansp = {
      class = "variable",
      char = "𝗽"
   },
   mbfsansq = {
      class = "variable",
      char = "𝗾"
   },
   mbfsansr = {
      class = "variable",
      char = "𝗿"
   },
   mbfsanss = {
      class = "variable",
      char = "𝘀"
   },
   mbfsanst = {
      class = "variable",
      char = "𝘁"
   },
   mbfsansu = {
      class = "variable",
      char = "𝘂"
   },
   mbfsansv = {
      class = "variable",
      char = "𝘃"
   },
   mbfsansw = {
      class = "variable",
      char = "𝘄"
   },
   mbfsansx = {
      class = "variable",
      char = "𝘅"
   },
   mbfsansy = {
      class = "variable",
      char = "𝘆"
   },
   mbfsansz = {
      class = "variable",
      char = "𝘇"
   },
   mitsansA = {
      class = "variable",
      char = "𝘈"
   },
   mitsansB = {
      class = "variable",
      char = "𝘉"
   },
   mitsansC = {
      class = "variable",
      char = "𝘊"
   },
   mitsansD = {
      class = "variable",
      char = "𝘋"
   },
   mitsansE = {
      class = "variable",
      char = "𝘌"
   },
   mitsansF = {
      class = "variable",
      char = "𝘍"
   },
   mitsansG = {
      class = "variable",
      char = "𝘎"
   },
   mitsansH = {
      class = "variable",
      char = "𝘏"
   },
   mitsansI = {
      class = "variable",
      char = "𝘐"
   },
   mitsansJ = {
      class = "variable",
      char = "𝘑"
   },
   mitsansK = {
      class = "variable",
      char = "𝘒"
   },
   mitsansL = {
      class = "variable",
      char = "𝘓"
   },
   mitsansM = {
      class = "variable",
      char = "𝘔"
   },
   mitsansN = {
      class = "variable",
      char = "𝘕"
   },
   mitsansO = {
      class = "variable",
      char = "𝘖"
   },
   mitsansP = {
      class = "variable",
      char = "𝘗"
   },
   mitsansQ = {
      class = "variable",
      char = "𝘘"
   },
   mitsansR = {
      class = "variable",
      char = "𝘙"
   },
   mitsansS = {
      class = "variable",
      char = "𝘚"
   },
   mitsansT = {
      class = "variable",
      char = "𝘛"
   },
   mitsansU = {
      class = "variable",
      char = "𝘜"
   },
   mitsansV = {
      class = "variable",
      char = "𝘝"
   },
   mitsansW = {
      class = "variable",
      char = "𝘞"
   },
   mitsansX = {
      class = "variable",
      char = "𝘟"
   },
   mitsansY = {
      class = "variable",
      char = "𝘠"
   },
   mitsansZ = {
      class = "variable",
      char = "𝘡"
   },
   mitsansa = {
      class = "variable",
      char = "𝘢"
   },
   mitsansb = {
      class = "variable",
      char = "𝘣"
   },
   mitsansc = {
      class = "variable",
      char = "𝘤"
   },
   mitsansd = {
      class = "variable",
      char = "𝘥"
   },
   mitsanse = {
      class = "variable",
      char = "𝘦"
   },
   mitsansf = {
      class = "variable",
      char = "𝘧"
   },
   mitsansg = {
      class = "variable",
      char = "𝘨"
   },
   mitsansh = {
      class = "variable",
      char = "𝘩"
   },
   mitsansi = {
      class = "variable",
      char = "𝘪"
   },
   mitsansj = {
      class = "variable",
      char = "𝘫"
   },
   mitsansk = {
      class = "variable",
      char = "𝘬"
   },
   mitsansl = {
      class = "variable",
      char = "𝘭"
   },
   mitsansm = {
      class = "variable",
      char = "𝘮"
   },
   mitsansn = {
      class = "variable",
      char = "𝘯"
   },
   mitsanso = {
      class = "variable",
      char = "𝘰"
   },
   mitsansp = {
      class = "variable",
      char = "𝘱"
   },
   mitsansq = {
      class = "variable",
      char = "𝘲"
   },
   mitsansr = {
      class = "variable",
      char = "𝘳"
   },
   mitsanss = {
      class = "variable",
      char = "𝘴"
   },
   mitsanst = {
      class = "variable",
      char = "𝘵"
   },
   mitsansu = {
      class = "variable",
      char = "𝘶"
   },
   mitsansv = {
      class = "variable",
      char = "𝘷"
   },
   mitsansw = {
      class = "variable",
      char = "𝘸"
   },
   mitsansx = {
      class = "variable",
      char = "𝘹"
   },
   mitsansy = {
      class = "variable",
      char = "𝘺"
   },
   mitsansz = {
      class = "variable",
      char = "𝘻"
   },
   mbfitsansA = {
      class = "variable",
      char = "𝘼"
   },
   mbfitsansB = {
      class = "variable",
      char = "𝘽"
   },
   mbfitsansC = {
      class = "variable",
      char = "𝘾"
   },
   mbfitsansD = {
      class = "variable",
      char = "𝘿"
   },
   mbfitsansE = {
      class = "variable",
      char = "𝙀"
   },
   mbfitsansF = {
      class = "variable",
      char = "𝙁"
   },
   mbfitsansG = {
      class = "variable",
      char = "𝙂"
   },
   mbfitsansH = {
      class = "variable",
      char = "𝙃"
   },
   mbfitsansI = {
      class = "variable",
      char = "𝙄"
   },
   mbfitsansJ = {
      class = "variable",
      char = "𝙅"
   },
   mbfitsansK = {
      class = "variable",
      char = "𝙆"
   },
   mbfitsansL = {
      class = "variable",
      char = "𝙇"
   },
   mbfitsansM = {
      class = "variable",
      char = "𝙈"
   },
   mbfitsansN = {
      class = "variable",
      char = "𝙉"
   },
   mbfitsansO = {
      class = "variable",
      char = "𝙊"
   },
   mbfitsansP = {
      class = "variable",
      char = "𝙋"
   },
   mbfitsansQ = {
      class = "variable",
      char = "𝙌"
   },
   mbfitsansR = {
      class = "variable",
      char = "𝙍"
   },
   mbfitsansS = {
      class = "variable",
      char = "𝙎"
   },
   mbfitsansT = {
      class = "variable",
      char = "𝙏"
   },
   mbfitsansU = {
      class = "variable",
      char = "𝙐"
   },
   mbfitsansV = {
      class = "variable",
      char = "𝙑"
   },
   mbfitsansW = {
      class = "variable",
      char = "𝙒"
   },
   mbfitsansX = {
      class = "variable",
      char = "𝙓"
   },
   mbfitsansY = {
      class = "variable",
      char = "𝙔"
   },
   mbfitsansZ = {
      class = "variable",
      char = "𝙕"
   },
   mbfitsansa = {
      class = "variable",
      char = "𝙖"
   },
   mbfitsansb = {
      class = "variable",
      char = "𝙗"
   },
   mbfitsansc = {
      class = "variable",
      char = "𝙘"
   },
   mbfitsansd = {
      class = "variable",
      char = "𝙙"
   },
   mbfitsanse = {
      class = "variable",
      char = "𝙚"
   },
   mbfitsansf = {
      class = "variable",
      char = "𝙛"
   },
   mbfitsansg = {
      class = "variable",
      char = "𝙜"
   },
   mbfitsansh = {
      class = "variable",
      char = "𝙝"
   },
   mbfitsansi = {
      class = "variable",
      char = "𝙞"
   },
   mbfitsansj = {
      class = "variable",
      char = "𝙟"
   },
   mbfitsansk = {
      class = "variable",
      char = "𝙠"
   },
   mbfitsansl = {
      class = "variable",
      char = "𝙡"
   },
   mbfitsansm = {
      class = "variable",
      char = "𝙢"
   },
   mbfitsansn = {
      class = "variable",
      char = "𝙣"
   },
   mbfitsanso = {
      class = "variable",
      char = "𝙤"
   },
   mbfitsansp = {
      class = "variable",
      char = "𝙥"
   },
   mbfitsansq = {
      class = "variable",
      char = "𝙦"
   },
   mbfitsansr = {
      class = "variable",
      char = "𝙧"
   },
   mbfitsanss = {
      class = "variable",
      char = "𝙨"
   },
   mbfitsanst = {
      class = "variable",
      char = "𝙩"
   },
   mbfitsansu = {
      class = "variable",
      char = "𝙪"
   },
   mbfitsansv = {
      class = "variable",
      char = "𝙫"
   },
   mbfitsansw = {
      class = "variable",
      char = "𝙬"
   },
   mbfitsansx = {
      class = "variable",
      char = "𝙭"
   },
   mbfitsansy = {
      class = "variable",
      char = "𝙮"
   },
   mbfitsansz = {
      class = "variable",
      char = "𝙯"
   },
   mttA = {
      class = "variable",
      char = "𝙰"
   },
   mttB = {
      class = "variable",
      char = "𝙱"
   },
   mttC = {
      class = "variable",
      char = "𝙲"
   },
   mttD = {
      class = "variable",
      char = "𝙳"
   },
   mttE = {
      class = "variable",
      char = "𝙴"
   },
   mttF = {
      class = "variable",
      char = "𝙵"
   },
   mttG = {
      class = "variable",
      char = "𝙶"
   },
   mttH = {
      class = "variable",
      char = "𝙷"
   },
   mttI = {
      class = "variable",
      char = "𝙸"
   },
   mttJ = {
      class = "variable",
      char = "𝙹"
   },
   mttK = {
      class = "variable",
      char = "𝙺"
   },
   mttL = {
      class = "variable",
      char = "𝙻"
   },
   mttM = {
      class = "variable",
      char = "𝙼"
   },
   mttN = {
      class = "variable",
      char = "𝙽"
   },
   mttO = {
      class = "variable",
      char = "𝙾"
   },
   mttP = {
      class = "variable",
      char = "𝙿"
   },
   mttQ = {
      class = "variable",
      char = "𝚀"
   },
   mttR = {
      class = "variable",
      char = "𝚁"
   },
   mttS = {
      class = "variable",
      char = "𝚂"
   },
   mttT = {
      class = "variable",
      char = "𝚃"
   },
   mttU = {
      class = "variable",
      char = "𝚄"
   },
   mttV = {
      class = "variable",
      char = "𝚅"
   },
   mttW = {
      class = "variable",
      char = "𝚆"
   },
   mttX = {
      class = "variable",
      char = "𝚇"
   },
   mttY = {
      class = "variable",
      char = "𝚈"
   },
   mttZ = {
      class = "variable",
      char = "𝚉"
   },
   mtta = {
      class = "variable",
      char = "𝚊"
   },
   mttb = {
      class = "variable",
      char = "𝚋"
   },
   mttc = {
      class = "variable",
      char = "𝚌"
   },
   mttd = {
      class = "variable",
      char = "𝚍"
   },
   mtte = {
      class = "variable",
      char = "𝚎"
   },
   mttf = {
      class = "variable",
      char = "𝚏"
   },
   mttg = {
      class = "variable",
      char = "𝚐"
   },
   mtth = {
      class = "variable",
      char = "𝚑"
   },
   mtti = {
      class = "variable",
      char = "𝚒"
   },
   mttj = {
      class = "variable",
      char = "𝚓"
   },
   mttk = {
      class = "variable",
      char = "𝚔"
   },
   mttl = {
      class = "variable",
      char = "𝚕"
   },
   mttm = {
      class = "variable",
      char = "𝚖"
   },
   mttn = {
      class = "variable",
      char = "𝚗"
   },
   mtto = {
      class = "variable",
      char = "𝚘"
   },
   mttp = {
      class = "variable",
      char = "𝚙"
   },
   mttq = {
      class = "variable",
      char = "𝚚"
   },
   mttr = {
      class = "variable",
      char = "𝚛"
   },
   mtts = {
      class = "variable",
      char = "𝚜"
   },
   mttt = {
      class = "variable",
      char = "𝚝"
   },
   mttu = {
      class = "variable",
      char = "𝚞"
   },
   mttv = {
      class = "variable",
      char = "𝚟"
   },
   mttw = {
      class = "variable",
      char = "𝚠"
   },
   mttx = {
      class = "variable",
      char = "𝚡"
   },
   mtty = {
      class = "variable",
      char = "𝚢"
   },
   mttz = {
      class = "variable",
      char = "𝚣"
   },
   imath = {
      class = "variable",
      char = "𝚤",
      safe = true
   },
   jmath = {
      class = "variable",
      char = "𝚥",
      safe = true
   },
   mbfAlpha = {
      class = "variable",
      char = "𝚨"
   },
   mbfBeta = {
      class = "variable",
      char = "𝚩"
   },
   mbfGamma = {
      class = "variable",
      char = "𝚪"
   },
   mbfDelta = {
      class = "variable",
      char = "𝚫"
   },
   mbfEpsilon = {
      class = "variable",
      char = "𝚬"
   },
   mbfZeta = {
      class = "variable",
      char = "𝚭"
   },
   mbfEta = {
      class = "variable",
      char = "𝚮"
   },
   mbfTheta = {
      class = "variable",
      char = "𝚯"
   },
   mbfIota = {
      class = "variable",
      char = "𝚰"
   },
   mbfKappa = {
      class = "variable",
      char = "𝚱"
   },
   mbfLambda = {
      class = "variable",
      char = "𝚲"
   },
   mbfMu = {
      class = "variable",
      char = "𝚳"
   },
   mbfNu = {
      class = "variable",
      char = "𝚴"
   },
   mbfXi = {
      class = "variable",
      char = "𝚵"
   },
   mbfOmicron = {
      class = "variable",
      char = "𝚶"
   },
   mbfPi = {
      class = "variable",
      char = "𝚷"
   },
   mbfRho = {
      class = "variable",
      char = "𝚸"
   },
   mbfvarTheta = {
      class = "variable",
      char = "𝚹"
   },
   mbfSigma = {
      class = "variable",
      char = "𝚺"
   },
   mbfTau = {
      class = "variable",
      char = "𝚻"
   },
   mbfUpsilon = {
      class = "variable",
      char = "𝚼"
   },
   mbfPhi = {
      class = "variable",
      char = "𝚽"
   },
   mbfChi = {
      class = "variable",
      char = "𝚾"
   },
   mbfPsi = {
      class = "variable",
      char = "𝚿"
   },
   mbfOmega = {
      class = "variable",
      char = "𝛀"
   },
   mbfnabla = "𝛁",
   mbfalpha = {
      class = "variable",
      char = "𝛂"
   },
   mbfbeta = {
      class = "variable",
      char = "𝛃"
   },
   mbfgamma = {
      class = "variable",
      char = "𝛄"
   },
   mbfdelta = {
      class = "variable",
      char = "𝛅"
   },
   mbfepsilon = {
      class = "variable",
      char = "𝛆"
   },
   mbfzeta = {
      class = "variable",
      char = "𝛇"
   },
   mbfeta = {
      class = "variable",
      char = "𝛈"
   },
   mbftheta = {
      class = "variable",
      char = "𝛉"
   },
   mbfiota = {
      class = "variable",
      char = "𝛊"
   },
   mbfkappa = {
      class = "variable",
      char = "𝛋"
   },
   mbflambda = {
      class = "variable",
      char = "𝛌"
   },
   mbfmu = {
      class = "variable",
      char = "𝛍"
   },
   mbfnu = {
      class = "variable",
      char = "𝛎"
   },
   mbfxi = {
      class = "variable",
      char = "𝛏"
   },
   mbfomicron = {
      class = "variable",
      char = "𝛐"
   },
   mbfpi = {
      class = "variable",
      char = "𝛑"
   },
   mbfrho = {
      class = "variable",
      char = "𝛒"
   },
   mbfvarsigma = {
      class = "variable",
      char = "𝛓"
   },
   mbfsigma = {
      class = "variable",
      char = "𝛔"
   },
   mbftau = {
      class = "variable",
      char = "𝛕"
   },
   mbfupsilon = {
      class = "variable",
      char = "𝛖"
   },
   mbfvarphi = {
      class = "variable",
      char = "𝛗"
   },
   mbfchi = {
      class = "variable",
      char = "𝛘"
   },
   mbfpsi = {
      class = "variable",
      char = "𝛙"
   },
   mbfomega = {
      class = "variable",
      char = "𝛚"
   },
   mbfpartial = "𝛛",
   mbfvarepsilon = {
      class = "variable",
      char = "𝛜"
   },
   mbfvartheta = {
      class = "variable",
      char = "𝛝"
   },
   mbfvarkappa = {
      class = "variable",
      char = "𝛞"
   },
   mbfphi = {
      class = "variable",
      char = "𝛟"
   },
   mbfvarrho = {
      class = "variable",
      char = "𝛠"
   },
   mbfvarpi = {
      class = "variable",
      char = "𝛡"
   },
   mitAlpha = {
      class = "variable",
      char = "𝛢"
   },
   mitBeta = {
      class = "variable",
      char = "𝛣"
   },
   mitGamma = {
      class = "variable",
      char = "𝛤"
   },
   mitDelta = {
      class = "variable",
      char = "𝛥"
   },
   mitEpsilon = {
      class = "variable",
      char = "𝛦"
   },
   mitZeta = {
      class = "variable",
      char = "𝛧"
   },
   mitEta = {
      class = "variable",
      char = "𝛨"
   },
   mitTheta = {
      class = "variable",
      char = "𝛩"
   },
   mitIota = {
      class = "variable",
      char = "𝛪"
   },
   mitKappa = {
      class = "variable",
      char = "𝛫"
   },
   mitLambda = {
      class = "variable",
      char = "𝛬"
   },
   mitMu = {
      class = "variable",
      char = "𝛭"
   },
   mitNu = {
      class = "variable",
      char = "𝛮"
   },
   mitXi = {
      class = "variable",
      char = "𝛯"
   },
   mitOmicron = {
      class = "variable",
      char = "𝛰"
   },
   mitPi = {
      class = "variable",
      char = "𝛱"
   },
   mitRho = {
      class = "variable",
      char = "𝛲"
   },
   mitvarTheta = {
      class = "variable",
      char = "𝛳"
   },
   mitSigma = {
      class = "variable",
      char = "𝛴"
   },
   mitTau = {
      class = "variable",
      char = "𝛵"
   },
   mitUpsilon = {
      class = "variable",
      char = "𝛶"
   },
   mitPhi = {
      class = "variable",
      char = "𝛷"
   },
   mitChi = {
      class = "variable",
      char = "𝛸"
   },
   mitPsi = {
      class = "variable",
      char = "𝛹"
   },
   mitOmega = {
      class = "variable",
      char = "𝛺"
   },
   mitnabla = "𝛻",
   mitalpha = {
      class = "variable",
      char = "𝛼"
   },
   mitbeta = {
      class = "variable",
      char = "𝛽"
   },
   mitgamma = {
      class = "variable",
      char = "𝛾"
   },
   mitdelta = {
      class = "variable",
      char = "𝛿"
   },
   mitepsilon = {
      class = "variable",
      char = "𝜀"
   },
   mitzeta = {
      class = "variable",
      char = "𝜁"
   },
   miteta = {
      class = "variable",
      char = "𝜂"
   },
   mittheta = {
      class = "variable",
      char = "𝜃"
   },
   mitiota = {
      class = "variable",
      char = "𝜄"
   },
   mitkappa = {
      class = "variable",
      char = "𝜅"
   },
   mitlambda = {
      class = "variable",
      char = "𝜆"
   },
   mitmu = {
      class = "variable",
      char = "𝜇"
   },
   mitnu = {
      class = "variable",
      char = "𝜈"
   },
   mitxi = {
      class = "variable",
      char = "𝜉"
   },
   mitomicron = {
      class = "variable",
      char = "𝜊"
   },
   mitpi = {
      class = "variable",
      char = "𝜋"
   },
   mitrho = {
      class = "variable",
      char = "𝜌"
   },
   mitvarsigma = {
      class = "variable",
      char = "𝜍"
   },
   mitsigma = {
      class = "variable",
      char = "𝜎"
   },
   mittau = {
      class = "variable",
      char = "𝜏"
   },
   mitupsilon = {
      class = "variable",
      char = "𝜐"
   },
   mitphi = {
      class = "variable",
      char = "𝜑"
   },
   mitchi = {
      class = "variable",
      char = "𝜒"
   },
   mitpsi = {
      class = "variable",
      char = "𝜓"
   },
   mitomega = {
      class = "variable",
      char = "𝜔"
   },
   mitpartial = "𝜕",
   mitvarepsilon = {
      class = "variable",
      char = "𝜖"
   },
   mitvartheta = {
      class = "variable",
      char = "𝜗"
   },
   mitvarkappa = {
      class = "variable",
      char = "𝜘"
   },
   mitvarphi = {
      class = "variable",
      char = "𝜙"
   },
   mitvarrho = {
      class = "variable",
      char = "𝜚"
   },
   mitvarpi = {
      class = "variable",
      char = "𝜛"
   },
   mbfitAlpha = {
      class = "variable",
      char = "𝜜"
   },
   mbfitBeta = {
      class = "variable",
      char = "𝜝"
   },
   mbfitGamma = {
      class = "variable",
      char = "𝜞"
   },
   mbfitDelta = {
      class = "variable",
      char = "𝜟"
   },
   mbfitEpsilon = {
      class = "variable",
      char = "𝜠"
   },
   mbfitZeta = {
      class = "variable",
      char = "𝜡"
   },
   mbfitEta = {
      class = "variable",
      char = "𝜢"
   },
   mbfitTheta = {
      class = "variable",
      char = "𝜣"
   },
   mbfitIota = {
      class = "variable",
      char = "𝜤"
   },
   mbfitKappa = {
      class = "variable",
      char = "𝜥"
   },
   mbfitLambda = {
      class = "variable",
      char = "𝜦"
   },
   mbfitMu = {
      class = "variable",
      char = "𝜧"
   },
   mbfitNu = {
      class = "variable",
      char = "𝜨"
   },
   mbfitXi = {
      class = "variable",
      char = "𝜩"
   },
   mbfitOmicron = {
      class = "variable",
      char = "𝜪"
   },
   mbfitPi = {
      class = "variable",
      char = "𝜫"
   },
   mbfitRho = {
      class = "variable",
      char = "𝜬"
   },
   mbfitvarTheta = {
      class = "variable",
      char = "𝜭"
   },
   mbfitSigma = {
      class = "variable",
      char = "𝜮"
   },
   mbfitTau = {
      class = "variable",
      char = "𝜯"
   },
   mbfitUpsilon = {
      class = "variable",
      char = "𝜰"
   },
   mbfitPhi = {
      class = "variable",
      char = "𝜱"
   },
   mbfitChi = {
      class = "variable",
      char = "𝜲"
   },
   mbfitPsi = {
      class = "variable",
      char = "𝜳"
   },
   mbfitOmega = {
      class = "variable",
      char = "𝜴"
   },
   mbfitnabla = "𝜵",
   mbfitalpha = {
      class = "variable",
      char = "𝜶"
   },
   mbfitbeta = {
      class = "variable",
      char = "𝜷"
   },
   mbfitgamma = {
      class = "variable",
      char = "𝜸"
   },
   mbfitdelta = {
      class = "variable",
      char = "𝜹"
   },
   mbfitepsilon = {
      class = "variable",
      char = "𝜺"
   },
   mbfitzeta = {
      class = "variable",
      char = "𝜻"
   },
   mbfiteta = {
      class = "variable",
      char = "𝜼"
   },
   mbfittheta = {
      class = "variable",
      char = "𝜽"
   },
   mbfitiota = {
      class = "variable",
      char = "𝜾"
   },
   mbfitkappa = {
      class = "variable",
      char = "𝜿"
   },
   mbfitlambda = {
      class = "variable",
      char = "𝝀"
   },
   mbfitmu = {
      class = "variable",
      char = "𝝁"
   },
   mbfitnu = {
      class = "variable",
      char = "𝝂"
   },
   mbfitxi = {
      class = "variable",
      char = "𝝃"
   },
   mbfitomicron = {
      class = "variable",
      char = "𝝄"
   },
   mbfitpi = {
      class = "variable",
      char = "𝝅"
   },
   mbfitrho = {
      class = "variable",
      char = "𝝆"
   },
   mbfitvarsigma = {
      class = "variable",
      char = "𝝇"
   },
   mbfitsigma = {
      class = "variable",
      char = "𝝈"
   },
   mbfittau = {
      class = "variable",
      char = "𝝉"
   },
   mbfitupsilon = {
      class = "variable",
      char = "𝝊"
   },
   mbfitphi = {
      class = "variable",
      char = "𝝋"
   },
   mbfitchi = {
      class = "variable",
      char = "𝝌"
   },
   mbfitpsi = {
      class = "variable",
      char = "𝝍"
   },
   mbfitomega = {
      class = "variable",
      char = "𝝎"
   },
   mbfitpartial = "𝝏",
   mbfitvarepsilon = {
      class = "variable",
      char = "𝝐"
   },
   mbfitvartheta = {
      class = "variable",
      char = "𝝑"
   },
   mbfitvarkappa = {
      class = "variable",
      char = "𝝒"
   },
   mbfitvarphi = {
      class = "variable",
      char = "𝝓"
   },
   mbfitvarrho = {
      class = "variable",
      char = "𝝔"
   },
   mbfitvarpi = {
      class = "variable",
      char = "𝝕"
   },
   mbfsansAlpha = {
      class = "variable",
      char = "𝝖"
   },
   mbfsansBeta = {
      class = "variable",
      char = "𝝗"
   },
   mbfsansGamma = {
      class = "variable",
      char = "𝝘"
   },
   mbfsansDelta = {
      class = "variable",
      char = "𝝙"
   },
   mbfsansEpsilon = {
      class = "variable",
      char = "𝝚"
   },
   mbfsansZeta = {
      class = "variable",
      char = "𝝛"
   },
   mbfsansEta = {
      class = "variable",
      char = "𝝜"
   },
   mbfsansTheta = {
      class = "variable",
      char = "𝝝"
   },
   mbfsansIota = {
      class = "variable",
      char = "𝝞"
   },
   mbfsansKappa = {
      class = "variable",
      char = "𝝟"
   },
   mbfsansLambda = {
      class = "variable",
      char = "𝝠"
   },
   mbfsansMu = {
      class = "variable",
      char = "𝝡"
   },
   mbfsansNu = {
      class = "variable",
      char = "𝝢"
   },
   mbfsansXi = {
      class = "variable",
      char = "𝝣"
   },
   mbfsansOmicron = {
      class = "variable",
      char = "𝝤"
   },
   mbfsansPi = {
      class = "variable",
      char = "𝝥"
   },
   mbfsansRho = {
      class = "variable",
      char = "𝝦"
   },
   mbfsansvarTheta = {
      class = "variable",
      char = "𝝧"
   },
   mbfsansSigma = {
      class = "variable",
      char = "𝝨"
   },
   mbfsansTau = {
      class = "variable",
      char = "𝝩"
   },
   mbfsansUpsilon = {
      class = "variable",
      char = "𝝪"
   },
   mbfsansPhi = {
      class = "variable",
      char = "𝝫"
   },
   mbfsansChi = {
      class = "variable",
      char = "𝝬"
   },
   mbfsansPsi = {
      class = "variable",
      char = "𝝭"
   },
   mbfsansOmega = {
      class = "variable",
      char = "𝝮"
   },
   mbfsansnabla = "𝝯",
   mbfsansalpha = {
      class = "variable",
      char = "𝝰"
   },
   mbfsansbeta = {
      class = "variable",
      char = "𝝱"
   },
   mbfsansgamma = {
      class = "variable",
      char = "𝝲"
   },
   mbfsansdelta = {
      class = "variable",
      char = "𝝳"
   },
   mbfsansepsilon = {
      class = "variable",
      char = "𝝴"
   },
   mbfsanszeta = {
      class = "variable",
      char = "𝝵"
   },
   mbfsanseta = {
      class = "variable",
      char = "𝝶"
   },
   mbfsanstheta = {
      class = "variable",
      char = "𝝷"
   },
   mbfsansiota = {
      class = "variable",
      char = "𝝸"
   },
   mbfsanskappa = {
      class = "variable",
      char = "𝝹"
   },
   mbfsanslambda = {
      class = "variable",
      char = "𝝺"
   },
   mbfsansmu = {
      class = "variable",
      char = "𝝻"
   },
   mbfsansnu = {
      class = "variable",
      char = "𝝼"
   },
   mbfsansxi = {
      class = "variable",
      char = "𝝽"
   },
   mbfsansomicron = {
      class = "variable",
      char = "𝝾"
   },
   mbfsanspi = {
      class = "variable",
      char = "𝝿"
   },
   mbfsansrho = {
      class = "variable",
      char = "𝞀"
   },
   mbfsansvarsigma = {
      class = "variable",
      char = "𝞁"
   },
   mbfsanssigma = {
      class = "variable",
      char = "𝞂"
   },
   mbfsanstau = {
      class = "variable",
      char = "𝞃"
   },
   mbfsansupsilon = {
      class = "variable",
      char = "𝞄"
   },
   mbfsansphi = {
      class = "variable",
      char = "𝞅"
   },
   mbfsanschi = {
      class = "variable",
      char = "𝞆"
   },
   mbfsanspsi = {
      class = "variable",
      char = "𝞇"
   },
   mbfsansomega = {
      class = "variable",
      char = "𝞈"
   },
   mbfsanspartial = "𝞉",
   mbfsansvarepsilon = {
      class = "variable",
      char = "𝞊"
   },
   mbfsansvartheta = {
      class = "variable",
      char = "𝞋"
   },
   mbfsansvarkappa = {
      class = "variable",
      char = "𝞌"
   },
   mbfsansvarphi = {
      class = "variable",
      char = "𝞍"
   },
   mbfsansvarrho = {
      class = "variable",
      char = "𝞎"
   },
   mbfsansvarpi = {
      class = "variable",
      char = "𝞏"
   },
   mbfitsansAlpha = {
      class = "variable",
      char = "𝞐"
   },
   mbfitsansBeta = {
      class = "variable",
      char = "𝞑"
   },
   mbfitsansGamma = {
      class = "variable",
      char = "𝞒"
   },
   mbfitsansDelta = {
      class = "variable",
      char = "𝞓"
   },
   mbfitsansEpsilon = {
      class = "variable",
      char = "𝞔"
   },
   mbfitsansZeta = {
      class = "variable",
      char = "𝞕"
   },
   mbfitsansEta = {
      class = "variable",
      char = "𝞖"
   },
   mbfitsansTheta = {
      class = "variable",
      char = "𝞗"
   },
   mbfitsansIota = {
      class = "variable",
      char = "𝞘"
   },
   mbfitsansKappa = {
      class = "variable",
      char = "𝞙"
   },
   mbfitsansLambda = {
      class = "variable",
      char = "𝞚"
   },
   mbfitsansMu = {
      class = "variable",
      char = "𝞛"
   },
   mbfitsansNu = {
      class = "variable",
      char = "𝞜"
   },
   mbfitsansXi = {
      class = "variable",
      char = "𝞝"
   },
   mbfitsansOmicron = {
      class = "variable",
      char = "𝞞"
   },
   mbfitsansPi = {
      class = "variable",
      char = "𝞟"
   },
   mbfitsansRho = {
      class = "variable",
      char = "𝞠"
   },
   mbfitsansvarTheta = {
      class = "variable",
      char = "𝞡"
   },
   mbfitsansSigma = {
      class = "variable",
      char = "𝞢"
   },
   mbfitsansTau = {
      class = "variable",
      char = "𝞣"
   },
   mbfitsansUpsilon = {
      class = "variable",
      char = "𝞤"
   },
   mbfitsansPhi = {
      class = "variable",
      char = "𝞥"
   },
   mbfitsansChi = {
      class = "variable",
      char = "𝞦"
   },
   mbfitsansPsi = {
      class = "variable",
      char = "𝞧"
   },
   mbfitsansOmega = {
      class = "variable",
      char = "𝞨"
   },
   mbfitsansnabla = "𝞩",
   mbfitsansalpha = {
      class = "variable",
      char = "𝞪"
   },
   mbfitsansbeta = {
      class = "variable",
      char = "𝞫"
   },
   mbfitsansgamma = {
      class = "variable",
      char = "𝞬"
   },
   mbfitsansdelta = {
      class = "variable",
      char = "𝞭"
   },
   mbfitsansepsilon = {
      class = "variable",
      char = "𝞮"
   },
   mbfitsanszeta = {
      class = "variable",
      char = "𝞯"
   },
   mbfitsanseta = {
      class = "variable",
      char = "𝞰"
   },
   mbfitsanstheta = {
      class = "variable",
      char = "𝞱"
   },
   mbfitsansiota = {
      class = "variable",
      char = "𝞲"
   },
   mbfitsanskappa = {
      class = "variable",
      char = "𝞳"
   },
   mbfitsanslambda = {
      class = "variable",
      char = "𝞴"
   },
   mbfitsansmu = {
      class = "variable",
      char = "𝞵"
   },
   mbfitsansnu = {
      class = "variable",
      char = "𝞶"
   },
   mbfitsansxi = {
      class = "variable",
      char = "𝞷"
   },
   mbfitsansomicron = {
      class = "variable",
      char = "𝞸"
   },
   mbfitsanspi = {
      class = "variable",
      char = "𝞹"
   },
   mbfitsansrho = {
      class = "variable",
      char = "𝞺"
   },
   mbfitsansvarsigma = {
      class = "variable",
      char = "𝞻"
   },
   mbfitsanssigma = {
      class = "variable",
      char = "𝞼"
   },
   mbfitsanstau = {
      class = "variable",
      char = "𝞽"
   },
   mbfitsansupsilon = {
      class = "variable",
      char = "𝞾"
   },
   mbfitsansphi = {
      class = "variable",
      char = "𝞿"
   },
   mbfitsanschi = {
      class = "variable",
      char = "𝟀"
   },
   mbfitsanspsi = {
      class = "variable",
      char = "𝟁"
   },
   mbfitsansomega = {
      class = "variable",
      char = "𝟂"
   },
   mbfitsanspartial = "𝟃",
   mbfitsansvarepsilon = {
      class = "variable",
      char = "𝟄"
   },
   mbfitsansvartheta = {
      class = "variable",
      char = "𝟅"
   },
   mbfitsansvarkappa = {
      class = "variable",
      char = "𝟆"
   },
   mbfitsansvarphi = {
      class = "variable",
      char = "𝟇"
   },
   mbfitsansvarrho = {
      class = "variable",
      char = "𝟈"
   },
   mbfitsansvarpi = {
      class = "variable",
      char = "𝟉"
   },
   mbfDigamma = {
      class = "variable",
      char = "𝟊"
   },
   mbfdigamma = {
      class = "variable",
      char = "𝟋"
   },
   mbfzero = "𝟎",
   mbfone = "𝟏",
   mbftwo = "𝟐",
   mbfthree = "𝟑",
   mbffour = "𝟒",
   mbffive = "𝟓",
   mbfsix = "𝟔",
   mbfseven = "𝟕",
   mbfeight = "𝟖",
   mbfnine = "𝟗",
   Bbbzero = "𝟘",
   Bbbone = "𝟙",
   Bbbtwo = "𝟚",
   Bbbthree = "𝟛",
   Bbbfour = "𝟜",
   Bbbfive = "𝟝",
   Bbbsix = "𝟞",
   Bbbseven = "𝟟",
   Bbbeight = "𝟠",
   Bbbnine = "𝟡",
   msanszero = "𝟢",
   msansone = "𝟣",
   msanstwo = "𝟤",
   msansthree = "𝟥",
   msansfour = "𝟦",
   msansfive = "𝟧",
   msanssix = "𝟨",
   msansseven = "𝟩",
   msanseight = "𝟪",
   msansnine = "𝟫",
   mbfsanszero = "𝟬",
   mbfsansone = "𝟭",
   mbfsanstwo = "𝟮",
   mbfsansthree = "𝟯",
   mbfsansfour = "𝟰",
   mbfsansfive = "𝟱",
   mbfsanssix = "𝟲",
   mbfsansseven = "𝟳",
   mbfsanseight = "𝟴",
   mbfsansnine = "𝟵",
   mttzero = "𝟶",
   mttone = "𝟷",
   mtttwo = "𝟸",
   mttthree = "𝟹",
   mttfour = "𝟺",
   mttfive = "𝟻",
   mttsix = "𝟼",
   mttseven = "𝟽",
   mtteight = "𝟾",
   mttnine = "𝟿",

}

deferred_accents = {
   hat = {
      narrow = "narrowhat",
      wide = "widehat"
   },
   vec = {
      narrow = "narrowvec",
      wide = "widevec"
   }
}

-- Local Variables:
-- coding: utf-8-unix
-- End:
