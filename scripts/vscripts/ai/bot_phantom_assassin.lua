-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

require("ai/ai_util")
local heroData = require( GetScriptDirectory().."/hero_data" )
local utils = require( GetScriptDirectory().."/utility" )
local dt = require( GetScriptDirectory().."/decision" )
local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )
local ability = require( GetScriptDirectory().."/abilityUse/abilityUse_phantom_assassin" )

function setHeroVar(bot, var, value)
    gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

function getHeroVar(bot, var)
    return gHeroVar.GetVar(bot:GetPlayerID(), var)
end

local SKILL_Q = heroData.phantom_assassin.SKILL_0
local SKILL_W = heroData.phantom_assassin.SKILL_1
local SKILL_E = heroData.phantom_assassin.SKILL_2
local SKILL_R = heroData.phantom_assassin.SKILL_3

local TALENT1 = heroData.phantom_assassin.TALENT_0
local TALENT2 = heroData.phantom_assassin.TALENT_1
local TALENT3 = heroData.phantom_assassin.TALENT_2
local TALENT4 = heroData.phantom_assassin.TALENT_3
local TALENT5 = heroData.phantom_assassin.TALENT_4
local TALENT6 = heroData.phantom_assassin.TALENT_5
local TALENT7 = heroData.phantom_assassin.TALENT_6
local TALENT8 = heroData.phantom_assassin.TALENT_7

local AbilityPriority = {
    SKILL_Q,    SKILL_W,    SKILL_Q,    SKILL_E,    SKILL_Q,
    SKILL_R,    SKILL_Q,    SKILL_W,    SKILL_W,    SKILL_W,
    SKILL_R,    SKILL_E,    SKILL_E,    SKILL_E,    TALENT1,
    SKILL_R,    SKILL_3,    TALENT6,    TALENT7
}

local botPA = dt:new()

function botPA:new(o)
    o = o or dt:new(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

local paBot = botPA:new{abilityPriority = AbilityPriority}

function paBot:ConsiderAbilityUse(bot)
    return ability.AbilityUsageThink(bot)
end

function paBot:GetNukeDamage(bot, target)
    return ability.nukeDamage( bot, target )
end

function paBot:QueueNuke(bot, target, actionQueue, engageDist)
    return ability.queueNuke( bot, target, actionQueue, engageDist )
end

function paBot:DoHeroSpecificInit(bot)
    local mvAbility = bot:GetAbilityByName(SKILL_W)
    self:setHeroVar(bot, "HasMovementAbility", {mvAbility, mvAbility:GetCastRange()})
    self:setHeroVar(bot, "HasEscape", {mvAbility, mvAbility:GetCastRange()})
end

function Think(bot)
    if bot:HasModifier("modifier_phantom_strike_datadriven") and IsValidEntity(bot:GetTarget()) then
        bot:Action_AttackUnit(bot:GetTarget(), false)
        return
    end
    paBot:Think(bot)
end

function Spawn()
    if not IsServer() then return end
    if thisEntity == nil then return end
	SetBot(thisEntity)
    thisEntity:SetThink(function()
        if not thisEntity:IsAlive() then return 1 end
        if GameRules:IsGamePaused() then return 0.5 end
        local ret,error = xpcall(function() Think(thisEntity) end, function() print(debug.traceback()) end)
		if not ret then print(error); GameRules:SendCustomMessage(error, -1, -1); return 3; end
        return 0.1
    end, "WrapThink", 0.1)
end
