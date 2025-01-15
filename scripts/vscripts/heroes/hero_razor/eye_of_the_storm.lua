function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	if caster:HasScepter() then
		target_types = target_types + DOTA_UNIT_TARGET_BUILDING
	end
	local units = FindUnitsInRadius(caster:GetTeam(),
		caster:GetAbsOrigin(),
		nil,
		ability:GetSpecialValueFor("radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		target_types,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		FIND_ANY_ORDER,
		false)
	-- find units with the lowest health
	if #units == 0 then
		return
	end
	local unit_lowest_hp = units[1]
	for i=2,#units do
		if units[i]:GetHealth() < unit_lowest_hp:GetHealth() then
			unit_lowest_hp = units[i]
		end
	end

	print("Storm strikes " .. unit_lowest_hp:GetName())
	ability:ApplyDataDrivenModifier(caster, unit_lowest_hp, "modifier_razor_eye_debuff_datadriven", 
		{duration = caster:FindModifierByName("modifier_razor_eye_datadriven"):GetRemainingTime()})

	local flag = DOTA_DAMAGE_FLAG_NONE
	if ability:GetSpecialValueFor("bypass_block") ~= 0 then
		flag = DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK
	end

	ApplyDamage({
		victim = unit_lowest_hp,
		attacker = caster,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage = ability:GetAbilityDamage(),
		ability = ability,
		damage_flags = flag
	})
	unit_lowest_hp:EmitSound("Hero_razor.lightning")
	local particle = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf", 
		PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin() + Vector(0, 0, 400))
	ParticleManager:SetParticleControlEnt(particle, 1, unit_lowest_hp, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_lowest_hp:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)
end