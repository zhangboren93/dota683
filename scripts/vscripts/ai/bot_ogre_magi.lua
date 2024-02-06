
require("ai/ai_util")

local heroData = require( GetScriptDirectory().."/hero_data" )
local utils = require( GetScriptDirectory().."/utility" )
local dt = require( GetScriptDirectory().."/decision" )
local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )
local ability = require( GetScriptDirectory().."/abilityUse/abilityUse_ogre_magi" )

function setHeroVar(bot, var, value)
    gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

local SKILL_Q = heroData.ogre_magi.SKILL_0
local SKILL_W = heroData.ogre_magi.SKILL_1
local SKILL_E = heroData.ogre_magi.SKILL_2
local SKILL_R = heroData.ogre_magi.SKILL_4

local TALENT1 = heroData.ogre_magi.TALENT_0
local TALENT3 = heroData.ogre_magi.TALENT_2
local TALENT6 = heroData.ogre_magi.TALENT_5
local TALENT8 = heroData.ogre_magi.TALENT_7

local ogre_magiAbilityPriority = {
    SKILL_W,    SKILL_Q,    SKILL_W,    SKILL_Q,    SKILL_W,
    SKILL_R,    SKILL_W,    SKILL_Q,    SKILL_Q,    SKILL_E,
    SKILL_R,    SKILL_E,    SKILL_E,    SKILL_E,    TALENT1,
    SKILL_R,    TALENT3,    TALENT6,    TALENT8
}

local botOgre = dt:new()

function botOgre:new(o)
    o = o or dt:new(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

local ogreBot = botOgre:new{abilityPriority = ogre_magiAbilityPriority}

function ogreBot:ConsiderAbilityUse(bot)
    return ability.AbilityUsageThink(bot)
end

function ogreBot:GetNukeDamage(bot, target)
    return ability.nukeDamage( bot, target )
end

function ogreBot:QueueNuke(bot, target, actionQueue, engageDist)
    return ability.queueNuke( bot, target, actionQueue, engageDist )
end

function ogreBot:DoHeroSpecificInit(bot)
end

function Think(bot)
    ogreBot:Think(bot)
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
