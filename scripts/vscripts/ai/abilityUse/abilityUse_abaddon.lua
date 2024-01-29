-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local abaddonAbility = BotsInit.CreateGeneric()

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
    heroData.abaddon.SKILL_0,
    heroData.abaddon.SKILL_1,
    heroData.abaddon.SKILL_2,
    heroData.abaddon.SKILL_3
}

local abilityQ = ""
local abilityW = ""
local abilityE = ""
local abilityR = ""

local AttackRange   = 0
local ManaPerc      = 0.0
local HealthPerc    = 0.0
local modeName      = nil

function abaddonAbility:AbilityUsageThink(bot)
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
	local castWDesire, castWTarget  = ConsiderW(bot)
    
    -- CHECK BELOW TO SEE WHAT PRIORITY OF ABILITIES YOU WANT FOR THIS HERO --
    -- YOU MIGHT ALSO WANT TO ADD OTHER CONDITIONS TO WHEN TO CAST WHAT     --
    -- EXAMPLE: 
    -- if castRDesire >= modeDesire and castRDesire >= Max(CastEDesire, CastWDesire) then
	
	if castWDesire >= modeDesire then
		gHeroVar.HeroUseAbilityOnEntity(bot, abilityW, castWTarget)
		return true
	end

	if castQDesire >= modeDesire then
		gHeroVar.HeroUseAbilityOnEntity(bot, abilityQ, castQTarget)
		return true
	end
    
    return false
end

function ConsiderQ(bot)
    if not abilityQ:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, nil
	end
    
    -- WRITE CODE HERE --
    
    return BOT_ACTION_DESIRE_NONE, nil
end

local function CanCast2(npcEnemy)
	return not npcEnemy:IsOutOfGame() and 
		   not npcEnemy:IsInvulnerable() and 
		   not npcEnemy:HasModifier("modifier_abaddon_aphotic_shield")
end

function ConsiderW(bot)
    if not abilityW:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE
	end
    
	local ability = abilityW
	local npcBot = bot
	local CastRange = ability:GetCastRange(nil, nil)
	local ManaPercentage = npcBot:GetManaPercent()
    local HealthPercentage = npcBot:GetHealthPercent()

	local allys = GetNearbyNonIllusionHeroes(npcBot, CastRange + 200, false)
    local allys_filtered = {}
    for i=1,#allys do
        if CanCast2(allys[i]) and 
            (WasRecentlyDamagedByAnyHero(allys[i], 4) or WasRecentlyDamagedByTower(allys[i], 2)) then
            table.insert(allys_filtered, allys[i])
        end
    end
    allys = allys_filtered

	local WeakestAlly, AllyHealth = GetWeakestUnit(allys)
	local enemys = GetNearbyHeroes(npcBot, CastRange + 300, true, BOT_MODE_NONE)
	local creeps = GetNearbyCreeps(npcBot, CastRange + 300, true)
	local function Rate(it)
		local rate = 0
		if it == npcBot then
			rate = rate + 15
		end
		if IsSeverelyDisabled(it) then
			rate = rate + 30
		end
		if GetMovementSpeedPercent(it) <= 0.3 then
			rate = rate + 15
		elseif GetMovementSpeedPercent(it) <= 0.7 then
			rate = rate + 8
		end
		if it:GetHealthPercent() <= 30 then
			rate = rate + 20
		elseif it:GetHealthPercent() <= 70 then
			rate = rate + 8
		end
		return rate
	end

    if #allys == 0 then
        return BOT_ACTION_DESIRE_NONE, nil
    end
    local maxAllyIdx = 1
    local maxAllyRate = Rate(allys[1])
    for i=2,#allys do
        if Rate(allys[i]) > maxAllyRate then
            maxAllyIdx = i
            maxAllyRate = Rate(allys[i])
        end
    end
    if maxAllyRate >= 15 then
		local t = allys[maxAllyIdx]
		local rate = maxAllyRate
		return Script_RemapValClamped(rate, 15, 80, BOT_ACTION_DESIRE_MODERATE - 0.1, BOT_ACTION_DESIRE_VERYHIGH), t
    end
	if IsAttackingEnemies(npcBot) then
		if WeakestAlly ~= nil then
			if AllyHealth / WeakestAlly:GetMaxHealth() < 0.3 then
				if CanCast2(WeakestAlly) then
					return BOT_ACTION_DESIRE_MODERATE, WeakestAlly
				end
			end
		end
		for _, npcTarget in pairs(allys) do
			if npcTarget:GetHealth() / npcTarget:GetMaxHealth() < (0.6 + #enemys * 0.05 + 0.002 * ManaPercentage) or
				npcTarget:WasRecentlyDamagedByAnyHero(5.0) then
				if CanCast2(npcTarget) then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget
				end
			end
		end
	end
	if npcBot:GetActiveMode() == "pushlane" or npcBot:GetActiveMode() == "defendlane" then
		if #enemys + #creeps >= 3 then
			if ManaPercentage > 40 then
				for _, npcTarget in pairs(allys) do
					if CanCast2(npcTarget) then
						return BOT_ACTION_DESIRE_MODERATE, npcTarget
					end
				end
			end
		end
	end
	if npcBot:GetActiveMode() == "defendally" or npcBot:GetActiveMode() == "fight" then
		local npcEnemy = npcBot:GetTarget()
		if ManaPercentage > 40 and HealthPercentage <= 66 then
			if npcEnemy ~= nil then
				if CanCast2(npcBot) then
					return BOT_ACTION_DESIRE_MODERATE, npcBot
				end
			end
		end
	end
	if npcBot:GetActiveMode() == "laning" then
		if #enemys >= 1 and CanCast2(npcBot) then
			if npcBot:GetMana() > npcBot:GetMaxMana() * 0.7 + ability:GetManaCost(ability:GetLevel()) then
				return BOT_ACTION_DESIRE_LOW, npcBot
			end
		end
	end
	return BOT_ACTION_DESIRE_NONE, 0
end

function abaddonAbility:nukeDamage( bot, enemy )
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
    
    if abilityW:IsFullyCastable() then
        local manaCostW = abilityW:GetManaCost(-1)
        if manaCostW <= manaAvailable then
            manaAvailable = manaAvailable - manaCostW
            --dmgTotal = dmgTotal + XYZ
            --castTime = castTime + abilityW:GetCastPoint()
            --stunTime = stunTime + XYZ
            --engageDist = Min(engageDist, abilityW:GetCastRange())
            table.insert(comboQueue, abilityW)
        end
    end
    
    return dmgTotal, comboQueue, castTime, stunTime, slowTime, engageDist
end

function abaddonAbility:queueNuke(bot, enemy, castQueue, engageDist)
    if not utils.ValidTarget(enemy) then return false end
    
    -- WRITE CODE HERE --
    
    return false
end

return abaddonAbility
