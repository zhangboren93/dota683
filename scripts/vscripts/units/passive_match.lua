function handleIntervalThink(event)
	local target_ability = event.TargetAbility
	local ability = event.ability
	local caster = event.caster
	ability:SetLevel(caster:FindAbilityByName(target_ability):GetLevel() + 1)
end