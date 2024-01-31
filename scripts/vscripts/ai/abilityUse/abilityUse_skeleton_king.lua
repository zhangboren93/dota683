BotsInit = require( "game/botsinit" )
local skeleKingAbility = BotsInit.CreateGeneric()

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
    heroData.skeleton_king.SKILL_0,
    heroData.skeleton_king.SKILL_1,
    heroData.skeleton_king.SKILL_2,
    heroData.skeleton_king.SKILL_3
}

local abilityQ = ""
local abilityW = ""
local abilityE = ""
local abilityR = ""

local AttackRange   = 0
local ManaPerc      = 0.0
local HealthPerc    = 0.0
local modeName      = nil

function skeleKingAbility:AbilityUsageThink(bot)
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
    
    -- CHECK BELOW TO SEE WHAT PRIORITY OF ABILITIES YOU WANT FOR THIS HERO --
    -- YOU MIGHT ALSO WANT TO ADD OTHER CONDITIONS TO WHEN TO CAST WHAT     --
    -- EXAMPLE: 
    -- if castRDesire >= modeDesire and castRDesire >= Max(CastEDesire, CastWDesire) then
	if castQDesire >= modeDesire then
		gHeroVar.HeroUseAbilityOnEntity(bot, abilityQ, castQTarget)
		return true
	end
    
    return false
end

function GetComboDamage(bot) 
	local tempComboDamage = abilityQ:GetAbilityDamage()
	return math.max(tempComboDamage, GetOffensivePower(bot))
end

function ConsiderQ(bot)
	local ability = abilityQ
	local npcBot = bot
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local CastRange = ability:GetCastRange();
	local Damage = ability:GetAbilityDamage();

	local allys = GetNearbyHeroes(npcBot, 1200, false, BOT_MODE_NONE);
	local enemys = GetNearbyHeroes(npcBot, CastRange + 300, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = GetWeakestUnit(enemys)
	local creeps = GetNearbyCreeps(npcBot, CastRange + 300, true)
	local WeakestCreep, CreepHealth = GetWeakestUnit(creeps)

	-- Check for a channeling enemy
	for _, enemy in pairs(enemys) do
		if enemy:IsChanneling() then
			return BOT_ACTION_DESIRE_HIGH, enemy
		end
	end

	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = GetNearbyHeroes(npcBot, 1000, false, BOT_MODE_ATTACK);
	if (#tableNearbyAttackingAlliedHeroes >= 2)
	then

		local npcMostDangerousEnemy = nil;
		local nMostDangerousDamage = 0;

		local tableNearbyEnemyHeroes = GetNearbyHeroes(npcBot, CastRange, true, BOT_MODE_NONE);
		for _, npcEnemy in pairs(tableNearbyEnemyHeroes) do
			if (not enemyDisabled(npcEnemy))
			then
				local Damage2 = GetEstimatedDamageToTarget(npcEnemy, false, npcBot, 3.0, DAMAGE_TYPE_ALL);
				if (Damage2 > nMostDangerousDamage)
				then
					nMostDangerousDamage = Damage2;
					npcMostDangerousEnemy = npcEnemy;
				end
			end
		end

		if (npcMostDangerousEnemy ~= nil)
		then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy;
		end
	end

	--try to kill enemy hero
	if (npcBot:GetActiveMode() ~= "retreat")
	then
		if (WeakestEnemy ~= nil)
		then
			if (
				HeroHealth <= GetActualIncomingDamage(WeakestEnemy, Damage, DAMAGE_TYPE_MAGICAL) or
					(
					HeroHealth <= GetActualIncomingDamage(WeakestEnemy, GetComboDamage(npcBot), DAMAGE_TYPE_MAGICAL) and
						npcBot:GetMana() > 300))
			then
				return BOT_ACTION_DESIRE_HIGH, WeakestEnemy;
			end
		end
	end

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if (npcBot:GetActiveMode() == "retreat")
	then
		local tableNearbyEnemyHeroes = GetNearbyHeroes(npcBot, CastRange, true, BOT_MODE_NONE);
		for _, npcEnemy in pairs(tableNearbyEnemyHeroes) do
			if (WasRecentlyDamagedByHero(npcBot, npcEnemy, 2.0))
			then
				if (not enemyDisabled(npcEnemy))
				then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy;
				end
			end
		end
	end


	-- If we're going after someone
	if (npcBot:GetActiveMode() == "defendally" or
		npcBot:GetActiveMode() == "fight")
	then
		local npcTarget = npcBot:GetTarget();

		if (npcTarget ~= nil)
		then
			if (GetUnitToUnitDistance(npcBot, npcTarget) < CastRange + 75 * #allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function skeleKingAbility:nukeDamage( bot, enemy )
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

function skeleKingAbility:queueNuke(bot, enemy, castQueue, engageDist)
    if not utils.ValidTarget(enemy) then return false end
    
    -- WRITE CODE HERE --
    
    return false
end

return skeleKingAbility
