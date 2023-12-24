function handleTakeDamage(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local range = ability:GetSpecialValueFor("max_range_tooltip")
	if attacker:GetTeam() ~= caster:GetTeam() and not attacker:IsBuilding()
		and (attacker:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() <= range then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_corrosive_skin_debuff_datadriven", {})
		attacker:EmitSound("Hero_Viper.CorrosiveSkin")
	end
end
