function handleAbilityExecuted(keys)
	local unit = keys.unit
	local ability2 = keys.ability
	local event_ability = keys.event_ability
	local target = keys.target
	if event_ability:GetName() == "item_cyclone" then
		ability2:ApplyDataDrivenModifier(unit, target, "modifier_eul_cyclone_datadriven", {}):SetDuration(2.5, true)
	end
end