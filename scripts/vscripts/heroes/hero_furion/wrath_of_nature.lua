--[[
	Author: Noya
	Date: April 5, 2015
	Bounces from the main point/target to other targets visible on the map
	Every bounce does increased damage and has a delay between the next jump
]]
function WrathOfNature( event )
	local DEBUG = false
	local caster = event.caster -- the hero
	local thinker = event.target -- the thinker, point where the abilty was clicked
	local ability = event.ability
	local abilityTargetType = ability:GetAbilityTargetType()
	local abilityDamageType = ability:GetAbilityDamageType()

	local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability:GetLevel()-1)
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel()-1)
	local damage_percent_add = ability:GetSpecialValueFor("damage_percent_add") * 0.01
	local jump_delay = ability:GetSpecialValueFor("jump_delay")
	local particleName = "particles/units/heroes/hero_furion/furion_wrath_of_nature.vpcf"
	-- Control points
	-- CP0 Origin
	-- CP1 Jump1
	-- CP2 Origin2
	-- CP3 Jump2
	-- CP4 Hit

	print(point,thinker:GetUnitName(),caster:GetUnitName())

	-- Get the first target
	local visible_enemies = FindUnitsInRadius(caster:GetTeamNumber(), thinker:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, 
									   abilityTargetType, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

	print(#visible_enemies)
	-- Main target first. 
	-- Deal damage and play particle
	
	-- won't hit siege creeps
	local tmp = {}
	for i=1,#visible_enemies do
		if visible_enemies[i]:GetName() == "npc_dota_creep_siege" then
		else
			table.insert(tmp, visible_enemies[i])
		end
	end
	visible_enemies = tmp

	local target_number = 1
	local main_target = visible_enemies[target_number]
	local damage_table = {}
	damage_table.victim = main_target
	damage_table.attacker = caster					
	damage_table.damage_type = abilityDamageType
	damage_table.damage = damage

	ApplyDamage(damage_table)
	local targets_hit = 1
	if DEBUG then print("Wrath hit Number "..targets_hit..": "..damage_table.victim:GetUnitName().." for "..damage_table.damage) end

	-- Keep track of the previous target to set the particle origin on next jump
	local previous_target = main_target

	-- Do bounces from the main target to closest targets
	caster:SetThink(function()
		-- Increment target iterator
		target_number = target_number + 1
		-- Jump to this target if its possible
		local next_target = visible_enemies[target_number]
		if next_target and IsValidEntity(next_target) and next_target:IsAlive() then
			-- Valid target chosen
			targets_hit = targets_hit + 1
			-- Deal increased damaged
			damage_table.damage = damage_table.damage + (damage * damage_percent_add)
			damage_table.victim = next_target
			ApplyDamage(damage_table)
			if DEBUG then print("Wrath hit Number "..targets_hit..": "..damage_table.victim:GetUnitName().." for "..damage_table.damage) end
			-- Particle and sound
			local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(particle, 0, previous_target, PATTACH_POINT_FOLLOW, "attach_hitloc", previous_target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 1, next_target, PATTACH_POINT_FOLLOW, "attach_hitloc", next_target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 2, next_target, PATTACH_POINT_FOLLOW, "attach_hitloc", next_target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 3, next_target, PATTACH_POINT_FOLLOW, "attach_hitloc", next_target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 4, next_target, PATTACH_POINT_FOLLOW, "attach_hitloc", next_target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle)

			if next_target:IsRealHero() then
				next_target:EmitSound("Hero_Furion.WrathOfNature_Damage")
			else
				next_target:EmitSound("Hero_Furion.WrathOfNature_Damage.Creep")
			end
			-- Fire the timer again if there are jumps left
			if targets_hit < max_targets then
				-- Update the previous target for the next jump
				previous_target = next_target
				return jump_delay
			end
		else
			-- The target is invalid (was killed while the ability was bouncing)
			-- Fire the timer again if there are jumps left, ignoring this bounce
			if targets_hit < max_targets then
				return jump_delay
			else
				if DEBUG then print("Wrath of Nature ends after "..targets_hit.." hits") end
				return
			end
		end
	end, "wrath of nature think", jump_delay)
end
