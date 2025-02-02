require( "ai/global_ability_data" )
local gHeroVar = require( "ai/global_hero_data" )

GAMEMODE_AP = 1
LANE_MID = 2
LANE_MID_LINES = {Vector(-4887, -4322, 384), Vector(4394, 3906, 384)}
BOT_MODE_LANING = 1
BOT_MODE_ATTACK = 2

ITEM_SLOT_TYPE_INVALID = -1 
-- openhyperai begin 
local function enhanceUnit(ret, thisEntity)
	ret.CanBeSeen = 			function(self) return self:CanEntityBeSeenByMyTeam(self) end
	ret.GetLocation = 			function(self) return self:GetAbsOrigin() end
	ret.OriginalGetHealth = 	function(self) return self:GetHealth() end
	ret.OriginalGetMaxHealth = 	function(self) return self:GetMaxHealth() end
    ret.IsCastingAbility =      function(self) return false end
    ret.IsUsingAbility =        function(self) return false end
	ret.GetOffensivePower =     function(self) return 0	end
    ret.GetRawOffensivePower =  function(self) return 0 end
    ret.IsBot =                 function(self) return false end
    ret.GetNearbyHeroes = function(self, radius, enemy, botMode) return GetNearbyHeroes(self, radius, enemy, botMode) end
	ret.GetIncomingTrackingProjectiles = function(self)
		local retVal = {}
		local time = GameRules:GetGameTime()
		if self.iap == nil then return retVal end
		for i=1,#self.iap do
			if self.iap[i].expire_at <= time then
				local attacker = EntIndexToHScript(self.iap[i].caster_id)
				if IsValidEntity(attacker) then
					local duration = time - self.iap[i].create_at
					local total_duration = self.iap[i].expire_at - self.iap[i].create_at
					table.insert(retVal, {
						is_attack = 1,
						caster = attacker,
						location = attacker:GetAbsOrigin() + (self:GetAbsOrigin() - attacker:GetAbsOrigin()) * duration / total_duration
					})
				end
			end
		end
		return retVal
	end
	return ret
end
local function enhanceUnits(ret, thisEntity)
	for i=1,#ret do
		enhanceUnit(ret[i], thisEntity)
	end
	return ret
end

function Init_G(thisEntity)
	_G["GetBot"] = function() return thisEntity end
	_G["CDOTA_Bot_Script"] = {}
	_G["GetTeam"] = function() return thisEntity:GetTeam() end
	_G["IsPlayerBot"] = function(id) return PlayerResource:GetPlayer(id) ~= nil end
	_G["GetTeamMember"] = function(n) 
		local pid = PlayerResource:GetNthPlayerIDOnTeam(thisEntity:GetTeam(), n) 
		local player = PlayerResource:GetPlayer(pid)
		if player == nil then return nil end
		return player:GetAssignedHero()
	end
	_G["GetItemComponents"] = function(item) 
		print("TODO GetItemComponents " .. item)
		return {}
	end
	_G["GetGameMode"] = function() return GAMEMODE_AP end
	_G["GetOpposingTeam"] = function() 
		if thisEntity:GetTeam() == DOTA_TEAM_GOODGUYS then
			return DOTA_TEAM_BADGUYS
		else
			return DOTA_TEAM_GOODGUYS
		end
	end
	_G["GetUnitList"] = function(team)
		local ret = nil
		if team == UNIT_LIST_ENEMIES then
			ret = FindUnitsInRadius(thisEntity:GetTeam(), Vector(0, 0, 0), nil, 30000, DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, 0, false)
		else
			print("TODO GetUnitList " .. team)
			return {}
		end
		return enhanceUnits(ret, thisEntity)
	end
	_G["GetLaneFrontLocation"] = function(team, lane, delta)
		if delta ~= 0 or lane ~= LANE_MID or team ~= DOTA_TEAM_BADGUYS then
			print("TODO GetLaneFrontLocation " .. team .. ", " .. lane .. ", " .. delta)
			return Vector(0, 0, 0)
		end
		local units = FindUnitsInLine(team, LANE_MID_LINES[1], LANE_MID_LINES[2], nil,
			500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 
			DOTA_UNIT_TARGET_FLAG_NONE)
		if #units == 0 then
			return LANE_MID_LINES[1]
		end
		local front_creep = units[1]
		for i=2,#units do
			if units[i]:GetAbsOrigin().x < front_creep:GetAbsOrigin().x then
				front_creep = units[i]
			end
		end
		return front_creep:GetAbsOrigin()
	end
	_G["GetTower"] = function(team, towerId)
		if team == DOTA_TEAM_GOODGUYS then
			return enhanceUnit(Entities:FindByName(nil, RAD_BUILDING_TYPE_2_NAME[towerId]),  thisEntity)
		else
			return enhanceUnit(Entities:FindByName(nil, DIRE_BUILDING_TYPE_2_NAME[towerId]), thisEntity)
		end
	end
    _G["GetHeroLevel"]  = function(pid) return PlayerResource:GetLevel(pid)  end
    _G["GetHeroKills"]  = function(pid) return PlayerResource:GetKills(pid)  end
    _G["GetHeroDeaths"] = function(pid) return PlayerResource:GetDeaths(pid) end


	thisEntity.OriginalGetMaxHealth = 		function() return thisEntity:GetMaxHealth() end
	thisEntity.OriginalGetHealth =    		function() return thisEntity:GetHealth()	end
	thisEntity.GetAssignedLane =      		function() return LANE_MID end
	thisEntity.GetActiveMode = 		  		function() return thisEntity.bot_active_mode end
	thisEntity.GetActiveModeDesire = 		function() return thisEntity.bot_active_mode_desire end
	thisEntity.GetAttackRange = 	  		function() return thisEntity:Script_GetAttackRange() end
	thisEntity.GetTarget = 			  		function() return thisEntity:GetAttackTarget() end
	thisEntity.GetNetWorth = 		  		function() return PlayerResource:GetNetWorth(thisEntity:GetPlayerOwnerID()) end
	thisEntity.GetAttackPoint = 	  		function() return thisEntity:GetAttackAnimationPoint() end
	thisEntity.GetAttackProjectileSpeed = 	function() return thisEntity:GetProjectileSpeed() end
	thisEntity.SetTarget = 					function(self, target) thisEntity:SetAttacking(target) end
	thisEntity.Action_MoveToLocation = 		function(self, loc) thisEntity:MoveToPosition(loc) end
	thisEntity.ActionQueue_AttackMove = 	function(self, loc) thisEntity:MoveToPositionAggressive(loc) end
	thisEntity.Action_AttackUnit = 			function(self, target) 
		if not thisEntity:IsAttackingEntity(target) then
			thisEntity:MoveToTargetToAttack(target) 
		end
	end
	thisEntity.NumQueuedActions = function()
		print("TODO NumQueuedActions")
		return 0
	end
	thisEntity.IsCastingAbility = function()
		print("TODO IsCastingAbility")
		return false
	end
	thisEntity.IsUsingAbility = function()
		print("TODO IsUsingAbility")
		return false
	end
	thisEntity.WasRecentlyDamagedByAnyHero = function(self, time)
		print("TODO Set bot.damagedByTowerTime")
		if thisEntity.damagedByHeroTime == nil then
			return false
		end
		return (GameRules:GetGameTime() - bot.damagedByHeroTime) < time
	end
	thisEntity.GetNearbyHeroes = function(self, distance, isEnemy, mode_unused)
		local team_filter = DOTA_UNIT_TARGET_TEAM_FRIENDLY 
		if isEnemy then team_filter = DOTA_UNIT_TARGET_TEAM_ENEMY end
		local units = FindUnitsInRadius(self:GetTeam(), self:GetAbsOrigin(), nil,
			distance, team_filter, DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
			FIND_ANY_ORDER, false)
		return enhanceUnits(units, thisEntity)
	end
	thisEntity.GetAnimActivity = function()
		if thisEntity:IsAttacking()  then return ACT_DOTA_ATTACK
		elseif thisEntity:IsMoving() then return ACT_DOTA_RUN
		else 							  return ACT_DOTA_IDLE    end
	end
    thisEntity.FindItemSlot = function(self, item_name)
        local item = thisEntity:FindItemInInventory(item_name)
		if item == nil then return ITEM_SLOT_TYPE_INVALID end
		return item:GetItemSlot()
    end
	thisEntity.GetNearbyTowers = function(self, range, is_enemy)
		local target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
		if is_enemy then target_team = DOTA_UNIT_TARGET_TEAM_ENEMY end
		local buildings = FindUnitsInRadius(self:GetTeam(), self:GetAbsOrigin(), nil, range, 
			target_team, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local towers = {}
		for i=1,#buildings do
			if buildings[i]:IsTower() then
				table.insert(towers, buildings[i])
			end
		end
		return enhanceUnits(towers)
	end
	thisEntity.GetNearbyCreeps = function(self, range, enemy)
		local target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
		if is_enemy then target_team = DOTA_UNIT_TARGET_TEAM_ENEMY end
		return enhanceUnits(FindUnitsInRadius(self:GetTeam(), self:GetAbsOrigin(), nil, range, target_team,
			DOTA_UNIT_TARGET_CREEP,	DOTA_UNIT_TARGET_FLAG_NONE,	FIND_CLOSEST, false))
	end
	thisEntity.GetNearbyLaneCreeps = function(self, range, enemy) return self:GetNearbyCreeps(range, enemy) end
	thisEntity.WasRecentlyDamagedByTower = function(self, time)
		print("TODO WasRecentlyDamagedByTower " .. time)
		return false
	end
	thisEntity.WasRecentlyDamagedByCreep = function(self, time)
		print("TODO WasRecentlyDamagedByCreep " .. time)
		return false
	end
end

function GetScriptDirectory()
	return "openhyperai/bots"
end

-- openhyperai end

local function setHeroVar(bot, var, value)
    gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

local function getHeroVar(bot, var)
    return gHeroVar.GetVar(bot:GetPlayerID(), var)
end

LANE_NONE = 0
LANE_TOP  = 1
--LANE_MID  = 2
LANE_BOT  = 3
LANE_WIDTH = 1000
LANE_TOP_LINES = {Vector(-6634, -3704, 384), Vector(-5913, 5469, 384), Vector(3705, 5754, 384)}
--LANE_MID_LINES = {Vector(-4887, -4322, 384), Vector(4394, 3906, 384)}
LANE_BOT_LINES = {Vector(-4227, -6101, 384), Vector(5506, -5569, 384), Vector(6266, 3187, 384)}

GAME_STATE_PRE_GAME = DOTA_GAMERULES_STATE_PRE_GAME
GAME_STATE_GAME_IN_PROGRESS = DOTA_GAMERULES_STATE_GAME_IN_PROGRESS 

DIFFICULTY_EASY = 0
DIFFICULTY_MEDIUM = 1
DIFFICULTY_HARD = 2
DIFFICULTY_UNFAIR = 3

UNIT_LIST_ALL  				= 0
UNIT_LIST_ALLIES			= 1
UNIT_LIST_ALLIED_HEROES		= 2
UNIT_LIST_ALLIED_CREEPS		= 3
UNIT_LIST_ALLIED_WARDS		= 4
UNIT_LIST_ALLIED_BUILDINGS	= 5
UNIT_LIST_ENEMIES			= 6
UNIT_LIST_ENEMY_HEROES		= 7
UNIT_LIST_ENEMY_CREEPS		= 8
UNIT_LIST_ENEMY_WARDS		= 9
UNIT_LIST_NEUTRAL_CREEPS	= 10
UNIT_LIST_ENEMY_BUILDINGS	= 11

TEAM_RADIANT = DOTA_TEAM_GOODGUYS
TEAM_DIRE = DOTA_TEAM_BADGUYS

ANCIENT 	= 1
TOWER_TOP_1 = 2
TOWER_TOP_2 = 3
TOWER_TOP_3 = 4
TOWER_MID_1 = 5
TOWER_MID_2 = 6
TOWER_MID_3 = 7
TOWER_BOT_1 = 8
TOWER_BOT_2 = 9
TOWER_BOT_3 = 10
TOWER_BASE_1 =11
TOWER_BASE_2 =12
BARRACKS_TOP_MELEE = 13
BARRACKS_TOP_RANGED =14
BARRACKS_MID_MELEE = 15
BARRACKS_MID_RANGED =16
BARRACKS_BOT_MELEE = 17
BARRACKS_BOT_RANGED =18

BOT_ACTION_DESIRE_NONE		= 0.0
BOT_ACTION_DESIRE_VERYLOW	= 0.1
BOT_ACTION_DESIRE_LOW		= 0.25
BOT_ACTION_DESIRE_MODERATE	= 0.5
BOT_ACTION_DESIRE_HIGH		= 0.75
BOT_ACTION_DESIRE_VERYHIGH	= 0.9
BOT_ACTION_DESIRE_ABSOLUTE	= 1.0

BOT_MODE_DESIRE_NONE 	= 0
BOT_MODE_DESIRE_VERYLOW = 0.1
BOT_MODE_DESIRE_LOW 	= 0.25
BOT_MODE_DESIRE_MODERATE= 0.5
BOT_MODE_DESIRE_HIGH 	= 0.75
BOT_MODE_DESIRE_VERYHIGH= 0.9
BOT_MODE_DESIRE_ABSOLUTE= 1.0

RAD_BUILDING_TYPE_2_NAME = {
	"dota_goodguys_fort",
	"dota_goodguys_tower1_top",
	"dota_goodguys_tower2_top",
	"dota_goodguys_tower3_top",
	"dota_goodguys_tower1_mid",
	"dota_goodguys_tower2_mid",
	"dota_goodguys_tower3_mid",
	"dota_goodguys_tower1_bot",
	"dota_goodguys_tower2_bot",
	"dota_goodguys_tower3_bot",
	"dota_goodguys_tower4_top",
	-- TODO tower4 has same name
	"dota_goodguys_tower4_top",
	"good_rax_melee_top",
	"good_rax_range_top",
	"good_rax_melee_mid",
	"good_rax_range_mid",
	"good_rax_melee_bot",
	"good_rax_range_bot"
}

DIRE_BUILDING_TYPE_2_NAME = {
	"dota_badguys_fort",
	"dota_badguys_tower1_top",
	"dota_badguys_tower2_top",
	"dota_badguys_tower3_top",
	"dota_badguys_tower1_mid",
	"dota_badguys_tower2_mid",
	"dota_badguys_tower3_mid",
	"dota_badguys_tower1_bot",
	"dota_badguys_tower2_bot",
	"dota_badguys_tower3_bot",
	"dota_badguys_tower4_top",
	-- TODO tower4 has same name
	"dota_badguys_tower4_top",
	"bad_rax_melee_top",
	"bad_rax_range_top",
	"bad_rax_melee_mid",
	"bad_rax_range_mid",
	"bad_rax_melee_bot",
	"bad_rax_range_bot"
}

ITEM_SLOT_TYPE_MAIN = 1
ITEM_SLOT_TYPE_BACKPACK = 2
ITEM_SLOT_TYPE_STASH = 3

BOT_MODE_DEFEND_ALLY = "defendally"
BOT_MODE_ROAM = "roam"
BOT_MODE_PUSH_LANE = "pushlane"
BOT_MODE_DEFEND_LANE = "defendlane"
BOT_MODE_RETREAT = "retreat"

ACTION_DEBUG_HERO = "invalid"
local function debugprint(ret)
	if ret then 
		return "true"
	else
		return "false"
	end
end

ListenToGameEvent('player_chat', function(event)
	updateDebugHero(event.text)
end, nil)

function updateDebugHero(text) 
	if string.find(text, "debug") then
		ACTION_DEBUG_HERO = string.sub(text, 7)
		print("ACTION_DEBUG_HERO " .. ACTION_DEBUG_HERO)
	end
end

function SetBot(bot)
	bot.GetDifficulty = function()
		return GameRules:GetCustomGameDifficulty()
	end
	
	bot.GetAbilityByName = function(self, name)
		return self:FindAbilityByName(name)
	end

    bot.GetItemSlotType = function(self, slot)
        if slot <= DOTA_ITEM_SLOT_6 then
            return ITEM_SLOT_TYPE_MAIN
        elseif slot <= DOTA_ITEM_SLOT_9 then
            return ITEM_SLOT_TYPE_BACKPACK
        else
            return ITEM_SLOT_TYPE_STASH
        end
    end
    bot.GetUnitList = function(self, list_type)
	    if list_type == UNIT_LIST_ALLIED_HEROES then
	    	local players = PlayerResource:GetPlayerCountForTeam(self:GetTeam())
	    	local heroes = {}
	    	for i=1,players do
	    		table.insert(heroes, self:GetTeamMember(i))
	    	end
	    	return heroes
	    elseif list_type == UNIT_LIST_ENEMY_HEROES then
			local enemyTeam = DOTA_TEAM_GOODGUYS
			if self:GetTeam() == DOTA_TEAM_GOODGUYS then
				enemyTeam = DOTA_TEAM_BADGUYS
			end
			local players = PlayerResource:GetPlayerCountForTeam(enemyTeam)
	    	local heroes = {}
	    	for i=1,players do
	    		local player_id = PlayerResource:GetNthPlayerIDOnTeam(enemyTeam, i)
	    		local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
				if hero ~= nil and hero:IsAlive() then
	    			table.insert(heroes, hero)
				end
	    	end
	    	return heroes
		else
	    	print("ERR: Unknown list type " .. list_type)
			return {}
	    end
    end
    bot.GetTeamMember = function(self, idx)
	    local player_id = PlayerResource:GetNthPlayerIDOnTeam(self:GetTeam(), idx)
	    local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
	    return hero
    end

	-- ACTION START --
	bot.ActionImmediate_LevelAbility = function(self, ability_name)
		local ability =	self:FindAbilityByName(ability_name);
		local ability_points = self:GetAbilityPoints()
		if ability:GetLevel() < ability:GetMaxLevel() and ability_points > 0 then
			ability:SetLevel(ability:GetLevel() + 1)
			self:SetAbilityPoints(ability_points - 1)
		end
	end
	bot.Action_MoveToLocation = function(self, loc)
		if string.find(self:GetName(), ACTION_DEBUG_HERO) then
			print(self:GetName() .. " Action_MoveToLocation ")
		end
		self:MoveToPosition(loc)
	end
	bot.Action_MoveToUnit = function(self, unit)
		if string.find(self:GetName(), ACTION_DEBUG_HERO) then
			print(self:GetName() .. " Action_MoveToUnit " .. unit:GetName())
		end
		self:MoveToNPC(unit)
	end
	bot.Action_UseAbilityOnTree = function(self, ability, tree)
		if string.find(self:GetName(), ACTION_DEBUG_HERO) then
			print(self:GetName() .. " Action_UseAbilityOnTree " .. ability:GetName())
		end
		self:CastAbilityOnTarget(tree, ability, self:GetPlayerID())
	end
	bot.Action_ClearActions = function(self, stop)
		if stop then
			self:Stop()
		end
	end
	bot.ActionImmediate_Chat = function(msg, toAll)
	end
	bot.ActionQueue_Delay = function(self, time)
	end
	bot.ActionPush_Delay = function(self, time)
	end
	bot.ActionPush_UseAbilityOnEntity = function(self, ability, unit)
		if string.find(self:GetName(), ACTION_DEBUG_HERO) then
			print(self:GetName() .. " Action_UseAbilityOnEntity " .. ability:GetName() .. " " .. unit:GetName())
		end
		self:CastAbilityOnTarget(unit, ability, self:GetPlayerID())
		if ability:GetCastPoint() > 0.2 then
			self.lastActionAbility = ability
			self.lastActionAbilityTime = GameTime()
		end
	end
	bot.Action_UseAbility = function(self, ability)
		self:CastAbilityNoTarget(ability, self:GetPlayerID())
		if ability:GetCastPoint() > 0.2 then
			self.lastActionAbility = ability
			self.lastActionAbilityTime = GameTime()
		end
	end
	bot.Action_UseAbilityOnEntity = function(self, ability, unit)
		if string.find(self:GetName(), ACTION_DEBUG_HERO) then
			print(self:GetName() .. " Action_UseAbilityOnEntity " .. ability:GetName() .. " " .. unit:GetName())
		end
		self:CastAbilityOnTarget(unit, ability, self:GetPlayerID())
		if ability:GetCastPoint() > 0.2 then
			self.lastActionAbility = ability
			self.lastActionAbilityTime = GameTime()
		end
	end
	bot.ActionImmediate_PurchaseItem = function(self, item)
		print(self:GetName() .. " purchase ".. item)
		local cost = GetItemCost(item)
		if self:GetGold() < cost then
			print("WARN no enough gold to buy " .. self:GetGold() .. " " .. cost)
			return
		end
		self:SpendGold(cost, DOTA_ModifyGold_PurchaseItem)
		self:AddItemByName(item)
	end
	bot.Action_AttackUnit = function(self, target, once)
		if string.find(self:GetName(), ACTION_DEBUG_HERO) then
			print(self:GetName() .. " Action_AttackUnit " .. target:GetName())
		end
		self:MoveToTargetToAttack(target)
	end
	bot.Action_UseAbilityOnLocation = function(self, ability, loc)
		if string.find(self:GetName(), ACTION_DEBUG_HERO) then
			print(self:GetName() .. " Action_UseAbilityOnLocation " .. ability:GetName())
		end
		self:CastAbilityOnPosition(loc, ability, self:GetPlayerID())
		self.nextBotThinkTime = GameRules:GetGameTime() + ability:GetCastPoint() + 0.1
	end
	bot.ActionQueue_AttackUnit = function(self, target, bOnce)
		if string.find(self:GetName(), ACTION_DEBUG_HERO) then
			print(self:GetName() .. " ActionQueue_AttackUnit " .. target:GetName())
		end
		self:SetThink(function()
			self:MoveToTargetToAttack(target)
		end, "ActionQueue_AttackUnit", 0.5)
	end
	-- ACTION END --

    bot.NumQueuedActions = function(self)
        return 0
    end
    bot.IsCastingAbility = function(self)
		local ret = false
		if bot:IsChanneling() then
			return true
		end
		if self.lastActionAbilityTime ~= nil then
			if self.lastActionAbilityTime < GameRules:GetGameTime() - 3 then
				return false
			end
			if bit.band(self.lastActionAbility:GetBehavior(), DOTA_ABILITY_BEHAVIOR_ATTACK) ~= 0 then
				if self.lastAttackTime == nil then
					ret = true
				else
					ret = self.lastActionAbilityTime >= self.lastAttackTime
				end
			else
				if self.lastAbilityCastTime == nil then
					ret = true
				else
					ret = self.lastActionAbilityTime >= self.lastAbilityCastTime
				end
			end
		end
		--if string.find(self:GetName(), ACTION_DEBUG_HERO) then
		--	print("IsCastingAbility " .. self:GetName() .. " " .. debugprint(ret))
		--end
        return ret 
    end
	bot.GetNextItemPurchaseValue = function(self)
		if bot.nextItemPurchaseValue == nil then
			return 0
		end
		return bot.nextItemPurchaseValue
	end
	bot.DistanceFromFountain = function(self)
		local fountain_name
		if self:GetTeam() == DOTA_TEAM_GOODGUYS then
			fountain_name = "ent_dota_fountain_good"
		else
			fountain_name = "ent_dota_fountain_bad"
		end
		return (Entities:FindByName(nil, fountain_name):GetAbsOrigin() - self:GetAbsOrigin()):Length()
	end
	bot.DistanceFromSecretShop = function(self)
		local shop_location = Vector(-4499, 1376, 384)
		local shop_distance = (self:GetAbsOrigin() - shop_location):Length()
		local shop_location2 = Vector(3356.220703125, 340, 384)
		local shop_distance2 = (self:GetAbsOrigin() - shop_location2):Length()
		if shop_distance > shop_distance2 then
			return shop_distance2
		else
			return shop_distance
		end
	end
	bot.DistanceFromSideShop = function(self)
		local shop_location = Vector(-7397, 4435, 384)
		local shop_distance = (self:GetAbsOrigin() - shop_location):Length()
		local shop_location2 = Vector(7395, -4098, 384)
		local shop_distance2 = (self:GetAbsOrigin() - shop_location2):Length()
		if shop_distance > shop_distance2 then
			return shop_distance2
		else
			return shop_distance
		end
	end
	bot.SetNextItemPurchaseValue = function(self, value)
		self.nextItemPurchaseValue = value
	end
	bot.GetNearbyBarracks = function(self, range, is_enemy)
		local target_team
		if is_enemy then
			target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
		else
			target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
		end
		local buildings = FindUnitsInRadius(self:GetTeam(),
			self:GetAbsOrigin(),
			nil, 
			range, 
			target_team,
			DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_CLOSEST,
			false)
		local towers = {}
		for i=1,#buildings do
			if buildings[i]:IsBarracks() then
				table.insert(towers, buildings[i])
			end
		end
		return towers
	end
	bot.WasRecentlyDamagedByCreep = function(self, time)
		if bot.damagedByCreepTime == nil then
			return false
		end
		return (GameRules:GetGameTime() - bot.damagedByCreepTime) < time
	end
	bot.FindAoELocation = function(self, is_enemy, is_hero, loc, range, radius, time, health)
		local teamFilter = GetTeamFilter(is_enemy)
		local typeFilter = GetUnitTypeFilter(is_hero)
		local units = FindUnitsInRadius(self:GetTeam(), loc, nil, range, teamFilter, typeFilter, 0, 0, false)
		local units_below_hp = {}
		for i=1,#units do
			if units[i]:GetHealth() < health then
				table.insert(units_below_hp, units[i])
			end
		end
		units = units_below_hp
		if #units == 0 then 
			return {
				count = 0,
				targetloc = loc
			}
		end
		local maxUnit = units[1]
		local maxCount = #FindUnitsInRadius(self:GetTeam(), maxUnit:GetAbsOrigin(), nil, radius, teamFilter, typeFilter, 0, 0, false)
		for i=2,#units do
			local count = #FindUnitsInRadius(self:GetTeam(), maxUnit:GetAbsOrigin(), nil, radius, teamFilter, typeFilter, 0, 0, false)
			if count > maxCount then
				maxCount = count
				maxUnit = units[i]
			end
		end
		return {
			count = maxCount,
			targetloc = maxUnit:GetAbsOrigin()
		}
	end
	bot.GetLocationAlongLane = function(self, lane, amount)
		if amount < 0 then
			amount = 0
		elseif amount > 1 then
			amount = 1
		end
		if self:GetTeam() == DOTA_TEAM_BADGUYS then
			amount = 1 - amount
		end
		if lane == LANE_TOP then
			if amount < 0.5 then
				return LANE_TOP_LINES[1] + (LANE_TOP_LINES[2] - LANE_TOP_LINES[1]) * amount * 2
			else
				return LANE_TOP_LINES[2] + (LANE_TOP_LINES[3] - LANE_TOP_LINES[2]) * (amount - 0.5) * 2
			end
		elseif lane == LANE_MID then
			return LANE_MID_LINES[1] + (LANE_MID_LINES[2] - LANE_MID_LINES[1]) * amount
		elseif lane == LANE_BOT then
			if amount < 0.5 then
				return LANE_BOT_LINES[1] + (LANE_BOT_LINES[2] - LANE_BOT_LINES[1]) * amount * 2
			else
				return LANE_BOT_LINES[2] + (LANE_BOT_LINES[3] - LANE_BOT_LINES[2]) * (amount - 0.5) * 2
			end
		end
	end
	bot.GetAttackPoint = function(self)
		return self:GetAttackAnimationPoint()
	end
	bot.GetLocation = function(self)
		return self:GetAbsOrigin()
	end
	bot.GetLaneFrontAmount = function(self, team, lane, ignoreTowers)
		local typeFilter = GetLaneTypeFilter(ignoreTowers)
		local teamFilter = DOTA_UNIT_TARGET_TEAM_FRIENDLY 
		if team ~= self:GetTeam() then
			teamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY 
		end
		if lane == LANE_NONE then
			return 0
		end
		local amount = 0
		if lane == LANE_MID then
			if team == DOTA_TEAM_GOODGUYS then
				amount = findAmountLinesClamped(bot:GetTeam(), teamFilter, LANE_MID_LINES[2], LANE_MID_LINES[1], typeFilter, 2)
			else
				amount = 1 - findAmountLinesClamped(bot:GetTeam(), teamFilter, LANE_MID_LINES[1], LANE_MID_LINES[2], typeFilter, 2)
			end
		elseif lane == LANE_TOP then
			if team == DOTA_TEAM_GOODGUYS then
				amount = findAmountLinesClamped(bot:GetTeam(), teamFilter, LANE_TOP_LINES[3], LANE_TOP_LINES[2], typeFilter, 1)
				if amount > 0 then
					amount = 0.5 * (1 + amount)
				else
					amount = 0.5 * findAmountLinesClamped(bot:GetTeam(), teamFilter, LANE_TOP_LINES[2], LANE_TOP_LINES[1], typeFilter, 2) 
				end
			else -- team == DOTA_TEAM_BADGUYS
				amount = findAmountLinesClamped(bot:GetTeam(), teamFilter, LANE_TOP_LINES[1], LANE_TOP_LINES[2], typeFilter, 2)
				if amount > 0 then
					amount = 0.5 * (1 - amount)
				else
					amount = 1 - 0.5 * findAmountLinesClamped(bot:GetTeam(), teamFilter, LANE_TOP_LINES[2], LANE_TOP_LINES[3], typeFilter, 1) 
				end
			end
		elseif lane == LANE_BOT then
			if team == DOTA_TEAM_GOODGUYS then
				amount = findAmountLinesClamped(bot:GetTeam(), teamFilter, LANE_BOT_LINES[3], LANE_BOT_LINES[2], typeFilter, 2)
				if amount > 0 then
					amount = 0.5 * (1 + amount)
				else
					amount = 0.5 * findAmountLinesClamped(bot:GetTeam(), teamFilter, LANE_BOT_LINES[2], LANE_BOT_LINES[1], typeFilter, 1)
				end
			else
				amount = findAmountLinesClamped(bot:GetTeam(), teamFilter, LANE_BOT_LINES[1], LANE_BOT_LINES[2], typeFilter, 1)
				if amount > 0 then
					amount = 0.5 * (1 - amount)
				else
					amount = 1 - 0.5 * findAmountLinesClamped(bot:GetTeam(), teamFilter, LANE_BOT_LINES[2], LANE_BOT_LINES[3], typeFilter, 2) 
				end
			end
		else
			print("WARN GetLaneFrontAmount invalid lane")
			return 0
		end
		if self:GetTeam() == DOTA_TEAM_BADGUYS then
			amount = 1 - amount
		end
		return amount
	end
	bot.GetNearbyTrees = function(self, distance)
		return GridNav:GetAllTreesAroundPoint(self:GetAbsOrigin(), distance, false)
	end
	bot.HasEmptyItemSlot = function(self) 
		for i=DOTA_ITEM_SLOT_1,DOTA_ITEM_SLOT_6 do
			if self:GetItemInSlot(i) == nil then
				return true
			end
		end
		return false
	end
	bot.GetActiveMode = function(self) return self.currentModeName end
	bot.GetTarget = function(self) return getHeroVar(self, "Target") end
	bot.GetNearbyHeroes = function(self, range, enemy, mode) return GetNearbyHeroes(self, range, enemy, mode) end
	bot.WasRecentlyDamagedByHero = function(self, hero, time) return WasRecentlyDamagedByHero(self, hero, time) end
end

function GetGameState()
	return GameRules:State_Get()
end

function GameTime()
	return GameRules:GetGameTime()
end

function DotaTime()
	return GameRules:GetDOTATime(false, false)
end

function GetNumCouriers()
	return 0
end

function GetTeamPlayers(team)
	local players = PlayerResource:GetPlayerCountForTeam(team)
	local heroes = {}
	for i=1,players do
		table.insert(heroes, PlayerResource:GetNthPlayerIDOnTeam(team, i))
	end
	return heroes
end

function IsHeroAlive(pid)
	local hero = PlayerResource:GetPlayer(pid):GetAssignedHero()
	if hero == nil then
		return false
	end
    return hero:IsAlive()
end

function GetHeroLastSeenInfo(pid)
	-- FIXME hero is always visible
	local hero = PlayerResource:GetPlayer(pid):GetAssignedHero()
	if hero == nil then
		return { time = 1000 }
	end
	return {
		time = 0,
		location = hero:GetAbsOrigin(),
		time_since_seen = 0
	}
end

function GetBarracks(team, towerId)
	if team == DOTA_TEAM_GOODGUYS then
		return Entities:FindByName(nil, RAD_BUILDING_TYPE_2_NAME[towerId])
	else
		return Entities:FindByName(nil, DIRE_BUILDING_TYPE_2_NAME[towerId])
	end
end

function GetAncient(team)
	local ret = nil
	if team == DOTA_TEAM_GOODGUYS then
		ret = Entities:FindByName(nil, RAD_BUILDING_TYPE_2_NAME[ANCIENT])
	else
		ret = Entities:FindByName(nil, DIRE_BUILDING_TYPE_2_NAME[ANCIENT])
	end
	ret.GetLocation = function() return ret:GetAbsOrigin() end
	return ret
end

function GetAmountDPos2Line(pos, lstart, lend)
	local length = (lend - lstart):Length()
	local lineDirection = (lend - lstart):Normalized()
	local amount = (pos - lstart):Dot(lineDirection) / length
	local distance = CalcDistanceToLineSegment2D(pos, lstart, lend)
	--if amount > 1 then
	--	amount = 1
	--	distance = (lend - pos):Length()
	--elseif amount < 0 then
	--	amount = 0
	--	distance = (lstart - pos):Length()
	--else
	--	distance = (pos - lstart + (pos - lstart):Dot(lineDirection) * lineDirection):Length() 
	--end
	return { amount = amount, distance = distance}
end

function GetItemStockCount(bot, name)
	return GameRules:GetItemStockCount(bot:GetTeam(), name, bot:GetPlayerID())
end

function IsItemPurchasedFromSecretShop(item)
	return false
end

function GetAvoidanceZones()
	--TODO 
	return {}
end

function GetLinearProjectiles()
	-- TODO
	return {}
end

function TimeSinceDamagedByAnyHero(entity)
	if entity.lastAttackedByHeroTime == nil then
		return 100
	end
	local attackTime = GameRules:GetGameTime() - entity.lastAttackedByHeroTime
	if attackTime > 100 then
		return 100
	else
		return attackTime
	end
end

function IsItemPurchasedFromSecretShop(item)
	return false
end

function IsItemPurchasedFromSideShop(item)
	return false
end

function GetUnitToUnitDistance(a, b)
	return (a:GetAbsOrigin() - b:GetAbsOrigin()):Length()
end

function GetUnitToLocationDistance( hUnit, pos )
	return (hUnit:GetAbsOrigin() - pos):Length()
end

function Max(a, b) 
	return math.max(a, b)
end

function Min(a, b)
	return math.min(a, b)
end

function GetExtrapolatedLocation(unit, time)
	if not unit:IsMoving() then
		return unit:GetAbsOrigin()
	end
	return unit:GetAbsOrigin() + unit:GetForwardVector() * unit:GetBaseMoveSpeed() * time
end

function GetTeamFilter(is_enemy)
	if is_enemy then
		return DOTA_UNIT_TARGET_TEAM_ENEMY
	else
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
end

function GetUnitTypeFilter(is_hero)
	if is_hero then
		return DOTA_UNIT_TARGET_HERO
	else
		return DOTA_UNIT_TARGET_CREEP
	end
end

function GetLaneTypeFilter(ignoreTowers)
	if ignoreTowers then
		return DOTA_UNIT_TARGET_CREEP 
	else
		return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING 
	end
end

function clampAmount(amount, min, max)
	if amount > max then
		return max
	elseif amount < min then
		return min
	else
		return amount
	end
end

--find unit closest to start and return amount as unit to end / start to end between [0,1]
function findAmountLinesClamped(team, teamFilter, lstart, lend, typeFilter, direction)
	local units = FindUnitsInLine(team, lstart, lend, nil, LANE_WIDTH, teamFilter, typeFilter, 0)
	local units_filtered = {}
	for i=1,#units do
		if units[i]:GetTeam() ~= DOTA_TEAM_NEUTRALS then
			table.insert(units_filtered, units[i])
		end
	end
	units = units_filtered
	if #units == 0 then return 0 end
	local amount = (units[1]:GetAbsOrigin()[direction] - lend[direction]) / (lstart[direction] - lend[direction])
	for i=2,#units do
		local currentAmount = (units[i]:GetAbsOrigin()[direction] - lend[direction]) / (lstart[direction] - lend[direction])
		if currentAmount > amount then
			amount = currentAmount
		end
	end
	return clampAmount(amount, 0, 1)
end

function GetAmountAlongLane(myTeam, lane, pos)
	local distance = 0
	local amount = 0
	if lane < 0 or lane > LANE_BOT then
		print("Warning GetAmountAlongLane with invalid lane")
	end
	if lane == LANE_TOP then
		local amountD = GetAmountDPos2Line(pos, LANE_TOP_LINES[1], LANE_TOP_LINES[2])
		local amountD2 = GetAmountDPos2Line(pos, LANE_TOP_LINES[2], LANE_TOP_LINES[3])
		if amountD.distance < amountD2.distance then
			distance = amountD.distance
			amount = amountD.amount * 0.5
		else 
			distance = amountD2.distance
			amount = 0.5 *(1 + amountD2.amount)
		end
	elseif lane == LANE_MID then
		local amountD = GetAmountDPos2Line(pos, LANE_MID_LINES[1], LANE_MID_LINES[2])
		distance = amountD.distance
		amount = amountD.amount
	else -- lane == LANE_BOT
		local amountD = GetAmountDPos2Line(pos, LANE_BOT_LINES[1], LANE_BOT_LINES[2])
		local amountD2 = GetAmountDPos2Line(pos, LANE_BOT_LINES[2], LANE_BOT_LINES[3])
		if amountD.distance < amountD2.distance then
			distance = amountD.distance
			amount = amountD.amount * 0.5
		else 
			distance = amountD2.distance
			amount = (amountD2.amount + 1) * 0.5
		end
	end
	if myTeam == DOTA_TEAM_BADGUYS then amount = 1 - amount end
	return { amount = amount, distance = distance }
end

function GetTreeLocation(tree)
	return tree:GetAbsOrigin()
end

function GetActualIncomingDamage(target, damage, damage_type)
	if damage_type == DAMAGE_TYPE_PHYSICAL then
		return damage / (1 + target:GetPhysicalArmorValue(false) * 0.06) 
	elseif damage_type == DAMAGE_TYPE_MAGICAL then
		return damage * (1 - target:Script_GetMagicalArmorValue(false, nil))
	end
	return damage
end

function GetCurrentMovementSpeed(unit)
	return unit:GetMoveSpeedModifier(unit:GetBaseMoveSpeed(), false)
end


function WasRecentlyDamagedByHero(unit, hero, time)
	if unit.damagedByHeroTime == nil then
		return false
	end
	return (GameRules:GetGameTime() - unit.damagedByHeroTime) < time and unit.damagedByHero == hero
end

function DistanceFromFountain(unit)
	local fountain_name
	if unit:GetTeam() == DOTA_TEAM_GOODGUYS then
		fountain_name = "ent_dota_fountain_good"
	else
		fountain_name = "ent_dota_fountain_bad"
	end
	return (Entities:FindByName(nil, fountain_name):GetAbsOrigin() - unit:GetAbsOrigin()):Length()
end

--==HERO ESTIMATES BEGIN==--

DEBUG_HERO_ESTIMATE = false
function GetStunDuration(unit, available)
	if not unit:IsRealHero() then return 0 end
	local ret = 0
	for i=1,DOTA_MAX_ABILITIES do
		local ability = unit:GetAbilityByIndex(i-1)
		if ability ~= nil then
			local power = HERO_ABILITY_POWER[ability:GetName()]
			if power ~= nil and ability:GetLevel() > 0 then
				local ability_availabe = ability:IsCooldownReady() and
					unit:GetMana() > ability:GetManaCost(ability:GetLevel() - 1)
				if ability_available or not available then	
					if power.stun then
						if power.stun == "AbilityDuration" then
							ret = ret + ability:GetDuration()
						else
							ret = ret + ability:GetSpecialValueFor(power.stun)
						end
					end
					if power.stunpl then
						ret = ret + power.stunpl[ability:GetLevel()]
					end
				end
			end
		end
	end
	if DEBUG_HERO_ESTIMATE then
		print("GetStunDuration " .. unit:GetName() .. " returns " .. ret)
		print(available)
	end
	return ret
end

function GetSlowDuration(unit, available)
	if not unit:IsRealHero() then return 0 end
	local ret = 0
	for i=1,DOTA_MAX_ABILITIES do
		local ability = unit:GetAbilityByIndex(i-1)
		if ability ~= nil then
			local power = HERO_ABILITY_POWER[ability:GetName()]
			if power ~= nil and ability:GetLevel() > 0 then
				local ability_availabe = ability:IsCooldownReady() and
					unit:GetMana() > ability:GetManaCost(ability:GetLevel() - 1)
				if ability_available or not available then	
					if power.slow then
						if power.slow == "AbilityDuration" then
							ret = ret + ability:GetDuration()
						else
							ret = ret + ability:GetSpecialValueFor(power.slow)
						end
					end
					if power.slowpl then
						ret = ret + power.slowpl[ability:GetLevel()]
					end
				end
			end
		end
	end
	if DEBUG_HERO_ESTIMATE then
		print("GetSlowDuration " .. unit:GetName() .. " returns " .. ret)
		print(available)
	end
	return ret
end

function HasSilence(unit, available)
	if not unit:IsRealHero() then return false end
	local ret = false
	for i=1,DOTA_MAX_ABILITIES do
		local ability = unit:GetAbilityByIndex(i-1)
		if ability ~= nil then
			local power = HERO_ABILITY_POWER[ability:GetName()]
			if power ~= nil and ability:GetLevel() > 0 then
				local ability_availabe = ability:IsCooldownReady() and
					unit:GetMana() > ability:GetManaCost(ability:GetLevel() - 1)
				if ability_available or not available then	
					if power.silence then
						ret = true
					end
				end
			end
		end
	end
	if DEBUG_HERO_ESTIMATE then
		print("HasSilence " .. unit:GetName())
		print(available)
		print(ret)
	end
	return ret
end

function GetEstimatedDamageToTarget(unit, available, target, duration, damage_type)
	local ret = 0
	if damage_type == DAMAGE_TYPE_PHYSICAL then
		local attack_damage = unit:GetAttackDamage()
		local attack_speed = unit:GetAttackSpeed(false)
		if unit:IsRealHero() then 
			for i=1,DOTA_MAX_ABILITIES do
				local ability = unit:GetAbilityByIndex(i-1)
				if ability ~= nil then
					local power = HERO_ABILITY_POWER[ability:GetName()]
					if power ~= nil and ability:GetLevel() > 0 then
						local ability_availabe = ability:IsCooldownReady() and
							unit:GetMana() > ability:GetManaCost(ability:GetLevel() - 1)
						if ability_available or not available then	
							if power.adpl then
								attack_damage = attack_damage + power.adpl[ability:GetLevel()]
							end
							if power.as then
								attack_speed = attack_speed + ability:GetSpecialValueFor(power.as)
							end
							if power.attack then
								attack_damage = attack_damage + power.attack[ability:GetLevel()]
							end
							if power.attackppl then
								attack_damage = attack_damage * (100 + power.attackppl[ability:GetLevel()]) / 100
							end
						end
					end
				end
			end
		end
		ret = attack_damage / (1 + target:GetPhysicalArmorValue(false) * 0.06) * duration / attack_speed
	elseif damage_type == DAMAGE_TYPE_MAGICAL then
		if not unit:IsRealHero() then return 0 end
		for i=1,DOTA_MAX_ABILITIES do
			local ability = unit:GetAbilityByIndex(i-1)
			if ability ~= nil then
				local power = HERO_ABILITY_POWER[ability:GetName()]
				if power ~= nil and ability:GetLevel() > 0 then
					local ability_availabe = ability:IsCooldownReady() and
						unit:GetMana() > ability:GetManaCost(ability:GetLevel() - 1)
					if ability_available or not available then	
						if power.mdamage then
							if power.mdamage == "AbilityDamage" then
								ret = ret + ability:GetAbilityDamage()
							else
								ret = ret + ability:GetSpecialValueFor(power.mdamage)
							end
						end
						if power.mdamagepl then
							ret = ret + power.mdamagepl[ability:GetLevel()]
						end
						local ability_duration = duration
						if power.duration then
							ability_duration = Min(ability_duration, ability:GetSpecialValueFor(power.duration))
						end
						if power.mdps then
							if power.mdps == "AbilityDamage" then
								ret = ret + ability:GetAbilityDamage() * ability_duration
							else
								ret = ret + ability:GetSpecialValueFor(power.mdps) * ability_duration
							end
						end
						if power.mdpspl then
							ret = ret + power.mdpspl[ability:GetLevel()] * ability_duration
						end
					end
				end
			end
		end
		ret = ret * (1 - target:Script_GetMagicalArmorValue(false, nil))
	elseif damage_type == DAMAGE_TYPE_PURE then
		if not unit:IsRealHero() then return 0 end
		for i=1,DOTA_MAX_ABILITIES do
			local ability = unit:GetAbilityByIndex(i-1)
			if ability ~= nil then
				local power = HERO_ABILITY_POWER[ability:GetName()]
				if power ~= nil and ability:GetLevel() > 0 then
					local ability_availabe = ability:IsCooldownReady() and
						unit:GetMana() > ability:GetManaCost(ability:GetLevel() - 1)
					if ability_available or not available then	
						if power.pdamagepl then
							ret = ret + power.pdamagepl[ability:GetLevel()]
						end
					end
				end
			end
		end
	elseif damage_type == DAMAGE_TYPE_ALL then
		ret = ret + GetEstimatedDamageToTarget(unit, available, target, duration, DAMAGE_TYPE_PHYSICAL)
		ret = ret + GetEstimatedDamageToTarget(unit, available, target, duration, DAMAGE_TYPE_MAGICAL)
		ret = ret + GetEstimatedDamageToTarget(unit, available, target, duration, DAMAGE_TYPE_PURE)
	end
	if DEBUG_HERO_ESTIMATE then
		print("GetEstimatedDamageToTarget " .. unit:GetName() .. " " .. target:GetName() .. " " .. duration .. " " .. damage_type .. " : " .. ret)
		print(available)
	end
	return ret
end

function GetOffensivePower(unit)
	return GetRawOffensivePower(unit)
end

function GetRawOffensivePower(unit)
	local duration = 5
	if GetStunDuration(unit, true) > 0 then
		duration = 10
	elseif GetSlowDuration(unit, true) > 0 then
		duration = 7.5
	end
	target_team = DOTA_TEAM_GOODGUYS
	if unit:GetTeam() == DOTA_TEAM_GOODGUYS then
		target_team = DOTA_TEAM_BADGUYS
	end
	local player_count = PlayerResource:GetPlayerCountForTeam(target_team)
	local damage = 0
	for i=1,player_count do
		local player_hero = PlayerResource:GetPlayer(PlayerResource:GetNthPlayerIDOnTeam(target_team, i)):GetAssignedHero()
		damage = damage + GetEstimatedDamageToTarget(unit, true, player_hero, duration, DAMAGE_TYPE_ALL)
	end
	if player_count > 0 then
		damage = damage / player_count
	end

	if DEBUG_HERO_ESTIMATE then
		print("GetRawOffensivePower " .. unit:GetName() .. " ret " .. damage)
	end
	return damage 
end

--==HERO ESTIMATES END==--


function GetNearbyHeroes(target, range, is_enemy, mode)
	local target_team
	if is_enemy then
		target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	else
		target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
	return FindUnitsInRadius(target:GetTeam(),
		target:GetAbsOrigin(),
		nil, 
		range, 
		target_team,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_CLOSEST,
		false)
end

function GetNearbyCreeps(bot, range, is_enemy)
	local target_team
	if is_enemy then
		target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	else
		target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
	return FindUnitsInRadius(bot:GetTeam(),
		bot:GetAbsOrigin(),
		nil, 
		range, 
		target_team,
		DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_CLOSEST,
		false)
end

function GetNearbyNonIllusionHeroes(bot, range, isEnemy)
	local team_filter = DOTA_UNIT_TARGET_TEAM_FRIENDLY 
	if isEnemy then
		team_filter = DOTA_UNIT_TARGET_TEAM_ENEMY
	end
	return FindUnitsInRadius(
		bot:GetTeam(),
		bot:GetAbsOrigin(), nil,
		range,
		team_filter,
		DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
end

function WasRecentlyDamagedByAnyHero(unit, time)
	if unit.damagedByHeroTime == nil then
		return false
	end
	return (GameRules:GetGameTime() - unit.damagedByHeroTime) < time
end

function WasRecentlyDamagedByTower(unit, time)
	if unit.damagedByTowerTime == nil then
		return false
	end
	return (GameRules:GetGameTime() - unit.damagedByTowerTime) < time
end

function GetWeakestUnit(EnermyUnits)
	if EnermyUnits == nil or #EnermyUnits == 0 then
		return nil, 10000;
	end

	local WeakestUnit = nil;
	local LowestHealth = 10000;
	for i=1,#EnermyUnits do
		local unit = EnermyUnits[i]
		if unit ~= nil and unit:IsAlive()
		then
			if unit:GetHealth() < LowestHealth
			then
				LowestHealth = unit:GetHealth();
				WeakestUnit = unit;
			end
		end
	end

	return WeakestUnit, LowestHealth
end

function IsSeverelyDisabled(npc)
    return npc:IsStunned() or 
		   npc:IsHexed() or 
		   npc:IsRooted() or 
		   npc:IsFeared() or 
           npc:HasModifier("modifier_bane_nightmare") or 
		   npc:HasModifier("modifier_legion_commander_duel_datadriven") or
           npc:HasModifier("modifier_axe_berserkers_call") or 
		   npc:HasModifier("modifier_shadow_demon_purge_slow") or
           npc:HasModifier("modifier_doom_datadriven")
end

function GetMovementSpeedPercent(npc)
    return npc:GetMoveSpeedModifier(npc:GetBaseMoveSpeed(), false) / npc:GetBaseMoveSpeed()
end

function IsSeverelyDisabledOrSlowed(npc)
	return IsSeverelyDisabled(npc) or GetMovementSpeedPercent(npc) < 0.35
end

function IsAttackingEnemies(bot)
	local mode = bot:GetActiveMode()
    return mode == BOT_MODE_ATTACK or mode ==  BOT_MODE_DEFEND_ALLY or mode == BOT_MODE_ROAM
end

function enemyDisabled(npcEnemy)
	if npcEnemy:IsRooted() or npcEnemy:IsStunned() or npcEnemy:IsHexed() then
		return true;
	end
	return false;
end

function NormalCanCastFunction(target)
	if target:IsInvulnerable() then
		return false
	end
	if target:HasModifier("modifier_slark_shadow_dance") then
		return false
	end
	if target:IsMagicImmune() then
		return false
	end
	return true
end

function PhysicalCanCastFunction(target)
	if target:IsAttackImmune() then return false end
	if target:IsInvulnerable() then return false end
	if target:HasModifier("modifier_slark_shadow_dance") then
		return false
	end
	return true
end

function CanBeEngaged(npc)
	if npc:IsOwnedByAnyPlayer() then
		return true
	end
	if npc.GetActiveMode ~= nil and npc:GetActiveMode() ~= "retreat" then
		return true
	end
	return false
end

function GetComboMana(AbilitiesReal)
	local tempComboMana = 0
	for i, ability in pairs(AbilitiesReal) do
		if ability and ability:GetLevel() >= 1 and not ability:IsPassive() and not ability:IsHidden() then
			if ability:GetAbilityType() ~= ABILITY_TYPE_ULTIMATE or ability:GetCooldownTimeRemaining() <= 30 then
				tempComboMana = tempComboMana + ability:GetManaCost(-1)
			end
		end
	end
	return math.max(tempComboMana, 300)
end
