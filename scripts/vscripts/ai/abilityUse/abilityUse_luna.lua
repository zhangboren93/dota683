-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local lunaAbility = BotsInit.CreateGeneric()

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
    heroData.luna.SKILL_0,
    heroData.luna.SKILL_1,
    heroData.luna.SKILL_2,
    heroData.luna.SKILL_3
}

local abilityQ = ""
local abilityW = ""
local abilityE = ""
local abilityR = ""

local AttackRange   = 0
local ManaPerc      = 0.0
local HealthPerc    = 0.0
local modeName      = nil
local ComboMana = 0

local CanCast = {
	NormalCanCastFunction,
	nil,
	nil,
	NormalCanCastFunction
}
function lunaAbility:AbilityUsageThink(bot)
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
    
    -- CHECK BELOW TO SEE WHICH ABILITIES ARE NOT PASSIVE AND WHAT RETURN TYPES ARE --
    -- Consider using each ability
	local castQDesire, castQTarget  = ConsiderQ(bot)
	local castRDesire  = ConsiderR(bot)
    
    -- CHECK BELOW TO SEE WHAT PRIORITY OF ABILITIES YOU WANT FOR THIS HERO --
    -- YOU MIGHT ALSO WANT TO ADD OTHER CONDITIONS TO WHEN TO CAST WHAT     --
    -- EXAMPLE: 
    -- if castRDesire >= modeDesire and castRDesire >= Max(CastEDesire, CastWDesire) then
	
	if castRDesire >= modeDesire then
		gHeroVar.HeroUseAbility(bot, abilityR)
		return true
	end

	if castQDesire >= modeDesire then
		gHeroVar.HeroUseAbilityOnEntity(bot, abilityQ, castQTarget)
		return true
	end
    
    return false
end

local function GetComboDamage(bot)
	local tempComboDamage = 0;
	if abilityQ:GetLevel() > 0 then
		tempComboDamage = tempComboDamage + abilityQ:GetSpecialValueFor("beam_damage")
	end
	if abilityR:GetLevel() > 0 and abilityQ:GetLevel() > 0 then
		tempComboDamage = tempComboDamage + abilityQ:GetSpecialValueFor("beam_damage") * 4
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

	local CastRange = ability:GetCastRange();
	local Damage = ability:GetSpecialValueFor("beam_damage");

	local allys = GetNearbyHeroes(npcBot, 1200, false, BOT_MODE_NONE);
	local enemys = GetNearbyHeroes(npcBot, CastRange + 300, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = GetWeakestUnit(enemys)
	local creeps = GetNearbyCreeps(npcBot, CastRange + 300, true)
	local WeakestCreep, CreepHealth = GetWeakestUnit(creeps)
	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	-- Check for a channeling enemy
	for _, npcEnemy in pairs(enemys) do
		if (npcEnemy:IsChanneling() and CanCast[abilityNumber](npcEnemy))
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end

	--Try to kill enemy hero
	if (npcBot:GetActiveMode() ~= BOT_MODE_RETREAT)
	then
		if (WeakestEnemy ~= nil)
		then
			if (CanCast[abilityNumber](WeakestEnemy))
			then
				if (
					HeroHealth <= GetActualIncomingDamage(WeakestEnemy, Damage, DAMAGE_TYPE_MAGICAL) or
						(
						HeroHealth <= GetActualIncomingDamage(WeakestEnemy, GetComboDamage(bot), DAMAGE_TYPE_MAGICAL) and
							npcBot:GetMana() > ComboMana))
				then
					return BOT_ACTION_DESIRE_HIGH, WeakestEnemy;
				end
			end
		end
	end

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	--protect myself
	local enemys2 = GetNearbyHeroes(npcBot, 500, true, BOT_MODE_NONE);
	if (WasRecentlyDamagedByAnyHero(npcBot, 5))
	then
		for _, npcEnemy in pairs(enemys2) do
			if (CanCast[abilityNumber](npcEnemy))
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if (npcBot:GetActiveMode() == BOT_MODE_RETREAT)
	then
		for _, npcEnemy in pairs(enemys) do
			if (WasRecentlyDamagedByHero(npcBot, npcEnemy, 2.0))
			then
				if (CanCast[abilityNumber](npcEnemy) and not enemyDisabled(npcEnemy))
				then
					return BOT_ACTION_DESIRE_LOW, npcEnemy;
				end
			end
		end
	end

	-- If my mana is enough,use it at enemy
	if (npcBot:GetActiveMode() ~= BOT_MODE_RETREAT)
	then
		if ((ManaPerc > 65 and npcBot:GetMana() > ComboMana) and ability:GetLevel() >= 2)
		then
			if (WeakestEnemy ~= nil)
			then
				if (CanCast[abilityNumber](WeakestEnemy))
				then
					return BOT_ACTION_DESIRE_LOW, WeakestEnemy;
				end
			end
		end
	end

	-- If we're going after someone
	if (npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		local npcEnemy = npcBot:GetTarget();

		if (npcEnemy ~= nil)
		then
			if (CanCast[abilityNumber](npcEnemy) and GetUnitToUnitDistance(npcBot, npcEnemy) < CastRange + 75 * #allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy
			end
		end
	end
	return BOT_ACTION_DESIRE_NONE, 0
end

function ConsiderR(bot)
    if not abilityR:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE
	end
    
	local ability = abilityR
	local npcBot = bot
	local abilityNumber = 4

	local CastRange = ability:GetCastRange() - 150;
	local singleShotDamage = abilityQ:GetSpecialValueFor("beam_damage")
	local compoundDamage = singleShotDamage * 4
	local Radius = ability:GetSpecialValueFor("radius")

	local allys = GetNearbyHeroes(npcBot, 1600, false, BOT_MODE_NONE);
	local enemys = GetNearbyHeroes(npcBot, Radius, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = GetWeakestUnit(enemys)
	local creeps = GetNearbyCreeps(npcBot, Radius, true)
	local WeakestCreep, CreepHealth = GetWeakestUnit(creeps)

	--------------------------------------
	-- Global high-priorty usage
	--------------------------------------
	local disabledheronum = 0
	for _, temphero in pairs(enemys) do
		if (enemyDisabled(temphero) or GetCurrentMovementSpeed(temphero) <= 200)
		then
			disabledheronum = disabledheronum + 1
		end
	end

	if (npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		local npcEnemy = npcBot:GetTarget()

		if (npcEnemy ~= nil and #creeps <= 1)
		then
			if (
				CanCast[abilityNumber](npcEnemy) and
					(
					npcEnemy:GetHealth() <= GetActualIncomingDamage(npcEnemy, GetOffensivePower(npcBot), DAMAGE_TYPE_MAGICAL) or
						npcEnemy:GetHealth() <= compoundDamage) and GetUnitToUnitDistance(npcEnemy, npcBot) <= Radius)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end
	return BOT_ACTION_DESIRE_NONE
end

function lunaAbility:nukeDamage( bot, enemy )
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

function lunaAbility:queueNuke(bot, enemy, castQueue, engageDist)
    if not utils.ValidTarget(enemy) then return false end
    
    -- WRITE CODE HERE --
    
    return false
end

return lunaAbility
