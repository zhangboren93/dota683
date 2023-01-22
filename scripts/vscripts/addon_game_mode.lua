-- Generated from template

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

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

	LinkLuaModifier( "modifier_bonus_strength_lua", "modifiers/bonus_strength.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_necronomicon_bonus_intellect", "modifiers/necronomicon_bonus_intellect.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_necronomicon_2_bonus_intellect", "modifiers/necronomicon_2_bonus_intellect.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_necronomicon_3_bonus_intellect", "modifiers/necronomicon_3_bonus_intellect.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_dagon_damage_lua", "modifiers/dagon_bonus_damage.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_refresher_bonus_lua", "modifiers/refresher_bonus.lua", LUA_MODIFIER_MOTION_NONE)
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	
	-- TODO: Add more attribute stat
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP, 19)
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP_REGEN, 0.03)
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR, 0.17)
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA, 13)
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN, 0.04)
	
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
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(25)
	GameRules:GetGameModeEntity():SetFreeCourierModeEnabled(true)

	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(CAddonTemplateGameMode, "OrderFilter"), self)
	ListenToGameEvent('npc_spawned', function(event)
		HandleNpcSpawned(event.entindex, event.is_respawn)
	end, nil)
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

-- Add the order filter to your game mode entity
-- TODO tell user glyph and scan are disabled
function CAddonTemplateGameMode:OrderFilter(event)
    --Check if the order is the glyph type
    if event.order_type == DOTA_UNIT_ORDER_GLYPH then
		return false
    end
	if event.order_type == DOTA_UNIT_ORDER_RADAR then
		return false
    end
    --Return true by default to keep all other orders the same
    return true
end

function HandleNpcSpawned(entityIndex, is_respawn)
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
    end
end