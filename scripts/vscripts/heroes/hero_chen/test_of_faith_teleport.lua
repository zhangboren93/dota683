--[[Author: Pizzalol
	Date: 05.04.2015.
	Checks what the target is and then decides what kind of teleport action to perform]]
function TestOfFaithTeleportTarget( keys )
	local caster = keys.caster
	local caster_team = caster:GetTeamNumber()
	local caster_location = caster:GetAbsOrigin()
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local teleport_delay = ability:GetLevelSpecialValueFor("hero_teleport_delay", ability_level)
	local sound_tp_out = keys.sound_tp_out
	local sound_tp_in = keys.sound_tp_in
	local teleport_modifier = keys.teleport_modifier
	local teleport_particle = keys.teleport_particle

	-- If the target is a creep under the casters control then teleport it instantly to the specified point
	if not target:IsHero() and target:GetPlayerOwnerID() == caster:GetPlayerOwnerID() then
		-- Play the teleport particle
		local particle = ParticleManager:CreateParticle(teleport_particle, PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)

		-- Play the teleport sounds
		EmitSoundOn(sound_tp_out, target)
		EmitSoundOn(sound_tp_in, target)

		-- Specified point
		if target:GetTeam() == DOTA_TEAM_GOODGUYS then
			target:SetAbsOrigin(Vector(-7132, -6633, 520))
		else
			target:SetAbsOrigin(Vector(7034, 6380, 520))
		end
		target:AddNewModifier(caster, nil, "modifier_phased", {duration = 0.03})
	-- If the target is the caster then find all the units under casters control and apply the teleport delay modifier
	elseif target == caster then
		-- Targeting variables
		local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
		local target_types = DOTA_UNIT_TARGET_CREEP
		local target_flags = DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED

		local units = FindUnitsInRadius(caster_team, caster_location, nil, 30000, target_teams, target_types, target_flags, FIND_CLOSEST, false)

		for _,unit in ipairs(units) do
			-- Check if the found unit is under the casters control
			if (unit:GetPlayerOwnerID() == caster:GetPlayerOwnerID() and unit ~= caster) then
				ability:ApplyDataDrivenModifier(caster, unit, teleport_modifier, {Duration = teleport_delay})
			end
		end
	else
		-- If the target is not the caster of a creep controlled by the caster then apply the teleport delay
		ability:ApplyDataDrivenModifier(caster, target, teleport_modifier, {Duration = teleport_delay})
	end
end

function TestOfFaithStopSound( keys )
	local target = keys.target
	local sound = keys.sound

	StopSoundEvent(sound, target)
end

--[[Author: Pizzalol
	Date: 05.04.2015.
	Checks where the targeted unit needs to be teleported to]]
function TestOfFaithTeleport( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin()

	-- If the target is a unit under the casters control then teleport it to the caster
	if not target:IsHero() and target:GetPlayerOwnerID() == caster:GetPlayerOwnerID() then
		target:SetAbsOrigin(caster_location + RandomVector(100))
	else
		-- Otherwise teleport it to a specific location
		if target:GetTeam() == DOTA_TEAM_GOODGUYS then
			target:SetAbsOrigin(Vector(-7132, -6633, 520))
		else
			target:SetAbsOrigin(Vector(7034, 6380, 520))
		end
	end
	target:AddNewModifier(caster, nil, "modifier_phased", {Duration = 0.03})
end
