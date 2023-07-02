function handleAbilityExecuted(keys)
	local unit = keys.unit
	local ability = keys.ability
	local event_ability = keys.event_ability
	local target_ability = keys.TargetAbility
	local modifier = keys.Modifier
	local requires_scepter = keys.RequiresScepter
	if event_ability:GetName() == target_ability then
		if requires_scepter == 1 and not unit:HasScepter() then
			return
		end
		ability:SetLevel(event_ability:GetLevel())
		ability:ApplyDataDrivenModifier(unit, unit, modifier, {})
	end
end
