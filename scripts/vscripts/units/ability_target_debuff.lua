function handleAbilityExecuted(keys)
	local unit = keys.unit
	local ability = keys.ability
	local event_ability = keys.event_ability
	local target_ability = keys.TargetAbility
	local modifier = keys.Modifier
	local target = keys.target
	if event_ability:GetName() == target_ability then
		ability:SetLevel(event_ability:GetLevel())
		if not target:HasModifier(modifier) then
			ability:ApplyDataDrivenModifier(unit, target, modifier, {})
		else
			local existing_mod = target:FindModifierByName(modifier)
			existing_mod:SetDuration(keys.Duration, true)
		end
	end
end

function handleIntervalThink(keys)
	local target = keys.target
	if not target:HasModifier(keys.MainModifier) then
		target:RemoveModifierByName(keys.Modifier)
	end
end
