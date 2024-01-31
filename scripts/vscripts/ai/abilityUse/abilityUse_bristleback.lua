
-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local bristlebackAbility = BotsInit.CreateGeneric()

local heroData = require( GetScriptDirectory().."/hero_data" )
local utils = require( GetScriptDirectory().."/utility" )
local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )

function setHeroVar(bot, var, value)
    gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

function getHeroVar(bot, var)
    return gHeroVar.GetVar(bot:GetPlayerID(), var)
end

local Abilities = {
    heroData.bristleback.SKILL_0,
    heroData.bristleback.SKILL_1,
    heroData.bristleback.SKILL_2,
    heroData.bristleback.SKILL_3
}

local abilityQ = ""
local abilityW = ""
local abilityE = ""
local abilityR = ""

local AttackRange   = 0
local ManaPerc      = 0.0
local HealthPerc    = 0.0
local modeName      = nil

function bristlebackAbility:AbilityUsageThink(bot)
    -- Check if we're already using an ability
    if utils.IsBusy(bot) then return true end
    
    -- Check to see if we are CC'ed
    if utils.IsUnableToCast(bot) then return false end

    if abilityQ == "" then abilityQ = bot:GetAbilityByName( Abilities[1] ) end
    if abilityW == "" then abilityW = bot:GetAbilityByName( Abilities[2] ) end
    if abilityE == "" then abilityE = bot:GetAbilityByName( Abilities[3] ) end
    if abilityR == "" then abilityR = bot:GetAbilityByName( Abilities[4] ) end
    
    local modeDesire    = Max(0.01, bot.SelfRef:getCurrentModeValue())
    
    -- CHECK BELOW TO SEE WHICH ABILITIES ARE NOT PASSIVE AND WHAT RETURN TYPES ARE --
    -- Consider using each ability
	local castQDesire, castQTarget  = ConsiderQ(bot)
	local castWDesire = ConsiderW(bot)
    
    -- CHECK BELOW TO SEE WHAT PRIORITY OF ABILITIES YOU WANT FOR THIS HERO --
    -- YOU MIGHT ALSO WANT TO ADD OTHER CONDITIONS TO WHEN TO CAST WHAT     --
    -- EXAMPLE: 
    -- if castRDesire >= modeDesire and castRDesire >= Max(CastEDesire, CastWDesire) then
	
	if castWDesire >= modeDesire then
		gHeroVar.HeroUseAbility(bot, abilityW)
		return true
	end

	if castQDesire >= modeDesire then
		gHeroVar.HeroUseAbilityOnEntity(bot, abilityQ, castQTarget)
		return true
	end
    
    return false
end

function ConsiderQ(bot)
	local ability = abilityQ
	local npcBot = bot
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end
	--TODO fill
	return BOT_ACTION_DESIRE_NONE, 0
end

function ConsiderW(bot)
	local ability = abilityW
	local npcBot = bot
    if not abilityW:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE
	end
    
	--TODO fill

	return BOT_ACTION_DESIRE_NONE, 0
end

function bristlebackAbility:nukeDamage( bot, enemy )
    if not utils.ValidTarget(enemy) then return 0, {}, 0, 0, 0 end

    local comboQueue = {}
    local manaAvailable = bot:GetMana()
    local dmgTotal = GetOffensivePower(bot)
    local castTime = 0
    local stunTime = 0
    local slowTime = 0
    local engageDist = 500
    
    -- WRITE CODE HERE --
    -- local physImmune = modifiers.IsPhysicalImmune(enemy)
    -- local magicImmune = utils.IsTargetMagicImmune(enemy)
    
    if abilityQ:IsFullyCastable() then
    local manaCostQ = abilityQ:GetManaCost(-1)
        if manaCostQ <= manaAvailable then
            manaAvailable = manaAvailable - manaCostQ
            --dmgTotal = dmgTotal + XYZ
            --castTime = castTime + abilityQ:GetCastPoint()
            --stunTime = stunTime + XYZ
            --engageDist = Min(engageDist, abilityQ:GetCastRange())
            table.insert(comboQueue, abilityQ)
        end
    end
    
    return dmgTotal, comboQueue, castTime, stunTime, slowTime, engageDist
end

function bristlebackAbility:queueNuke(bot, enemy, castQueue, engageDist)
    if not utils.ValidTarget(enemy) then return false end
    
    -- WRITE CODE HERE --
    
    return false
end

return bristlebackAbility
