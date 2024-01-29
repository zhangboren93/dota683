-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

require("ai/ai_util")

local heroData = require( GetScriptDirectory().."/hero_data" )
local utils = require( GetScriptDirectory().."/utility" )
local dt = require( GetScriptDirectory().."/decision" )
local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )
local ability = require( GetScriptDirectory().."/abilityUse/abilityUse_antimage" )

function setHeroVar(bot, var, value)
    gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

local SKILL_Q = heroData.antimage.SKILL_0
local SKILL_W = heroData.antimage.SKILL_1
local SKILL_E = heroData.antimage.SKILL_2
local SKILL_R = heroData.antimage.SKILL_3

local TALENT1 = heroData.antimage.TALENT_0
local TALENT2 = heroData.antimage.TALENT_1
local TALENT3 = heroData.antimage.TALENT_2
local TALENT4 = heroData.antimage.TALENT_3
local TALENT5 = heroData.antimage.TALENT_4
local TALENT6 = heroData.antimage.TALENT_5
local TALENT7 = heroData.antimage.TALENT_6
local TALENT8 = heroData.antimage.TALENT_7

local AntimageAbilityPriority = {
    SKILL_W,    SKILL_Q,    SKILL_Q,    SKILL_E,    SKILL_Q,
    SKILL_R,    SKILL_Q,    SKILL_W,    SKILL_W,    TALENT1,
    SKILL_W,    SKILL_R,    SKILL_E,    SKILL_E,    TALENT4,
    SKILL_E,    SKILL_R,    TALENT6,    TALENT8
}

local botAM = dt:new()

function botAM:new(o)
    o = o or dt:new(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

local amBot = botAM:new{abilityPriority = AntimageAbilityPriority}

function amBot:ConsiderAbilityUse(bot)
    return ability.AbilityUsageThink(bot)
end

function amBot:GetNukeDamage(bot, target)
    return ability.nukeDamage( bot, target )
end

function amBot:QueueNuke(bot, target, actionQueue, engageDist)
    return ability.queueNuke( bot, target, actionQueue, engageDist )
end

function amBot:DoHeroSpecificInit(bot)
    local mvAbility = bot:GetAbilityByName(SKILL_W)
    self:setHeroVar(bot, "HasMovementAbility", {mvAbility, mvAbility:GetSpecialValueFor("blink_range")})
    self:setHeroVar(bot, "HasEscape", {mvAbility, mvAbility:GetSpecialValueFor("blink_range")})
end

function Think(bot)
    amBot:Think(bot)
end

function Spawn()
    if not IsServer() then return end
    if thisEntity == nil then return end
	SetBot(thisEntity)
    thisEntity:SetThink(function()
        if not thisEntity:IsAlive() then return 1 end
        if GameRules:IsGamePaused() then return 0.5 end
        Think(thisEntity)
        return 0.1
    end, "WrapThink", 0.1)
end
