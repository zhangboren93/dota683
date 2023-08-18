function handleIntervalThink(event)
	local caster = event.caster
	if not caster:HasModifier("modifier_nyx_assassin_vendetta") then
		caster:RemoveAllModifiersOfName("modifier_vendetta_physical_damage_active")
	end
end

function handleAttackLanded(event)
	local caster = event.caster
	caster:RemoveAllModifiersOfName("modifier_vendetta_physical_damage_active")
end
