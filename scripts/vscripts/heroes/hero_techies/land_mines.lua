--[[Author: Pizzalol
	Date: 24.03.2015.
	Creates the land mine and keeps track of it]]
function LandMinesPlant( keys )
	local caster = keys.caster
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Modifiers
	local modifier_land_mine = keys.modifier_land_mine
	local modifier_tracker = keys.modifier_tracker
	local modifier_caster = keys.modifier_caster
	local modifier_land_mine_invisibility = keys.modifier_land_mine_invisibility

	-- Ability variables
	local activation_time = ability:GetSpecialValueFor("activation_time") 
	local max_mines = ability:GetSpecialValueFor("max_mines") 
	local fade_time = ability:GetSpecialValueFor("fade_time")

	-- Create the land mine and apply the land mine modifier
	local land_mine = CreateUnitByName("npc_dota_techies_land_mine", target_point, false, caster, caster, caster:GetTeamNumber())
	land_mine:SetControllableByPlayer(caster:GetPlayerID(), true)
	ability:ApplyDataDrivenModifier(caster, land_mine, modifier_land_mine, {})
	land_mine.plant_time = GameRules:GetDOTATime(true, true)

	-- If we exceeded the maximum number of mines then kill the oldest one
	local my_land_mines = getMyLandMines(modifier_land_mine, caster)  
	while #my_land_mines > 20 do
		local oldest = my_land_mines[1]
		for j=2,#my_land_mines do
			if my_land_mines[j].plant_time < oldest.plant_time then
				oldest = my_land_mines[j]
			end
		end
		oldest:ForceKill(true)
		my_land_mines = getMyLandMines(modifier_land_mine, caster)  
	end

	local land_mine_count = #my_land_mines

	-- Increase caster stack count of the caster modifier and add it to the caster if it doesnt exist
	if not caster:HasModifier(modifier_caster) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})
	end

	caster:SetModifierStackCount(modifier_caster, ability, land_mine_count)

	-- Apply the tracker after the activation time
	land_mine:SetThink(function()
		ability:ApplyDataDrivenModifier(caster, land_mine, modifier_tracker, {})
	end, "activate land mine", activation_time)

	-- Apply the invisibility after the fade time
	land_mine:SetThink(function()
		ability:ApplyDataDrivenModifier(caster, land_mine, modifier_land_mine_invisibility, {})
	end, "land mine invis", fade_time)
end

--[[Author: Pizzalol
	Date: 24.03.2015.
	Stop tracking the mine and create vision on the mine area]]
function LandMinesDeath( keys )
	local caster = keys.caster
	local unit = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level) 
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)

	-- Create vision on the mine position
	ability:CreateVisibilityNode(unit:GetAbsOrigin(), vision_radius, vision_duration)

	local my_land_mines = getMyLandMines("modifier_land_mine_datadriven", caster)
	local land_mine_count = #my_land_mines - 1

	caster:SetModifierStackCount("modifier_land_mine_caster_datadriven", ability, land_mine_count)
	if land_mine_count < 1 then
		caster:RemoveModifierByNameAndCaster("modifier_land_mine_caster_datadriven", caster) 
	end

	local dummy = CreateUnitByName("npc_dummy_unit", unit:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
	ability:ApplyDataDrivenModifier(dummy, dummy, "modifier_dummy_detonate_effect_datadriven", {})
	local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf",
		PATTACH_ABSORIGIN_FOLLOW, dummy)
	dummy:AddNewModifier(caster, ability, "modifier_kill", {duration = 0.1})

	-- apply damange
	-- Target variables
	local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	local trigger_radius = ability:GetSpecialValueFor("small_radius") 
	local damage_half = ability:GetSpecialValueFor("damage_half") 
	local big_radius = ability:GetSpecialValueFor("big_radius") 

	-- Find the valid units in the trigger radius
	local units = FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, trigger_radius, target_team, target_types, target_flags, FIND_CLOSEST, false) 
	for i=1,#units do
		ApplyDamage({ victim = units[i], attacker = caster, damage = damage_half,	damage_type = DAMAGE_TYPE_PHYSICAL})
	end
	units = FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, big_radius, target_team, target_types, target_flags, FIND_CLOSEST, false) 
	for i=1,#units do
		ApplyDamage({ victim = units[i], attacker = caster, damage = damage_half,	damage_type = DAMAGE_TYPE_PHYSICAL})
	end
end

--[[Author: Pizzalol
	Date: 24.03.2015.
	Tracks if any enemy units are within the mine radius]]
function LandMinesTracker( keys )
	local target = keys.target
	if target.diesIn ~= nil then
		if target.diesIn > 0 then
			target.diesIn = target.diesIn - 1
		else
			keys.unit = target
			LandMinesDeath(keys)
			target:ForceKill(true)
		end
		return
	end
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local trigger_radius = ability:GetLevelSpecialValueFor("small_radius", ability_level) 
	local explode_delay = ability:GetLevelSpecialValueFor("explode_delay", ability_level) 

	-- Target variables
	local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES

	-- Find the valid units in the trigger radius
	local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, trigger_radius, target_team, target_types, target_flags, FIND_CLOSEST, false) 

	-- If there is a valid unit in range then explode the mine
	if #units > 0 then
		if target.diesIn == nil then
			target.diesIn = 3
		end
	end
end

function getMyLandMines(modifier_land_mine, caster)
	local land_mines = Entities:FindAllByName("npc_dota_techies_mines")
	local my_land_mines = {}
	for i=1,#land_mines do
		if land_mines[i]:IsAlive() and land_mines[i]:HasModifier(modifier_land_mine) and land_mines[i]:GetOwner() == caster then
			table.insert(my_land_mines, land_mines[i])
		end
	end
	return my_land_mines
end
