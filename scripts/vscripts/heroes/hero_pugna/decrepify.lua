function handleSpellStart(event)
	local caster = event.caster
	caster:EmitSound("Hero_Pugna.Decrepify")
	local ability = event.ability
	local target = event.target
	local same_team = caster:GetTeam() == target:GetTeam()
	if not same_team and target:TriggerSpellAbsorb(ability) then return end

	local modifier_name = "modifier_pugna_decrepify_enemy_datadriven"
	if same_team then
		modifier_name = "modifier_pugna_decrepify_ally_datadriven"
	end
	ability:ApplyDataDrivenModifier(caster, target, modifier_name, { duration = ability:GetDuration() })
end
