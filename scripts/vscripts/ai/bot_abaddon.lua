
require("ai/ai_util")

local heroData = require( GetScriptDirectory().."/hero_data" )
local utils = require( GetScriptDirectory().."/utility" )
local dt = require( GetScriptDirectory().."/decision" )
local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )
local ability = require( GetScriptDirectory().."/abilityUse/abilityUse_abaddon" )

function setHeroVar(bot, var, value)
    gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

local SKILL_Q = heroData.abaddon.SKILL_0
local SKILL_W = heroData.abaddon.SKILL_1
local SKILL_E = heroData.abaddon.SKILL_2
local SKILL_R = heroData.abaddon.SKILL_3

local TALENT1 = heroData.abaddon.TALENT_0
local TALENT3 = heroData.abaddon.TALENT_2
local TALENT6 = heroData.abaddon.TALENT_5
local TALENT8 = heroData.abaddon.TALENT_7

local abaddonAbilityPriority = {
    SKILL_W,    SKILL_E,    SKILL_W,    SKILL_E,    SKILL_W,
    SKILL_R,    SKILL_W,    SKILL_E,    SKILL_E,    SKILL_Q,
    SKILL_R,    SKILL_Q,    SKILL_Q,    SKILL_Q,    TALENT1,
    SKILL_R,    TALENT3,    TALENT6,    TALENT8
}

local botAba = dt:new()

function botAba:new(o)
    o = o or dt:new(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

local abaBot = botAba:new{abilityPriority = abaddonAbilityPriority}

function abaBot:ConsiderAbilityUse(bot)
    return ability.AbilityUsageThink(bot)
end

function abaBot:GetNukeDamage(bot, target)
    return ability.nukeDamage( bot, target )
end

function abaBot:QueueNuke(bot, target, actionQueue, engageDist)
    return ability.queueNuke( bot, target, actionQueue, engageDist )
end

function abaBot:DoHeroSpecificInit(bot)
end

function Think(bot)
    abaBot:Think(bot)
end

function Spawn()
    if not IsServer() then return end
    if thisEntity == nil then return end
	SetBot(thisEntity)
    thisEntity:SetThink(function()
        if not thisEntity:IsAlive() then return 1 end
        if GameRules:IsGamePaused() then return 0.5 end
        local ret,error = xpcall(function() Think(thisEntity) end, function() print(debug.traceback) end)
		if not ret then print(error); GameRules:SendCustomMessage(error, -1, -1); return 3; end
        return 0.1
    end, "WrapThink", 0.1)
end
