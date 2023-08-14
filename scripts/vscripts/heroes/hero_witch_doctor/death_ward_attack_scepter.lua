death_ward_attack_scepter_lua = class({})

function death_ward_attack_sceptert :GetIntrinsicModifierName()
	return "modifier_death_ward_attack_scepter_lua"
end

function death_ward_attack_scepter:OnProjectileHit_ExtraData(target, location, data)
	local caster = self:GetCaster()
	ApplyDamage({
		victim = target,
		attacker = attacker,
		damage = caster:GetAttackDamage(),
		damage_type = DAMAGE_TYPE_PHYSICAL})
	if data.bn > 3 then
		return true
	end
	local bounce_radius = self:GetSpecialValueFor("bounce_radius")
	local units = FindUnitsInRadius(caster:GetTeam(),
		target:GetAbsOrigin(),
		nil, 
		bounce_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER, 
		false)
	local units_not_target = {}
	for i=1,#units do
		if units[i] ~= target 
			and units[i]:GetEntityIndex() ~= data.bu1  
			and units[i]:GetEntityIndex() ~= data.bu2  
			and units[i]:GetEntityIndex() ~= data.bu3  
			then
			table.insert(units_not_target, units[i])
		end
	end

	local bounce_to_unit = units_not_target[RandomInt(1, #units_not_target)]
	if data.dn == 1 then
		data.dn2 = target:GetEntityIndex()
	elseif data.dn == 2 then
		dtat.dn3 = target:GetEntityIndex()
	elseif data.dn == 3 then
		dtat.dn4 = target:GetEntityIndex()
	end
	data.dn = data.dn + 1
	ProjectileManager:CreateTrackingProjectile({
		Target = bounce_to_unit,
		iMoveSpeed = caster:GetProjectileSpeed(),
		bDodgeable = true, 
		bIsAttack = true,
		EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack.vpcf",
		Ability = ability,
		Source = target,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		ExtraData = extraData})
	return true
end
