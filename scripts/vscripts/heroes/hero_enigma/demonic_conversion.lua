enigma_demonic_conversion_datadriven = class({})

function enigma_demonic_conversion_datadriven:CastFilterResultTarget(target)
	if target:IsConsideredHero() then
		return UF_FAIL_CONSIDERED_HERO 
	end
	if target:IsBuilding() then
		return UF_FAIL_BUILDING
	end
	if target:IsCourier() then
		return UF_FAIL_COURIER
	end
	if target:IsAncient() then
		return UF_FAIL_ANCIENT
	end
	if not target:IsCreep() then
		return UF_FAIL_CUSTOM
	end

	if target:GetLevel() > self:GetSpecialValueFor("creep_max_level") then
		return UF_FAIL_CUSTOM
	end
	if target:GetName() == "npc_dota_beastmaster_boar"
		or target:GetName() == "npc_dota_beastmaster_hawk" then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function enigma_demonic_conversion_datadriven:GetCustomCastErrorTarget(target)
	if target:GetLevel() > self:GetSpecialValueFor("creep_max_level") then
		return "#dota_hud_error_demonic_conversion_creep_level"
	end
	if target:GetName() == "npc_dota_beastmaster_boar"
		or target:GetName() == "npc_dota_beastmaster_hawk" then
		return "#dota_hud_error_demonic_conversion_beast_master"
	end
	return ""
end

function enigma_demonic_conversion_datadriven:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local ability = self
	local target_origin = target:GetAbsOrigin()
	local direction = target:GetForwardVector()
	local duration = ability:GetSpecialValueFor("duration_tooltip")
	local count = ability:GetSpecialValueFor("spawn_count")
	local xp_radius = ability:GetSpecialValueFor("xp_radius")
	local bounty = target:GetGoldBounty()
	local xp = target:GetDeathXP()
	local units = FindUnitsInRadius(target:GetTeamNumber(), target_origin, nil, xp_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
	local shared_xp = xp/#units
	local eidelon_level = ability:GetLevel()
	
	-- Denies give half the experience
	if target:GetTeam() == caster:GetTeam() then
		shared_xp = shared_xp / 2
	end
	-- Determines which unit to spawn
	local unit_name
	if eidelon_level == 1 then
		unit_name = "npc_dota_lesser_eidolon"
	elseif eidelon_level == 2 then
		unit_name = "npc_dota_eidolon"
	elseif eidelon_level == 3 then
		unit_name = "npc_dota_greater_eidolon"
	elseif eidelon_level == 4 then
		unit_name = "npc_dota_dire_eidolon"
	end	
	
	target:EmitSound("Hero_Enigma.Demonic_Conversion")
	-- Kills the target unit
	target:ForceKill(true)
	-- Gives the caster the gold bounty
	if caster:GetTeam() ~= target:GetTeam() then
		caster:ModifyGold(bounty, false, DOTA_ModifyGold_CreepKill)
	end
	-- Splits the experience among heroes in range
	for i=1,#units do
		units[i]:AddExperience(shared_xp, 0, false, false)
	end
	-- Creates the eidelons on the target and facing the same direction
	for i=1,count do
		local eidelon = CreateUnitByName(unit_name, target_origin, true, caster, nil, caster:GetTeam())
		eidelon:SetForwardVector(direction)
		eidelon:SetControllableByPlayer(caster:GetPlayerID(), true)
		eidelon:SetOwner(caster)
	
		-- Adds the green duration circle, and kills the eidelon after the duration ends
		eidelon:AddNewModifier(eidelon, nil, "modifier_kill", {duration = duration})
		-- Phases the eidelon for a short period so there is no unit collision
		eidelon:AddNewModifier(eidelon, nil, "modifier_phased", {duration = 0.03})
		-- Applies the modifier to count each eidelon's attacks
		eidelon:AddNewModifier(eidelon, self, "modifier_eidelon_check_attacks_lua", {})
		-- Takes note of the game time, so we know the duration for the split eidelons
		eidelon.time = GameRules:GetGameTime()
	end
end

