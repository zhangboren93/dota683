-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local cmAbility = BotsInit.CreateGeneric()

require( GetScriptDirectory().."/fight_simul" )
require( GetScriptDirectory().."/modifiers" )

local heroData = require( GetScriptDirectory().."/hero_data" )
local utils = require( GetScriptDirectory().."/utility" )
local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )

function setHeroVar(bot, var, value)
    gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

function getHeroVar(bot, var)
    return gHeroVar.GetVar(bot:GetPlayerID(), var)
end

local Abilities ={
    heroData.crystal_maiden.SKILL_0,
    heroData.crystal_maiden.SKILL_1,
    heroData.crystal_maiden.SKILL_2,
    heroData.crystal_maiden.SKILL_3
}

local abilityQ = ""
local abilityW = ""
local abilityE = ""
local abilityR = ""

local ManaPerc      = 0.0
local modeName      = nil

function cmAbility:nukeDamage( bot, enemy )
    return 0, {}, 0, 0, 0
end

function cmAbility:queueNuke(bot, enemy, castQueue, engageDist)
    return false
end

function cmAbility:AbilityUsageThink(bot)
    if utils.IsBusy(bot) then return true end
    
    if utils.IsUnableToCast(bot) then return false end

    if abilityQ == "" then abilityQ = bot:GetAbilityByName( Abilities[1] ) end
    if abilityW == "" then abilityW = bot:GetAbilityByName( Abilities[2] ) end
    if abilityE == "" then abilityE = bot:GetAbilityByName( Abilities[3] ) end
    if abilityR == "" then abilityR = bot:GetAbilityByName( Abilities[4] ) end

    local nearbyEnemyHeroes = gHeroVar.GetNearbyEnemies(bot, 1200)
    local nearbyEnemyCreep = gHeroVar.GetNearbyEnemyCreep(bot, 1200)
    
    if #nearbyEnemyHeroes == 0 and #nearbyEnemyCreep == 0 then return false end

    if #nearbyEnemyHeroes >= 1 then
        local nRadius = abilityQ:GetSpecialValueFor( "radius" )
        local nCastRange = abilityQ:GetCastRange()

        --FIXME: in the future we probably want to target a hero that has a disable to my ult, rather than weakest
        local enemy, enemyHealth = utils.GetWeakestHero(bot, nRadius + nCastRange, nearbyEnemyHeroes)
        local dmg, castQueue, castTime, stunTime, slowTime, engageDist = self:nukeDamage( bot, enemy )

        local rightClickTime = stunTime + 0.5*slowTime
        if rightClickTime > 0.5 then
            dmg = dmg + fight_simul.estimateRightClickDamage( bot, enemy, rightClickTime )
        end

        -- magic immunity is already accounted for by nukeDamage()
        if dmg > enemyHealth then
            local bKill = self:queueNuke(bot, enemy, castQueue, engageDist)
            if bKill then
                setHeroVar(bot, "Target", enemy)
                return true
            end
        end
    end
    
	ManaPerc      = bot:GetMana()/bot:GetMaxMana()
    modeName      = bot.SelfRef:getCurrentMode():GetName()
    
    local modeDesire = Max(0.01, bot.SelfRef:getCurrentModeValue())
    
    -- Consider using each ability
	local castQDesire, castQLocation  = ConsiderQ(bot)
	local castWDesire, castWTarget    = ConsiderW(bot)
	local castRDesire                 = ConsiderR(bot)
    
    if castQDesire >= modeDesire and castQDesire >= castWDesire and castQDesire >= castRDesire then
        gHeroVar.HeroUseAbilityOnLocation( bot, abilityQ, castQLocation )
        return true
    end
    
    if castWDesire >= modeDesire and castWDesire >= castRDesire then
        gHeroVar.HeroUseAbilityOnEntity( bot, abilityW, castWTarget )
        return true
    end
    
    if castRDesire >= modeDesire then
        gHeroVar.HeroUseAbility( bot, abilityR )
        return true
    end
    
    return false
end

function ConsiderQ(bot)
    
    if not abilityQ:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, {}
    end
    
    local CastRange = abilityQ:GetCastRange()
    local Radius    = 425
    local CastPoint = abilityQ:GetCastPoint()
    local Damage    = abilityQ:GetSpecialValueFor("nova_damage")
    
    --------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	--try to kill enemy hero
    local WeakestEnemy, HeroHealth = utils.GetWeakestHero(bot, CastRange + Radius - 100)
    
	if modeName ~= "retreat" then
		if utils.ValidTarget(WeakestEnemy) then
			if not utils.IsTargetMagicImmune( WeakestEnemy ) then
				if HeroHealth <= GetActualIncomingDamage(WeakestEnemy, Damage, DAMAGE_TYPE_MAGICAL) then
					return BOT_ACTION_DESIRE_HIGH, GetExtrapolatedLocation(WeakestEnemy, CastPoint )
				end
			end
		end
	end
    
	--------------------------------------
	-- Mode based usage
	--------------------------------------
    
    local nearbyAlliedHeroes = gHeroVar.GetNearbyAllies(bot, 1000)
    local coreNear = false
    for _, ally in pairs(nearbyAlliedHeroes) do
        if not ally:IsIllusion() and utils.IsCore(ally) and ally ~= bot then
            coreNear = true
            break
        end
    end
    
	-- farming/laning
	if modeName == "jungling" or modeName == "laning" then
		if ManaPerc > 0.5 and not coreNear then
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), CastRange, Radius, 0, Damage )

			if locationAoE.count >= 1 and GetUnitToLocationDistance(bot, locationAoE.targetloc) <= CastRange then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
			end
		end
		
        -- if we can hit 2+ enemies do it
		if ManaPerc > 0.5 and abilityQ:GetLevel() >= 2 then
			local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), CastRange, Radius, 0, 0 )
			if locationAoE.count >= 2 and GetUnitToLocationDistance(bot, locationAoE.targetloc) <= CastRange then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
			end
		end
	end

	-- If we're pushing or defending a lane and can hit 3+ creeps, go for it
	if modeName == "defendlane" or modeName == "pushlane" then
		local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), CastRange, Radius, 0, 0 )

		if locationAoE.count >= 3 and GetUnitToLocationDistance(bot, locationAoE.targetloc) <= CastRange then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
		end
	end

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if modeName == "retreat" or modeName == "shrine" then
		local tableNearbyEnemyHeroes = gHeroVar.GetNearbyEnemies( bot, CastRange + Radius + 200 )
		for _, npcEnemy in pairs( tableNearbyEnemyHeroes ) do
			if utils.ValidTarget(npcEnemy) and WasRecentlyDamagedByHero(bot, npcEnemy, 2.0 ) then
				if not utils.IsTargetMagicImmune( npcEnemy ) then
					return BOT_ACTION_DESIRE_MODERATE, GetExtrapolatedLocation(npcEnemy, CastPoint )
				end
			end
		end
	end

	-- If we're going after someone
	if modeName == "roam" or modeName == "defendally" or modeName == "fight" then
		local npcEnemy = getHeroVar(bot, "RoamTarget")
        if npcEnemy == nil then npcEnemy = getHeroVar(bot, "Target") end

		if utils.ValidTarget(npcEnemy) then
			if not utils.IsTargetMagicImmune(npcEnemy) then
				return BOT_ACTION_DESIRE_HIGH, GetExtrapolatedLocation(npcEnemy, CastPoint )
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, {}    
end

function ConsiderW(bot)
    
    if not abilityW:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, nil
    end
    
    local CastRange = abilityW:GetCastRange()
    local Damage    = abilityW:GetSpecialValueFor("damage_per_second") * abilityW:GetSpecialValueFor("duration")

    --------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
    local enemies = gHeroVar.GetNearbyEnemies(bot, CastRange + 250)
    
	for _, npcEnemy in pairs( enemies ) do
		if utils.ValidTarget(npcEnemy) and npcEnemy:IsChanneling() and not utils.IsTargetMagicImmune(npcEnemy) then
			return BOT_ACTION_DESIRE_HIGH+0.1, npcEnemy
		end
	end
	
	-- Try to kill enemy hero
    local WeakestEnemy, HeroHealth = utils.GetWeakestHero(bot, 1200)
	if modeName ~= "retreat" or (modeName == "retreat" and bot.SelfRef:getCurrentModeValue() < BOT_MODE_DESIRE_VERYHIGH) then
		if utils.ValidTarget(WeakestEnemy) and GetUnitToUnitDistance(bot, WeakestEnemy) < (CastRange + 150) then
			if not utils.IsTargetMagicImmune(WeakestEnemy) and not utils.IsCrowdControlled(WeakestEnemy) then
				if HeroHealth <= GetActualIncomingDamage(WeakestEnemy, Damage, DAMAGE_TYPE_MAGICAL) then
					return BOT_ACTION_DESIRE_HIGH+0.1, WeakestEnemy
				end
			end
		end
	end
	
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = utils.InTeamFight(bot, 1000)
	if #tableNearbyAttackingAlliedHeroes >= 2 then
		local npcMostDangerousEnemy = utils.GetScariestEnemy(bot, CastRange)

		if utils.ValidTarget(npcMostDangerousEnemy)	then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy
		end
	end
    
	--------------------------------------
	-- Mode based usage
	--------------------------------------
    
	-- protect myself
	if bot:WasRecentlyDamagedByAnyHero(5) then
        local closeEnemies = gHeroVar.GetNearbyEnemies(bot, 500)
		for _, npcEnemy in pairs( closeEnemies ) do
			if utils.ValidTarget(npcEnemy) and not utils.IsTargetMagicImmune( npcEnemy ) and not utils.IsCrowdControlled(npcEnemy) then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end
	
	-- If my mana is enough, use it on weakest enemy
	if modeName == "jungling" or modeName == "laning" then
		if (ManaPerc > 0.4 and abilityW:GetLevel() >= 2) or
           (ManaPerc > 0.7) then
			if utils.ValidTarget(WeakestEnemy) and GetUnitToUnitDistance(bot, WeakestEnemy) < (CastRange + 100) then
				if not utils.IsTargetMagicImmune(WeakestEnemy) and not utils.IsCrowdControlled(WeakestEnemy) then
                    if utils.CanHarass(bot, WeakestEnemy) then
                        return BOT_ACTION_DESIRE_LOW, WeakestEnemy
                    end
				end
			end
		end
        
        -- if we are farming, kill strongest creep
        local nearbyAlliedHeroes = gHeroVar.GetNearbyAllies(bot, 1200)
        local coreNear = false
        for _, ally in pairs(nearbyAlliedHeroes) do
            if not ally:IsIllusion() and utils.IsCore(ally) then
                coreNear = true
                break
            end
        end
    
        if not coreNear and ManaPerc > 0.4 and #gHeroVar.GetNearbyEnemies(bot, 1500) == 0 then
            local enemyCreep = gHeroVar.GetNearbyEnemyCreep(bot, CastRange + 225)
            if #enemyCreep > 0 then
                if #enemyCreep > 1 then
                    table.sort(enemyCreep, function(n1,n2) return n1:GetHealth() > n2:GetHealth() end)
                end
                if utils.ValidTarget(enemyCreep[1]) and not enemyCreep[1]:IsAncient() then
                    return BOT_ACTION_DESIRE_LOW-0.01, enemyCreep[1]
                end
            end
        end
	end
	
	-- If we're going after someone
	if modeName == "roam" or modeName == "defendally" or modeName == "fight" then
		local npcEnemy = getHeroVar(bot, "RoamTarget")
        if npcEnemy == nil then npcEnemy = getHeroVar(bot, "Target") end

		if utils.ValidTarget(npcEnemy) then
			if not utils.IsTargetMagicImmune(npcEnemy) and not utils.IsCrowdControlled(npcEnemy) and 
                GetUnitToUnitDistance(bot, npcEnemy) < (CastRange + 75*#gHeroVar.GetNearbyAllies(bot,1200)) then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy
			end
		end
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if modeName == "retreat" or modeName == "shrine" then
		local tableNearbyEnemyHeroes = gHeroVar.GetNearbyEnemies( bot, CastRange )
		for _, npcEnemy in pairs( tableNearbyEnemyHeroes ) do
			if utils.ValidTarget(npcEnemy) and WasRecentlyDamagedByHero(bot, npcEnemy, 2.0 ) then
				if not utils.IsTargetMagicImmune(npcEnemy) and not utils.IsCrowdControlled(npcEnemy) then
					return BOT_ACTION_DESIRE_HIGH+0.01, npcEnemy
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function ConsiderR(bot)
    
    if not abilityR:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE
    end

	local Radius    = abilityR:GetSpecialValueFor("radius")

	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
    
    local enemies = gHeroVar.GetNearbyEnemies(bot, Radius)
    local disabledHeroCount = 0
	for _, eHero in pairs(enemies) do
		if utils.ValidTarget(eHero) and (utils.IsCrowdControlled(eHero) or GetCurrentMovementSpeed(eHero) <= 200) then
			disabledHeroCount = disabledHeroCount + 1
		end
	end
    
    if (modeName == "fight" and #enemies >= 2) or disabledHeroCount >= 2 then
        return BOT_ACTION_DESIRE_HIGH
    end
	
	-- If we're going after someone
	if modeName == "roam" or modeName == "defendally" or modeName == "fight" then
		local npcEnemy = getHeroVar(bot, "RoamTarget")
        if npcEnemy == nil then npcEnemy = getHeroVar(bot, "Target") end

		if utils.ValidTarget(npcEnemy) then
			if not utils.IsTargetMagicImmune(npcEnemy) and utils.IsCrowdControlled(npcEnemy) and 
                npcEnemy:GetHealth() <= GetActualIncomingDamage(npcEnemy, GetOffensivePower(bot), DAMAGE_TYPE_MAGICAL) and 
                GetUnitToUnitDistance(bot, npcEnemy) <= Radius then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE
end

return cmAbility
