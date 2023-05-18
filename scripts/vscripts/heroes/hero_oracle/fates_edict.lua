function handleAbilityExecuted(event)
	local event_ability = event.event_ability
	local caster = event.caster
	local target = event.target
	if event_ability:GetName() == "oracle_fates_edict" then
		local ability = event.ability
		local duration = event_ability:GetSpecialValueFor("duration")
		if caster:GetTeam() == target:GetTeam() then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_oracle_fates_edict_allie_disarm", { duration = duration })
		else
			ability:ApplyDataDrivenModifier(caster, target, "modifier_oracle_fates_edict_enemy_resist", { duration = duration })
		end
	end
end