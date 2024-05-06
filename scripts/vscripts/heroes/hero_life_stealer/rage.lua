require("../../items/item_magic_stick")
--[[
    author: jacklarnes
    email: christucket@gmail.com
    reddit: /u/jacklarnes
]]

function rage_start( keys )
    local caster = keys.caster

	ProcsMagicStick(keys)
    caster:Purge(false, true, false, true, false)
end
