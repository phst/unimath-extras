module("unimath.data")

-- Table that maps the fixed family commands to internal family names.  The
-- keys are TeX command names (without leading backslash), the values are
-- strings containing valid Lua names.
families = {
   mathup = "upright",
   mathbbit = "doublestruck_italic",
   mathbfup = "bold",
   mathnormal = "italic",
   mathit = "text_italic",
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
   mathtt = "monospace"
}

-- The default family
default_family = "upright"

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
-- 10. ζ is a table, and ζ.class is the string "variable".  Let φ be the family
--     denoted by ζ.family or, if that is nil, by the module variable
--     default_family.  If ζ.defer is true, then ζ.alphabet must be a string
--     which is a valid Lua name.  ζ.chars must be a table; each key in this
--     table must be contained as a value in the module-level families table,
--     and each value must be a string consisting of a single character or a
--     number denoting a Unicode scalar value.  Then, for each family–code
--     pair, ε is to be defined as a mathematical character with class 7
--     (variable).  If ζ.defer is true, the definition is deferred until a call
--     to \unimathsetup.
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
characters = {
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
      family = "upright",
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
      family = "upright",
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
      family = "upright",
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
      family = "upright",
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
      family = "upright",
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
      family = "upright",
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
      family = "upright",
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
      family = "upright",
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
      family = "upright",
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
      family = "upright",
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
   A = {
      class = "variable",
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      char = "["
   }
   ["\\"] = "ordinary",
   ["]"] = "close",
   rbrack = {
      class = "close",
      char = "]"
   }
   a = {
      class = "variable",
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
      family = "italic",
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
   }
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
