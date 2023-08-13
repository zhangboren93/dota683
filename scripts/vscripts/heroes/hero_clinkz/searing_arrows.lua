function handleIntervalThink(event)
	local caster = event.caster
	if not caster:HasModifier("modifier_clinkz_searing_arrow_lua") then
		caster:AddNewModifier(caster, event.ability, "modifier_clinkz_searing_arrow_lua", {})
	end
end
