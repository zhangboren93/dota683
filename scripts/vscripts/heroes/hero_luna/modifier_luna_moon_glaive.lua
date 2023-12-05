modifier_luna_moon_glaive_lua = class({})

function modifier_luna_moon_glaive_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_luna_moon_glaive_lua:IsHidden()
	return true
end

function modifier_luna_moon_glaive_lua:OnAttackLanded(event)
	local target = event.target
	local attacker = event.attacker
	local ability = self:GetAbility()
	local range = ability:GetSpecialValueFor("range")
	if attacker == self:GetParent() and not target:IsTower() and IsServer() then
		local units = FindUnitsInRadius(
			attacker:GetTeam(),
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
				iMoveSpeed = attacker:GetProjectileSpeed(),
				bDodgeable = true,
				EffectName = attacker:GetRangedProjectileName(),
				Ability = ability,
				Source = target,
				ExtraData = { 
					bounces = ability:GetSpecialValueFor("bounces")
				}
			})
		end
	end
end
