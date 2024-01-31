
require("ai/ai_util")

local heroData = require( GetScriptDirectory().."/hero_data" )
local utils = require( GetScriptDirectory().."/utility" )
local dt = require( GetScriptDirectory().."/decision" )
local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )
local ability = require( GetScriptDirectory().."/abilityUse/abilityUse_skeleton_king" )

function setHeroVar(bot, var, value)
    gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

local SKILL_Q = heroData.skeleton_king.SKILL_0
local SKILL_W = heroData.skeleton_king.SKILL_1
local SKILL_E = heroData.skeleton_king.SKILL_2
local SKILL_R = heroData.skeleton_king.SKILL_3

local TALENT1 = heroData.skeleton_king.TALENT_0
local TALENT3 = heroData.skeleton_king.TALENT_2
local TALENT6 = heroData.skeleton_king.TALENT_5
local TALENT8 = heroData.skeleton_king.TALENT_7

local skeleKingAbilityPriority = {
    SKILL_Q,    SKILL_E,    SKILL_Q,    SKILL_W,    SKILL_Q,
    SKILL_R,    SKILL_Q,    SKILL_E,    SKILL_E,    SKILL_E,
    SKILL_R,    SKILL_W,    SKILL_W,    SKILL_W,    TALENT1,
    SKILL_R,    TALENT3,    TALENT6,    TALENT8
}

local botSkeleKing = dt:new()

function botSkeleKing:new(o)
    o = o or dt:new(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

local skeleKingBot = botSkeleKing:new{abilityPriority = skeleKingAbilityPriority}

function skeleKingBot:ConsiderAbilityUse(bot)
    return ability.AbilityUsageThink(bot)
end

function skeleKingBot:GetNukeDamage(bot, target)
    return ability.nukeDamage( bot, target )
end

function skeleKingBot:QueueNuke(bot, target, actionQueue, engageDist)
    return ability.queueNuke( bot, target, actionQueue, engageDist )
end

function skeleKingBot:DoHeroSpecificInit(bot)
end

function Think(bot)
    skeleKingBot:Think(bot)
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
