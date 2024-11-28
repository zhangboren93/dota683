function handleAbilityExecuted(event)
	if event.event_ability:GetName() == "spirit_breaker_empowering_haste" then
		event.ability:SetLevel(event.caster:FindAbilityByName("spirit_breaker_empowering_haste"):GetLevel())
		event.ability:ApplyDataDrivenModifier(event.caster, event.caster, "empowering_haste_activate_debuff_aura", {})
	end
end

function handleIntervalThink(event)
	local ability = event.ability
	local target = event.target
	local modifier = target:FindModifierByName("modifier_spirit_breaker_empowering_haste_datadriven")
	if ability:GetLevel() > 0 and ability:IsCooldownReady() then
		modifier:SetStackCount(2)
		return
	end
	local time_remaining = ability:GetCooldownTimeRemaining()
	if time_remaining < 10 then
		modifier:SetStackCount(1)
	else
		modifier:SetStackCount(3)
	end
end
