function handleIntervalThink(event)
	local caster = event.caster
	if not caster:HasModifier("modifier_ember_spirit_fire_remnant") then
		GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), 200, false)
		caster:RemoveModifierByName("modifier_fire_remnant_clear_tree")
	end
end