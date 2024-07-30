function handleAbilityExecuted(event)
	local caster = event.caster
	caster:RemoveModifierByName("modifier_wind_walk_datadriven")
	caster:RemoveModifierByName("modifier_invisible")
end
