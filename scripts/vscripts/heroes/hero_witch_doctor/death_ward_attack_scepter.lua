death_ward_attack_scepter_lua = class({})

function death_ward_attack_scepter_lua:GetIntrinsicModifierName()
	return "modifier_death_ward_attack_scepter_lua"
end

function death_ward_attack_scepter_lua:OnProjectileHit_ExtraData(target, location, data)
	local caster = self:GetCaster()
	local bounces = self:GetSpecialValueFor("bounces")
	local witch_doctor = caster:GetOwner()
	local death_ward = witch_doctor:FindAbilityByName("witch_doctor_death_ward")
	local damage = death_ward:GetSpecialValueFor("damage")
	ApplyDamage({
		victim = target,
		attacker = caster, 
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
		ability = death_ward })
	if data.bn > bounces then
		return true
	end
	local bounce_radius = self:GetSpecialValueFor("bounce_radius")
	local units = FindUnitsInRadius(caster:GetTeam(),
		target:GetAbsOrigin(),
		nil, 
		bounce_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER, 
		false)
	local units_not_target = {}
	for i=1,#units do
		if units[i] ~= target then
			table.insert(units_not_target, units[i])
		end
	end

	local bounce_to_unit = units_not_target[RandomInt(1, #units_not_target)]
	data.bn = data.bn + 1
	ProjectileManager:CreateTrackingProjectile({
		Target = bounce_to_unit,
		iMoveSpeed = caster:GetProjectileSpeed(),
		bDodgeable = true, 
		bIsAttack = true,
		EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack.vpcf",
		Ability = self,
		Source = target,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		ExtraData = data})
	return true
end
