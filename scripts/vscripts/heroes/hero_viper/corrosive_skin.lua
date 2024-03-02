function handleTakeDamage(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local range = ability:GetSpecialValueFor("max_range_tooltip")
	if attacker:GetTeam() ~= caster:GetTeam() and not attacker:IsBuilding()
		and (attacker:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() <= range
		and (event.damage_flags % 32 - 16) >= 0 then	-- DOTA_DAMAGE_FLAG_REFLECTION == 16
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_corrosive_skin_debuff_datadriven", {})
		attacker:EmitSound("Hero_Viper.CorrosiveSkin")
	end
end

function handleDamage(event)
	local damageTable =
	{
		victim 		 = event.target,
		attacker 	 = event.caster,
		damage 		 = event.Damage,
		damage_type	 = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
		ability 	 = event.ability
	}
	ApplyDamage(damageTable)
end
