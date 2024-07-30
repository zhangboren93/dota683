function handleProjectileHitUnit(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target ~= ability.shuriken_target then
		return
	end
	local units = FindUnitsInRadius(caster:GetTeam(),
		target:GetAbsOrigin(),
		nil,
		900,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for i=1,#units do
		if units[i] ~= target and units[i]:HasModifier("modifier_bounty_hunter_track_aura_datadriven") then
			ProjectileManager:CreateTrackingProjectile({
				Target = units[i],
				iMoveSpeed = 1000,
				bDodgeable = true,
				EffectName = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf",
				Ability = ability,
				Source = target
			})
		end
	end
end

function handleSpellStart(event)
	local ability = event.ability
	local target = event.target
	ability.shuriken_target = target
end
