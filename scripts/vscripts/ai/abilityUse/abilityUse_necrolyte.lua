-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local necrolyteAbility = BotsInit.CreateGeneric()

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
    heroData.necrolyte.SKILL_0,
    heroData.necrolyte.SKILL_1,
    heroData.necrolyte.SKILL_2,
    heroData.necrolyte.SKILL_3
}

local abilityQ = ""
local abilityW = ""
local abilityE = ""
local abilityR = ""

local AttackRange   = 0
local ManaPerc      = 0.0
local HealthPerc    = 0.0
local modeName      = nil

function necrolyteAbility:AbilityUsageThink(bot)
    -- Check if we're already using an ability
    if utils.IsBusy(bot) then return true end
    
    -- Check to see if we are CC'ed
    if utils.IsUnableToCast(bot) then return false end

    if abilityQ == "" then abilityQ = bot:GetAbilityByName( Abilities[1] ) end
    if abilityW == "" then abilityW = bot:GetAbilityByName( Abilities[2] ) end
    if abilityE == "" then abilityE = bot:GetAbilityByName( Abilities[3] ) end
    if abilityR == "" then abilityR = bot:GetAbilityByName( Abilities[4] ) end
    
    local modeDesire    = Max(0.01, bot.SelfRef:getCurrentModeValue())
    
	ComboMana = GetComboMana({abilityQ, abilityR})
	ManaPerc = bot:GetManaPercent()
	HealthPerc = bot:GetHealthPercent()

    -- CHECK BELOW TO SEE WHICH ABILITIES ARE NOT PASSIVE AND WHAT RETURN TYPES ARE --
    -- Consider using each ability
	local castQDesire = ConsiderQ(bot)
	local castRDesire, castRTarget  = ConsiderR(bot)
    
    -- CHECK BELOW TO SEE WHAT PRIORITY OF ABILITIES YOU WANT FOR THIS HERO --
    -- YOU MIGHT ALSO WANT TO ADD OTHER CONDITIONS TO WHEN TO CAST WHAT     --
    -- EXAMPLE: 
    -- if castRDesire >= modeDesire and castRDesire >= Max(CastEDesire, CastWDesire) then
	
	if castRDesire >= modeDesire then
		gHeroVar.HeroUseAbilityOnEntity(bot, abilityR, castRTarget)
		return true
	end

	if castQDesire >= modeDesire then
		gHeroVar.HeroUseAbility(bot, abilityQ)
		return true
	end
    
    return false
end

local CanCast = {
	NormalCanCastFunction,
	nil,
	nil,
	NormalCanCastFunction
}

local function GetComboDamage(bot)
	local tempComboDamage = 0
	if abilityQ:GetLevel() > 0 then
		tempComboDamage = tempComboDamage + abilityQ:GetAbilityDamage()
	end
	if ablilityR:GetLevel() > 0 then
		tempComboDamage = tempComboDamage + abilityR:GetLevel() * 150
	end
	return math.max(tempComboDamage, GetOffensivePower(bot))
end

function ConsiderQ(bot)
	local ability = abilityQ
	local npcBot = bot
	local abilityNumber = 1
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end

    local CastRange = 0
    local Damage = ability:GetAbilityDamage()
    local Radius = ability:GetSpecialValueFor("radius")
    local CastPoint = ability:GetCastPoint()
    local allys = GetNearbyHeroes(npcBot, Radius, false, BOT_MODE_NONE)
    local WeakestAlly, AllyHealth = GetWeakestUnit(allys)
    local enemys = GetNearbyHeroes(npcBot, Radius, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = GetWeakestUnit(enemys)
    local creeps = GetNearbyCreeps(npcBot, Radius, true)
    local WeakestCreep, CreepHealth = GetWeakestUnit(creeps)
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if CanCast[abilityNumber](WeakestEnemy) then
                if HeroHealth <= GetActualIncomingDamage(WeakestEnemy, Damage, DAMAGE_TYPE_MAGICAL) or
                    (
                    HeroHealth <= GetActualIncomingDamage(WeakestEnemy, GetComboDamage(bot), DAMAGE_TYPE_MAGICAL) and
                        npcBot:GetMana() > ComboMana) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end
    if ManaPerc > 50 or npcBot:GetMana() > ComboMana then
        for _, npcTarget in pairs(allys) do
            if npcTarget:GetHealth() / npcTarget:GetMaxHealth() < (0.6 + #enemys * 0.05) then
                if CanCast[abilityNumber](npcTarget) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end
    if ManaPerc > 40 or npcBot:GetMana() > ComboMana or npcBot:GetActiveMode() == BOT_MODE_RETREAT then
        if (WasRecentlyDamagedByAnyHero(npcBot, 2) and #enemys >= 1) or #enemys >= 2 or HealthPerc <= 40 then
            for _, npcEnemy in pairs(enemys) do
                if CanCast[abilityNumber](npcEnemy) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_PUSH_LANE or npcBot:GetActiveMode() == BOT_MODE_DEFEND_LANE then
        if #enemys + #creeps >= 5 then
            if ManaPerc > 60 or npcBot:GetMana() > ComboMana * 1.5 then
                return BOT_ACTION_DESIRE_MODERATE, WeakestEnemy
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if ManaPerc > 75 then
            if WeakestEnemy ~= nil and WeakestCreep ~= nil then
                if CanCast[abilityNumber](WeakestEnemy) then
                    return BOT_ACTION_DESIRE_LOW
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if #creeps >= 4 then
            if ManaPerc > 50 or npcBot:GetMana() > ComboMana then
                return BOT_ACTION_DESIRE_MODERATE
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or
        npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = npcBot:GetTarget()
        if npcEnemy ~= nil then
            if CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) <= Radius then
                return BOT_ACTION_DESIRE_MODERATE
            end
        end
    end
	return BOT_ACTION_DESIRE_NONE, 0
end

function ConsiderR(bot)
	local ability = abilityR
	local npcBot = bot
    if not abilityR:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end

    local CastRange = ability:GetCastRange()
    local DamagePercent = ability:GetSpecialValueFor("damage_per_health")
    local allys = GetNearbyHeroes(npcBot, 1200, false, BOT_MODE_NONE)
    local enemys = GetNearbyNonIllusionHeroes(npcBot, CastRange + 300, true, 0)
    local WeakestEnemy, HeroHealth = GetWeakestUnit(enemys)

    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        for i, npcEnemy in pairs(enemys) do
            if NormalCanCastFunction(npcEnemy) and not npcEnemy:IsMagicImmune() then
                local Damage = (npcEnemy:GetMaxHealth() - npcEnemy:GetHealth()) * DamagePercent * (1 + #allys * 0.06)
                if npcEnemy:GetHealth() <= GetActualIncomingDamage(npcEnemy, Damage, DAMAGE_TYPE_MAGICAL) then
                    return BOT_ACTION_DESIRE_HIGH, npcEnemy
                end
            end
        end
    end
	return BOT_ACTION_DESIRE_NONE, 0
end

function necrolyteAbility:nukeDamage( bot, enemy )
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

function necrolyteAbility:queueNuke(bot, enemy, castQueue, engageDist)
    if not utils.ValidTarget(enemy) then return false end
    
    -- WRITE CODE HERE --
    
    return false
end

return necrolyteAbility
