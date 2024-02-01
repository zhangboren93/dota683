
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

local friends
local enemies
local ComboMana

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
    
	friends = GetNearbyNonIllusionHeroes(bot, 1500, false)
	enemies = GetNearbyNonIllusionHeroes(bot, 1200, true)
    ManaPerc = bot:GetManaPercent()
    ComboMana = GetComboMana({abilityQ, abilityW});

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

local CanCast = {
    NormalCanCastFunction,
    PhysicalCanCastFunction,
}
function ConsiderQ(bot)
	local ability = abilityQ
	local npcBot = bot
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end
    local castRange = ability:GetCastRange()

	-- when one ally is nearby
	local friends_filtered = {}
	for i=1,#friends do 
		if CanBeEngaged(friends[i]) then
			table.insert(friends_filtered, friends[i])
		end
	end
	if #friends_filtered >= 2 then
		local enemy_filtered = {}
		for i=1,#enemies do
			if CanCast[1](enemies[i]) then
				table.insert(enemy_filtered, enemies[i])
			end
		end
		if #enemy_filtered > 0 then
			local target = enemy_filtered[0]
			local maxDamage = GetEstimatedDamageToTarget(npcBot, false, enemy_filtered[1], 3, DAMAGE_TYPE_ALL)
			for i=2,#enemy_filtered do
				local damage = GetEstimatedDamageToTarget(npcBot, false, enemy_filtered[i], 3, DAMAGE_TYPE_ALL)
				if damage > maxDamage then
					target = enemy_filtered[i]
					maxDamage = damage
				end
			end
			return BOT_ACTION_DESIRE_HIGH, target
		end
    end
    if npcBot:GetActiveMode() ~= "retreat" and npcBot:GetActiveMode() ~= "laning" then
        if #enemies > 0 then
            local target = nil
            local maxValue = 0
            for i=1,#enemies do
                local currentValue = enemies[i]:GetHealth()
                if IsSeverelyDisabledOrSlowed(enemies[i]) then
                    currentValue = currentValue * 1.5
                end
                if currentValue > maxValue then
                    target = enemies[i]
                    maxValue = currentValue
                end
            end
            return BOT_ACTION_DESIRE_HIGH, target
        end
    end
    if IsAttackingEnemies(npcBot) then
        local target = npcBot:GetTarget()
        if target then
            if CanCast[1](target) and GetUnitToUnitDistance(npcBot, target) < castRange then
                return BOT_ACTION_DESIRE_MODERATE, target
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, nil
end

local function GetQuilIncomingDamage(npc, base_damage, stack_damage) 
    local modifier = npc:FindModifierByName("modifier_bristleback_quill_spray_stack")
    if modifier == nil then
        return GetActualIncomingDamage(npc, base_damage, DAMAGE_TYPE_PHYSICAL)
    end
    local stacks = modifier:GetStackCount()
    return GetActualIncomingDamage(npc, base_damage + stack_damage * stacks, DAMAGE_TYPE_PHYSICAL)
end

function ConsiderW(bot)
	local ability = abilityW
	local npcBot = bot
    local abilityNumber = 2
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = 0
    local Damage = ability:GetSpecialValueFor("quill_base_damage")
    local quill_stack_damage = ability:GetSpecialValueFor("quill_stack_damage")
    local Radius = ability:GetSpecialValueFor("radius") - 50
    local CastPoint = 0
    local allys = GetNearbyHeroes(npcBot, 1200, false, BOT_MODE_NONE)
    local enemys = GetNearbyHeroes(npcBot, Radius, true, BOT_MODE_NONE)
    local WeakestEnemy, HeroHealth = GetWeakestUnit(enemys)
    local creeps = GetNearbyCreeps(npcBot, Radius, true)
    local WeakestCreep, CreepHealth = GetWeakestUnit(creeps)
    local manaPercent = ManaPerc
    if npcBot:GetActiveMode() ~= "retreat" then
        if WeakestEnemy ~= nil then
            if CanCast[abilityNumber](WeakestEnemy) then
                if HeroHealth <= GetQuilIncomingDamage(WeakestEnemy, Damage, quill_stack_damage) or
                    WeakestEnemy:HasModifier("modifier_bristleback_viscous_nasal_goo") then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end
    if (WasRecentlyDamagedByAnyHero(npcBot, 2) and #enemys >= 1) or #enemys >= 2 then
        for _, npcEnemy in pairs(enemys) do
            if CanCast[abilityNumber](npcEnemy) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if (manaPercent > 0.65 or npcBot:GetMana() > ComboMana) then
            if WeakestEnemy ~= nil then
                if CanCast[abilityNumber](WeakestEnemy) then
                    if GetUnitToUnitDistance(npcBot, WeakestEnemy) < Radius then
                        return BOT_ACTION_DESIRE_LOW
                    end
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if #creeps >= 2 then
            if WeakestCreep ~= nil then
                if CreepHealth <= GetQuilIncomingDamage(WeakestCreep, Damage, quill_stack_damage) and
                    (manaPercent > 0.4 or npcBot:GetMana() > ComboMana) then
                    return BOT_ACTION_DESIRE_LOW
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_LANING then
        if WeakestCreep ~= nil then
            if (manaPercent > 0.5 or npcBot:GetMana() > ComboMana) and
                GetUnitToUnitDistance(npcBot, WeakestCreep) < Radius then
                if CreepHealth <= GetQuilIncomingDamage(WeakestCreep, Damage, quill_stack_damage) - 20 then
                    return BOT_ACTION_DESIRE_LOW
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or
       npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
       npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = npcBot:GetTarget()
        if npcEnemy ~= nil then
            if CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) <= Radius then
                return BOT_ACTION_DESIRE_MODERATE, npcEnemy
            end
        end
    end
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
