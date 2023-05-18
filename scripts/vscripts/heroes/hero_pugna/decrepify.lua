function handleAbilityExecuted(event)
	local event_ability = event.event_ability
	local target = event.target
	local caster = event.caster
	if event_ability:GetName() == "pugna_decrepify" and target:GetTeam() == caster:GetTeam() then
		local ability = event.ability
		ability:ApplyDataDrivenModifier(caster, target, "pugna_decrepify_ally_debuff_active", {}):SetDuration(
			event_ability:GetDuration(), true)
	end
end