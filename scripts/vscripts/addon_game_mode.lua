-- Generated from template

require("creepspawn")
if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

playerRepicked = {}
randomBonusGranted = {}

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
	LinkLuaModifier( "item_sheep_stick_regen_percentage_modifier", "items/item_sheepstick.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "item_orchid_regen_percentage_modifier", "items/item_orchid.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "item_urn_bonus_modifier", "items/item_urn_of_shadows.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "item_cyclone_regen_percentage_modifier", "items/item_cyclone.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_force_staff_health_regen_modifier", "items/item_force_staff.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_necronomicon_intellect_modifier", "items/item_necronomicon.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_dagon_modifier_lua", "items/item_dagon.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_refresher_modifier_lua", "items/item_refresher.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_sphere_bonus_modifier", "items/item_sphere.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_crimson_guard_bonus_modifier", "items/item_crimson_guard.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_bfury_regen_percentage_modifier", "items/item_bfury.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_soul_ring_bonus_modifier", "items/item_soul_ring.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_medallion_regen_percentage_modifier", "items/item_medallion.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_equipped_bonus_modifier", "items/item_equip_bonus.lua", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier( "modifier_bonus_strength_lua", "modifiers/bonus_strength.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_necronomicon_bonus_intellect", "modifiers/necronomicon_bonus_intellect.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_necronomicon_2_bonus_intellect", "modifiers/necronomicon_2_bonus_intellect.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_necronomicon_3_bonus_intellect", "modifiers/necronomicon_3_bonus_intellect.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_dagon_damage_lua", "modifiers/dagon_bonus_damage.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_refresher_bonus_lua", "modifiers/refresher_bonus.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_sphere_bonus_damage_lua", "modifiers/sphere_bonus_damage.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_soul_ring_health_regen_lua", "modifiers/soul_ring_health_regen.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_tower_bonus_cancel_lua", "modifiers/tower_bonus_cancel.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_shadow_amulet_attack_speed", "modifiers/shadow_amulet_attack_speed.lua", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier( "modifier_attribute_regen_adjust", "modifiers/attribute_regen.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_troll_warlord_bash", "modifiers/troll_bash.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_safe_lane_move_speed_bonus", "modifiers/creep.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_cancels_item_on_hit", "modifiers/item_cancel_on_hit.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_ai", "creepai.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_health_bonus", "modifiers/creep_health.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_pudge_flesh_magic_resist", "modifiers/pudge_flesh_magic_resist.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_riki_invis_health_regen",         "modifiers/riki_invis_health_regen.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_enchantress_aghs_attack_range",   "modifiers/enchantress_aghs_attack_range.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_omniknight_guardian_angel_regen", "modifiers/omniknight_guardian_regen.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_bounty_hunter_track_effect_lua",  "modifiers/bounty_hunter_track_effect.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_doom_scorched_earth_regen", 		 "modifiers/doom_scorched_earth_regen.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_sandstorm_channel_end",			 "modifiers/sandstorm_channel_end.lua", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier( "modifier_tpscroll_travel_cooldown", "modifiers/tpscroll.lua", LUA_MODIFIER_MOTION_NONE)
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	
	GameRules:SetStartingGold(625)
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP, 19)
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR, 0.17)
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA, 13)
	
	GameRules:GetGameModeEntity():SetCustomBackpackSwapCooldown(15)
	GameRules:GetGameModeEntity():SetCustomBackpackCooldownPercent(1)
	GameRules:GetGameModeEntity():SetCustomBuybackCooldownEnabled(true)
	GameRules:GetGameModeEntity():SetCustomGlyphCooldown(-1)
	GameRules:GetGameModeEntity():SetCustomScanCooldown(-1)
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
	GameRules:SetCreepSpawningEnabled(false)

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

	ListenToGameEvent('npc_spawned', function(event)
		HandleNpcSpawned(self, event.entindex, event.is_respawn)
	end, nil)
	ListenToGameEvent('modifier_event', function(event)
		HandleModifierEvent(event.eventname, event.caster, event.ability)
	end, nil)
	ListenToGameEvent('entity_killed', function(event)
		HandleEntityKilled(event.entindex_killed, event.entindex_attacker, event.entindex_inflictor)
	end, nil)
	ListenToGameEvent('dota_rune_activated_server', function(event)
		HandleRuneActivated(event.PlayerID, event.rune)
	end, nil)
	ListenToGameEvent('player_chat', function(event)
		HandlePlayerChat(self, event.teamonly, event.text, event.playerid)
	end, nil)
	ListenToGameEvent('entity_hurt', function(event)
		HandleEntityHurt(event.entindex_killed, event.entindex_attacker)
	end, nil)
	ListenToGameEvent("dota_hero_swap", function(event)
		print("dota_hero_swap")
	end, nil)

	if GetMapName() == "dota_683" then
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
			elseif pos[1] == -448 and pos[2] == -3136 then
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
		elseif text == '-cm' then
			GameRules:SetHeroSelectionTime(600)
			self.rdEnabled = false
			self.botEnabled = false
			self.captainEnabled = true
			GameRules:SetSameHeroSelectionEnabled(false)
			GameRules:SendCustomMessage("开启队长模式", -1, -1)
		end
	end
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION or GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		if not self.rdEnabled and not self.captainEnabled and text == '-repick' then
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
			PlayerResource:ModifyGold(playerid, -100, true, DOTA_ModifyGold_SelectionPenalty)
			if PlayerResource:HasRandomed(playerid) then
				PlayerResource:ModifyGold(playerid, -250, true, DOTA_ModifyGold_SelectionPenalty)
			end
			playerRepicked[playerid] = true
		end
	end
end

function swapLocation(e1, e2)
	local tmpLoc = e1:GetAbsOrigin()
	e1:SetAbsOrigin(e2:GetAbsOrigin())
	e2:SetAbsOrigin(tmpLoc)
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if self.rdEnabled and IsServer() and self.rdHeroFiltered == nil then
			local heroes = {
				"npc_dota_hero_abaddon"				,
				"npc_dota_hero_ancient_apparition" 	,
				"npc_dota_hero_antimage"			,
				"npc_dota_hero_arc_warden"			,
				"npc_dota_hero_axe"					,
				"npc_dota_hero_bane"				,
				"npc_dota_hero_beastmaster"			,
				"npc_dota_hero_brewmaster"			,
				"npc_dota_hero_centaur"				,
				"npc_dota_hero_chaos_knight"		,
				"npc_dota_hero_crystal_maiden"		,
				"npc_dota_hero_dazzle"				,
				"npc_dota_hero_dragon_knight"		,
				"npc_dota_hero_drow_ranger"			,
				"npc_dota_hero_earthshaker"			,
				"npc_dota_hero_faceless_void"		,
				"npc_dota_hero_juggernaut"			,
				"npc_dota_hero_leshrac"				,
				"npc_dota_hero_lich"				,
				"npc_dota_hero_life_stealer"		,
				"npc_dota_hero_lina"				,
				"npc_dota_hero_lion"				,
				"npc_dota_hero_luna"				,
				"npc_dota_hero_lycan"				,
				"npc_dota_hero_magnataur"			,
				"npc_dota_hero_medusa"				,
				"npc_dota_hero_morphling"			,
				"npc_dota_hero_naga_siren"			,
				"npc_dota_hero_nevermore"			,
				"npc_dota_hero_night_stalker"		,
				"npc_dota_hero_nyx_assassin"		,
				"npc_dota_hero_obsidian_destroyer"	,
				"npc_dota_hero_ogre_magi"			,
				"npc_dota_hero_omniknight"			,
				"npc_dota_hero_oracle"				,
				"npc_dota_hero_pugna"				,
				"npc_dota_hero_rattletrap"			,
				"npc_dota_hero_razor"				,
				"npc_dota_hero_shadow_demon"		,
				"npc_dota_hero_shadow_shaman"		,
				"npc_dota_hero_skeleton_king"		,
				"npc_dota_hero_skywrath_mage"		,
				"npc_dota_hero_slardar"				,
				"npc_dota_hero_slark"				,
				"npc_dota_hero_sniper"				,
				"npc_dota_hero_spirit_breaker"		,
				"npc_dota_hero_sven"				,
				"npc_dota_hero_terrorblade"			,
				"npc_dota_hero_tidehunter"			,
				"npc_dota_hero_troll_warlord"		,
				"npc_dota_hero_tusk"				,
				"npc_dota_hero_vengefulspirit"		,
				"npc_dota_hero_viper"				,
				"npc_dota_hero_visage"				,
				"npc_dota_hero_warlock"				,
				"npc_dota_hero_weaver"				,
				"npc_dota_hero_windrunner"			,
				"npc_dota_hero_witch_doctor"		,
				"npc_dota_hero_abyssal_underlord"	,
				"npc_dota_hero_alchemist"			,
				"npc_dota_hero_bounty_hunter"		,
				"npc_dota_hero_clinkz"				,
				"npc_dota_hero_death_prophet"		,
				"npc_dota_hero_disruptor"			,
				"npc_dota_hero_earth_spirit"		,
				"npc_dota_hero_elder_titan"			,
				"npc_dota_hero_ember_spirit"		,
				"npc_dota_hero_enigma"				,
				"npc_dota_hero_gyrocopter"			,
				"npc_dota_hero_huskar"				,
				"npc_dota_hero_invoker"				,
				"npc_dota_hero_jakiro"				,
				"npc_dota_hero_keeper_of_the_light"	,
				"npc_dota_hero_phantom_assassin"	,
				"npc_dota_hero_phoenix"				,
				"npc_dota_hero_sand_king"			,
				"npc_dota_hero_shredder"			,
				"npc_dota_hero_silencer"			,
				"npc_dota_hero_tinker"				,
				"npc_dota_hero_tiny"				,
				"npc_dota_hero_treant"				,
				"npc_dota_hero_venomancer"			,
				"npc_dota_hero_winter_wyvern"		,
				"npc_dota_hero_bristleback"			,
				"npc_dota_hero_storm_spirit"		,
				"npc_dota_hero_wisp"				,
				"npc_dota_hero_dark_seer"			,
				"npc_dota_hero_lone_druid"			,
				"npc_dota_hero_mirana"				,
				"npc_dota_hero_necrolyte"			,
				"npc_dota_hero_puck"				,
				"npc_dota_hero_pudge"				,
				"npc_dota_hero_queenofpain"			,
				"npc_dota_hero_riki"				,
				"npc_dota_hero_rubick"				,
				"npc_dota_hero_techies"				,
				"npc_dota_hero_templar_assassin"	,
				"npc_dota_hero_zuus"				,
				"npc_dota_hero_batrider"			,
				"npc_dota_hero_bloodseeker"			,
				"npc_dota_hero_broodmother"			,
				"npc_dota_hero_chen"				,
				"npc_dota_hero_doom_bringer"		,
				"npc_dota_hero_enchantress"			,
				"npc_dota_hero_furion"				,
				"npc_dota_hero_kunkka"				,
				"npc_dota_hero_legion_commander"	,
				"npc_dota_hero_meepo"				,
				"npc_dota_hero_monkey_king"			,
				"npc_dota_hero_phantom_lancer"		,
				"npc_dota_hero_spectre"				,
				"npc_dota_hero_undying"				,
				"npc_dota_hero_ursa"	
			}
			for i=1,#heroes do
				if RandomInt(1, 111) > 30 then
					GameRules:AddHeroToBlacklist(heroes[i])
				end
			end
			self.rdHeroFiltered = true
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME and self.botEnabled and self.botInitialized == nil then
		print("Init bot")
		local botHeroPool = {
			"npc_dota_hero_axe",
			"npc_dota_hero_ogre_magi",
			"npc_dota_hero_luna",
			"npc_dota_hero_skywrath_mage",
			"npc_dota_hero_lina",

			"npc_dota_hero_bristleback",
			"npc_dota_hero_witch_doctor",
			"npc_dota_hero_venomancer",
			"npc_dota_hero_zuus",
			"npc_dota_hero_skeleton_king",

			"npc_dota_hero_lion",
			"npc_dota_hero_abaddon",
			"npc_dota_hero_vengefulspirit",
			"npc_dota_hero_sniper",
			"npc_dota_hero_phantom_assassin",
		}
		Tutorial:StartTutorialMode()	
		GameRules:SetSameHeroSelectionEnabled(true)
		GameRules:GetGameModeEntity():SetFreeCourierModeEnabled(true)
		-- pick 5 random hero to play
		local lanes = {"bot", "bot", "mid", "top", "top"}
		for i=1,5 do
			local heroNumber = RandomInt(1, #botHeroPool)	
			Tutorial:AddBot(botHeroPool[heroNumber], lanes[i], "hard", false)
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
			--GameRules:SpawnNeutralCreeps()
			self.hasSpawnNeutralsAt30s = true
		end

		if not self.botEnabled and time > 0 and (math.floor(time) % 30) < 3 and (self.creepSpawnTime == nil or (time - self.creepSpawnTime) > 10) then
			spawnCreepsLua()
			self.creepSpawnTime = time
		end
		if time >= 0 and (self.timeofdayset == nil) then
			GameRules:SetTimeOfDay(0.25)
			self.timeofdayset = true
		end
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	if (GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME or GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION) and not self.rdEnabled and not self.captainEnabled then
		local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
		for i=1,n do
			local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
			if PlayerResource:HasRandomed(playerid) and not randomBonusGranted[playerid] and not playerRepicked[playerid] then
				PlayerResource:ModifyGold(playerid, 250, true, DOTA_ModifyGold_Unspecified)
				randomBonusGranted[playerid] = true
			end
		end
		local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
		for i=1,n do
			local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
			if PlayerResource:HasRandomed(playerid) and not randomBonusGranted[playerid] and not playerRepicked[playerid] then
				PlayerResource:ModifyGold(playerid, 250, true, DOTA_ModifyGold_Unspecified)
				randomBonusGranted[playerid] = true
			end
		end
	end
	return 1
end

-- Add the order filter to your game mode entity
function CAddonTemplateGameMode:OrderFilter(event)
    --Check if the order is the glyph type
    if event.order_type == DOTA_UNIT_ORDER_GLYPH then
		local player = PlayerResource:GetPlayer(event.issuer_player_id_const)
		local team = player:GetTeam()
		local fountain = nil
		if team == DOTA_TEAM_GOODGUYS then
			fountain = Entities:FindByName(nil, "ent_dota_fountain_good")
		else
			fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
		end
		local glyph = fountain:FindAbilityByName("glyph_datadriven")
		glyph:CastAbility()
		return false
    end
	if event.order_type == DOTA_UNIT_ORDER_RADAR then
		return false
    end
	for i,v in pairs(event.units) do
		local unit = EntIndexToHScript(v)
		if unit:GetName() == "npc_dota_courier" then
 			if unit.isSharedWithTeam == nil
			    and unit:GetPlayerOwnerID() ~= event.issuer_player_id_const then
				event.units[i] = nil
			end
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
		if recentRuneSpawn == nil then
			if RandomInt(0, 1) == 0 then
				event.rune_type = DOTA_RUNE_BOUNTY
			else
				local runeTypes = {DOTA_RUNE_DOUBLEDAMAGE, DOTA_RUNE_HASTE, DOTA_RUNE_ILLUSION, DOTA_RUNE_INVISIBILITY, DOTA_RUNE_REGENERATION}
				event.rune_type = runeTypes[RandomInt(1, #runeTypes)]
			end
			self.runeSpawnedAtTime[nthRuneSpawned] = event.rune_type
		else
			if recentRuneSpawn ~= DOTA_RUNE_BOUNTY then
				event.rune_type = DOTA_RUNE_BOUNTY
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
    if entity:IsRealHero() and is_respawn == 0 then
		entity:SetThink(function()
			entity:RemoveItem(entity:FindItemInInventory("item_tpscroll"))
        end, "remove tpscroll", 0.5)
		entity:AddNewModifier(entity, nil, "item_sheep_stick_regen_percentage_modifier", {})
		entity:AddNewModifier(entity, nil, "item_orchid_regen_percentage_modifier", {})
		entity:AddNewModifier(entity, nil, "item_cyclone_regen_percentage_modifier", {})
		entity:AddNewModifier(entity, nil, "item_urn_bonus_modifier", {})
		entity:AddNewModifier(entity, nil, "item_force_staff_health_regen_modifier", {})
		entity:AddNewModifier(entity, nil, "item_dagon_modifier_lua", {})
		entity:AddNewModifier(entity, nil, "item_necronomicon_intellect_modifier", {})
		entity:AddNewModifier(entity, nil, "item_refresher_modifier_lua", {})
		entity:AddNewModifier(entity, nil, "item_sphere_bonus_modifier", {})
		entity:AddNewModifier(entity, nil, "item_crimson_guard_bonus_modifier", {})
		entity:AddNewModifier(entity, nil, "item_bfury_regen_percentage_modifier", {})
		entity:AddNewModifier(entity, nil, "item_soul_ring_bonus_modifier", {})
		entity:AddNewModifier(entity, nil, "item_medallion_regen_percentage_modifier", {})
    	entity:AddNewModifier(entity, nil, "modifier_tower_bonus_cancel_lua", {})
    	entity:AddNewModifier(entity, nil, "modifier_attribute_regen_adjust" , {})
    	entity:AddNewModifier(entity, nil, "modifier_cancels_item_on_hit" , {})
		entity:AddNewModifier(entity, nil, "modifier_tpscroll_travel_cooldown", {})
		entity:AddNewModifier(entity, nil, "item_equipped_bonus_modifier", {
			item = "item_shadow_amulet",
			modifier = "modifier_item_shadow_amulet_attack_speed"
		})

		-- add custom glyph to fountain
		local fountain = nil
		if entity:GetTeam() == DOTA_TEAM_GOODGUYS then
			fountain = Entities:FindByName(nil, "ent_dota_fountain_good")
		elseif entity:GetTeam() == DOTA_TEAM_BADGUYS then
			fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
		end
		if fountain ~= nil then
			fountain:SetControllableByPlayer(entity:GetPlayerID(), true)
			fountain:FindAbilityByName("glyph_datadriven"):CastAbility()
		end
		
		-- give 200 gold to randomed player
		local player = entity:GetPlayerOwner()
		if player == nil then
			-- its is going to be an illusion
			return
		end

		--give 90 gold per minute
		player:SetThink(function()
			local time = GameRules:GetDOTATime(false, false) 
			if time >= 2 then
			-- give passive gold to all players
				entity:ModifyGold(3, true, DOTA_ModifyGold_GameTick)
			end
			return 2
		end, "give 90 gold per minute after game start", 2)

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
		elseif entity:GetName() == "npc_dota_hero_meepo" then
			entity:SetThink(function()
				if entity:HasScepter() and not entity:HasAbility("special_bonus_unique_meepo_5") then
					entity:AddAbility("special_bonus_unique_meepo_5")
					print("added meepo ahgs ability")
				end
				return 1
			end, "meepo scepter", 1);
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
		elseif entity:GetName() == "npc_dota_hero_enchantress" then
			entity:AddNewModifier(entity, nil, "modifier_enchantress_aghs_attack_range", {})
		elseif entity:GetName() == "npc_dota_hero_keeper_of_the_light" then
			entity:SetThink(function()
				local ability = entity:FindAbilityByName("keeper_of_the_light_recall")
				if entity:HasScepter() and ability:IsHidden() then
					ability:SetHidden(false)
					ability:SetLevel(1)
					return 2
				end
				return 2
			end, "kotl aghs", 2);
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
	if entity:GetName() == "npc_dota_roshan" then
		entity:SetThink(function()
		entity:RemoveItem(entity:FindItemInInventory("item_aghanims_shard_roshan"))
		entity:RemoveItem(entity:FindItemInInventory("item_ultimate_scepter_roshan"))
		entity:RemoveItem(entity:FindItemInInventory("item_refresher_shard"))
		end, "remove refresher shard, ags shard and ags", 0.5)
	end

	-- courier fix speed and health
	if entity:GetName() == "npc_dota_courier" or
		entity:GetName() == "npc_dota_flying_courier" then
	    entity:SetThink(function()
			if entity:HasAbility("courier_share") then
				entity:FindAbilityByName("courier_share"):SetLevel(1)
			end
			if entity:GetLevel() >= 4 then
				entity:SetBaseMoveSpeed(430)
				entity:SetBaseMaxHealth(150)
				return
			end
	        entity:RemoveModifierByName("modifier_courier_passive_bonus")
			return 1
    	end, nil, "fix speed", 1)
	end

	if entity:GetName() == "npc_dota_ward_base" or entity:GetName() == "npc_dota_ward_base_truesight" then
		entity:SetThink(function()
			local position = entity:GetAbsOrigin()
			if isAtWardPoint(position, -1940, -4760) then
				entity:SetAbsOrigin(Vector(position[1] + 300, position[2] + 300, position[3] + 256))
			elseif isAtWardPoint(position, -1171, -4621) then
				entity:SetAbsOrigin(Vector(position[1] - 400, position[2] + 100, position[3] + 256))
			elseif isAtWardPoint(position, 4172, -1283) then
				entity:SetAbsOrigin(Vector(position[1] + 400, position[2], position[3] + 256))
			elseif isAtWardPoint(position, 4951, -1269) then
				entity:SetAbsOrigin(Vector(position[1] - 350, position[2], position[3] + 256))
			end
		end, "delay change word location", 0.1)
	end

	if entity:GetName() == "npc_dota_creep_lane" then
		entity:SetThink(function()
			entity:RemoveModifierByName("modifier_creep_bonus_xp")
			entity:RemoveAbilityFromIndexByName("flagbearer_creep_aura_effect")
			entity:SetBaseMagicalResistanceValue(0)
		end, "remove flag bearer bonus", 1)
	end
	if entity:GetName() == "npc_dota_lone_druid_bear" then
		entity:SetThink(function()
			entity:RemoveModifierByName("modifier_spirit_bear_attack_damage")
			entity:RemoveModifierByName("modifier_lone_druid_spirit_bear_attack_check")
		end, "remove spirit bear original attack bonus", 1)
	end
	if not entity:IsBuilding() and not entity:IsCreep() then
		entity:SetThink(function()
			if entity:HasModifier("modifier_omninight_guardian_angel") then
				entity:AddNewModifier(entity, nil, "modifier_omniknight_guardian_angel_regen", {})
			else
				entity:RemoveModifierByName("modifier_omniknight_guardian_angel_regen")
			end
			return 1
		end, "Omni guardian health regen", 1)
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
end

function isAtWardPoint(position, x, y)
	return position[1] < x + 75 and position[1] > x - 75 and position[2] > y - 75 and position[2] < y + 75
end

function HandleEntityKilled(entityIdx, attackerIdx, inflictorIdx)
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
	end
	if ability ~= nil and ability:GetName() == "necrolyte_reapers_scythe" and attacker:HasScepter() and entity:IsRealHero() then
		entity:SetBuyBackDisabledByReapersScythe(true)
		print("renabling buyback after " .. entity:GetRespawnTime())
		entity:SetThink(function()
			entity:SetBuyBackDisabledByReapersScythe(false)
		end, "", {}, entity:GetRespawnTime())
	end
	if IsServer() and entity:IsRealHero() then
		handleKillBonus(attacker, entity)
	end
end

function handleKillBonus(attacker, entity)
	if attacker:GetTeam() == entity:GetTeam() then
		print("Denied, no gold/XP bonus")
		return
	end
	if attacker:IsCreep() and attacker:GetTeam() == DOTA_TEAM_NEUTRALS then
		print("killed by neutral, no gold/XP bonus")
		return
	end
	if not attacker:IsRealHero() and attacker:GetOwner() ~= nil then
		print("Setting attacker to the owner of the summoned units")
		attacker = attacker:GetOwner()
	end
	if attacker:IsHero() then
		print("gives extra 100 gold")
		attacker:ModifyGold(100, true, DOTA_ModifyGold_HeroKill)
		attacker:AddExperience(50, DOTA_ModifyXP_HeroKill, false, false)
	end
	-- give assist gold
	local assist_players = {}
	if entity.time_attacked ~= nil then
		local current_time = GameRules:GetDOTATime(true, false)
		for i,v in pairs(entity.time_attacked) do
			if current_time - v < 20 then
				assist_players[i] = true
			end
		end
	end
	local assist_gold = 4 * entity:GetLevel() + 0.2 * GetAssistGoldComebackFactor(entity:GetTeam()) * (
		PlayerResource:GetGoldSpentOnItems(entity:GetPlayerID()) + PlayerResource:GetGold(entity:GetPlayerID()))
	print("Assist gold " .. assist_gold)
	DeepPrintTable(assist_players)
	for i,v in pairs(assist_players) do
		PlayerResource:GetPlayer(i):GetAssignedHero():ModifyGold(assist_gold, false, DOTA_ModifyGold_HeroKill)
	end
	-- give experience
	local units = FindUnitsInRadius( entity:GetTeamNumber(), entity:GetAbsOrigin(), nil, 1500,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	
	-- add attacker the XP if out of range 
	if attacker:IsAlive() and attacker:IsHero() then
		local unitsContainsAttacker = false
		for i=1,#units do
			if units[i]:GetEntityIndex() == attacker:GetEntityIndex() then
				unitsContainsAttacker = true
				break
			end
		end
		if not unitsContainsAttacker then
			print("Adding attacker to xp bounty remotely")
			table.insert(units, attacker)
		end
	end

	local assist_exp = 7 * entity:GetLevel() + GetAssistXPComebackFactor(entity:GetTeam()) * PlayerResource:GetTotalEarnedXP(entity:GetPlayerID()) * 0.15
	print("Granting assist experience " .. assist_exp .. " to " .. #units .. " units.")
	for i=1,#units do
		if units[i].AddExperience ~= nil then
			print(units[i]:GetName())
			units[i]:AddExperience(assist_exp, DOTA_ModifyXP_HeroKill, false, false)
		end
	end
end

function GetAssistGoldComebackFactor(victim_team)
	local victim_team_total_gold = GetTeamTotalGold(victim_team)
	local attacker_team = DOTA_TEAM_BADGUYS
	if victim_team == DOTA_TEAM_BADGUYS then
		attacker_team = DOTA_TEAM_GOODGUYS
	end
	local attacker_team_total_gold = GetTeamTotalGold(attacker_team)
	local factor = victim_team_total_gold / attacker_team_total_gold - 1 
	print("Assist gold factor " .. factor)
	if factor < 0 then
		return 0
	elseif factor >= 1 then
		return 1
	else
		return factor
	end
end

function GetAssistXPComebackFactor(victim_team)
	local victim_team_total_gold = GetTeamTotalXP(victim_team)
	local attacker_team = DOTA_TEAM_BADGUYS
	if victim_team == DOTA_TEAM_BADGUYS then
		attacker_team = DOTA_TEAM_GOODGUYS
	end
	local attacker_team_total_gold = GetTeamTotalXP(attacker_team)
	local factor = (victim_team_total_gold - attacker_team_total_gold) / (attacker_team_total_gold + attacker_team_total_gold) 
	print("Assist exp factor " .. factor)
	if factor < 0 then
		return 0
	else
		return factor
	end
end

function GetTeamTotalGold(victim_team)
	local victim_team_total_gold = 0
	for i=1,PlayerResource:GetPlayerCountForTeam(victim_team) do
		local playerId = PlayerResource:GetNthPlayerIDOnTeam(victim_team, i)
		victim_team_total_gold = victim_team_total_gold + PlayerResource:GetGoldSpentOnItems(playerId) + PlayerResource:GetGold(playerId)
	end
	return victim_team_total_gold
end

function GetTeamTotalXP(victim_team)
	local victim_team_total_gold = 0
	for i=1,PlayerResource:GetPlayerCountForTeam(victim_team) do
		local playerId = PlayerResource:GetNthPlayerIDOnTeam(victim_team, i)
		victim_team_total_gold = victim_team_total_gold + PlayerResource:GetTotalEarnedXP(playerId)
	end
	return victim_team_total_gold
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
		hero:ModifyGold(bounty, true, DOTA_ModifyGold_BountyRune)
		hero:AddExperience(exp, DOTA_ModifyXP_TomeOfKnowledge, false, false)
		local bottle = hero:FindItemInInventory("item_bottle")
		if bottle ~= nil and bottle:GetItemState() == 1 then
			bottle:SetCurrentCharges(3)
		end
	end
end

function HandleEntityHurt(entindex_killed, entindex_attacker)
	local target = EntIndexToHScript(entindex_killed)
	local attacker = EntIndexToHScript(entindex_attacker)
	if attacker:GetPlayerOwner() == nil then
		return
	end
	if target:IsRealHero() then
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
	return true
end

function CAddonTemplateGameMode:ModifyExperienceFilter(event)
	if event.reason_const == DOTA_ModifyXP_Unspecified and event.experience > 50 then
		print("cap unspecified XP")
		event.experience = 50
	end
	return true
end