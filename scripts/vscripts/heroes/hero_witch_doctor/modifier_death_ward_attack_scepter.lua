modifier_death_ward_attack_scepter_lua = class({})

function modifier_death_ward_attack_scepter_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_death_ward_attack_scepter_lua:OnAttackLanded(event)
	local caster = event.attacker
	if caster == self:GetParent() then
		local ability = self:GetAbility()
		local bounce_radius = ability:GetSpecialValueFor("bounce_radius")
		local target = event.target
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
			if units[i] ~= target then
				table.insert(units_not_target, units[i])
			end
		end
		if #units_not_target == 0 then
			return
		end
		local bounce_to_unit = units_not_target[RandomInt(1, #units_not_target)]
		ProjectileManager:CreateTrackingProjectile({
			Target = bounce_to_unit,
			iMoveSpeed = caster:GetProjectileSpeed(),
			bDodgeable = true, 
			bIsAttack = true,
			EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack.vpcf",
			Ability = ability,
			Source = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
			ExtraData = { bn = 1 }})
	end
end
