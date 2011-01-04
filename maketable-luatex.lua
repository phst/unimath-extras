#!/usr/bin/env lua

require("unicode")
require("unimath-data")

local function write_styles(kind, data, default)
   for key, value in pairs(data) do
      local name, safe
      if type(value) == "string" then
         name = value
         safe = false
      else
         name = value.name
         safe = value.safe or false
      end
      local safe_str = safe and "safe" or "unsafe"
      local factory = "\\um_new_" .. safe_str .. "_" .. kind .. ":nN"
      local name_arg = " { " .. name .. " }"
      local isdefault = name == default
      local isdefault_arg = " { " .. tostring(isdefault) .. " }"
      local command_arg = " \\" .. key
      io.write(factory .. name_arg .. isdefault_arg .. command_arg .. "\n")
   end
   local setdefault = "\\um_set_default_" .. kind .. ":n"
   local name_arg = " { " .. default .. " }"
   io.write(setdefault .. name_arg .. "\n")
end

local function write_families()
   write_styles("family", unimath.data.families, unimath.data.default_family)
end

local function write_mappings()
   write_styles("mapping", unimath.data.mappings, unimath.data.default_mapping)
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

local function get_delim_code(entity, delim)
   if type(delim) == "nil" then
      return -1
   elseif type(delim) == "bool" then
      if delim then
         return get_entity_code(entity)
      else
         return -1
      end
   else
      return get_entity_code(delim)
   end
end


-- rules 1 to 5
local function write_simple_def(entity, definition)
   -- mathematical code or character definition
   local is_code = is_entity_code(entity)
   local factory, entity_arg
   if is_code then
      factory = "\\um_assign_mathcode:nNNn"
      local entity_code = get_entity_code(entity)
      entity_arg = " { " .. entity_code .. " }"
   else
      local safe = definition.safe or false
      local safe_str = safe and "safe" or "unsafe"
      factory = "\\um_new_" .. safe_str .. "_chdef:NNNn"
      local entity_ctlseq = get_entity_ctlseq(entity)
      entity_arg = " " .. entity_ctlseq
   end
   local class = definition.class or "ordinary"
   local class_arg = " \\c_um_class_" .. class .. "_int"
   local family = definition.family or unimath.data.default_family
   local family_arg = " \\g_um_" .. family .. "_fam"
   local char = definition.char or entity
   local mathcode = get_entity_code(char)
   local mathcode_arg = " { " .. mathcode .. " }"
   io.write(factory .. entity_arg .. class_arg .. family_arg .. mathcode_arg .. "\n")
   -- delimiter code
   if is_code then
      local delim = definition.delim or false
      if delim then
         local delcode = get_delim_code(entity, delim)
         local delcode_arg = " { " .. delcode .. " }"
         local factory = "\\um_assign_delcode:nNn"
         io.write(factory .. entity_arg .. family_arg .. delcode_arg .. "\n")
      end
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
write_mappings()
write_immediate_defs()
io.close()

io.output("unicode-math-table-luatex-deferred.tex")
write_deferred_defs()
io.close()
