#!/usr/bin/env texlua

require("unicode")
require("unimath-data")

local function get_family_cmd(family)
   return "\\g_um_" .. family .. "_fam"
end

local function write_families()
   for key, value in pairs(unimath.data.families) do
      local family = get_family_cmd(value)
      io.write("\\chk_if_free_cs:N " .. family .. "\n")
      io.write("\\newfam " .. family .. "\n")
      local command = "\\" .. key
      io.write("\\cs_new_protected_nopar:Npn " .. command .. " #1 { \\c_group_begin_token \\fam " .. family .. " #1 \\c_group_end_token }\n")
   end
end

local class_codes = {
   ordinary = 0,
   operator = 1,
   binary = 2,
   relation = 3,
   open = 4,
   close = 5,
   punctuation = 6,
   variable = 7
}

local function is_entity_code(entity)
   return type(entity) == "number" or (type(entity) == "string" and unicode.utf8.len(entity) == 1)
end

local function get_entity_code(entity)
   if type(entity) == "number" then
      return entity
   else
      return unicode.utf8.byte(entity)
   end
end

local function get_entity_ctlseq(entity)
   if string.byte(entity) == 0x5C then
      return entity
   else
      return "\\" .. entity
   end
end

local function start_definition(entity, safe)
   if is_entity_code(entity) then
      local code = get_entity_code(entity)
      io.write("\\luatexUmathcode " .. code .. "~ ")
   else
      local ctlseq = get_entity_ctlseq(entity)
      if safe == false then
         io.write("\\um_check_unsafe:N " .. ctlseq .. "\n")
      end
      io.write("\\luatexUmathchardef " .. ctlseq .. " ")
   end
end

-- rules 1 to 5
local function write_simple_def(entity, definition)
   -- mathematical code or character definition
   start_definition(entity, definition.safe or false)
   local class = definition.class or "ordinary"
   local family = get_family_cmd(definition.family or unimath.data.default_family)
   local char = definition.char or entity
   local code = get_entity_code(char)
   io.write(class_codes[class] .. "~ " .. family .. " " .. code .. "~\n")
   -- delimiter code
   local delim = definition.delim
   if type(delim) == "bool" and delim == true then
      delim = code
   elseif is_entity_code(delim) then
      delim = get_entity_code(delim)
   else
      delim = false
   end
   if delim ~= false then
      io.write("\\luatexUdelcode " .. code .. " = " .. family .. " " .. delim .. "~\n")
   end
end

local simple_classes = {
   ordinary = true,
   binary = true,
   relation = true,
   punctuation = true
}

local function write_immediate_defs()
   for key, value in pairs(unimath.data.characters) do
      if type(value) == "table" and simple_classes[value.class] then
         -- rules 1 and 3
         write_simple_def(key, value)
      elseif is_entity_code(value) then
         -- rule 2
         write_simple_def(key, {class = "ordinary", char = key})
      elseif type(value) == "string" and simple_classes[value] then
         -- rule 4
         write_simple_def(key, {class = value, char = key})
      end
   end
end

local function write_deferred_defs()
   for key, value in pairs(unimath.data.characters) do
   end
end

io.output("unicode-math-table-luatex-immediate.tex")
write_families()
write_immediate_defs()
io.close()

io.output("unicode-math-table-luatex-deferred.tex")
write_deferred_defs()
io.close()
