function handleSpellStart(event)
	local target_point = event.target_points[1]
	local original_ability = event.ability
	local caster = event.caster
	local is_scepter_chakram = false
	local ability = event.ability
	if ability:GetName() == "shredder_chakram_2_datadriven" then
		ability = caster:FindAbilityByName("shredder_chakram_datadriven")
		is_scepter_chakram = true
	end
	local speed = ability:GetSpecialValueFor("speed")
	local radius = ability:GetSpecialValueFor("radius")
	
	local velocity = target_point - caster:GetAbsOrigin()
	velocity = Vector(velocity.x, velocity.y, 0):Normalized() * speed
	local duration = (target_point - caster:GetAbsOrigin()):Length2D() / speed
	CreateUnitByNameAsync("npc_dummy_unit", 
		caster:GetAbsOrigin(),
		false,
		caster,
		caster, 
		caster:GetTeam(),
		function(unit)
			if is_scepter_chakram then
				caster.chakram_2_dummy_unit = unit
			else
				caster.chakram_dummy_unit = unit
			end
			unit:AddNewModifier(caster, ability, "modifier_shredder_chakram_lua", { })
			unit:AddNewModifier(caster, ability, "modifier_shredder_chakram_move_lua", { vx = velocity.x, vy = velocity.y, duration = duration })
			unit.particle_id = ParticleManager:CreateParticle(
				"particles/units/heroes/hero_shredder/shredder_chakram_spin.vpcf",
				PATTACH_ABSORIGIN_FOLLOW,
				unit)
			ParticleManager:SetParticleControl(unit.particle_id, 1, Vector(radius, 0, 0))
			ParticleManager:SetParticleControlEnt(unit.particle_id, 3, unit, PATTACH_ABSORIGIN_FOLLOW, "default", Vector(0, 0, 0), false)
			if is_scepter_chakram then
				ParticleManager:SetParticleControl(unit.particle_id, 15, Vector(0, 0, 255))
				ParticleManager:SetParticleControl(unit.particle_id, 16, Vector(1, 0, 0))
			end
			unit:EmitSound("Hero_Shredder.Chakram")
		end)
	local return_ability = nil
	if is_scepter_chakram then
		return_ability = caster:FindAbilityByName("shredder_return_chakram_2_datadriven")
	else
		return_ability = caster:FindAbilityByName("shredder_return_chakram_datadriven")
	end
	if return_ability:GetLevel() == 0 then
		return_ability:SetLevel(1)
	end
	if is_scepter_chakram then
		caster:SwapAbilities("shredder_chakram_2_datadriven", "shredder_return_chakram_2_datadriven", false, true)
	else
		caster:SwapAbilities("shredder_chakram_datadriven", "shredder_return_chakram_datadriven", false, true)
	end
	caster:EmitSound("Hero_Shredder.Chakram.Cast")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shredder_chakram_disarm_datadriven", {})
	original_ability.chakram_projectile = ProjectileManager:CreateLinearProjectile({
		vSpawnOrigin = caster:GetAbsOrigin(),
		vVelocity = velocity,
		fStartRadius = radius,
		fEndRadius = radius,
		fDistance = (target_point - caster:GetAbsOrigin()):Length2D(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		Ability = ability,
		Source = caster,
		bProvidesVision = true,
		iVisionRadius = 200,
		iVisionTeamNumber = caster:GetTeam()
	})
end

function handleReturnSpellStart(event)
	local caster = event.caster
	local chakram_dummy_unit = caster.chakram_dummy_unit
	local ability = event.ability
	local is_scepter_chakram = false
	if ability:GetName() == "shredder_return_chakram_2_datadriven" then
		chakram_dummy_unit = caster.chakram_2_dummy_unit
		is_scepter_chakram = true
	end
	if not IsValidEntity(chakram_dummy_unit) then return end
	chakram_dummy_unit:AddNewModifier(caster, ability, "modifier_shredder_chakram_return_lua", {})
	caster:EmitSound("Hero_Shredder.Chakram.Return")
	local chakram_ability = caster:FindAbilityByName("shredder_chakram_datadriven")
	if is_scepter_chakram then
		chakram_ability = caster:FindAbilityByName("shredder_chakram_2_datadriven")
	end
	local chakram_projectile = chakram_ability.chakram_projectile
	if chakram_projectile ~= nil then
		ProjectileManager:DestroyLinearProjectile(chakram_projectile)
	end
	chakram_dummy_unit:RemoveModifierByName("modifier_shredder_chakram_move_lua")
end

function handleProjectileHitUnit(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = ability:GetSpecialValueFor("pass_damage")
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = ability
	})
	target:EmitSound("Hero_Shredder.Chakram.Target")
end

function handleDeath(event)
	local caster = event.caster
	local ability = event.ability
	local chakram_dummy_unit = caster.chakram_dummy_unit
	chakram_dummy_unit:StopSound("Hero_Shredder.Chakram")
	if chakram_dummy_unit.particle_id ~= nil then
		ParticleManager:DestroyParticle(chakram_dummy_unit.particle_id, false)
		chakram_dummy_unit.particle_id = nil
	end
	chakram_dummy_unit:ForceKill(false)
	if ability:IsHidden() then
		caster:SwapAbilities("shredder_chakram_datadriven", "shredder_return_chakram_datadriven", true, false)
	end
	-- clean scepter chakram
	chakram_dummy_unit = caster.chakram_2_dummy_unit
	chakram_dummy_unit:StopSound("Hero_Shredder.Chakram")
	if chakram_dummy_unit.particle_id ~= nil then
		ParticleManager:DestroyParticle(chakram_dummy_unit.particle_id, false)
		chakram_dummy_unit.particle_id = nil
	end
	chakram_dummy_unit:ForceKill(false)
	ability = caster:FindAbilityByName("shredder_chakram_2_datadriven")
	if ability:IsHidden() and ability:GetLevel() > 0 then
		caster:SwapAbilities("shredder_chakram_2_datadriven", "shredder_return_chakram_2_datadriven", true, false)
	end
end

function handleIntervalThink(event)
	local caster = event.caster
	if caster:HasScepter() then
		local chakram_2 = caster:FindAbilityByName("shredder_chakram_2_datadriven")
		if chakram_2 ~= nil and chakram_2:GetLevel() == 0 then
			chakram_2:SetLevel(1)
			chakram_2:SetHidden(false)
		end
	end
end
