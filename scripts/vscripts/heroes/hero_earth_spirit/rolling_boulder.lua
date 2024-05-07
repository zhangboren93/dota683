require("../../items/item_magic_stick")
function rollingMotion(event)
	local caster = event.caster
	local ability = event.ability
	if (caster:GetAbsOrigin() - ability.startPosition):Length2D() >= ability.rollDistance 
		or caster:IsStunned() 
		or not caster:HasModifier("modifier_rolling_boulder_check_hit_units") then
		caster:EmitSound("Hero_EarthSpirit.RollingBoulder.Destroy")
		rollingStop(caster)
	else
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.rollDirection * ability.rollSpeed / 30)
	end
end

function rollingStop(caster)
	caster:InterruptMotionControllers(false)
	caster:RemoveModifierByName("modifier_rolling_boulder_check_hit_units")
    order = {
        UnitIndex = caster:GetEntityIndex(),
        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = caster:GetAbsOrigin(),
        Queue = false
    }
    ExecuteOrderFromTable(order)
	caster:StopSound("Hero_EarthSpirit.RollingBoulder.Loop")
end

function handleSpellStart(event)
	local target = event.target_points[1]
	local caster = event.caster
	local ability = event.ability
	ProcsMagicStick(event)
	ability.startPosition = caster:GetAbsOrigin()
	ability.rollDistance = ability:GetSpecialValueFor("distance")
	ability.rollSpeed = ability:GetSpecialValueFor("speed")
	ability.rollDirection = (target - caster:GetAbsOrigin()):Normalized()
end

function handleIntervalThink(event)
	local caster = event.caster
	if caster:IsStunned() then
		caster:RemoveModifierByName("modifier_rolling_boulder_check_hit_units")
		return
	end
	if not caster:HasModifier("modifier_rolling_boulder_check_hit_units") then
		return
	end
	if caster:FindModifierByName("modifier_rolling_boulder_check_hit_units"):GetRemainingTime() > 2 then
		return
	end
	local ability = event.ability
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")
	-- Damage creeps
	local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)
	for i=1,#units do
		if not units[i]:IsConsideredHero() then
			ability:ApplyDataDrivenModifier(caster, units[i], "modifier_rolling_boulder_creep_hit", {})
		end
	end
	-- hit hero
	for i=1,#units do
		if units[i]:IsConsideredHero() then
			ability:ApplyDataDrivenModifier(caster, units[i], "modifier_rolling_boulder_hero_slow", {})
			rollingStop(caster)
			caster:SetAbsOrigin(units[i]:GetAbsOrigin() + ability.rollDirection * 128) 
			units[i]:EmitSound("Hero_EarthSpirit.RollingBoulder.Destroy")
			ApplyDamage({victim = units[i], attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

			local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 3000, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
			for j=1,#units do
				if units[j]:HasModifier("modifier_earth_spirit_magnetize") then
					ability:ApplyDataDrivenModifier(caster, units[j], "modifier_rolling_boulder_hero_slow", {})
				end
			end
			return
		end
	end
	-- hit rock to gain speed and distance
	local rocks2 = Entities:FindAllByClassname("npc_dota_earth_spirit_stone")
	local rocks = {}
	for i = 1,#rocks2 do 
		if rocks2[i]:IsAlive() and (caster:GetAbsOrigin() - rocks2[i]:GetAbsOrigin()):Length2D() <= radius then 
			table.insert(rocks, rocks2[i]) 
		end
	end

	if #rocks > 0 then
		if ability.rollDistance == 800 then
			caster:EmitSound("Hero_EarthSpirit.RollingBoulder.Stone")
		end
		ability.rollDistance = ability:GetSpecialValueFor("rock_distance")
		ability.rollSpeed = ability:GetSpecialValueFor("rock_speed")
	end
	for i=1,#rocks do
		rocks[i]:ForceKill(false)
	end

	GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), radius, false)
end
