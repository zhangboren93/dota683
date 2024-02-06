-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

require("ai/ai_util")
require( GetScriptDirectory().."/constants" )

local heroData = require( GetScriptDirectory().."/hero_data" )
local utils = require( GetScriptDirectory().."/utility" )
local dt = require( GetScriptDirectory().."/decision" )
local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )
local ability = require( GetScriptDirectory().."/abilityUse/abilityUse_sniper" )

local SKILL_Q = heroData.sniper.SKILL_0
local SKILL_W = heroData.sniper.SKILL_1
local SKILL_E = heroData.sniper.SKILL_2
local SKILL_R = heroData.sniper.SKILL_3

local TALENT1 = heroData.sniper.TALENT_0
local TALENT2 = heroData.sniper.TALENT_1
local TALENT3 = heroData.sniper.TALENT_2
local TALENT4 = heroData.sniper.TALENT_3
local TALENT5 = heroData.sniper.TALENT_4
local TALENT6 = heroData.sniper.TALENT_5
local TALENT7 = heroData.sniper.TALENT_6
local TALENT8 = heroData.sniper.TALENT_7

local AbilityPriority = {
    SKILL_W,    SKILL_Q,    SKILL_Q,    SKILL_E,    SKILL_E,
    SKILL_R,    SKILL_W,    SKILL_W,    SKILL_W,    SKILL_E,
    SKILL_R,    SKILL_E,    SKILL_Q,    SKILL_Q,    TALENT2,
    SKILL_R,    TALENT3,    TALENT6,    TALENT8
}

local botSniper = dt:new()

function botSniper:new(o)
    o = o or dt:new(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

local sniperBot = botSniper:new{abilityPriority = AbilityPriority}

function sniperBot:DoHeroSpecificInit(bot)
end

function sniperBot:ConsiderAbilityUse(bot)
    return ability.AbilityUsageThink()
end

function sniperBot:GetNukeDamage(bot, target)
    return ability.nukeDamage( bot, target )
end

function sniperBot:QueueNuke(bot, target, actionQueue, engageDist)
    return ability.queueNuke( bot, target, actionQueue, engageDist )
end

function Think(bot)
    sniperBot:Think(bot)
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
