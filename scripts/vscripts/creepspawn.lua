CREEP_ALERT_RADIUS = 540
CREEP_ALERT_RADIUS_RANGED = 632
CREEP_ALERT_RADIUS_SEIGE = 832
CREEP_ATTACK_RANGE = 140
CREEP_ATTACK_RANGE_RANGED = 532
CREEP_ATTACK_RANGE_SEIGE = 722
local radiantSpawners = {
	"lane_bot_goodguys_melee_spawner", 
	"lane_mid_goodguys_melee_spawner",
	"lane_top_goodguys_melee_spawner"}
local direSpawners = {
	"lane_bot_badguys_melee_spawner",
	"lane_mid_badguys_melee_spawner",
	"lane_top_badguys_melee_spawner"}
local radiantPathNames = { "gb", "gm", "gt"}
local direPathNames = { "bb", "bm", "bt"}
local direracks = {
	"bad_rax_melee_bot", 
	"bad_rax_melee_mid",
	"bad_rax_melee_top",
	"bad_rax_range_bot",
	"bad_rax_range_mid",
	"bad_rax_range_top"}
local radiantracks = {
	"good_rax_melee_bot",
	"good_rax_melee_mid",
	"good_rax_melee_top",
	"good_rax_range_bot",
	"good_rax_range_mid",
	"good_rax_range_top"}
function spawnCreepsLua()
	spawnCreepsFromSide(radiantSpawners, 
		radiantPathNames,
		{
			creepUpgradedName("npc_dota_creep_goodguys_melee", "bad_rax_melee_bot", direracks), 
			creepUpgradedName("npc_dota_creep_goodguys_melee", "bad_rax_melee_mid", direracks), 
			creepUpgradedName("npc_dota_creep_goodguys_melee", "bad_rax_melee_top", direracks)},
		{
			creepUpgradedName("npc_dota_creep_goodguys_ranged", "bad_rax_range_bot", direracks), 
			creepUpgradedName("npc_dota_creep_goodguys_ranged", "bad_rax_range_mid", direracks), 
			creepUpgradedName("npc_dota_creep_goodguys_ranged", "bad_rax_range_top", direracks)},
		{
			creepUpgradedName("npc_dota_goodguys_siege", "bad_rax_range_bot", direracks), 
			creepUpgradedName("npc_dota_goodguys_siege", "bad_rax_range_mid", direracks), 
			creepUpgradedName("npc_dota_goodguys_siege", "bad_rax_range_top", direracks)},
		DOTA_TEAM_GOODGUYS)
	spawnCreepsFromSide(direSpawners,
		direPathNames,
		{
			creepUpgradedName("npc_dota_creep_badguys_melee", "good_rax_melee_bot", radiantracks), 
			creepUpgradedName("npc_dota_creep_badguys_melee", "good_rax_melee_mid", radiantracks), 
			creepUpgradedName("npc_dota_creep_badguys_melee", "good_rax_melee_top", radiantracks)},
		{
			creepUpgradedName("npc_dota_creep_badguys_ranged", "good_rax_range_bot", radiantracks), 
			creepUpgradedName("npc_dota_creep_badguys_ranged", "good_rax_range_mid", radiantracks), 
			creepUpgradedName("npc_dota_creep_badguys_ranged", "good_rax_range_top", radiantracks)},
		{
			creepUpgradedName("npc_dota_badguys_siege", "good_rax_range_bot", radiantracks), 
			creepUpgradedName("npc_dota_badguys_siege", "good_rax_range_mid", radiantracks), 
			creepUpgradedName("npc_dota_badguys_siege", "good_rax_range_top", radiantracks)},
		DOTA_TEAM_BADGUYS)
end

function creepUpgradedName(prefix, raxName, megaraks)
	if shouldSpawnMegas(megaraks) then
		return prefix .. "_upgraded_mega"
	end
	local rax = Entities:FindByName(nil, raxName)
	if rax == nil or not rax:IsAlive() then
		return prefix .. "_upgraded"
	end
	return prefix
end

function shouldSpawnMegas(racks)
	for i=1,#racks do
		local rax = Entities:FindByName(nil, racks[i])
		if rax ~= nil and rax:IsAlive() then
			return false
		end
	end
	return true
end

function calculateNumMeleeCreep()
	return math.min(3 + math.floor(GameRules:GetDOTATime(false, false) / (15 * 60)), 6)
end

function calculateNumRangedCreep()
	if GameRules:GetDOTATime(false, false) >= 40 * 60 - 10 then
		return 2
	else
		return 1
	end
end

function calculateNumSiegeCreep()
	if GameRules:GetDOTATime(false, false) >= 45 * 60 - 10 then
		return 2
	else
		return 1
	end
end

function spawnCreepsFromSide(spawners, pathNames, melee, ranged, seige, team)
	local numMeleeCreep = calculateNumMeleeCreep()
	local numRangedCreep = calculateNumRangedCreep()
	local numSiegeCreep = calculateNumSiegeCreep()
	local shouldSpawnSeige = GameRules:GetDOTATime(false, false) > 60 and GameRules:GetDOTATime(false, false) % 300 < 10
	for i=1,#spawners do
		local spawner = Entities:FindByName(nil, spawners[i])
		local spawnVecter = spawner:GetAbsOrigin()
		local creepLevel = math.floor(GameRules:GetDOTATime(false, false) / 450)
		for j=1,numMeleeCreep do
			CreateUnitByNameAsync(melee[i], spawnVecter, true, nil, nil, team, function(spawnedUnit)
				spawnedUnit:SetIdleAcquire(false)
				spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", { 
					alertRadius = CREEP_ALERT_RADIUS, 
					pathName = pathNames[i], 
					seige = false,
					attackrange = CREEP_ATTACK_RANGE })
				if spawners[i] == "lane_bot_goodguys_melee_spawner" or spawners[i] == "lane_top_badguys_melee_spawner" then
					if not spawnedUnit:HasModifier("modifier_creep_safe_lane_move_speed_bonus") then
						spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_safe_lane_move_speed_bonus", { }):SetDuration(25, true)
					end
				end
				if string.find(melee[i], "upgraded") == nil then
					spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_health_bonus", { health = 10 * creepLevel, damage = 1 * creepLevel  })
					spawnedUnit:SetMaximumGoldBounty(spawnedUnit:GetMaximumGoldBounty() + creepLevel)
					spawnedUnit:SetMinimumGoldBounty(spawnedUnit:GetMinimumGoldBounty() + creepLevel)
				elseif string.find(melee[i], "mega") == nill then											  
					spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_health_bonus", { health = 17 * creepLevel, damage = 2 * creepLevel  })
					spawnedUnit:SetMaximumGoldBounty(spawnedUnit:GetMaximumGoldBounty() + creepLevel * 2)
					spawnedUnit:SetMinimumGoldBounty(spawnedUnit:GetMinimumGoldBounty() + creepLevel * 2)
				end
				spawnedUnit:AddAbility("creep_alert_aura_datadriven"):SetLevel(1)
			end)
		end
		if team == DOTA_TEAM_GOODGUYS then
			spawnVecter[1] = spawnVecter[1] - 300
			spawnVecter[2] = spawnVecter[2] - 300
		else
			spawnVecter[1] = spawnVecter[1] + 300
			spawnVecter[2] = spawnVecter[2] + 300
		end
		for j=1,numRangedCreep do
			CreateUnitByNameAsync(ranged[i], spawnVecter, true, nil, nil, team, function(spawnedUnit)
				spawnedUnit:SetIdleAcquire(false)
				spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", {
					alertRadius = CREEP_ALERT_RADIUS_RANGED, 
					pathName = pathNames[i], 
					seige = false,
					attackrange = CREEP_ATTACK_RANGE_RANGED })
				if spawners[i] == "lane_bot_goodguys_melee_spawner" or spawners[i] == "lane_top_badguys_melee_spawner" then
					if not spawnedUnit:HasModifier("modifier_creep_safe_lane_move_speed_bonus") then
						spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_safe_lane_move_speed_bonus", { }):SetDuration(25, true)
					end
				end
				if string.find(ranged[i], "upgraded") == nil then
					spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_health_bonus", { health = 10 * creepLevel, damage = 2 * creepLevel })
					spawnedUnit:SetMaximumGoldBounty(spawnedUnit:GetMaximumGoldBounty() + creepLevel)
					spawnedUnit:SetMinimumGoldBounty(spawnedUnit:GetMinimumGoldBounty() + creepLevel)
				elseif string.find(ranged[i], "mega") == nill then
					spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_health_bonus", { health = 16 * creepLevel, damage = 3 * creepLevel })
					spawnedUnit:SetMaximumGoldBounty(spawnedUnit:GetMaximumGoldBounty() + creepLevel * 2)
					spawnedUnit:SetMinimumGoldBounty(spawnedUnit:GetMinimumGoldBounty() + creepLevel * 2)
				end
				spawnedUnit:AddAbility("creep_alert_aura_datadriven"):SetLevel(1)
			end)
		end
		if shouldSpawnSeige then
			for i=1,#numSiegeCreep do
				CreateUnitByNameAsync(seige[i], spawnVecter, true, nil, nil, team, function(spawnedUnit)
					spawnedUnit:SetIdleAcquire(false)
					spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", {
						alertRadius = CREEP_ALERT_RADIUS_SEIGE, 
						pathName = pathNames[i], 
						seige = true,
						attackrange = CREEP_ATTACK_RANGE_SEIGE })
					spawnedUnit:AddAbility("creep_alert_aura_datadriven"):SetLevel(1)
				end)
			end
		end
	end
end

--radiant camp 1
--Vector 000000000239EC30 [3008.000000 -4800.000000 512.000000]
--{
--   Maxs                            	= Vector 0000000002330988 [768.000000 512.000000 128.000000] (userdata)
--   Mins                            	= Vector 000000000266DCF0 [-768.000000 -512.000000 -128.000000] (userdata)
--}
--radiant camp 2
--Vector 00000000023EEED8 [3232.000000 -3520.000000 512.000000]
--{
--   Maxs                            	= Vector 00000000023EF048 [544.000000 576.000000 128.000000] (userdata)
--   Mins                            	= Vector 00000000023EEFC8 [-544.000000 -576.000000 -128.000000] (userdata)
--}
--radiant camp 3
--Vector 0000000002308B88 [1696.000000 -3872.000000 512.000000]
--{
--   Maxs                            	= Vector 0000000002338B48 [608.000000 672.000000 128.000000] (userdata)
--   Mins                            	= Vector 0000000002338AC8 [-608.000000 -672.000000 -128.000000] (userdata)
--}
--radiant camp 4
--Vector 00000000023F12C0 [-480.000000 -2912.000000 384.000000]
--{
--   Maxs                            	= Vector 00000000024064B8 [544.000000 544.000000 128.000000] (userdata)
--   Mins                            	= Vector 0000000002406470 [-544.000000 -544.000000 -128.000000] (userdata)
--}
--radiant camp 5
--Vector 00000000023F1698 [-1563.430054 -3872.000000 480.000000]
--{
--   Maxs                            	= Vector 00000000023F1808 [859.430054 352.000000 224.000000] (userdata)
--   Mins                            	= Vector 00000000023F1788 [-164.569946 -608.000000 -224.000000] (userdata)
--}
--radiant camp 6
--Vector 000000000239E130 [-3040.000000 256.000000 512.000000]
--{
--   Maxs                            	= Vector 000000000239E2A0 [480.000000 512.000000 128.000000] (userdata)
--   Mins                            	= Vector 000000000239E220 [-480.000000 -512.000000 -128.000000] (userdata)
--}
--dire camp 1
--Vector 00000000023A6748 [-4384.000000 3808.000000 512.000000]
--{
--   Maxs                            	= Vector 000000000266E758 [672.000000 544.000000 128.000000] (userdata)
--   Mins                            	= Vector 000000000266E6D8 [-672.000000 -544.000000 -128.000000] (userdata)
--}
--dire camp 2
--Vector 000000000263FF28 [-3072.000000 4512.000000 512.000000]
--{
--   Maxs                            	= Vector 000000000269D238 [384.000000 416.000000 128.000000] (userdata)
--   Mins                            	= Vector 0000000002640018 [-384.000000 -544.000000 -128.000000] (userdata)
--}
--dire camp 3
--Vector 00000000023555C8 [-1440.000000 2720.000000 384.000000]
--{
--   Maxs                            	= Vector 00000000023556D8 [479.999969 416.000000 128.000000] (userdata)
--   Mins                            	= Vector 0000000002355658 [-528.000000 -544.000000 -128.000000] (userdata)
--}
--dire camp 4
--Vector 00000000023D50F8 [-416.000000 3648.000000 512.000000]
--{
--   Maxs                            	= Vector 0000000002355B08 [416.000000 448.000000 128.000000] (userdata)
--   Mins                            	= Vector 0000000002355A88 [-416.000000 -448.000000 -128.000000] (userdata)
--}
--dire camp 5
--Vector 0000000002716300 [1056.000000 3296.000000 512.000000]
--{
--   Maxs                            	= Vector 0000000002355D20 [608.000000 480.000000 128.000000] (userdata)
--   Mins                            	= Vector 00000000027163F0 [-608.000000 -480.000000 -128.000000] (userdata)
--}
--dire camp 6
--Vector 00000000022FB218 [4072.179932 -792.000000 384.000000]
--{
--   Maxs                            	= Vector 00000000022FB388 [471.820068 407.999969 128.000000] (userdata)
--   Mins                            	= Vector 00000000022FB308 [-616.179932 -359.999969 -128.000000] (userdata)
--}
CAMP_SIZE_SMALL = 1
CAMP_SIZE_MEDIUM = 2
CAMP_SIZE_LARGE = 3
CAMP_SIZE_ANCIENT = 4
neutralcamp_name_2_size = {
	neutralcamp_good_1 = CAMP_SIZE_SMALL,
	neutralcamp_good_2 = CAMP_SIZE_MEDIUM,
	neutralcamp_good_3 = CAMP_SIZE_LARGE,
	neutralcamp_good_4 = CAMP_SIZE_MEDIUM,
	neutralcamp_good_5 = CAMP_SIZE_LARGE,
	neutralcamp_good_6 = CAMP_SIZE_ANCIENT,
	neutralcamp_evil_1 = CAMP_SIZE_LARGE,
	neutralcamp_evil_2 = CAMP_SIZE_SMALL,
	neutralcamp_evil_3 = CAMP_SIZE_MEDIUM,
	neutralcamp_evil_4 = CAMP_SIZE_MEDIUM,
	neutralcamp_evil_5 = CAMP_SIZE_LARGE,
	neutralcamp_evil_6 = CAMP_SIZE_ANCIENT,
}
neutralcamp_name_2_location = {
	neutralcamp_good_1 = Vector(2989, -4621, 384),
	neutralcamp_good_2 = Vector(3093, -3307, 384),
	neutralcamp_good_3 = Vector(1642, -3600, 384),
	neutralcamp_good_4 = Vector(-295, -3085, 256),
	neutralcamp_good_5 = Vector(-1044, -4127, 256),
	neutralcamp_good_6 = Vector(-3024, 195, 384),
	neutralcamp_evil_1 = Vector(-4465, 3502, 384),
	neutralcamp_evil_2 = Vector(-3048, 4511, 384),
	neutralcamp_evil_3 = Vector(-1586, 2599, 256),
	neutralcamp_evil_4 = Vector(-231, 3626, 384),
	neutralcamp_evil_5 = Vector(1324, 3318, 384),
	neutralcamp_evil_6 = Vector(4060, -666, 256)
}
neutralcamp_size_2_creeps = {
	{ 
		{
			"npc_dota_neutral_kobold",
			"npc_dota_neutral_kobold",
			"npc_dota_neutral_kobold",
			"npc_dota_neutral_kobold_tunneler",
			"npc_dota_neutral_kobold_taskmaster",
		},
		{
			"npc_dota_neutral_fel_beast",
			"npc_dota_neutral_fel_beast",
			"npc_dota_neutral_ghost"	
		},
		{
			"npc_dota_neutral_gnoll_assassin",
			"npc_dota_neutral_gnoll_assassin",
			"npc_dota_neutral_gnoll_assassin"
		},
		{
			"npc_dota_neutral_harpy_scout",
			"npc_dota_neutral_harpy_scout",
			"npc_dota_neutral_harpy_storm"
		},
		{
			"npc_dota_neutral_forest_troll_berserker",
			"npc_dota_neutral_forest_troll_berserker",
			"npc_dota_neutral_forest_troll_high_priest"	
		}
	},
	{ 
		{
			"npc_dota_neutral_centaur_khan",
			"npc_dota_neutral_centaur_outrunner",
		},
		{
			"npc_dota_neutral_mud_golem",
			"npc_dota_neutral_mud_golem"
		},
		{
			"npc_dota_neutral_ogre_mauler",
			"npc_dota_neutral_ogre_mauler",
			"npc_dota_neutral_ogre_magi"
		},
		{
			"npc_dota_neutral_giant_wolf",
			"npc_dota_neutral_giant_wolf",
			"npc_dota_neutral_alpha_wolf"
		},
	},
	{
		{
			"npc_dota_neutral_polar_furbolg_champion",
			"npc_dota_neutral_polar_furbolg_ursa_warrior"
		},
		{
			"npc_dota_neutral_wildkin",
			"npc_dota_neutral_wildkin",
			"npc_dota_neutral_enraged_wildkin"
		},
		{
			"npc_dota_neutral_satyr_soulstealer",
			"npc_dota_neutral_satyr_trickster",
			"npc_dota_neutral_satyr_hellcaller"
		},
		{
			"npc_dota_neutral_dark_troll_warlord",
			"npc_dota_neutral_dark_troll",
			"npc_dota_neutral_dark_troll"
		},
		{
			"npc_dota_neutral_centaur_khan",
			"npc_dota_neutral_centaur_outrunner",
		}
	},
	{ 
		{
			"npc_dota_neutral_big_thunder_lizard",
			"npc_dota_neutral_small_thunder_lizard",
			"npc_dota_neutral_small_thunder_lizard"
		},
		{
			"npc_dota_neutral_black_dragon",
			"npc_dota_neutral_black_drake",
			"npc_dota_neutral_black_drake"
		},
		{
			"npc_dota_neutral_rock_golem",
			"npc_dota_neutral_rock_golem",
			"npc_dota_neutral_granite_golem"
		},
		{
			"npc_dota_neutral_ice_shaman",
			"npc_dota_neutral_frostbitten_golem",
			"npc_dota_neutral_frostbitten_golem",
		},
		{
			"npc_dota_neutral_elder_jungle_stalker",
			"npc_dota_neutral_jungle_stalker",
			"npc_dota_neutral_jungle_stalker"
		}
	}
}

local neutralCampCache = {
	{}, {}, {}, {}, {}, {}, -- radiant camps
	{}, {}, {}, {}, {}, {}  -- dire camps
}
local function isCampEmpty(campIdx)
	local trigger_name = "neutralcamp_good_" .. campIdx
	if campIdx >= 7 then
		trigger_name = "neutralcamp_evil_" .. (campIdx - 6)
	end
	local spawn_trigger = Entities:FindByName(nil, trigger_name)
	local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, spawn_trigger:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for j=1,#units do
		if spawn_trigger:IsTouching(units[j]) 
			and units[j]:GetName() ~= "npc_dota_templar_assassin_psionic_trap" 
			and units[j]:GetName() ~= "npc_dota_techies_mines" 
			and not units[j]:HasModifier("modifier_fire_remnant_dummy_buff_lua") then
			return false
		end
	end
	return true
end

local function getCampLocation(campIdx)
	local trigger_name = "neutralcamp_good_" .. campIdx
	if campIdx >= 7 then
		trigger_name = "neutralcamp_evil_" .. (campIdx - 6)
	end
	local spawn_trigger = Entities:FindByName(nil, trigger_name)
	return spawn_trigger:GetAbsOrigin()
end

local function spawnMinimapCampIcon(camp_location)
    local all_units = Entities:FindAllInSphere(camp_location, 129)
    local has_radiant_camp = false
    local has_dire_camp = false
    for j=1,#all_units do
        if all_units[j].HasModifier ~= nil and all_units[j]:HasModifier("modifier_minimap_camp_icon_datadriven") then
            if all_units[j]:GetTeam() == DOTA_TEAM_GOODGUYS then
                has_radiant_camp = true
            elseif all_units[j]:GetTeam() == DOTA_TEAM_BADGUYS then
                has_dire_camp = true
            end
        end
    end
    if not has_radiant_camp then
    CreateUnitByNameAsync("npc_dummy_unit_minimap_camp",
        camp_location,
        false,
        nil, 
        nil,
        DOTA_TEAM_GOODGUYS,
        function(entity)
            entity:FindAbilityByName("minimap_camp_icon_datadriven"):SetLevel(1)
        end)
	end
	if not has_dire_camp then
    CreateUnitByNameAsync("npc_dummy_unit_minimap_camp",
        camp_location,
        false,
        nil, 
        nil,
        DOTA_TEAM_BADGUYS,
        function(entity)
            entity:FindAbilityByName("minimap_camp_icon_datadriven"):SetLevel(1)
        end)
	end
end

function SpawnNeutralCreepsCustom()
    if not IsServer() then return end
	-- if all neutralCampCache are filled, spawn from cache instead 
	for i=1,12 do
		if #neutralCampCache[i] == 0 then
			SpawnNeutralCreepsCustomOfSide("neutralcamp_good_")
			SpawnNeutralCreepsCustomOfSide("neutralcamp_evil_")
			return
		end
	end
	for i=1,12 do
		if isCampEmpty(i) then
			print("camp " .. i .. " is empty, spawning from cache")
			for j=1,#neutralCampCache[i] do
				local newCampCreep = EntIndexToHScript(neutralCampCache[i][j])
				newCampCreep:RemoveModifierByName("modifier_creep_preparing_lua")
			end
			neutralCampCache[i] = {}
			-- spawn camp indicator
			local camp_location = getCampLocation(i)

			spawnMinimapCampIcon(camp_location)
		end
	end
end

function SpawnNeutralCreepsCustomOfSide(trigger_name_prefix)
	for i=1,6 do
		local trigger_name = trigger_name_prefix .. i
		local spawn_trigger = Entities:FindByName(nil, trigger_name)
		local camp_location = neutralcamp_name_2_location[trigger_name]

		local spawner_empty
		if string.find(trigger_name_prefix, "good") ~= nil then
			spawner_empty = isCampEmpty(i)
		else
			spawner_empty = isCampEmpty(i + 6)
		end

		if spawner_empty then
			local camp_size = neutralcamp_name_2_size[trigger_name]
			local camp_types = neutralcamp_size_2_creeps[camp_size]
			local camp_type = camp_types[RandomInt(1, #camp_types)]
			for j=1,#camp_type do
				CreateUnitByNameAsync(camp_type[j], camp_location, true, nil, nil, DOTA_TEAM_NEUTRALS, function(entity)
					for k=1,entity:GetAbilityCount() do
						local ability = entity:GetAbilityByIndex(k)
						if ability ~= nil then
							ability:SetLevel(1)
						else
							break
						end
					end
				end)
			end
		end
		spawnMinimapCampIcon(camp_location)
	end
end
-- Improvement lane spawn creeps every second & show creeps at 30 seconds mark
-- game 1.5 hours max, rangecreep count 2, meleecreep count 6, siege creep count 2
-- 10 * 6 = 60 every 30 seconds, prepare in 20s, each 2 second cache create 6 units
function calculateNumMeleeCreepNextBatch()
	return 0 + math.min(3 + math.floor(
		(GameRules:GetDOTATime(false, false) + 30) / (15 * 60)), 6)
end

function calculateNumRangedCreepNextBatch()
	if GameRules:GetDOTATime(false, false) >= 40 * 60 - 40 then
		return 2
	else
		return 1
	end
end

function calculateNumSiegeCreepNextBatch()
	local nextTime = GameRules:GetDOTATime(false, false) + 30
	if nextTime % 300 > 10 then
		return 0
	end

	if GameRules:GetDOTATime(false, false) >= 45 * 60 - 40 then
		return 2
	else
		return 1
	end
end
function prepareCreepSpawnQueue()
	local result = {}
	local numMeleeCreep = calculateNumMeleeCreepNextBatch()
	local numRangedCreep = calculateNumRangedCreepNextBatch()
	local numSiegeCreep = calculateNumSiegeCreepNextBatch()
	for i=1,numMeleeCreep do
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_creep_goodguys_melee", "bad_rax_melee_bot", direracks),
			path = "gb",
			team = DOTA_TEAM_GOODGUYS,
			alertRadius = CREEP_ALERT_RADIUS,
			siege = 0,
			attackRange = CREEP_ATTACK_RANGE
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_creep_goodguys_melee", "bad_rax_melee_mid", direracks),
			path = "gm",
			team = DOTA_TEAM_GOODGUYS,
			alertRadius = CREEP_ALERT_RADIUS,
			siege = 0,
			attackRange = CREEP_ATTACK_RANGE
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_creep_goodguys_melee", "bad_rax_melee_top", direracks),
			path = "gt",
			team = DOTA_TEAM_GOODGUYS,
			alertRadius = CREEP_ALERT_RADIUS,
			siege = 0,
			attackRange = CREEP_ATTACK_RANGE
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_creep_badguys_melee", "good_rax_melee_bot", radiantracks),
			path = "bb",
			team = DOTA_TEAM_BADGUYS,
			alertRadius = CREEP_ALERT_RADIUS,
			siege = 0,
			attackRange = CREEP_ATTACK_RANGE
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_creep_badguys_melee", "good_rax_melee_mid", radiantracks),
			path = "bm",
			team = DOTA_TEAM_BADGUYS,
			alertRadius = CREEP_ALERT_RADIUS,
			siege = 0,
			attackRange = CREEP_ATTACK_RANGE
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_creep_badguys_melee", "good_rax_melee_top", radiantracks),
			path = "bt",
			team = DOTA_TEAM_BADGUYS,
			alertRadius = CREEP_ALERT_RADIUS,
			siege = 0,
			attackRange = CREEP_ATTACK_RANGE
		})
	end
	for i=1,numRangedCreep do
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_creep_goodguys_ranged", "bad_rax_range_bot", direracks),
			path = "gb",
			team = DOTA_TEAM_GOODGUYS,
			alertRadius = CREEP_ALERT_RADIUS_RANGED,
			siege = 0,
			attackRange = CREEP_ATTACK_RANGE_RANGED

		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_creep_goodguys_ranged", "bad_rax_range_mid", direracks),
			path = "gm",
			team = DOTA_TEAM_GOODGUYS,
			alertRadius = CREEP_ALERT_RADIUS_RANGED,
			siege = 0,
			attackRange = CREEP_ATTACK_RANGE_RANGED
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_creep_goodguys_ranged", "bad_rax_range_top", direracks),
			path = "gt",
			team = DOTA_TEAM_GOODGUYS,
			alertRadius = CREEP_ALERT_RADIUS_RANGED,
			siege = 0,
			attackRange = CREEP_ATTACK_RANGE_RANGED
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_creep_badguys_ranged", "good_rax_range_bot", direracks),
			path = "bb",
			team = DOTA_TEAM_BADGUYS,
			alertRadius = CREEP_ALERT_RADIUS_RANGED,
			siege = 0,
			attackRange = CREEP_ATTACK_RANGE_RANGED
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_creep_badguys_ranged", "good_rax_range_mid", direracks),
			path = "bm",
			team = DOTA_TEAM_BADGUYS,
			alertRadius = CREEP_ALERT_RADIUS_RANGED,
			siege = 0,
			attackRange = CREEP_ATTACK_RANGE_RANGED
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_creep_badguys_ranged", "good_rax_range_top", direracks),
			path = "bt",
			team = DOTA_TEAM_BADGUYS,
			alertRadius = CREEP_ALERT_RADIUS_RANGED,
			siege = 0,
			attackRange = CREEP_ATTACK_RANGE_RANGED
		})
	end
	for i=1,numSiegeCreep do
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_goodguys_siege", "bad_rax_range_bot", direracks),
			path = "gb",
			team = DOTA_TEAM_GOODGUYS,
			alertRadius = CREEP_ALERT_RADIUS_SEIGE,
			siege = 1,
			attackRange = CREEP_ATTACK_RANGE_SEIGE
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_goodguys_siege", "bad_rax_range_mid", direracks),
			path = "gm",
			team = DOTA_TEAM_GOODGUYS,
			alertRadius = CREEP_ALERT_RADIUS_SEIGE,
			siege = 1,
			attackRange = CREEP_ATTACK_RANGE_SEIGE
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_goodguys_siege", "bad_rax_range_top", direracks),
			path = "gt",
			team = DOTA_TEAM_GOODGUYS,
			alertRadius = CREEP_ALERT_RADIUS_SEIGE,
			siege = 1,
			attackRange = CREEP_ATTACK_RANGE_SEIGE
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_badguys_siege", "good_rax_range_bot", direracks),
			path = "bb",
			team = DOTA_TEAM_BADGUYS,
			alertRadius = CREEP_ALERT_RADIUS_SEIGE,
			siege = 1,
			attackRange = CREEP_ATTACK_RANGE_SEIGE
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_badguys_siege", "good_rax_range_mid", direracks),
			path = "bm",
			team = DOTA_TEAM_BADGUYS,
			alertRadius = CREEP_ALERT_RADIUS_SEIGE,
			siege = 1,
			attackRange = CREEP_ATTACK_RANGE_SEIGE
		})
		table.insert(result, 
		{
			name = creepUpgradedName("npc_dota_badguys_siege", "good_rax_range_top", direracks),
			path = "bt",
			team = DOTA_TEAM_BADGUYS,
			alertRadius = CREEP_ALERT_RADIUS_SEIGE,
			siege = 1,
			attackRange = CREEP_ATTACK_RANGE_SEIGE
		})
	end
	--DeepPrintTable(result)
	return result
end

function processCreepSpawnQueue(queue, max, immediate)
	--print("processCreepSpawnQueue called " .. #queue)
	local creepLevel = math.floor((GameRules:GetDOTATime(false, false) + 30) / 450)
    if immediate then
        creepLevel = math.floor((GameRules:GetDOTATime(false, false)) / 450)
    end
	for i=1,max do
		if #queue == 0 then
			break
		end
		local creep = queue[1]
		table.remove(queue, 1)
		
		-- find spawner
		local spawner = nil
		if creep.team == DOTA_TEAM_GOODGUYS then
			if creep.path == "gb" then
				spawner = radiantSpawners[1]
			elseif creep.path == "gm" then
				spawner = radiantSpawners[2]
			else
				spawner = radiantSpawners[3]
			end
		else
			if creep.path == "bb" then
				spawner = direSpawners[1]
			elseif creep.path == "bm" then
				spawner = direSpawners[2]
			else
				spawner = direSpawners[3]
			end
		end
		spawner = Entities:FindByName(nil, spawner)
		local spawnVecter = spawner:GetAbsOrigin()
		if string.find(creep.name, "ranged") ~= nil or string.find(creep.name, "siege") ~= nil then
			if creep.team == DOTA_TEAM_GOODGUYS then
				spawnVecter[1] = spawnVecter[1] - 300
				spawnVecter[2] = spawnVecter[2] - 300
			else
				spawnVecter[1] = spawnVecter[1] + 300
				spawnVecter[2] = spawnVecter[2] + 300
			end
		end

		CreateUnitByNameAsync(creep.name, spawnVecter, true, nil, nil, creep.team, function(spawnedUnit)
			spawnedUnit:SetIdleAcquire(false)
			local duration = 30 - GameRules:GetDOTATime(false, false) % 30
			if duration > 0 and not immediate then
				spawnedUnit:AddNoDraw()
				spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_preparing_lua", {})
			end
			spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", { 
				alertRadius = creep.alertRadius, 
				pathName = creep.path, 
				seige = creep.siege,
				attackrange = creep.attackRange })
			if creep.path == "gb" or creep.path == "bt" then
				if not spawnedUnit:HasModifier("modifier_creep_safe_lane_move_speed_bonus") then
					spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_safe_lane_move_speed_bonus", { }):SetDuration(25, true)
				end
			end
			if string.find(creep.name, "upgraded") == nil then
				spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_health_bonus", { health = 10 * creepLevel, damage = 1 * creepLevel  })
				spawnedUnit:SetMaximumGoldBounty(spawnedUnit:GetMaximumGoldBounty() + creepLevel)
				spawnedUnit:SetMinimumGoldBounty(spawnedUnit:GetMinimumGoldBounty() + creepLevel)
			elseif string.find(creep.name, "mega") == nil then											  
				spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_health_bonus", { health = 17 * creepLevel, damage = 2 * creepLevel  })
				spawnedUnit:SetMaximumGoldBounty(spawnedUnit:GetMaximumGoldBounty() + creepLevel * 2)
				spawnedUnit:SetMinimumGoldBounty(spawnedUnit:GetMinimumGoldBounty() + creepLevel * 2)
			end
			spawnedUnit:AddAbility("creep_alert_aura_datadriven"):SetLevel(1)
		end)
	end
end

function SpawnNeutralCreepCampCache()
	for i=1,12 do
		if #neutralCampCache[i] == 0 then
			print("Spawning neutral camp cache idx: " .. i)
			local trigger_name = "neutralcamp_good_".. i
			if i >= 7 then
				trigger_name = "neutralcamp_evil_" .. (i - 6)
			end
			local spawn_trigger = Entities:FindByName(nil, trigger_name)
			local camp_location = neutralcamp_name_2_location[trigger_name]
			local camp_size = neutralcamp_name_2_size[trigger_name]
			local camp_types = neutralcamp_size_2_creeps[camp_size]
			local camp_type = camp_types[RandomInt(1, #camp_types)]
			for j=1,#camp_type do
				CreateUnitByNameAsync(camp_type[j], camp_location, true, nil, nil, DOTA_TEAM_NEUTRALS, function(entity)
					for k=1,entity:GetAbilityCount() do
						local ability = entity:GetAbilityByIndex(k)
						if ability ~= nil then
							ability:SetLevel(1)
						else
							break
						end
					end
					entity:AddNoDraw()
					entity:AddNewModifier(nil, nil, "modifier_creep_preparing_lua", {})
					table.insert(neutralCampCache[i], entity:GetEntityIndex())
				end)
			end
			break
		end
	end
end

local function getUnitSpawnerLane(unit)
    local closest_spawner = nil
    local teamSpawners = nil
    local closest_spawner_idx = 1
    if unit:GetTeam() == DOTA_TEAM_GOODGUYS then
        closest_spawner = radiantSpawners[1]
        teamSpawners = radiantSpawners
    else
        closest_spawner = direSpawners[1]
        teamSpawners = direSpawners
    end
    for i=2,#teamSpawners do
		local spawner = Entities:FindByName(nil, closest_spawner)
        local spawner2 = Entities:FindByName(nil, teamSpawners[i])
        if (unit:GetAbsOrigin() - spawner:GetAbsOrigin()):Length2D() >
            (unit:GetAbsOrigin() - spawner2:GetAbsOrigin()):Length2D() then
            closest_spawner = teamSpawners[i]
            closest_spawner_idx = i
        end
    end
    return closest_spawner_idx
end

local function targetCreepName(unit, lane)
    local level_1_unit_name = "npc_dota_creep_goodguys_melee"
    local rax_melee = true
    if unit:GetTeam() == DOTA_TEAM_GOODGUYS then
        if string.find(unit:GetUnitName(), "siege") ~= nil then
            level_1_unit_name = "npc_dota_goodguys_siege"
            rax_melee = false
        elseif unit:IsRangedAttacker() then
            level_1_unit_name = "npc_dota_creep_goodguys_ranged" 
            rax_melee = false
        end
    else
        if string.find(unit:GetUnitName(), "siege") ~= nil then
            level_1_unit_name = "npc_dota_badguys_siege"
            rax_melee = false
        elseif unit:IsRangedAttacker() then
            level_1_unit_name = "npc_dota_creep_badguys_ranged" 
            rax_melee = false
        else
            level_1_unit_name = "npc_dota_creep_badguys_melee"
        end
    end

    local enemy_rak_name = ""
    local megaraks = direracks
    if unit:GetTeam() == DOTA_TEAM_GOODGUYS then
        enemy_rak_name = "bad_rax_"
    else
        enemy_rak_name = "good_rax_"
        megaraks = radiantracks
    end
    if rax_melee then
        enemy_rak_name = enemy_rak_name .. "melee_"
    else
        enemy_rak_name = enemy_rak_name .. "range_"
    end
    if lane == 1 then
        enemy_rak_name = enemy_rak_name .. "bot"
    elseif lane == 2 then
        enemy_rak_name = enemy_rak_name .. "mid"
    else
        enemy_rak_name = enemy_rak_name .. "top"
    end

    return creepUpgradedName(level_1_unit_name, enemy_rak_name, megaraks)
end

local function shouldUpgradeCachedCreep(unit) 
    -- find creep lane based on spawner distance
    local closest_spawner_idx = getUnitSpawnerLane(unit) -- 1: bot, 2:mid, 3:top
    local target_creep_name = targetCreepName(unit, closest_spawner_idx)
 --   print(unit:GetUnitName() .. " lane " .. closest_spawner_idx .. " target " .. target_creep_name)
    return target_creep_name ~= unit:GetUnitName()
end

function spawnNewLaneCreepWithSameType(unit)
    -- find unit lane
    local lane = getUnitSpawnerLane(unit) -- 1: bot, 2:mid, 3:top
    local path = "gb"
    if unit:GetTeam() == DOTA_TEAM_GOODGUYS then
        if lane == 2 then path = "gm"
        elseif lane == 3 then path = "gt"
        end
    else
        if lane == 1 then path = "bt"
        elseif lane == 2 then path = "bm"
        else path = "bt"
        end
    end
    -- find unit type
    -- find unit level
    local target_creep_name = targetCreepName(unit, lane)
    local alertRadius = CREEP_ALERT_RADIUS
    local attackRange = CREEP_ATTACK_RANGE
    local siege = 0
    if string.find(target_creep_name, "siege") ~= nil then
        alertRadius = CREEP_ALERT_RADIUS_SEIGE
        siege = 1
        attackRange = CREEP_ATTACK_RANGE_SEIGE
    elseif unit:IsRangedAttacker() then
        alertRadius = CREEP_ALERT_RADIUS_RANGED
        attackRange = CREEP_ATTACK_RANGE_RANGED
    end
    -- spawn unit
    local dummyqueue = {}
    table.insert(dummyqueue, {
        team = unit:GetTeam(),
        path = path,
        name = target_creep_name,
		alertRadius = alertRadius, 
		siege = siege,
		attackRange = attackRange
    })
    processCreepSpawnQueue(dummyqueue, 1, true) 
end

function SpawnCachedCreeps()
    -- get all lane creeps with modifier_creep_health_bonus
    local all_units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0, 0, 0), nil, 100000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_CREEP, 
        DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , FIND_ANY_ORDER, false)
    for i=1,#all_units do
        local unit = all_units[i]
        if unit:GetTeam() == DOTA_TEAM_GOODGUYS or unit:GetTeam() == DOTA_TEAM_BADGUYS then
            if unit:HasModifier("modifier_creep_preparing_lua") then
                if shouldUpgradeCachedCreep(unit) then
                    spawnNewLaneCreepWithSameType(unit)
                    unit:ForceKill(false)
                else
                    unit:RemoveModifierByName("modifier_creep_preparing_lua")
                end
            end
        end
    end
end

function SpawnNeutralCreepFirstTime(trigger_prefix)
	for i=1,6 do
		local campIdx = i
		if string.find(trigger_prefix, "evil") ~= nil then
			campIdx = i + 6
		end
		if isCampEmpty(campIdx) then
			local neutralTrigger = Entities:FindAllByName(trigger_prefix..i)
			if #neutralTrigger > 0 then
				neutralTrigger = neutralTrigger[1]
				local spawner = Entities:FindAllByClassname("npc_dota_neutral_spawner")
				if #spawner > 0 then
					local closestSpawner = spawner[1]
					for i=2,#spawner do
						if (spawner[i]:GetAbsOrigin() - neutralTrigger:GetAbsOrigin()):Length2D() <
							(closestSpawner:GetAbsOrigin() - neutralTrigger:GetAbsOrigin()):Length2D() then
							closestSpawner = spawner[i]
						end
					end
					spawner = closestSpawner
					spawner:CreatePendingUnits()
					spawner:CreatePendingUnits()
					spawner:CreatePendingUnits()
					spawner:CreatePendingUnits()
					spawner:CreatePendingUnits()
					spawner:SpawnNextBatch(true)
				end
			end
		end
	end
end

local function isCampBlockedByTechiesMine(trigger_name)
	local spawn_trigger = Entities:FindByName(nil, trigger_name)
	local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, spawn_trigger:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	local blockedByMine = false
	for j=1,#units do
		if spawn_trigger:IsTouching(units[j]) then
			if units[j]:GetName() == "npc_dota_techies_mines" 
				or units[j]:GetUnitName() == "npc_dota_techies_remote_mine_datadriven"
				or units[j]:HasModifier("modifier_fire_remnant_dummy_buff_lua") then
				blockedByMine = true
			elseif units[j]:GetName() ~= "npc_dota_templar_assassin_psionic_trap" then
				return false
			end
		end
	end
	return blockedByMine
end

-- if camp is blocked by techies mine only, spawn neutrals that is blocked
function SpawnNeutralCreepSecondTime(trigger_prefix)
	for i=1,6 do
		if isCampBlockedByTechiesMine(trigger_prefix .. i) then
			local neutralTrigger = Entities:FindAllByName(trigger_prefix..i)
			if #neutralTrigger > 0 then
				neutralTrigger = neutralTrigger[1]
				local spawner = Entities:FindAllByClassname("npc_dota_neutral_spawner")
				if #spawner > 0 then
					local closestSpawner = spawner[1]
					for i=2,#spawner do
						if (spawner[i]:GetAbsOrigin() - neutralTrigger:GetAbsOrigin()):Length2D() <
							(closestSpawner:GetAbsOrigin() - neutralTrigger:GetAbsOrigin()):Length2D() then
							closestSpawner = spawner[i]
						end
					end
					spawner = closestSpawner
					spawner:CreatePendingUnits()
					spawner:CreatePendingUnits()
					spawner:CreatePendingUnits()
					spawner:CreatePendingUnits()
					spawner:CreatePendingUnits()
					spawner:SpawnNextBatch(true)
				end
			end
		end
	end
end
