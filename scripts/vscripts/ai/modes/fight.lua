-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local X = BotsInit.CreateGeneric()

require( GetScriptDirectory().."/modifiers" )
require( GetScriptDirectory().."/global_game_state" )

local utils = require( GetScriptDirectory().."/utility" )
local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )

local function setHeroVar(bot, var, value)
    gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

local function getHeroVar(bot, var)
    return gHeroVar.GetVar(bot:GetPlayerID(), var)
end

function X:GetName()
    return "fight"
end

function X:OnStart(bot)
    local target = getHeroVar(bot, "Target")
    if utils.ValidTarget(target) then
        utils.PartyChat(bot, "Trying to kill " .. utils.GetHeroName(target), false)
    end
end

function X:OnEnd(bot)
    setHeroVar(bot, "Target", nil)
    bot.teamKill = false
end

function X:Think(bot)

    if utils.IsBusy(bot) then return end
    
    if utils.IsCrowdControlled(bot) then return end
    
    local target = utils.GetWeakestHero(bot, 1200)
    
    if utils.ValidTarget(target) then
        local dist = GetUnitToUnitDistance(bot, target)
        local attackRange = bot:Script_GetAttackRange() + bot:BoundingRadius2D()
        
        if utils.IsMelee(bot) then
            if dist < attackRange then
                if modifiers.IsPhysicalImmune(target) or (bot:GetLastAttackTime() + bot:GetSecondsPerAttack(false)) > GameTime() then
                    gHeroVar.HeroMoveToUnit(bot, target)
                    return
                else
                    gHeroVar.HeroAttackUnit(bot, target, true)
                    return
                end
            else
                if item_usage.UseMovementItems(bot, target:GetAbsOrigin()) then return end
                gHeroVar.HeroMoveToUnit(bot, target)
                return
            end
        else
            if dist < attackRange then
                if modifiers.IsPhysicalImmune(target) or (bot:GetLastAttackTime() + bot:GetSecondsPerAttack(false)) > GameTime() then
                    -- move away if we are too close
                    if dist < (attackRange-100) then
                        gHeroVar.HeroMoveToLocation(bot, utils.VectorAway(bot:GetLocation(), target:GetAbsOrigin(), attackRange-dist-100))
                        return
                    elseif dist > (attackRange-100) then
                        gHeroVar.HeroMoveToLocation(bot, utils.VectorTowards(bot:GetLocation(), target:GetAbsOrigin(), dist-attackRange-100))
                        return
                    end
                else
                    -- move away if we are too close
                    if dist < (attackRange-200) then
                        gHeroVar.HeroMoveToLocation(bot, utils.VectorAway(bot:GetLocation(), target:GetAbsOrigin(), attackRange-dist-100))
                        return
                    else
                        gHeroVar.HeroAttackUnit(bot, target, true)
                        return
                    end
                end
            else
                if item_usage.UseMovementItems(bot, target:GetAbsOrigin()) then return end
                gHeroVar.HeroMoveToUnit(bot, target)
                return
            end
        end
    else
        bot.SelfRef:ClearMode(bot)
    end
end

function X:Desire(bot)
    global_game_state.GlobalFightDetermination(bot)
    if bot.teamKill then return BOT_MODE_DESIRE_HIGH end
    
    local enemyList = gHeroVar.GetNearbyEnemies(bot, 1200)
    if #enemyList == 0 then return BOT_MODE_DESIRE_NONE end
    local allyList = gHeroVar.GetNearbyAllies(bot, 1200)
    
    local eTowers = gHeroVar.GetNearbyEnemyTowers(bot, 1200)
    local aTowers = gHeroVar.GetNearbyAlliedTowers(bot, 600)
    
    local lowestEnemyHealth = 100000
    local enemyHealth = 0
    local enemyDmg = 0
    for _, enemy in pairs(enemyList) do
        if utils.ValidTarget(enemy) and enemy:GetHealth()/enemy:GetMaxHealth() >= 0.25 and 
            not modifiers.HasDangerousModifiers(enemy) and 
            not utils.IsCrowdControlled(enemy) then
            for _, ally in pairs(allyList) do
                if not ally:IsIllusion() then
                    enemyDmg = enemyDmg + GetEstimatedDamageToTarget(enemy, true, ally, 4.0, DAMAGE_TYPE_ALL )
                end
            end
            enemyHealth = enemyHealth + enemy:GetHealth()
            if enemyHealth < lowestEnemyHealth then
                lowestEnemyHealth = enemyHealth
            end
        end
    end
    enemyDmg = enemyDmg + #eTowers*110
    
    local enemyValue = enemyDmg + enemyHealth
    
    local allyHealth = 0
    local allyDmg = 0
    for _, ally in pairs(allyList) do
        if not ally:IsIllusion() and ally:GetHealth()/ally:GetMaxHealth() >= 0.25 and 
            not modifiers.HasDangerousModifiers(ally) and 
            not utils.IsCrowdControlled(ally) then
            for _, enemy in pairs(enemyList) do
                if utils.ValidTarget(enemy) then
                    allyDmg = allyDmg + GetEstimatedDamageToTarget(ally, true, enemy, 4.0, DAMAGE_TYPE_ALL )
                end
            end
            allyHealth = allyHealth + ally:GetHealth()
        end
    end
    allyDmg = allyDmg + #aTowers*110
    
    local allyValue = allyDmg + allyHealth
    
    if enemyDmg >= 0.9*bot:GetHealth() then
        return BOT_MODE_DESIRE_NONE
    end
    
    if allyDmg >= 2.0*lowestEnemyHealth then
        return BOT_MODE_DESIRE_MODERATE
    end
    
    if allyValue/enemyValue > Max(1.0, (1.6 - bot:GetLevel()*0.1)) then
        return BOT_MODE_DESIRE_LOW
    end
    
    if #enemyList > 0 and not bot:WasRecentlyDamagedByAnyHero(2.0) and #eTowers == 0
        and #gHeroVar.GetNearbyEnemyCreep(bot, 1200) == 0 then
        local weakest, _ = utils.GetWeakestHero(bot, 1200, enemyList)
        if utils.ValidTarget(weakest) then
            setHeroVar(bot, "Target", weakest)
            return BOT_MODE_DESIRE_LOW + 0.01
        end
    end

    return BOT_MODE_DESIRE_NONE
end

return X
