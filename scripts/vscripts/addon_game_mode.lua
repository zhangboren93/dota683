-- Generated from template

require("creepspawn")
require("hero_innate_abilities")
require("kill_bonus")
require("heroes.hero_creep_aggro")
require("building_bounty")
require("root_modifiers")
require("hero_types")
require("ladder_game_mode")

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

playerRepicked = {}
randomBonusGranted = {}
radiant_primary_courier = nil
dire_primary_courier = nil


function Precache( context )
	--[[
		Precache things we know we'll use.	Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheResource( "particle", "particles/items_fx/immunity_sphere.vpcf", context )
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
	LinkLuaModifier( "item_pct_mana_regen_modifier_lua",	"items/item_pct_mana_regen.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_equipped_bonus_modifier",		"items/item_equip_bonus.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_tpscroll_clear_tree_modifier",	"items/item_tpscroll_clear_trees.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_blade_mail_new_active",	"items/item_blade_mail_active.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier( "item_bfury_cleave_lua",               "items/item_bfury.lua", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier( "modifier_tower_bonus_cancel_lua", "modifiers/tower_bonus_cancel.lua", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier( "modifier_attribute_regen_adjust", "modifiers/attribute_regen.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_troll_warlord_bash", "modifiers/troll_bash.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_safe_lane_move_speed_bonus", "modifiers/creep.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_cancels_item_on_hit", "modifiers/item_cancel_on_hit.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_ai", "creepai.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_health_bonus", "modifiers/creep_health.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_pudge_flesh_magic_resist",		"modifiers/pudge_flesh_magic_resist.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_riki_invis_health_regen",		"modifiers/riki_invis_health_regen.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_enchantress_aghs_attack_range",	"modifiers/enchantress_aghs_attack_range.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_bounty_hunter_track_effect_lua",	"modifiers/bounty_hunter_track_effect.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_doom_scorched_earth_regen",		"modifiers/doom_scorched_earth_regen.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_sandstorm_channel_end",			"modifiers/sandstorm_channel_end.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_drop_backpack_items",			"modifiers/drop_backpack_items.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_familiar_attack_damage_lua",		"modifiers/familiar_attack_bonus.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_kill_tree_on_death", 			"modifiers/kill_tree_on_death.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_no_creep_aggro_on_cast_orb_lua", "modifiers/no_creep_aggro_on_cast_orb.lua", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier( "modifier_bot_item_purchase",				"bots2/modifier_bot_item_purchase.lua", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier( "modifier_tidebringer_cleave",				"heroes/hero_kunkka/tidebringer_cleave.lua", LUA_MODIFIER_MOTION_NONE)
	-- shared between sven and tiny aghs
	LinkLuaModifier( "modifier_sven_great_cleave_radius", 		"heroes/hero_sven/great_cleave_radius.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_magnataur_empower_cleave_lua",	"heroes/hero_magnataur/empower_cleave.lua", LUA_MODIFIER_MOTION_NONE)
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	
	GameRules:SetStartingGold(625)
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP, 19)
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR, 0.17)
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA, 13)
	
	GameRules:GetGameModeEntity():SetCustomBackpackSwapCooldown(0)
	--GameRules:GetGameModeEntity():SetCustomBackpackCooldownPercent(1)
	GameRules:GetGameModeEntity():SetCustomBuybackCooldownEnabled(true)
	GameRules:GetGameModeEntity():SetCustomBuybackCostEnabled(true)
	GameRules:GetGameModeEntity():SetCustomGlyphCooldown(10000)
	GameRules:GetGameModeEntity():SetCustomScanCooldown(10000)
	GameRules:GetGameModeEntity():SetInnateMeleeDamageBlockAmount(0)
	GameRules:GetGameModeEntity():SetInnateMeleeDamageBlockPercent(0)
	GameRules:GetGameModeEntity():SetInnateMeleeDamageBlockPerLevelAmount(0)
	GameRules:GetGameModeEntity():SetRandomHeroBonusItemGrantDisabled(true)
	GameRules:GetGameModeEntity():SetGiveFreeTPOnDeath(false)
	GameRules:GetGameModeEntity():SetAllowNeutralItemDrops(false)
	GameRules:GetGameModeEntity():SetNeutralStashEnabled(false)
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(25)
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel({
		0,
		200,
		500,
		900,
		1400,
		2000,
		2600,
		3200,
		4400,
		5400,
		6000,
		8200,
		9000,
		10400,
		11900,
		13500,
		15200,
		17000,
		18900,
		20900,
		23000,
		25200,
		27500,
		29900,
		32400,
	})
	GameRules:GetGameModeEntity():SetFreeCourierModeEnabled(false)
	GameRules:GetGameModeEntity():SetUseDefaultDOTARuneSpawnLogic(false)
	GameRules:GetGameModeEntity():SetBountyRuneSpawnInterval(10000)
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled(false)
	GameRules:GetGameModeEntity():SetDaynightCycleAdvanceRate(1.25)
	GameRules:GetGameModeEntity():SetTPScrollSlotItemOverride("item_dummy_tpblock_datadriven")
	GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled(true)
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
	GameRules:SetGoldPerTick(0)
	GameRules:SetGoldTickTime(1000)
	GameRules:SetTreeRegrowTime(300)
	if GetMapName() == "dota" then
		GameRules:SetCreepSpawningEnabled(false)
	end

	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(CAddonTemplateGameMode, "OrderFilter"), self)

	-- rune 2 bounty at time 0 and 1 bounty & other per spawn afterwards
	self.runeSpawnedAtTime = {}
	GameRules:GetGameModeEntity():SetRuneSpawnFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "RuneSpawnFilter"), self)
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "BountyRunePickupFilter"), self)
	GameRules:GetGameModeEntity():SetModifyGoldFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "ModifyGoldFilter"), self)
	GameRules:GetGameModeEntity():SetModifyExperienceFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "ModifyExperienceFilter"), self)
	GameRules:GetGameModeEntity():SetHealingFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "HealingFilter"), self)
	GameRules:GetGameModeEntity():SetModifierGainedFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "ModifierGainedFilter"), self)
	GameRules:GetGameModeEntity():SetDamageFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "DamageFilter"), self)
	GameRules:GetGameModeEntity():SetAbilityTuningValueFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "AbilityTuningValueFilter"), self)

	ListenToGameEvent('npc_spawned', function(event)
		HandleNpcSpawned(self, event.entindex, event.is_respawn)
	end, nil)
	ListenToGameEvent('entity_killed', function(event)
		HandleEntityKilled(self, event.entindex_killed, event.entindex_attacker, event.entindex_inflictor)
	end, nil)
	ListenToGameEvent('dota_rune_activated_server', function(event)
		HandleRuneActivated(event.PlayerID, event.rune)
	end, nil)
	ListenToGameEvent('player_chat', function(event)
		HandlePlayerChat(self, event.teamonly, event.text, event.playerid)
	end, nil)
	ListenToGameEvent('entity_hurt', function(event)
		HandleEntityHurt(event.entindex_killed, event.entindex_attacker, event.damage)
	end, nil)
	ListenToGameEvent("dota_hero_swap", function(event)
		print("dota_hero_swap")
	end, nil)
	ListenToGameEvent("dota_buyback", function(event)
		HandleBuyback(event.entindex, event.player_id)
	end, nil)

	CustomGameEventManager:RegisterListener("ladder_hero_banned", CAddonTemplateGameMode.handleLadderHeroBanned)
	CustomGameEventManager:RegisterListener("captain_client_pick", CAddonTemplateGameMode.handleCaptainClientPick)
	CustomGameEventManager:RegisterListener("hero_bar_ping_miss", CAddonTemplateGameMode.handleHeroBarPingMiss)

	if GetMapName() == "dota" then
		local neutralSpawners = Entities:FindAllByClassname("npc_dota_neutral_spawner")
		local direMediumCamp = nil
		local direSmallCamp = nil
		local radiantMediumCamp = nil
		local radiantSmallCamp = nil
		for i=1,#neutralSpawners do
			local pos = neutralSpawners[i]:GetAbsOrigin()
			if pos[1] == -288 and pos[2] == 3616 then
				print("find dire small camp")
				direSmallCamp = neutralSpawners[i]
			elseif pos[1] == -3104 and pos[2] == 4448 then
				print("find dire medium camp")
				direMediumCamp = neutralSpawners[i]
			elseif math.floor(pos[1]) == 3016 and math.floor(pos[2]) == -4513 then
				print("find radiant medium camp")
				radiantMediumCamp = neutralSpawners[i]
			elseif pos[1] == -384 and pos[2] == -3136 then
				print("find radiant small camp")
				radiantSmallCamp = neutralSpawners[i]
			end
		end
		swapLocation(direMediumCamp, direSmallCamp)
		swapLocation(radiantMediumCamp, radiantSmallCamp)

		local neutraltriggers = Entities:FindAllByClassname("trigger_multiple")
		local direTrigger1 = Entities:FindByName(nil, "neutralcamp_evil_4")
		local direTrigger2 = Entities:FindByName(nil, "neutralcamp_evil_2")
		swapLocation(direTrigger1, direTrigger2)
		local radiantTrigger1 = Entities:FindByName(nil, "neutralcamp_good_1")
		local radiantTrigger2 = Entities:FindByName(nil, "neutralcamp_good_4")
		swapLocation(radiantTrigger1, radiantTrigger2)
	end
	if GetMapName() == "dota_low_poly" then
		local neutralSpawners = Entities:FindAllByClassname("npc_dota_neutral_spawner")
		for i=1,#neutralSpawners do
			local pos = neutralSpawners[i]:GetAbsOrigin()
			print(pos)
			if (pos[1] > -3723 and pos[1] < -3722) 
				or (pos[1] > -4967 and pos[1] < -4966) 
				or (pos[1] > 4451 and pos[1] < 4453) 
				or (pos[1] > -248 and pos[1] < -246) 
				or (pos[1] > -133 and pos[1] < -132) 
				or (pos[1] > 2548 and pos[1] < 2549) then
				print("destroy npc_dota_neutral_spawner")
				neutralSpawners[i]:Destroy()
			elseif (pos[1] > -2545 and pos[1] < -2543) then
				neutralSpawners[i]:SetAbsOrigin(Vector(-3037, -253, pos[3]))
			elseif (pos[1] > 4195 and pos[1] < 4196) then
				neutralSpawners[i]:SetAbsOrigin(Vector(3869, -511, pos[3]))
			elseif (pos[1] > -2465 and pos[1] < -2463) then
				neutralSpawners[i]:SetAbsOrigin(Vector(-2871, 4540, pos[3]))
			end
		end
		local bountyRuneSpawners = Entities:FindAllByClassname("dota_item_rune_spawner_bounty")
		print(#bountyRuneSpawners)
		for i=1,#bountyRuneSpawners do
			bountyRuneSpawners[i]:Destroy()
		end
		local healers = Entities:FindAllByClassname("npc_dota_healer")
		print(#healers)
		for i=1,#healers do
			healers[i]:Destroy()
		end
	end
end

function HandlePlayerChat(self, teamonly, text, playerid)
	if teamonly == 0 and GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		if text == '-rd' then
			self.rdEnabled = true
			GameRules:SendCustomMessage("RD模式开启", -1, -1)
		elseif text == '-ap' then
			self.rdEnabled = false
			self.botEnabled = false
			GameRules:SendCustomMessage("AP模式开启", -1, -1)
		elseif text == '-vsbot' then
			self.botEnabled = true
			GameRules:SendCustomMessage("Bot模式开启", -1, -1)
		elseif text == '-sp' then
			GameRules:SetSameHeroSelectionEnabled(true)
			GameRules:SendCustomMessage("开启相同英雄选择", -1, -1)
		elseif text == '-ld' then
			GameRules:SetHeroSelectionTime(80)
			GameRules:SetSameHeroSelectionEnabled(false)
			self.game_mode = "LD"
			GameRules:SendCustomMessage("开启天梯模式", -1, -1)
		elseif text == '-cm' then
			GameRules:SetHeroSelectionTime(40 * 10 + 110 * 2 + 60)
			GameRules:SetSameHeroSelectionEnabled(false)
			self.rdEnabled = false
			self.botEnabled = false
			self.game_mode = "CM"
			GameRules:SendCustomMessage("开启队长模式", -1, -1)
		end
	end
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION or GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		if not self.rdEnabled and not self.game_mode ~= "CM" and text == '-repick' then
			if PlayerResource:GetSelectedHeroName(playerid) == "" or playerRepicked[playerid] then
				GameRules:SendCustomMessage("无法重新选择英雄", -1, -1)
				return
			end
			if PlayerResource:GetGold(playerid) < 100 then
				GameRules:SendCustomMessage("金钱小于250时无法重新选择英雄")
				return
			end
			local player = PlayerResource:GetPlayer(playerid)
			player:SetSelectedHero("")
			PlayerResource:ModifyGold(playerid, -100, false, DOTA_ModifyGold_SelectionPenalty)
			if PlayerResource:HasRandomed(playerid) then
				PlayerResource:ModifyGold(playerid, -250, false, DOTA_ModifyGold_SelectionPenalty)
			end
			playerRepicked[playerid] = true
		end
	end
	if self.botEnabled then
		if text == "-gold" then
			PlayerResource:ModifyGold(playerid, 10000, true, DOTA_ModifyGold_HeroKill)
		elseif text == '-lvlup' then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			for i=1,24 do
				hero:HeroLevelUp(false)
			end
		end
	end
	--if text == "-test" then
	--	print(GetSystemTime())
	--	print(GetSystemTimeMS())
	--	print(GetSystemDate())
	--	print(Plat_FloatTime())
	--	print(Time())
	--end
	--if text == "-win" then
	--	GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	--end
end

function swapLocation(e1, e2)
	local tmpLoc = e1:GetAbsOrigin()
	e1:SetAbsOrigin(e2:GetAbsOrigin())
	e2:SetAbsOrigin(tmpLoc)
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION and IsServer() then
		if self.hero_selection_state == nil then
			self.hero_selection_state = "INI"
		end
		if self.hero_selection_state == "INI" then
			if self.rdEnabled then
				local heroes = all_heroes
				for i=1,#heroes do
					if RandomInt(1, 111) > 30 then
						GameRules:AddHeroToBlacklist(heroes[i])
					end
				end
				self.hero_selection_state = "PIC"
			end
			if self.game_mode == "LD" then
			-- add all heroes to ban list
				for i=1,#all_heroes do
					GameRules:AddHeroToBlacklist(all_heroes[i])
				end
				pickLadderHeroes(self)
				self.hero_selection_state = "BAN"
			elseif self.game_mode == "CM" then
				for i=1,#all_heroes do
					GameRules:AddHeroToBlacklist(all_heroes[i])
				end
				self.hero_selection_state = "CD_RAD_BAN_1"
 	   			CustomGameEventManager:Send_ServerToAllClients("captain_draft_start", {})
			else
				CustomGameEventManager:Send_ServerToAllClients("ladder_pick_start", {})
			end
		end
		if self.hero_selection_state == "BAN" and GameRules:GetDOTATime(true, true) > -60 then
			print("Ban time over")
			for i,v in pairs(ladder_heroes_2_ban) do
				if v < 2 then
					print("Adding hero to whitelist " .. i)
					GameRules:RemoveHeroFromBlacklist(i)
				end
			end
			CustomGameEventManager:Send_ServerToAllClients("ladder_pick_start", {})
			self.hero_selection_state = "PIC"
		end
		if self.hero_selection_state == "CD_RAD_BAN_1" then
			if captain_pick_phase == 0
				or captain_pick_phase == 2
				or captain_pick_phase == 4
				or captain_pick_phase == 6
				or captain_pick_phase == 8
				or captain_pick_phase == 10
				or captain_pick_phase == 12
				or captain_pick_phase == 14
				or captain_pick_phase == 17
				or captain_pick_phase == 18
			then
				if captain_normal_time >= 2 then
					captain_normal_time = captain_normal_time - 2
				elseif captain_radiant_extra_time >= 2 then
					captain_radiant_extra_time = captain_radiant_extra_time - 2
				else
					captain_normal_time = 0
					captain_radiant_extra_time = 0
				end
				CustomGameEventManager:Send_ServerToAllClients("captain_pick_timer", 
					{nt = captain_normal_time, et = captain_radiant_extra_time });
			else
				if captain_normal_time >= 2 then
					captain_normal_time = captain_normal_time - 2
				elseif captain_dire_extra_time >= 2 then
					captain_dire_extra_time = captain_dire_extra_time - 2
				else
					captain_normal_time = 0
					captain_dire_extra_time = 0
				end
				CustomGameEventManager:Send_ServerToAllClients("captain_pick_timer", 
					{nt = captain_normal_time, et = captain_dire_extra_time });
			end
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME and self.botEnabled and self.botInitialized == nil then
		print("Init bot")
		local botHeroPool = {
			"npc_dota_hero_axe",
			--"npc_dota_hero_ogre_magi",
			"npc_dota_hero_luna",
			"npc_dota_hero_skywrath_mage",
			"npc_dota_hero_lina",

			"npc_dota_hero_bristleback",
			"npc_dota_hero_witch_doctor",
			--"npc_dota_hero_venomancer",
			"npc_dota_hero_zuus",
			"npc_dota_hero_skeleton_king",

			"npc_dota_hero_lion",
			--"npc_dota_hero_abaddon",
			"npc_dota_hero_vengefulspirit",
			"npc_dota_hero_sniper",
			"npc_dota_hero_phantom_assassin",
		}
		Tutorial:StartTutorialMode()	
		GameRules:SetSameHeroSelectionEnabled(true)
		-- pick 5 random hero to play
		local lanes = {"bot", "bot", "mid", "top", "top"}
		for i=1,5 do
			local heroNumber = RandomInt(1, #botHeroPool)	
			Tutorial:AddBot(botHeroPool[heroNumber], lanes[i], "unfair", false)
			table.remove(botHeroPool, heroNumber)
		end
		GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
		GameRules:SetCreepSpawningEnabled(true)
		self.botInitialized = true
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		local time = GameRules:GetDOTATime(true, true) 
		if time > -2 then
			randomUnpickedPlayers()
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		local roshan = Entities:FindAllByClassname("npc_dota_roshan")
		if #roshan > 0 then
			roshan[1]:ForceKill(false)
			self.nextRoshanTime = -1
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		local time = GameRules:GetDOTATime(false, false) 
		if time >= 30 and self.hasSpawnNeutralsAt30s == nil then
			print("Spawn neutral creep at 30s")
			local spawners = Entities:FindAllByClassname("npc_dota_neutral_spawner")
			for i,v in pairs(spawners) do
				v:CreatePendingUnits()
				v:CreatePendingUnits()
				v:CreatePendingUnits()
				v:CreatePendingUnits()
				v:CreatePendingUnits()
				v:SpawnNextBatch(false)
			end
			self.hasSpawnNeutralsAt30s = true
		end

		if not self.botEnabled and GetMapName() == "dota" and time > 0 and (math.floor(time) % 30) < 3 and (self.creepSpawnTime == nil or (time - self.creepSpawnTime) > 10) then
			spawnCreepsLua()
			self.creepSpawnTime = time
		end
		if time >= 0 and (self.timeofdayset == nil) then
			GameRules:SetTimeOfDay(0.25)
			self.timeofdayset = true
		end

		-- give each player passive gold
		if time > 0 and IsServer() then
			local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
			for i=1,n do
				local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
				PlayerResource:ModifyGold(playerid, 3, true, DOTA_ModifyGold_GameTick)
			end
			local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
			for i=1,n do
				local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
				PlayerResource:ModifyGold(playerid, 3, true, DOTA_ModifyGold_GameTick)
			end
		end

		if self.nextRoshanTime ~= nil and time > self.nextRoshanTime then
			print("Spawn next rosh")
			local roshan = CreateUnitByName("npc_dota_roshan_datadriven", Vector(4320, -1824, 160), true, nil, nil, DOTA_TEAM_NEUTRALS)
			self.nextRoshanTime = nil
		end

		-- send glyph cooldown time to clients
		--print("send glyph cooldown time to clients")
		CustomGameEventManager:Send_ServerToTeam(DOTA_TEAM_GOODGUYS, "team_glyph_cooldown_tick", {
			cd = math.floor(Entities:FindByName(nil, "ent_dota_fountain_good"):FindAbilityByName("glyph_datadriven"):GetCooldownTimeRemaining()) })
		CustomGameEventManager:Send_ServerToTeam(DOTA_TEAM_BADGUYS, "team_glyph_cooldown_tick", {
			cd = math.floor(Entities:FindByName(nil, "ent_dota_fountain_bad"):FindAbilityByName("glyph_datadriven"):GetCooldownTimeRemaining()) })

	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end

	if (GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME or GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION) and not self.rdEnabled and self.game_mode ~= 'LD' and self.game_mode ~= 'CM' then
		local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
		for i=1,n do
			local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
			if PlayerResource:HasRandomed(playerid) and not randomBonusGranted[playerid] and not playerRepicked[playerid] then
				PlayerResource:ModifyGold(playerid, 250, false, DOTA_ModifyGold_Unspecified)
				randomBonusGranted[playerid] = true
			end
		end
		local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
		for i=1,n do
			local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
			if PlayerResource:HasRandomed(playerid) and not randomBonusGranted[playerid] and not playerRepicked[playerid] then
				PlayerResource:ModifyGold(playerid, 250, false, DOTA_ModifyGold_Unspecified)
				randomBonusGranted[playerid] = true
			end
		end
	end
	return 2
end

function hasRoomForItem(courier)
	for i=DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
		if courier:GetItemInSlot(i) == nil then
			return true
		end
	end
	return false
end

-- Add the order filter to your game mode entity
function CAddonTemplateGameMode:OrderFilter(event)
	--print("OrderFilter " .. event.order_type .. " " .. event.issuer_player_id_const)
	--DeepPrintTable(event)
	if event.order_type == DOTA_UNIT_ORDER_GLYPH then
		local player = PlayerResource:GetPlayer(event.issuer_player_id_const)
		local team = player:GetTeam()
		local fountain = nil
		if team == DOTA_TEAM_GOODGUYS then
			fountain = Entities:FindByName(nil, "ent_dota_fountain_good")
		else
			fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
		end--
		local glyph = fountain:FindAbilityByName("glyph_datadriven")
		glyph:CastAbility()
		return false
	end
	if event.order_type == DOTA_UNIT_ORDER_RADAR then
		return false
	end
	if event.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
		local target = EntIndexToHScript(event.entindex_target)
		if target:GetClassname() == "dota_item_drop" then
			return true
		end
		for i,v in pairs(event.units) do
			local unit = EntIndexToHScript(v)
			local ability = unit:FindAbilityByName("hero_creep_aggro_datadriven")
			if ability ~= nil then
				if target:IsHero() and target:GetTeam() ~= unit:GetTeam() and ability ~= nil and ability:IsCooldownReady() then
					aggroCreeps(unit, ability)
				elseif target:GetTeam() == unit:GetTeam() then
					ability:ApplyDataDrivenModifier(unit, unit, "modifier_creep_aggro_move_datadriven", {})
				end
			end
		end
	end
	if event.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION 
		or event.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET 
		or event.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE 
		or event.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
		for i,v in pairs(event.units) do
			local unit = EntIndexToHScript(v)
			if unit:HasModifier("modifier_item_travel_boots_caster_effect") then
				print("Moving when teleporting")
				return false
			end
		end
	elseif event.order_type == DOTA_UNIT_ORDER_CAST_POSITION 
		or event.order_type == DOTA_UNIT_ORDER_CAST_TARGET
		or event.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
		local ability = EntIndexToHScript(event.entindex_ability)
		if type(ability:GetBehavior()) ~= "userdata" and bit.band(ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL) == 0 then
			for i,v in pairs(event.units) do
				local unit = EntIndexToHScript(v)
				if unit:HasModifier("modifier_item_travel_boots_caster_effect") then
					return false
				end
			end
		end
		if ability:GetName() == "doom_bringer_doom" then
			local target = EntIndexToHScript(event.entindex_target)
			if target:IsRealHero() and target:GetName() == "npc_dota_hero_doom_bringer" then
				GameRules:SendCustomMessage("末日无法大自己", -1, -1)
				return false
			end
		elseif ability:GetName() == "morphling_replicate_datadriven" then
			local target = EntIndexToHScript(event.entindex_target)
			if target:IsRealHero() and target:GetName() == "npc_dota_hero_morphling" then
				GameRules:SendCustomMessage("水人无法大自己", -1, -1)
				return false
			end
		elseif ability:GetName() == "courier_transfer_items" then
			print("courier_transfer_items " .. event.issuer_player_id_const)
			local courier = EntIndexToHScript(event.units['0'])
			print(courier:GetName())
			if courier:IsInRangeOfShop(DOTA_SHOP_HOME, true) then
				local player_hero = PlayerResource:GetPlayer(event.issuer_player_id_const):GetAssignedHero()
				for i=DOTA_STASH_SLOT_1,DOTA_STASH_SLOT_6 do
					local stash_item = player_hero:GetItemInSlot(i)
					if stash_item ~= nil and hasRoomForItem(courier) then
						courier:AddItem(player_hero:TakeItem(stash_item))
					end
				end
			end
		elseif ability:GetName() == "kunkka_ghostship" then
			-- Always land ghost ship at 1000 range
			local player_hero = PlayerResource:GetPlayer(event.issuer_player_id_const):GetAssignedHero()
			local target_position = Vector(event.position_x, event.position_y, event.position_z)
			local hero_position = player_hero:GetAbsOrigin()
			local new_target_position = hero_position + (target_position - hero_position):Normalized() * 1000
			event.position_x = new_target_position.x
			event.position_y = new_target_position.y
			return true
		end
	end
	if event.order_type == DOTA_UNIT_ORDER_DROP_ITEM 
		or event.order_type == DOTA_UNIT_ORDER_GIVE_ITEM then
		local item = EntIndexToHScript(event.entindex_ability)
		if item:GetName() == "item_dummy_backpackblock_datadriven" then
			return false
		end
	end
	return true
end

function CAddonTemplateGameMode:RuneSpawnFilter(event)
	local time = GameRules:GetDOTATime(false, false) 
	if time < 10 then
		event.rune_type = DOTA_RUNE_BOUNTY 
	else
		local nthRuneSpawned = math.floor((time + 10) / 60)
		local recentRuneSpawn = self.runeSpawnedAtTime[nthRuneSpawned]
		local runeTypes = {DOTA_RUNE_DOUBLEDAMAGE, DOTA_RUNE_HASTE, DOTA_RUNE_ILLUSION, DOTA_RUNE_INVISIBILITY, DOTA_RUNE_REGENERATION}
		if recentRuneSpawn == nil then
			if RandomInt(0, 1) == 0 then
				event.rune_type = DOTA_RUNE_BOUNTY
			else
				event.rune_type = runeTypes[RandomInt(1, #runeTypes)]
			end
			self.runeSpawnedAtTime[nthRuneSpawned] = event.rune_type
		else
			if recentRuneSpawn ~= DOTA_RUNE_BOUNTY then
				event.rune_type = DOTA_RUNE_BOUNTY
			else
				event.rune_type = runeTypes[RandomInt(1, #runeTypes)]
			end
		end
	end
	return true
end

function CAddonTemplateGameMode:BountyRunePickupFilter(event)
	event.xp_bounty = 0
	event.gold_bounty = 0
	return true
end

function HandleNpcSpawned(self, entityIndex, is_respawn)
	local entity = EntIndexToHScript(entityIndex)
	--print(entity:GetName())
	--print(entity:GetModelName())
	--print(entity:GetClassname())
	if entity:IsRealHero() and is_respawn == 0 then
		-- modifiers
		entity:AddNewModifier(entity, nil, "modifier_tower_bonus_cancel_lua", {})
		entity:AddNewModifier(entity, nil, "modifier_attribute_regen_adjust" , {})
		entity:AddNewModifier(entity, nil, "modifier_cancels_item_on_hit" , {})
		entity:AddNewModifier(entity, nil, "item_tpscroll_clear_tree_modifier", {})
		entity:AddNewModifier(entity, nil, "modifier_no_creep_aggro_on_cast_orb_lua", {})
		if self.botEnabled and entity:GetTeam() == DOTA_TEAM_BADGUYS then
			entity:AddNewModifier(entity, nil, "modifier_bot_item_purchase", {})
		else
			entity:AddNewModifier(entity, nil, "modifier_drop_backpack_items", {})
		end

		-- thinkers
		entity:SetThink(function()
			entity:RemoveItem(entity:FindItemInInventory("item_tpscroll"))
		end, "remove tpscroll", 0.5)

		entity:SetThink(function()
			if entity:HasModifier("modifier_bounty_hunter_track") then
				local units = FindUnitsInRadius(
					entity:GetTeam(), 
					entity:GetAbsOrigin(), nil, 
					900, 
					DOTA_UNIT_TARGET_TEAM_ENEMY, 
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					0, 
					FIND_ANY_ORDER, 
					false)
				for i=1,#units do
					units[i]:AddNewModifier(units[i], nil, "modifier_bounty_hunter_track_effect_lua", {}):SetDuration(1, true)
				end
			end
			return 1
		end, "Bounty Track aura", 1)

		-- abilities
		entity:AddAbility("hero_creep_aggro_datadriven"):SetLevel(1)
		entity:AddAbility("hero_intrinstic_mechanism_datadriven"):SetLevel(1)

		local player = entity:GetPlayerOwner()
		if player ~= nil then
			-- add custom glyph to fountain
			local fountain = nil
			if entity:GetTeam() == DOTA_TEAM_GOODGUYS then
				fountain = Entities:FindByName(nil, "ent_dota_fountain_good")
			elseif entity:GetTeam() == DOTA_TEAM_BADGUYS then
				fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
			end
			if fountain ~= nil then
				fountain:SetControllableByPlayer(entity:GetPlayerID(), true)
			end
		end


		if entity:GetName() == "npc_dota_hero_troll_warlord" then
			entity:SetThink(function()
				if entity:HasModifier("modifier_troll_warlord_berserkers_rage") then
					local ability = entity:FindAbilityByName("troll_warlord_berserkers_rage")
					entity:AddNewModifier(entity, ability, "modifier_troll_warlord_bash", {
						bonus_damage = bonus_damage, bash_chance = bash_chance})
				else
					entity:RemoveModifierByName("modifier_troll_warlord_bash")
				end
				return 0.2
			end, "troll get bash on hit", 1)
			entity:FindAbilityByName("troll_warlord_whirling_axes_ranged_vision_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_meepo" then
			if self.mainMeepo == nil then
				print("Registering meepo spawned")
				self.mainMeepo = entity
			else
				print("Secondary meepo spawned")
				entity.mainMeepo = self.mainMeepo 
			end
			entity:FindAbilityByName("meepo_divided_we_stand_aghs_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_pudge" then
			entity:AddNewModifier(entity, entity:FindAbilityByName("pudge_flesh_heap"), "modifier_pudge_flesh_magic_resist", {})
		elseif entity:GetName() == "npc_dota_hero_riki" then
			entity:AddNewModifier(entity, entity:FindAbilityByName("riki_permanent_invisibility"), "modifier_riki_invis_health_regen", {})
		elseif entity:GetName() == "npc_dota_hero_visage" then
			entity:SetThink(function()
				if entity:HasScepter() and not entity:HasAbility("special_bonus_unique_visage_6") then
					local ability = entity:AddAbility("special_bonus_unique_visage_6")
					ability:SetLevel(1)
					print("added visage ahgs ability")
				end
				return 1
			end, "visage scepter", 1);
			entity:FindAbilityByName("visage_gravekeepers_cloak_bonus_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_windrunner" then
			entity:SetThink(function()
				entity:RemoveModifierByName("modifier_windrunner_windrun_invis")
				entity:RemoveModifierByName("modifier_windrunner_windrun_invis_thinker")
				return 0.3
			end, "windrunner scepter", 0.3);
		elseif entity:GetName() == "npc_dota_hero_tiny" then
			entity:SetThink(function()
				if entity:HasScepter() and not entity:HasAbility("tiny_tree_grab") then
					local ability = entity:AddAbility("tiny_tree_grab")
					ability:SetLevel(1)
					print("added tiny ahgs ability")
				end
				return 2
			end, "tiny scepter", 2);
			entity:FindAbilityByName("tiny_grow_move_speed_checker_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_enchantress" then
			entity:AddNewModifier(entity, nil, "modifier_enchantress_aghs_attack_range", {})
		elseif entity:GetName() == "npc_dota_hero_keeper_of_the_light" then
			entity:FindAbilityByName("keeper_of_the_light_spirit_form_checker"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_doom_bringer" then
			entity:SetThink(function()
				if entity:HasModifier("modifier_doom_bringer_scorched_earth_effect") then
					local ability = entity:FindAbilityByName("doom_bringer_scorched_earth")
					entity:AddNewModifier(entity, ability, "modifier_doom_scorched_earth_regen", {
						health_regen = ability:GetSpecialValueFor("damage_per_second")})
				else
					entity:RemoveModifierByName("modifier_doom_scorched_earth_regen")
				end
				return 1
			end, "doom", 1);
		elseif entity:GetName() == "npc_dota_hero_slark" then
			entity:FindAbilityByName("slark_shadow_dance_heal_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_arc_warden" then
			entity:FindAbilityByName("arc_warden_tempest_double_cost"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_nevermore" then
			entity:FindAbilityByName("nevermore_requiem_slow_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_sand_king" then
			entity:AddNewModifier(entity, entity, "modifier_sandstorm_channel_end", {})
		elseif entity:GetName() == "npc_dota_hero_razor" then
			entity:FindAbilityByName("razor_unstable_current_reflect_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_lone_druid" then
			entity:FindAbilityByName("lone_druid_true_form_checker_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_undying" then
			entity:FindAbilityByName("undying_flesh_golem_aura_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_shadow_demon" then
			entity:FindAbilityByName("shadow_demon_soul_catcher_debuff_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_obsidian_destroyer" then
			entity:FindAbilityByName("obsidian_destroyer_imprison_int_steal_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_wisp" then
			entity:FindAbilityByName("wisp_tether_charge_checker_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_chen" then
			entity:FindAbilityByName("chen_penitence_incoming_dmg_checker"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_life_stealer" then
			entity:FindAbilityByName("life_stealer_infest_bounty_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_shredder" then
			entity:SetThink(function()
				if entity:HasScepter() then
					local ability = entity:FindAbilityByName("shredder_chakram_2")
					local ability2 = entity:FindAbilityByName("shredder_return_chakram_2")
					if ability:IsHidden() and ability2:IsHidden() then
						ability:SetLevel(entity:FindAbilityByName("shredder_chakram"):GetLevel())
						ability:SetHidden(false)
					end
				end
				return 2
			end, "timbersaw scepter", 2);
		elseif entity:GetName() == "npc_dota_hero_legion_commander" then
			entity:FindAbilityByName("legion_commander_press_the_attack_as_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_morphling" then
			entity:FindAbilityByName("morphling_morph_attribute_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_broodmother" then
			entity:FindAbilityByName("broodmother_insatiable_hunger_damage_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_kunkka" then
			entity:AddNewModifier(entity, nil, "modifier_tidebringer_cleave", {})
		elseif entity:GetName() == "npc_dota_hero_invoker" then
			entity:SetThink(function()
				entity:FindAbilityByName("invoker_invoke"):SetLevel(0)
			end, "reset invoker invoke", 0.5)
		elseif entity:GetName() == "npc_dota_hero_earth_spirit" then
			entity:AddItemByName("item_aghanims_shard")
		end
		local innate_ability = hero_innate_abilities[entity:GetName()]
		if innate_ability ~= nil then
			entity:FindAbilityByName(innate_ability):SetLevel(1)
		end
	end


	if entity:IsRealHero() and is_respawn == 1 and entity.loseIntOnRespawn then
		print("Losing int at respawn")
		entity.silencerAbility:ApplyDataDrivenModifier(entity, entity, "modifier_int_steal_debuf_datadriven", {})
		if not entity:HasModifier("modifier_int_steal_debuf_stacks_datadriven") then
			entity.silencerAbility:ApplyDataDrivenModifier(entity, entity, "modifier_int_steal_debuf_stacks_datadriven", {})
		end
		local modifier = entity:FindModifierByName("modifier_int_steal_debuf_stacks_datadriven")
		modifier:IncrementStackCount()
		entity.loseIntOnRespawn = false
	end

	if entity:GetModelName() == "models/creeps/roshan/roshan.vmdl" then
		if self.roshanCount == nil then
			self.roshanCount = 1
		end
		entity.roshanNo = self.roshanCount
		self.roshanCount = self.roshanCount + 1
	end

	if entity:GetName() == "npc_dota_creep_lane" then
		entity:SetThink(function()
			entity:RemoveModifierByName("modifier_creep_bonus_xp")
			entity:RemoveAbilityFromIndexByName("flagbearer_creep_aura_effect")
			entity:SetBaseMagicalResistanceValue(0)
			if (entity:GetAbsOrigin()[2] < -5460 or entity:GetAbsOrigin()[2] > 4745) 
				and not entity:HasModifier("modifier_creep_safe_lane_move_speed_bonus") then
				entity:AddNewModifier(nil, nil, "modifier_creep_safe_lane_move_speed_bonus", {}):SetDuration(25, true)
			end
		end, "remove flag bearer bonus", 1)
	end

	if entity:GetName() == "npc_dota_lone_druid_bear" then
		entity:SetThink(function()
			entity:RemoveModifierByName("modifier_spirit_bear_attack_damage")
			entity:RemoveModifierByName("modifier_lone_druid_spirit_bear_attack_check")
			entity:FindAbilityByName("lone_druid_bear_damage_return_cd"):SetLevel(1)
		end, "remove spirit bear original attack bonus", 1)
	end

	if entity:GetModelName() == "models/creeps/pine_cone/pine_cone.vmdl" then
		entity:ForceKill(false)
		entity:SetThink(function()
			print("warpine thinks")
			local neutralSpawner = Entities:FindByClassnameNearest("npc_dota_neutral_spawner", entity:GetAbsOrigin(), 200)
			if neutralSpawner == nil then
				print("No spawner found")
				return
			end
			neutralSpawner:CreatePendingUnits()
			neutralSpawner:CreatePendingUnits()
			neutralSpawner:CreatePendingUnits()
			neutralSpawner:SpawnNextBatch(false)
		end, "warpine replace with other creeps", RandomFloat(0.2,0.5))
	end
	if entity:GetName() == "npc_dota_tusk_frozen_sigil" then
		entity:FindAbilityByName("tusk_frozen_sigil_aura_datadriven"):SetLevel(
			entity:GetOwner():FindAbilityByName("tusk_frozen_sigil"):GetLevel())
	end
	if entity:HasAbility("pugna_nether_ward_aura_datadriven") then
		entity:FindAbilityByName("pugna_nether_ward_aura_datadriven"):SetLevel(
			entity:GetOwner():FindAbilityByName("pugna_nether_ward"):GetLevel())
	end
	if entity:GetName() == "npc_dota_visage_familiar" then
		entity:FindAbilityByName("visage_gravekeepers_cloak_bonus_datadriven"):SetLevel(1)
		entity:FindAbilityByName("neutral_spell_immunity"):SetLevel(1)
		entity:AddNewModifier(entity, entity, "modifier_familiar_attack_damage_lua", {})
	elseif entity:GetName() == "npc_dota_courier" then
		entity:FindAbilityByName("courier_flying_upgrade_datadriven"):SetLevel(1)
		if entity:GetTeam() == DOTA_TEAM_GOODGUYS and radiant_primary_courier == nil then
			radiant_primary_courier = entity
			entity.is_primary_courier = true
		elseif entity:GetTeam() == DOTA_TEAM_BADGUYS and dire_primary_courier == nil then
			dire_primary_courier = entity
			entity.is_primary_courier = true
		end
	elseif entity:GetName() == "npc_dota_beastmaster_hawk" then
		--print("owned by " .. entity:GetPlayerOwnerID())
		entity:SetControllableByPlayer(entity:GetPlayerOwnerID(), false)
		entity:FindAbilityByName("beastmaster_hawk_invisibility_datadriven"):SetLevel(
			entity:GetPlayerOwner():GetAssignedHero():FindAbilityByName("beastmaster_call_of_the_wild_hawk"):GetLevel())
	elseif entity:GetName() == "npc_dota_venomancer_plagueward" then
		entity:SetThink(function()
			local hero_veno = entity:GetOwner()
			if hero_veno:IsRealHero() and hero_veno:HasAbility("venomancer_poison_sting_datadriven") then
				local ability_sting = hero_veno:FindAbilityByName("venomancer_poison_sting_datadriven")
				if ability_sting:GetLevel() > 0 then
					entity:AddAbility("venomancer_ward_poison_sting_datadriven"):SetLevel(ability_sting:GetLevel())
				end
			end
		end, "Add ward passive", 0.1)
	end
end

function HandleEntityKilled(self, entityIdx, attackerIdx, inflictorIdx)
	local entity = EntIndexToHScript(entityIdx)
	local attacker = EntIndexToHScript(attackerIdx)
	local ability = nil
	if inflictorIdx ~= nil then
		ability = EntIndexToHScript(inflictorIdx)
	end
	local name = entity:GetName()
	if name == "dota_badguys_tower1_mid"
		or name == "dota_badguys_tower1_top"
		or name == "dota_badguys_tower1_bot" then
		local fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
		fountain:FindAbilityByName("glyph_datadriven"):EndCooldown()
	elseif name == "dota_goodguys_tower1_mid"
		or name == "dota_goodguys_tower1_top"
		or name == "dota_goodguys_tower1_bot" then
		local fountain = Entities:FindByName(nil, "ent_dota_fountain_good")
		fountain:FindAbilityByName("glyph_datadriven"):EndCooldown()
	elseif entity:GetModelName() == "models/creeps/roshan/roshan.vmdl" then
		print("roshan killed")
		self.nextRoshanTime = GameRules:GetDOTATime(false, false) + RandomInt(480, 660);
		print("next rosh respawn time is " .. self.nextRoshanTime);
		local team = attacker:GetTeam()
		if team == DOTA_TEAM_GOODGUYS or team == DOTA_TEAM_BADGUYS then
			local n = PlayerResource:GetPlayerCountForTeam(team)
			for i=1,n do
				local playerid = PlayerResource:GetNthPlayerIDOnTeam(team, i)
				PlayerResource:ModifyGold(playerid, 200, false, DOTA_ModifyGold_RoshanKill)
			end
			local teamname = "近卫"
			if team == DOTA_TEAM_BADGUYS then teamname = "天灾" end
			GameRules:SendCustomMessage("肉山被击杀，"..teamname.."全员获得200金", -1, -1)
		end
	end
	if ability ~= nil and ability:GetName() == "necrolyte_reapers_scythe" and entity:IsRealHero() and not entity:IsReincarnating() then
		entity.necrospawnminus = 30
		if attacker:HasScepter() then
			entity:SetBuyBackDisabledByReapersScythe(true)
			print("renabling buyback after " .. entity:GetLevel() * 4)
			entity:SetThink(function()
				entity:SetBuyBackDisabledByReapersScythe(false)
			end, "", {}, entity:GetLevel() * 4 + 30)
		end
	end
	if IsServer() and entity:IsRealHero() and (not entity:IsReincarnating()) then
		handleKillBonus(self, attacker, entity)
		local buyback_cost = 100 + entity:GetLevel() * entity:GetLevel() * 1.5 + GameRules:GetDOTATime(false, false) * 0.25
		print("Set buyback cost to " .. buyback_cost)
		PlayerResource:SetCustomBuybackCost(entity:GetPlayerID(), buyback_cost)
		entity.last_dead_time = GameRules:GetDOTATime(false, false)
		entity:ModifyGold(-30 * entity:GetLevel(), false, DOTA_ModifyGold_Death)
	end
	if attacker:IsOwnedByAnyPlayer() and entity:IsBuilding() and attacker:GetTeam() ~= entity:GetTeam() then
		-- grant building kill bonus
		local bounty = entity:GetGoldBounty()
		PlayerResource:ModifyGold(attacker:GetPlayerOwnerID(), bounty, false, DOTA_ModifyGold_Building)
		local attackerName = string.sub(attacker:GetName(), 15)
		GameRules:SendCustomMessage(attackerName .. "摧毁了建筑，获得" .. bounty .. "钱", -1, -1)
	end
	if entity:IsBuilding() and building2teambounty[entity:GetName()] ~= nil then
		-- grant team bounty
		local team_bounty = building2teambounty[entity:GetName()]
		local is_deny = false
		if attacker:GetTeam() == entity:GetTeam() then
			is_deny = true
			team_bounty = team_bounty / 2
		end
		local grant_team = DOTA_TEAM_GOODGUYS
		local teamname = "近卫"
		if entity:GetTeam() == DOTA_TEAM_GOODGUYS then
			grant_team = DOTA_TEAM_BADGUYS
			teamname = "天灾"
		end
		local playerCount = PlayerResource:GetPlayerCountForTeam(grant_team)
		for i=1,playerCount do
			PlayerResource:ModifyGold(PlayerResource:GetNthPlayerIDOnTeam(grant_team, i), team_bounty, false, DOTA_ModifyGold_Building)
		end
		if is_deny then
			GameRules:SendCustomMessage("建筑被反补，".. teamname .. "玩家各获得" .. team_bounty .. "金" , -1, -1)
		else
			GameRules:SendCustomMessage("建筑被摧毁，".. teamname .. "玩家各获得" .. team_bounty .. "金" , -1, -1)
		end		
	end
	if entity:IsCourier() and entity.is_primary_courier then
		--TODO Courier bounty
		print("Main courier killed, team " .. entity:GetTeam() .. " respawn in " .. (60 + entity:GetLevel() * 6)); 
	end
end

function HandleRuneActivated(playerid, rune)
	if rune == DOTA_RUNE_BOUNTY then
			local player = PlayerResource:GetPlayer(playerid)
		local hero = player:GetAssignedHero()
		local time = GameRules:GetDOTATime(false, false)
		local bounty = 100
		local exp = 100
		if time > 90 then
			bounty = 50 + 2 * math.floor(time / 60)
			exp = 50 + 5 * math.floor(time / 60)
		end
		print("bounty picked up " .. bounty .. " " .. exp)
		hero:ModifyGold(bounty, false, DOTA_ModifyGold_BountyRune)
		hero:AddExperience(exp, DOTA_ModifyXP_TomeOfKnowledge, false, false)
		local bottle = hero:FindItemInInventory("item_bottle")
		if bottle ~= nil and bottle:GetItemState() == 1 then
			bottle:SetCurrentCharges(3)
		end
	end
end

function HandleEntityHurt(entindex_killed, entindex_attacker, damage)
	local target = EntIndexToHScript(entindex_killed)
	local attacker = EntIndexToHScript(entindex_attacker)
	if target:GetPlayerOwner() ~= nil and attacker:HasAbility("hero_intrinstic_mechanism_datadriven") and damage > 0 then 
		local ability = attacker:FindAbilityByName("hero_intrinstic_mechanism_datadriven")
		attacker:RemoveModifierByName("modifier_move_speed_cancel_active_datadriven")
		ability:StartCooldown(ability:GetCooldown(1))
	end
	if attacker:GetPlayerOwner() ~= nil and target:IsRealHero() then
		if target.time_attacked == nil then
			target.time_attacked = {}
		end
		target.time_attacked[attacker:GetPlayerOwnerID()] = GameRules:GetDOTATime(true, false)
	end
end

function randomUnpickedPlayers()
	local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	for i=1,n do
		local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
		print(PlayerResource:GetSelectedHeroName(playerid))
		if PlayerResource:GetSelectedHeroName(playerid) == "" then
			PlayerResource:GetPlayer(playerid):MakeRandomHeroSelection()
		end
	end
	local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
	for i=1,n do
		local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
		print(PlayerResource:GetSelectedHeroName(playerid))
		if PlayerResource:GetSelectedHeroName(playerid) == "" then
			PlayerResource:GetPlayer(playerid):MakeRandomHeroSelection()
		end
	end
end

function CAddonTemplateGameMode:ModifyGoldFilter(event)
	if event.reason_const == DOTA_ModifyGold_WardKill and event.gold > 0 then
		event.gold = 50
	end
	if event.reason_const == DOTA_ModifyGold_HeroKill then
		print("Blocking default hero kill gold " .. event.gold)
		return false
	end
	if event.reason_const == DOTA_ModifyGold_Building then
		print("Blocking default building bounty")
		return false
	end
	local hero = PlayerResource:GetPlayer(event.player_id_const):GetAssignedHero()
	if (event.reason_const == DOTA_ModifyGold_Building
		or event.reason_const == DOTA_ModifyGold_CreepKill
		or event.reason_const == DOTA_ModifyGold_NeutralKill)
		and hero:HasModifier("modifier_hero_buybacked_gold_penalty")
	then
		--print("Blocking buybacked hero from gaining unreliable gold")
		return false
	end 
	if event.reason_const == DOTA_ModifyGold_CourierKill then
		print("Give courier gold to player " .. event.player_id_const)
		event.gold = 150
	end
	return true
end

function CAddonTemplateGameMode:ModifyExperienceFilter(event)
	if event.reason_const == DOTA_ModifyXP_Unspecified and event.experience > 50 then
		print("cap unspecified XP")
		event.experience = 50
	elseif event.reason_const == DOTA_ModifyXP_HeroKill then
		return false
	end
	return true
end

function CAddonTemplateGameMode:HealingFilter(event)
	if event.entindex_healer_const == nil then
		return true
	end
	local ability = EntIndexToHScript(event.entindex_inflictor_const)
	if ability:GetName() == "keeper_of_the_light_spirit_form_illuminate" and not GameRules:IsDaytime() then
		return false
	elseif ability:GetName() == "shadow_shaman_shackles" then return false
	elseif ability:GetName() == "pudge_dismember" then return false
	end
	return true
end

function CAddonTemplateGameMode:ModifierGainedFilter(event)
	--print("ModifierGainedFilter " .. event.name_const)
	if event.name_const == "modifier_dark_seer_wall_slow" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local parent = EntIndexToHScript(event.entindex_parent_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		ApplyDamage({ victim = parent, attacker = caster, damage = ability:GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL })
	elseif event.name_const == "modifier_morphling_adaptive_strike" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local parent = EntIndexToHScript(event.entindex_parent_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local damage = ability:GetSpecialValueFor("damage_base")
		local damage_min = ability:GetSpecialValueFor("damage_min")
		local damage_max = ability:GetSpecialValueFor("damage_max")
		local ratio = caster:GetAgility() / caster:GetStrength()
		if ratio > 1.5 then
			ratio = 1
		else
			ratio = ratio / 1.5
		end
		damage = damage + (damage_min + ratio * (damage_max - damage_min)) * caster:GetAgility()
		ApplyDamage({ victim = parent, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	elseif event.name_const == "modifier_abyssal_underlord_firestorm_burn" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local parent = EntIndexToHScript(event.entindex_parent_const)
		local burn_datadriven = caster:FindAbilityByName("abyssal_underlord_firestorm_burn_datadriven")
		burn_datadriven:SetLevel(caster:FindAbilityByName("abyssal_underlord_firestorm"):GetLevel())
		burn_datadriven:ApplyDataDrivenModifier(caster, parent, "modifier_underlord_firestorm_burn_active_datadriven", {})
	elseif event.name_const == "modifier_abyssal_underlord_pit_of_malice_ensare" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local parent = EntIndexToHScript(event.entindex_parent_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		ApplyDamage({ victim = parent, attacker = caster, damage = ability:GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL })
	elseif event.name_const == "modifier_earth_spirit_boulder_smash_debuff" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local parent = EntIndexToHScript(event.entindex_parent_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_stunned", {duration = ability:GetSpecialValueFor("duration")})
	elseif event.name_const == "modifier_stunned" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local parent = EntIndexToHScript(event.entindex_parent_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		if ability:GetName() == "earth_spirit_rolling_boulder" then
			local slow = caster:FindAbilityByName("earth_spirit_rolling_boulder_slow_datadriven")
			slow:ApplyDataDrivenModifier(caster, parent, "modifier_earth_spirit_rolling_boulder_slow_datadriven", {})
		end
	elseif event.name_const == "modifier_illusion" then
		local parent = EntIndexToHScript(event.entindex_parent_const)
		if parent:GetName() ~= "npc_dota_hero_phantom_lancer" then
			print("illusion add")
			parent:AddAbility("illusion_bounty_cancel_datadriven"):SetLevel(1)
		end
	elseif event.name_const == "modifier_winter_wyvern_arctic_burn_slow" then
		local parent = EntIndexToHScript(event.entindex_parent_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		caster:FindAbilityByName("winter_wyvern_arctic_burn_pure_datadriven"):ApplyDataDrivenModifier(caster, parent, "modifier_winter_wyvern_arctic_burn_pure_datadriven", {})
	elseif event.name_const == "modifier_techies_stasis_trap_stunned" then
		local parent = EntIndexToHScript(event.entindex_parent_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		parent:AddNewModifier(caster, ability, "modifier_stunned", { duration = ability:GetSpecialValueFor("stun_duration")})
		return false
	elseif event.name_const == "modifier_arc_warden_magnetic_field_thinker_attack_range" then
		local parent = EntIndexToHScript(event.entindex_parent_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		parent:AddNewModifier(caster, ability, "modifier_arc_warden_magnetic_field_thinker_attack_speed", {})	
		parent:AddNewModifier(caster, ability, "modifier_arc_warden_magnetic_field_thinker_evasion", {})	
	elseif event.name_const == "modifier_visage_summon_familiars_stone_form_buff" then
		local parent = EntIndexToHScript(event.entindex_parent_const)
		parent:FindModifierByName("modifier_familiar_attack_damage_lua"):refreshStackCount()
	elseif event.name_const == "modifier_bane_nightmare" then
		local parent = EntIndexToHScript(event.entindex_parent_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local nightmare_damage = caster:FindAbilityByName("bane_nightmare_damage_datadriven")
		print(caster:GetName() .. " " .. nightmare_damage:GetName() .. " " .. parent:GetName())
		nightmare_damage:SetLevel(caster:FindAbilityByName("bane_nightmare"):GetLevel())
		if caster:GetTeam() ~= parent:GetTeam() then
			caster:SetThink(function()
				if parent:HasModifier("modifier_bane_nightmare") then
					ApplyDamage({victim = parent, attacker = caster, damage = 20, damage_type = DAMAGE_TYPE_PURE})
					nightmare_damage:ApplyDataDrivenModifier(caster, parent, "modifier_bane_nightmare_damage_active", {})
				end
			end, "nightmare_damage later", 1.5)
		end
	elseif event.name_const == "modifier_naga_siren_ensnare" then
		local parent = EntIndexToHScript(event.entindex_parent_const)
		if parent:IsMagicImmune() then
			return false
		end
	elseif event.name_const == "modifier_medusa_stone_gaze_stone" then
		local parent = EntIndexToHScript(event.entindex_parent_const)
		if parent:IsIllusion() then
			print("stone gaze kills illusion " .. parent:GetName())
			parent:ForceKill(false)
			return false
		end
		local caster = EntIndexToHScript(event.entindex_caster_const)
		print("Applying magic resist to stoned units")
		caster:FindAbilityByName("medusa_stone_gaze_magic_resist_datadriven"):ApplyDataDrivenModifier(
			caster, parent, "modifier_stone_gaze_magic_resist_datadriven", {})
	elseif event.name_const == "modifier_ember_spirit_fire_remnant_thinker" then
		local parent = EntIndexToHScript(event.entindex_parent_const)
		parent:SetDayTimeVisionRange(400)
		parent:SetNightTimeVisionRange(400)
	elseif event.name_const == "modifier_courier_transfer_items" then
		local parent = EntIndexToHScript(event.entindex_parent_const)
		print(parent.is_primary_courier)
		if parent.is_primary_courier then
			CustomGameEventManager:Send_ServerToTeam(parent:GetTeam(), "courier_start_transfer", {})
			parent:FindAbilityByName("courier_flying_upgrade_datadriven"):ApplyDataDrivenModifier(parent, parent,
				"modifier_courier_transfer_stop_checker", {})
		end
	elseif event.name_const == "modifier_slark_pounce_leash" then 
		local parent = EntIndexToHScript(event.entindex_parent_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		caster:FindAbilityByName("slark_shadow_dance_heal_datadriven"):ApplyDataDrivenModifier(
			caster, parent, "modifier_slark_pounce_leash_datadriven", { duration = 3.5 })
		return false
	elseif event.name_const == "modifier_fountain_invulnerability" then return false
	elseif event.name_const == "modifier_eul_cyclone" then return false
	elseif event.name_const == "modifier_tombstone_hp" then return false
	elseif event.name_const == "modifier_courier_passive_bonus" then return false
	elseif event.name_const == "modifier_beastmaster_call_of_the_wild_hawk" then return false
	end
	if root_modifiers[event.name_const] then
		local parent = EntIndexToHScript(event.entindex_parent_const)
		if parent:IsChanneling() then
			parent:InterruptChannel()
		end
	end
	if ethereal_modifiers[event.name_const] or disarm_modifiers[event.name_const] then
		local parent = EntIndexToHScript(event.entindex_parent_const)
		if parent:HasModifier("modifier_legion_commander_duel") then
			print("Cannot apply ethereal or disable modifier on dualed targets")
			return false
		end
	end
	return true
end

function CAddonTemplateGameMode:DamageFilter(event)
	local attacker = EntIndexToHScript(event.entindex_attacker_const)
	local victim = EntIndexToHScript(event.entindex_victim_const)
	if event.entindex_inflictor_const ~= nil then
		local inflictor = EntIndexToHScript(event.entindex_inflictor_const)
	--	print("DamageFilter " .. inflictor:GetName() .. "  " .. event.damage)
		if inflictor:GetName() == "bounty_hunter_shuriken_toss" then
			local victim = EntIndexToHScript(event.entindex_victim_const)
			victim:AddNewModifier(attacker, attacker:FindAbilityByName("bounty_hunter_shuriken_toss"), "modifier_stunned", {duration = 0.03})
		elseif inflictor:GetName() == "item_cyclone" then
			return false
		elseif inflictor:GetName() == "item_ethereal_blade" then
			--print(victim:Script_GetMagicalArmorValue(false, attacker))
			if attacker:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
				event.damage = (attacker:GetStrength() * 2 + 75) * (1 - victim:Script_GetMagicalArmorValue(false, attacker))
			elseif attacker:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
				event.damage = (attacker:GetAgility() * 2 + 75) * (1 - victim:Script_GetMagicalArmorValue(false, attacker))
			else
				event.damage = (attacker:GetIntellect() * 2 + 75) * (1 - victim:Script_GetMagicalArmorValue(false, attacker))
			end
			--print("Etheral damage " .. event.damage)
		elseif inflictor:GetName() == "phoenix_sun_ray" then
			local victim = EntIndexToHScript(event.entindex_victim_const)
			event.damage = event.damage / (1 - victim:Script_GetMagicalArmorValue(false, inflictor))
		elseif inflictor:GetName() == "earth_spirit_rolling_boulder" and event.damage > 0 then
			-- fix rolling boulder damage without strength component
			local victim = EntIndexToHScript(event.entindex_victim_const)
			event.damage = 100 * (1 - victim:Script_GetMagicalArmorValue(false, inflictor))
		end
    else
		--print(victim:GetName())
        if attacker:HasModifier("modifier_ember_spirit_sleight_of_fist_in_progress") and victim:IsCreep() then
            event.damage = event.damage / 2
		elseif attacker:IsBuilding() and victim:GetName() == "npc_dota_creep_siege" then
			-- It takes 4 hits for t1 tower to kill a siege creep.
			event.damage = event.damage  * 2 / 3
        end
	end
	return true
end

function CAddonTemplateGameMode:AbilityTuningValueFilter(event)
	local ability = EntIndexToHScript(event.entindex_ability_const)
	if ability:GetName() == "ogre_magi_ignite_datadriven" and event.value_name_const == "AbilityCastRange" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability_multicast = caster:FindAbilityByName("ogre_magi_multicast_datadriven")
		if ability_multicast:GetLevel() > 0 then
			event.value = event.value + ability_multicast:GetSpecialValueFor("ignite_range")
			return true
		end
	elseif ability:GetName() == "enigma_black_hole" and event.value_name_const == "scepter_pct_damage" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		if caster:HasScepter() then
			local enigma_midnight_pulse = caster:FindAbilityByName("enigma_midnight_pulse")
			if enigma_midnight_pulse:GetLevel() > 0 then
				event.value = enigma_midnight_pulse:GetSpecialValueFor("damage_percent")
				return true
			end
		end
	elseif ability:GetName() == "tiny_toss" and event.value_name_const == "bonus_damage_pct" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability_grow = caster:FindAbilityByName("tiny_grow")
		if ability_grow:GetLevel() > 0 then
			event.value = ability_grow:GetSpecialValueFor("toss_bonus_damage_pct")
			return true
		end
	end
end

function CAddonTemplateGameMode:handleLadderHeroBanned(event)
	local hero = slot_2_heroes[event.hero_id_suffix]
	print("hero banned " .. hero)
	ladder_heroes_2_ban[hero] = ladder_heroes_2_ban[hero] + 1
	CustomGameEventManager:Send_ServerToAllClients("ladder_hero_ban_s2c", {id_suffix = event.hero_id_suffix})
end

captain_pick_phase = 0
captain_radiant_pick = {}
captain_radiant_ban = {}
captain_dire_pick = {}
captain_dire_ban = {}
captain_normal_time = 40;
captain_radiant_extra_time = 110;
captain_dire_extra_time = 110;
function CAddonTemplateGameMode:handleCaptainClientPick(event)
	DeepPrintTable(event)
	if captain_pick_phase == event.pp then
		-- TODO validate player team
		if captain_pick_phase == 0 
			or captain_pick_phase == 2 
			or captain_pick_phase == 8 
			or captain_pick_phase == 10
			or captain_pick_phase == 17
			then
			table.insert(captain_radiant_ban, event.sh)
			DeepPrintTable(captain_radiant_ban)
		elseif captain_pick_phase == 1 
			or captain_pick_phase == 3 
			or captain_pick_phase == 9
			or captain_pick_phase == 11
			or captain_pick_phase == 16
			then
			table.insert(captain_dire_ban, event.sh)
			DeepPrintTable(captain_dire_ban)
		elseif captain_pick_phase == 4 
			or captain_pick_phase == 6
			or captain_pick_phase == 12
			or captain_pick_phase == 14
			or captain_pick_phase == 18
			then
			table.insert(captain_radiant_pick, event.sh)
			DeepPrintTable(captain_radiant_pick)
		elseif captain_pick_phase == 5
			or captain_pick_phase == 7
			or captain_pick_phase == 13
			or captain_pick_phase == 15
			or captain_pick_phase == 19
			then
			table.insert(captain_dire_pick, event.sh)
			DeepPrintTable(captain_dire_pick)
		end
		if (captain_pick_phase == 19) then
			GameRules:GetGameModeEntity():SetThink(function()
				for i=1,#captain_radiant_pick do
					GameRules:RemoveHeroFromBlacklist("npc_dota_hero_"..captain_radiant_pick[i])
				end
				for i=1,#captain_dire_pick do
					GameRules:RemoveHeroFromBlacklist("npc_dota_hero_"..captain_dire_pick[i])
				end
				CustomGameEventManager:Send_ServerToAllClients("captain_player_pick_start", {})
			end, "captain pick ends", 5)
		end
		CustomGameEventManager:Send_ServerToAllClients(
			"captain_hero_pick_s2c", { pp = captain_pick_phase, sh = event.sh })
		captain_pick_phase = captain_pick_phase + 1
		captain_normal_time = 40
	end
end

function CAddonTemplateGameMode:handleHeroBarPingMiss(event)
	local missing_player_id = event.mpid;
	local reporting_player_id = event.pid;
	local missing_hero = PlayerResource:GetPlayer(missing_player_id):GetAssignedHero():GetName()
	local team = PlayerResource:GetPlayer(reporting_player_id):GetTeam()
	GameRules:SendCustomMessageToTeam(string.sub(missing_hero, 15) .. "_miss", team, -1, -1)
end

function HandleBuyback(entindex, player_id)
	local entity = EntIndexToHScript(entindex)
	entity.buybacked = true
	local gold_penalty_duration = entity:GetLevel() * 4 + entity.last_dead_time - GameRules:GetDOTATime(false, false);
	print("gold_penalty_duration "..gold_penalty_duration)
	entity:FindAbilityByName("hero_intrinstic_mechanism_datadriven"):ApplyDataDrivenModifier(
		entity, entity, "modifier_hero_buybacked_gold_penalty", { duration = gold_penalty_duration });
	PlayerResource:SetCustomBuybackCooldown(player_id, 420)
end

function bitand(a, b)
    local result = 0
    local bitval = 1
    while a > 0 and b > 0 do
      if a % 2 == 1 and b % 2 == 1 then -- test the rightmost bits
          result = result + bitval      -- set the current bit
      end
      bitval = bitval * 2 -- shift left
      a = math.floor(a/2) -- shift right
      b = math.floor(b/2)
    end
    return result
end
