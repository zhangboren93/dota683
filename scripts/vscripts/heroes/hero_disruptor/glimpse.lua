function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target:TriggerSpellAbsorb(ability) then return end
	target:EmitSound("Hero_Disruptor.Glimpse.Target")
	if target:IsIllusion() then
		target:ForceKill(false)
		return
	end
	ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_glimpse_targetstart.vpcf", PATTACH_ABSORIGIN, target)
	-- TODO projectile to hero 4s position
	if caster.glimpse_locs == nil or caster.glimpse_locs[target:GetEntityIndex()] == nil then
		return
	end
	local loc = caster.glimpse_locs[target:GetEntityIndex()]
	if loc == nil or #loc == 0 then return end
	loc = loc[1]
	caster.glimpse_loc = loc
	caster.glimpse_target = target
	local speed = (caster:GetAbsOrigin() - loc):Length2D() / 1.8
	if speed < 600 then
		speed = 600
	end
	local duration = (caster:GetAbsOrigin() - loc):Length2D() / speed
	print("glimpse target to loc: " .. speed)
	print(loc)
	-- Creates a dummy unit at the glimpse location to throw the projectile at
	local dummy = CreateUnitByName("npc_dummy_unit", loc, false, caster, caster, caster:GetTeamNumber())
	-- Applies a modifier that removes it health bar
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_dummy", {})
	ability:ApplyDataDrivenModifier(caster, dummy, "modiifer_kill", { duration = 2 })
	
	-- Renders the glimpse location particle
	ability.particle = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_disruptor/disruptor_glimpse_targetend.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(ability.particle, 0, loc)
	ParticleManager:SetParticleControl(ability.particle, 1, loc)
	ParticleManager:SetParticleControl(ability.particle, 2, loc)
	
	-- Throws the glimpse projectile at the dummy
	local info = {
		Target = dummy,
		Source = target,
		Ability = ability,
		EffectName = "particles/units/heroes/hero_disruptor/disruptor_glimpse_travel.vpcf",
		bDodgeable = false,
	--[[Provides the caster's team with permanent vision over the starting position
	bProvidesVision = true,
	iVisionRadius = vision_radius,
	iVisionTeamNumber = caster:GetTeam(),]]
		iMoveSpeed = math.floor(speed),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	}
	ProjectileManager:CreateTrackingProjectile( info )
end

function handleIntervalThink(event)
	-- record all hero's position
	local caster = event.caster
	local heroes = HeroList:GetAllHeroes()
	for i=1,#heroes do
		if not heroes[i]:IsIllusion() and heroes[i]:GetTeam() ~= DOTA_TEAM_CUSTOM_1 and heroes[i]:IsAlive() then
			if caster.glimpse_locs == nil then
				caster.glimpse_locs = {}
			end
			if caster.glimpse_locs[heroes[i]:GetEntityIndex()] == nil then
				caster.glimpse_locs[heroes[i]:GetEntityIndex()] = {}
			end
			table.insert(caster.glimpse_locs[heroes[i]:GetEntityIndex()], heroes[i]:GetAbsOrigin())
		--	print(#caster.glimpse_locs[heroes[i]:GetEntityIndex()])
			if #caster.glimpse_locs[heroes[i]:GetEntityIndex()] > 20 then
				table.remove(caster.glimpse_locs[heroes[i]:GetEntityIndex()], 1)
			end
		end
	end
	--DeepPrintTable(caster.glimpse_locs)
end

function handleProjectileHitUnit(event)
	print("handleProjectileHitUnit")
	local caster = event.caster
	caster.glimpse_target:RemoveModifierByName("modifier_eul_cyclone_datadriven")
	FindClearSpaceForUnit(caster.glimpse_target, caster.glimpse_loc, false)
	caster.glimpse_target:EmitSound("Hero_Disruptor.Glimpse.End")
end
