function handleAbilityExecuted(event)
	if event.event_ability:GetName() == "spirit_breaker_empowering_haste" then
		event.ability:SetLevel(event.caster:FindAbilityByName("spirit_breaker_empowering_haste"):GetLevel())
		event.ability:ApplyDataDrivenModifier(event.caster, event.caster, "empowering_haste_activate_debuff_aura", {})
	end
end