--[[Author: YOLOSPAGHETTI
	Date: February 14, 2016
	Checks if the target already has a projectile flying at it, and attempts to send one at a fresh target]]

require("../../items/item_sphere")
require("../../items/item_magic_stick")

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

	ProcsMagicStick(keys)
	
	ability:ApplyDataDrivenModifier( caster, target, "modifier_ignite_multicast", {} )

	local multicast_ability = caster:FindAbilityByName("ogre_magi_multicast_datadriven")
	if multicast_ability:GetLevel() == 0 then
		return
	end
	local two_times = multicast_ability:GetSpecialValueFor( "multicast_2_times")
	local three_times = multicast_ability:GetSpecialValueFor( "multicast_3_times")
	local four_times = multicast_ability:GetSpecialValueFor( "multicast_4_times")
	local rand = math.random(1,100)
	local multicast = 1
	if rand < four_times then
		multicast = 4
	elseif rand < three_times then
		multicast = 3
	elseif rand < two_times then	
		multicast = 2
	else
		return
	end

	local multicast_delay = ability:GetSpecialValueFor("multicast_delay")
	-- Second projectile
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_ignite_multicast_action", {Duration = multicast_delay} )
	EmitSoundOn("Hero_OgreMagi.Ignite.x1", caster)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, caster) 
	ParticleManager:SetParticleControl(particle, 1, Vector(multicast, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle)
	-- Third projectile
	if multicast > 2 then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_ignite_multicast_action", {Duration = 2*multicast_delay} )
		if multicast == 3 then
			EmitSoundOn("Hero_OgreMagi.Ignite.x2", caster)
		end
	end
	-- Fourth projectile
	if multicast > 3 then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_ignite_multicast_action", {Duration = 3*multicast_delay} )
		EmitSoundOn("Hero_OgreMagi.Ignite.x3", caster)
	end
end

--[[Author: YOLOSPAGHETTI
	Date: February 14, 2016
	Applies an aoe effect on the target, if multicast is leveled]]
function AOEEffect(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local multicast = caster:FindAbilityByName("ogre_magi_multicast_datadriven")
	local ignite_aoe = ability:GetLevelSpecialValueFor("ignite_aoe", multicast:GetLevel() -1)
	
	if is_spell_blocked_by_linkens_sphere(target) then return end

	if multicast:GetLevel() > 0 then
		local units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, ignite_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
		for i,unit in ipairs(units) do
			ability:ApplyDataDrivenModifier( caster, unit, "modifier_ignite_datadriven", {} )
		end
	else
		ability:ApplyDataDrivenModifier( caster, target, "modifier_ignite_datadriven", {} )
	end
end
