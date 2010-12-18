module("unimath")

local default_family = tex.count.g_um_default_family_int

function switch_to_family(family)
   tex.fam = family
end

function switch_to_mapping(mapping)
   tex.fam = default_family
   for key, value in mapping do
      local table = {mapping.class, default_family, mapping.char}
      tex.setmathcode(key, table)
   end
end
