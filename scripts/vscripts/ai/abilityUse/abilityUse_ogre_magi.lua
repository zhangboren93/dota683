-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local ogreAbility = BotsInit.CreateGeneric()

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
    heroData.ogre_magi.SKILL_0,
    heroData.ogre_magi.SKILL_1,
    heroData.ogre_magi.SKILL_2,
    heroData.ogre_magi.SKILL_3,
    heroData.ogre_magi.SKILL_4
}

local abilityQ = ""
local abilityW = ""
local abilityE = ""
local abilityR = ""
local abilityD = ""

local AttackRange   = 0
local ManaPerc      = 0.0
local HealthPerc    = 0.0
local modeName      = nil
local ComboMana = 0

function ogreAbility:AbilityUsageThink(bot)
    -- Check if we're already using an ability
    if utils.IsBusy(bot) then return true end
    
    -- Check to see if we are CC'ed
    if utils.IsUnableToCast(bot) then return false end

    if abilityQ == "" then abilityQ = bot:GetAbilityByName( Abilities[1] ) end
    if abilityW == "" then abilityW = bot:GetAbilityByName( Abilities[2] ) end
    if abilityE == "" then abilityE = bot:GetAbilityByName( Abilities[3] ) end
    if abilityR == "" then abilityR = bot:GetAbilityByName( Abilities[5] ) end
    if abilityD == "" then abilityD = bot:GetAbilityByName( Abilities[4] ) end
    
    local modeDesire    = Max(0.01, bot.SelfRef:getCurrentModeValue())
	ComboMana = GetComboMana({abilityQ, abilityW})
	ManaPerc = bot:GetManaPercent()
    
    -- CHECK BELOW TO SEE WHICH ABILITIES ARE NOT PASSIVE AND WHAT RETURN TYPES ARE --
    -- Consider using each ability
	local castQDesire, castQTarget  = ConsiderQ(bot)
	local castWDesire, castWTarget  = ConsiderW(bot)
	local castEDesire, castETarget  = ConsiderE(bot)
    
    -- CHECK BELOW TO SEE WHAT PRIORITY OF ABILITIES YOU WANT FOR THIS HERO --
    -- YOU MIGHT ALSO WANT TO ADD OTHER CONDITIONS TO WHEN TO CAST WHAT     --
    -- EXAMPLE: 
    -- if castRDesire >= modeDesire and castRDesire >= Max(CastEDesire, CastWDesire) then
	
	if castEDesire >= modeDesire then
		gHeroVar.HeroUseAbilityOnEntity(bot, abilityE, castETarget)
		return true
	end

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

local CanCast = {
	NormalCanCastFunction,
	NormalCanCastFunction,
	NormalCanCastFunction,
	NormalCanCastFunction,
	NormalCanCastFunction}

local function GetComboDamage(bot)
	local tempComboDamage = 0;
	if abilityQ:GetLevel() > 0 then
		tempComboDamage = tempComboDamage + abilityQ:GetSpecialValueFor("fireblast_damage")
	end
	if abilityW:GetLevel() > 0 then
		tempComboDamage = tempComboDamage + abilityW:GetSpecialValueFor("burn_damage") * abilityW:GetSpecialValueFor("duration")
	end
	return math.max(tempComboDamage, GetOffensivePower(bot))
end

function ConsiderQ(bot)
	local ability = abilityQ
	local npcBot = bot
	if not ability:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, 0
	end
	local CastRange = ability:GetCastRange();
	local Damage = ability:GetSpecialValueFor("fireblast_damage");

	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
	local WeakestCreep, CreepHealth = GetWeakestUnit(creeps)

	-- Check for a channeling enemy
	for _, enemy in pairs(enemys) do
		if (enemy:IsChanneling() and CanCast[1](enemy))
		then
			return BOT_ACTION_DESIRE_HIGH, enemy
		end
	end

	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK);
	if (#tableNearbyAttackingAlliedHeroes >= 2)
	then

		local npcMostDangerousEnemy = nil;
		local nMostDangerousDamage = 0;

		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(CastRange, true, BOT_MODE_NONE);
		for _, npcEnemy in pairs(tableNearbyEnemyHeroes) do
			if (CanCast[1](npcEnemy) and not enemyDisabled(npcEnemy))
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
	if (npcBot:GetActiveMode() ~= BOT_MODE_RETREAT)
	then
		if (WeakestEnemy ~= nil)
		then
			if (CanCast[1](WeakestEnemy))
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

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if (npcBot:GetActiveMode() == BOT_MODE_RETREAT) then
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(CastRange, true, BOT_MODE_NONE);
		for _, npcEnemy in pairs(tableNearbyEnemyHeroes) do
			if (npcBot:WasRecentlyDamagedByHero(npcEnemy, 2.0))
			then
				if (CanCast[1](npcEnemy) and not enemyDisabled(npcEnemy))
				then
					return BOT_ACTION_DESIRE_HIGH, npcEnemy;
				end
			end
		end
	end
	-- If we're going after someone
	if (npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		local npcTarget = npcBot:GetTarget();

		if (npcTarget ~= nil)
		then
			if (
				CanCast[1](npcTarget) and not enemyDisabled(npcTarget) and
					GetUnitToUnitDistance(npcBot, npcTarget) < CastRange + 75 * #allys)
			then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function ConsiderW(bot)
	local ability = abilityW
	local npcBot = bot
    if not abilityW:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE
	end
    
	local CastRange = ability:GetCastRange();
	local Damage = (18 + 8 * ability:GetLevel()) * (4 + ability:GetLevel());

	local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE);
	local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
	local WeakestCreep, CreepHealth = GetWeakestUnit(creeps)

	--try to kill enemy hero
	if (npcBot:GetActiveMode() ~= BOT_MODE_RETREAT)
	then
		if (WeakestEnemy ~= nil)
		then
			if (CanCast[2](WeakestEnemy))
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

	--if ( npcBot:GetActiveMode() == BOT_MODE_LANING )
	--then
	if ((ManaPerc > 40 or npcBot:GetMana() > ComboMana) and ability:GetLevel() >= 2)
	then
		if (WeakestEnemy ~= nil)
		then
			if (CanCast[2](WeakestEnemy))
			then
				return BOT_ACTION_DESIRE_LOW, WeakestEnemy;
			end
		end
	end
	--end

	-- If we're farming and can hit 2+ creeps and kill 1+
	if (npcBot:GetActiveMode() == BOT_MODE_LANING)
	then
		if (#creeps >= 2)
		then
			if (CreepHealth <= GetActualIncomingDamage(WeakestCreep, Damage, DAMAGE_TYPE_MAGICAL) and npcBot:GetMana() > ComboMana
				)
			then
				return BOT_ACTION_DESIRE_LOW, WeakestCreep;
			end
		end
	end

	-- If we're pushing or defending a lane and can hit 3+ creeps, go for it
	if (npcBot:GetActiveMode() == BOT_MODE_PUSH_LANE or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_LANE)
	then
		if (#enemys >= 1)
		then
			if (ManaPerc > 50 or npcBot:GetMana() > ComboMana and AbilitiesReal[4]:GetLevel() >= 1)
			then
				if (WeakestEnemy ~= nil)
				then
					if (CanCast[2](WeakestEnemy) and GetUnitToUnitDistance(npcBot, WeakestEnemy) < CastRange + 75 * #allys)
					then
						return BOT_ACTION_DESIRE_LOW, WeakestEnemy;
					end
				end
			end
		end

		if (#creeps >= 3)
		then
			if (ManaPerc > 50 or npcBot:GetMana() > ComboMana and AbilitiesReal[4]:GetLevel() >= 1)
			then
				if (CanCast[2](creeps[1]) and GetUnitToUnitDistance(npcBot, creeps[1]) < CastRange + 75 * #allys)
				then
					return BOT_ACTION_DESIRE_LOW, creeps[1];
				end
			end
		end

	end

	-- If we're going after someone
	if (npcBot:GetActiveMode() == BOT_MODE_ROAM or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK)
	then
		local npcTarget = npcBot:GetTarget();

		if (ManaPerc > 40 or npcBot:GetMana() > ComboMana)
		then
			if (npcTarget ~= nil)
			then
				if (CanCast[2](npcTarget) and GetUnitToUnitDistance(npcBot, npcTarget) < CastRange + 75 * #allys)
				then
					return BOT_ACTION_DESIRE_MODERATE, npcTarget;
				end
			end
		end
	end
	return BOT_ACTION_DESIRE_NONE, 0
end

function ConsiderE(bot)
	local ability = abilityE
	local npcBot = bot
    if not abilityE:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE
	end
	local CastRange = ability:GetCastRange();
	local Damage = 0

	local allys = GetNearbyHeroes(npcBot, 1200, false, 0)
	--TODO order ally by power
	local enemys = npcBot:GetNearbyHeroes(CastRange + 300, true, BOT_MODE_NONE)
	local WeakestEnemy, HeroHealth = GetWeakestUnit(enemys)
	local creeps = npcBot:GetNearbyCreeps(CastRange + 300, true)
	local WeakestCreep, CreepHealth = GetWeakestUnit(creeps)

	-- If we're pushing or defending a lane
	if (npcBot:GetActiveMode() == BOT_MODE_DEFEND_LANE or
		npcBot:GetActiveMode() == BOT_MODE_PUSH_LANE)
	then
		if (ManaPerc > 60 and npcBot:GetMana() > ComboMana)
		then
			local tableNearbyFriendlyTowers = npcBot:GetNearbyTowers(CastRange + 300, false, 0);
			for _, myTower in pairs(tableNearbyFriendlyTowers) do
				if (
					GetUnitToUnitDistance(myTower, npcBot) < CastRange and not myTower:HasModifier("modifier_ogre_magi_bloodlust"))
				then
					return BOT_ACTION_DESIRE_MODERATE, myTower;
				end
			end

			for _, myFriend in pairs(allys) do
				if (
					GetUnitToUnitDistance(myFriend, npcBot) < CastRange and not myFriend:HasModifier("modifier_ogre_magi_bloodlust"))
				then
					return BOT_ACTION_DESIRE_MODERATE, myFriend;
				end
			end
			if not npcBot:HasModifier("modifier_ogre_magi_bloodlust") then
				return BOT_ACTION_DESIRE_MODERATE, npcBot;
			end
		end
	end

	-- If my mana is enough,buff myfriend.
	if (ManaPerc > 60 and npcBot:GetMana() > ComboMana)
	then
		for _, ally in pairs(allys) do
			if (not ally:HasModifier("modifier_ogre_magi_bloodlust"))
			then
				return BOT_ACTION_DESIRE_MODERATE, ally;
			end
		end

		if not npcBot:HasModifier("modifier_ogre_magi_bloodlust") then
			return BOT_ACTION_DESIRE_MODERATE, npcBot;
		end

	end
    
	return BOT_ACTION_DESIRE_NONE, 0
end

function ogreAbility:nukeDamage( bot, enemy )
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

function ogreAbility:queueNuke(bot, enemy, castQueue, engageDist)
    if not utils.ValidTarget(enemy) then return false end
    
    -- WRITE CODE HERE --
    
    return false
end

return ogreAbility
