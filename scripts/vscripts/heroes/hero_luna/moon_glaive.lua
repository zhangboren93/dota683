luna_moon_glaive_lua = class({})

function luna_moon_glaive_lua:GetIntrinsicModifierName()
	return "modifier_luna_moon_glaive_lua"
end

function luna_moon_glaive_lua:OnProjectileHit_ExtraData(target, location, extraData)
	local bounces = extraData.bounces
	-- calculate damage
	local caster = self:GetCaster()
	local bounceIndex = self:GetSpecialValueFor("bounces") - bounces
	local damage = caster:GetAverageTrueAttackDamage(nil) * 0.65
	for i=1,bounceIndex do
		damage = damage * 0.65
	end
	if not target:IsAttackImmune() then
		ApplyDamage({
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = 0,
			ability = self })
		target:EmitSound("Hero_Luna.MoonGlaive.Impact")
	end
	if bounces > 1 then
		local range = self:GetSpecialValueFor("range")
		-- bounce to other targets
		local units = FindUnitsInRadius(
			caster:GetTeam(),
			target:GetAbsOrigin(),
			nil,
			range,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false)
		local units_not_target = {}
		for i=1,#units do
			if units[i] ~= target then
				table.insert(units_not_target, units[i])
			end
		end
		units = units_not_target
		if #units > 0 then
			local unit = units[RandomInt(1, #units)]
			ProjectileManager:CreateTrackingProjectile({
				Target = unit,
				iMoveSpeed = caster:GetProjectileSpeed(),
				bDodgeable = true,
				EffectName = caster:GetRangedProjectileName(),
				Ability = self,
				Source = target,
				ExtraData = { bounces = bounces - 1 }
			})
		end
	end
end
