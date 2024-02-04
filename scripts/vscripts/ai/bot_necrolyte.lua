
require("ai/ai_util")

local heroData = require( GetScriptDirectory().."/hero_data" )
local utils = require( GetScriptDirectory().."/utility" )
local dt = require( GetScriptDirectory().."/decision" )
local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )
local ability = require( GetScriptDirectory().."/abilityUse/abilityUse_necrolyte" )

function setHeroVar(bot, var, value)
    gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

local SKILL_Q = heroData.necrolyte.SKILL_0
local SKILL_W = heroData.necrolyte.SKILL_1
local SKILL_E = heroData.necrolyte.SKILL_2
local SKILL_R = heroData.necrolyte.SKILL_3

local TALENT1 = heroData.necrolyte.TALENT_0
local TALENT3 = heroData.necrolyte.TALENT_2
local TALENT6 = heroData.necrolyte.TALENT_5
local TALENT8 = heroData.necrolyte.TALENT_7

local necrolyteAbilityPriority = {
    SKILL_Q,    SKILL_W,    SKILL_Q,    SKILL_W,    SKILL_E,
    SKILL_R,    SKILL_W,    SKILL_W,    SKILL_E,    SKILL_E,
    SKILL_R,    SKILL_Q,    SKILL_Q,    SKILL_E,    TALENT1,
    SKILL_R,    TALENT3,    TALENT6,    TALENT8
}

local botNecro = dt:new()

function botNecro:new(o)
    o = o or dt:new(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

local necrolyteBot = botNecro:new{abilityPriority = necrolyteAbilityPriority}

function necrolyteBot:ConsiderAbilityUse(bot)
    return ability.AbilityUsageThink(bot)
end

function necrolyteBot:GetNukeDamage(bot, target)
    return ability.nukeDamage( bot, target )
end

function necrolyteBot:QueueNuke(bot, target, actionQueue, engageDist)
    return ability.queueNuke( bot, target, actionQueue, engageDist )
end

function necrolyteBot:DoHeroSpecificInit(bot)
end

function Think(bot)
    necrolyteBot:Think(bot)
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
