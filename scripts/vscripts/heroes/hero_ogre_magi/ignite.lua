--[[Author: YOLOSPAGHETTI
	Date: February 14, 2016
	Checks if the target already has a projectile flying at it, and attempts to send one at a fresh target]]
function CheckTargets(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = caster:FindAbilityByName("ogre_magi_ignite_datadriven")
	local multicast_range = ability:GetLevelSpecialValueFor("multicast_range", ability:GetLevel() -1)
	local multicast_delay = ability:GetLevelSpecialValueFor("multicast_delay", ability:GetLevel() -1)
	local is_new_target = 0
	
	if target:HasModifier("modifier_ignite_multicast") then
		local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, multicast_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
		-- Checks all the units in the radius to see if they have the modifier, and applies it to the first unit without
		for i,unit in ipairs(units) do
			if unit:HasModifier("modifier_ignite_multicast") then
			else
				ability:ApplyDataDrivenModifier( caster, unit, "modifier_ignite_multicast", {Duration = 4*multicast_delay} )
				is_new_target = 1
				break
			end
		end
		-- Applies the modifier to the initial target again if there are no units in the radius without it
		if is_new_target == 0 then
			ability:ApplyDataDrivenModifier( caster, target, "modifier_ignite_multicast", {Duration = 4*multicast_delay} )
		end
	else
		-- Applies the modifier to the initial target if it does not already have it
		ability:ApplyDataDrivenModifier( caster, target, "modifier_ignite_multicast", {Duration = 4*multicast_delay} )
	end
end

--[[Author: YOLOSPAGHETTI
	Date: February 14, 2016
	Checks whether the target is in cast range (the cast range in datadriven is set to its maximum range)]]
function CheckDistance(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	ability:ApplyDataDrivenModifier( caster, target, "modifier_ignite_multicast", {} )
end

--[[Author: YOLOSPAGHETTI
	Date: February 14, 2016
	Applies an aoe effect on the target, if multicast is leveled]]
function AOEEffect(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local multicast = caster:FindAbilityByName("ogre_magi_multicast")
	local ignite_aoe = ability:GetLevelSpecialValueFor("ignite_aoe", multicast:GetLevel() -1)
	
	if multicast:GetLevel() > 0 then
		local units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, ignite_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
		for i,unit in ipairs(units) do
			ability:ApplyDataDrivenModifier( caster, unit, "modifier_ignite_datadriven", {} )
		end
	else
		ability:ApplyDataDrivenModifier( caster, target, "modifier_ignite_datadriven", {} )
	end
end
