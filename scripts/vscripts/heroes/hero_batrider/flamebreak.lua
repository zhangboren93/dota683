function handleSpellStart(event)
	local target_point = event.target_points[1]
	local caster = event.caster
	local ability = event.ability
	local speed = ability:GetSpecialValueFor("speed")
	local distance = target_point - caster:GetAbsOrigin()
	caster:EmitSound("Hero_Batrider.Flamebreak")
	-- creates a dummy unit, moves it 
	CreateUnitByNameAsync("npc_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeam(), function(unit)
		unit:AddNewModifier(caster, ability, "modifier_batrider_flamebreak_projectile_lua", { duration = 2,
			speedx = distance:Normalized().x * speed, speedy = distance:Normalized().y * speed })
		unit:AddNewModifier(caster, ability, "modifier_kill", { duration = distance:Length2D() / speed })
		unit.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak.vpcf",
			PATTACH_ABSORIGIN, unit)
		ParticleManager:SetParticleControl(unit.particleId, 1, Vector(900, 0, 0))
		ParticleManager:SetParticleControl(unit.particleId, 3, target_point)
		ParticleManager:SetParticleControl(unit.particleId, 5, target_point)
	end)
	-- Create projectile for vision
	ProjectileManager:CreateLinearProjectile({
		vSpawnOrigin = caster:GetAbsOrigin(),
		vVelocity = distance:Normalized() * speed,
		fDistance = distance:Length2D(),
		bDrawsOnMinimap = false,
		bVisibleToEnemies = false,
		Ability = ability,
		Source = caster,
		bProvidesVision = true,
		iVisionRadius = 300,
		iVisionTeamNumber = caster:GetTeam()
	})
end
