require("ai/ai_util")

local heroData = require( GetScriptDirectory().."/hero_data" )
local utils = require( GetScriptDirectory().."/utility" )
local dt = require( GetScriptDirectory().."/decision" )
local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )
local ability = require( GetScriptDirectory().."/abilityUse/abilityUse_bristleback" )

function setHeroVar(bot, var, value)
    gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

local SKILL_Q = heroData.bristleback.SKILL_0
local SKILL_W = heroData.bristleback.SKILL_1
local SKILL_E = heroData.bristleback.SKILL_2
local SKILL_R = heroData.bristleback.SKILL_3

local TALENT1 = heroData.bristleback.TALENT_0
local TALENT3 = heroData.bristleback.TALENT_2
local TALENT6 = heroData.bristleback.TALENT_5
local TALENT8 = heroData.bristleback.TALENT_7

local bristlebackAbilityPriority = {
    SKILL_W,    SKILL_E,    SKILL_W,    SKILL_Q,    SKILL_W,
    SKILL_R,    SKILL_W,    SKILL_E,    SKILL_E,    SKILL_E,
    SKILL_R,    SKILL_Q,    SKILL_Q,    SKILL_Q,    TALENT1,
    SKILL_R,    TALENT3,    TALENT6,    TALENT8
}

local botBB = dt:new()

function botBB:new(o)
    o = o or dt:new(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

local bbBot = botBB:new{abilityPriority = bristlebackAbilityPriority}

function bbBot:ConsiderAbilityUse(bot)
    return ability.AbilityUsageThink(bot)
end

function bbBot:GetNukeDamage(bot, target)
    return ability.nukeDamage( bot, target )
end

function bbBot:QueueNuke(bot, target, actionQueue, engageDist)
    return ability.queueNuke( bot, target, actionQueue, engageDist )
end

function bbBot:DoHeroSpecificInit(bot)
end

function Think(bot)
    bbBot:Think(bot)
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
