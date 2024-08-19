function damageStunUnits(caster, point, ability, base_damage)
	local units = FindUnitsInRadius(
		caster:GetTeam(), point, nil, 275, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, 0, 0, false) 
	for i = 1,#units do
		local unit = units[i]
		local damage = base_damage 
		if unit:HasModifier("modifier_toss_flying_lua") then
			damage = damage * 2
		end
		ApplyDamage({
			attacker = caster,
			victim = unit,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		})
		unit:AddNewModifier(caster, ability, "modifier_stunned", { duration = 1 })
	end
end

function handleSpellStart(event)
	local caster = event.caster
	local target_point = event.target_points[1]
	local ability = event.ability
	local tick_damage = ability:GetSpecialValueFor("avalanche_damage") / 4
	EmitSoundOnLocationWithCaster(target_point, "Ability.Avalanche", caster )
	if caster.avalanche_particle == nil then
		caster.avalanche_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", PATTACH_POINT, caster)
		ParticleManager:SetParticleControl(caster.avalanche_particle, 0, target_point + Vector(132, 0, 0))
		ParticleManager:SetParticleControl(caster.avalanche_particle, 1, Vector(275, 275, 1))
	end
	caster:SetThink(function()
		damageStunUnits(caster, target_point, ability, tick_damage)
	end, "avalanche delay", 0.5)
	caster:SetThink(function()
		damageStunUnits(caster, target_point, ability, tick_damage)
	end, "avalanche 2nd damage tick", 0.75)
	caster:SetThink(function()
		damageStunUnits(caster, target_point, ability, tick_damage)
	end, "avalanche 3rd damage tick", 1)
	caster:SetThink(function()
		damageStunUnits(caster, target_point, ability, tick_damage)
	end, "avalanche 4th damage tick", 1.25)
	caster:SetThink(function()
		if caster.avalanche_particle ~= nil then
			ParticleManager:DestroyParticle(caster.avalanche_particle, false)
			ParticleManager:ReleaseParticleIndex(caster.avalanche_particle)
			caster.avalanche_particle = nil
		end
	end, "stop avalanche particle", 2.5)
end
