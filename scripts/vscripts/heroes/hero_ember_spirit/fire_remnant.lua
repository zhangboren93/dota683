--[[
	Author: kritth
	Date: 17.1.2015.
	Level up activate fire remnant same time
]]
function fire_remnant_upgrade( keys )
	for i = 0, keys.caster:GetAbilityCount() - 1 do
		local currentAbility = keys.caster:GetAbilityByIndex( i )
		if currentAbility ~= nil and currentAbility:GetAbilityName() == keys.ability_name then
			if currentAbility:GetLevel() ~= keys.ability:GetLevel() then
				currentAbility:SetLevel( keys.ability:GetLevel() )
			end
			break
		end
	end
end

--[[
	Author: kritth
	Date: 18.1.2015.
	Init: Create a timer to start charging charges, modified from shrapnel code
	NOTE: This function only restores charges and manage the cooldown, doesn't have anything to do with duration of remnant
]]
function fire_remnant_charge( keys )
	-- Only start charging at level 1
	if keys.ability:GetLevel() ~= 1 then return end

	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_fire_remnant_counter_datadriven"
	local maximum_charges = ability:GetLevelSpecialValueFor( "max_charges", ( ability:GetLevel() - 1 ) )
	local charge_replenish_time = ability:GetLevelSpecialValueFor( "charge_restore_time", ( ability:GetLevel() - 1 ) )
	
	-- Initialize stack
	caster:SetModifierStackCount( modifierName, caster, 0 )
	caster.fire_remnant_charges = maximum_charges
	caster.start_charge = false
	caster.fire_remnant_cooldown = 0.0
	
	ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
	caster:SetModifierStackCount( modifierName, caster, maximum_charges )
	
	-- create timer to restore stack
	caster:SetThink( function()
			-- Restore charge
			if caster.start_charge and caster.fire_remnant_charges < maximum_charges then
				-- Calculate stacks
				local next_charge = caster.fire_remnant_charges + 1
				caster:RemoveModifierByName( modifierName )
				if next_charge ~= maximum_charges then
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = charge_replenish_time } )
					fire_remnant_start_cooldown( caster, charge_replenish_time )
				else
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
					caster.start_charge = false
				end
				caster:SetModifierStackCount( modifierName, caster, next_charge )
				
				-- Update stack
				caster.fire_remnant_charges = next_charge
			end
			
			-- Check if max is reached then check every 0.5 seconds if the charge is used
			if caster.fire_remnant_charges ~= maximum_charges then
				caster.start_charge = true
				return charge_replenish_time
			else
				return 0.5
			end
		end, "restore stacks", 0.5)
end

--[[
	Author: kritth
	Date: 18.01.2015.
	Helper: Create timer to track cooldown
]]
function fire_remnant_start_cooldown( caster, charge_replenish_time )
	caster.fire_remnant_cooldown = charge_replenish_time
	caster:SetThink( function()
			local current_cooldown = caster.fire_remnant_cooldown - 0.1
			if current_cooldown > 0.1 then
				caster.fire_remnant_cooldown = current_cooldown
				return 0.1
			else
				return nil
			end
		end, "fire remnamt start cooldown", 0.1)
end

--[[
	Author: kritth
	Date: 20.01.2015.
	Add dummy to the caster after user uses the ability
]]
function fire_remnant_add_location( keys )
	-- Check condition
	if keys.caster.fire_remnant_charges < 1 then
		return
	else
		keys.caster.fire_remnant_charges = keys.caster.fire_remnant_charges - 1
	end
	
	-- Variables
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local modifierCounterName = "modifier_fire_remnant_counter_datadriven"
	local modifierCounterCooldownName = "modifier_fire_remnant_counter_cooldown_datadriven"
	local dummyAnimationModifierName = "modifier_fire_remnant_dummy_animation_override_datadriven"
	local dummyModifierName = "modifier_fire_remnant_dummy_buff_datadriven"
	local maximum_charges = ability:GetLevelSpecialValueFor( "max_charges", ( ability:GetLevel() - 1 ) )
	local charge_replenish_time = ability:GetLevelSpecialValueFor( "charge_restore_time", ( ability:GetLevel() - 1 ) )
	local movespeed_multiplier = ability:GetLevelSpecialValueFor( "speed_multiplier", ability:GetLevel() - 1 )
	local dummyVisionRadius = ability:GetLevelSpecialValueFor( "vision_radius", ability:GetLevel() - 1 )
	local dummyDuration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	
	local intervals_per_second = 33.0
	local movespeed = caster:GetBaseMoveSpeed() * movespeed_multiplier
	local forwardVec = ( target - caster:GetAbsOrigin() ):Normalized()

	-- Create dummy and move it to location
	local dummy = CreateUnitByName( caster:GetName(), caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber() )
	ability:ApplyDataDrivenModifier( caster, dummy, dummyAnimationModifierName, {} )
	ability:ApplyDataDrivenModifier( caster, dummy, dummyModifierName, {} )
	dummy:SetDayTimeVisionRange( dummyVisionRadius )
	dummy:SetNightTimeVisionRange( dummyVisionRadius )
	dummy:AddNewModifier( caster, nil, "modifier_illusion", { duration = dummyDuration } )
	dummy:MakeIllusion()
	dummy:SetHullRadius( 0 )
	dummy:SetForwardVector( forwardVec )
	
	-- Add dummy to table
	-- NOTE: This is based on the assumption that the maximum will be at certain amount only
	if not caster.fire_remnant_entities then caster.fire_remnant_entities = {} end
	
	caster.fire_remnant_entities[ dummy:entindex() ] = target
	
	-- Check if it should start cooldown timer
	if caster.fire_remnant_charges + 1 == maximum_charges then
		caster:RemoveModifierByName( modifierCounterName )
		ability:ApplyDataDrivenModifier( caster, caster, modifierCounterName, { Duration = charge_replenish_time } )
		fire_remnant_start_cooldown( caster, charge_replenish_time )
	end
	caster:SetModifierStackCount( modifierCounterName, caster, caster.fire_remnant_charges )
	
	-- Reduce the charges in counter
	if caster.fire_remnant_charges > 0 then
		ability:EndCooldown()
	else
		ability:StartCooldown( caster.fire_remnant_cooldown )
	end
	
	-- Start the duration on the dummy
	ability:ApplyDataDrivenModifier( caster, caster, modifierCounterCooldownName, {} )
	
	-- Move to location at multiplier * speed
	dummy:StartGesture(ACT_DOTA_RUN )
	dummy:AddNewModifier(caster, ability, "modifier_ember_spirit_fire_remnant_add_location_lua", { speed = movespeed, x = target.x, y = target.y })
	caster:EmitSound("Hero_EmberSpirit.FireRemnant.Cast")
end

--[[
	Author: kritth
	Date: 26.01.2015.
	Activate the dummies
	NOTE: Currently does not detect the use of Sleight of Fist and Blink Dagger yet
	If you want it to be fully done with those above, detect the built-in event and stop the functionality in the timer
	while the other two abilities are active etc.
]]
function fire_remnant_activate( keys )
	if not IsServer() then return end
	local caster = keys.caster	
	local target = keys.target_points[1]
	
	-- Select furthest dummy
	local index = -1
	local max_distance = 0
	if caster.fire_remnant_entities == nil then
		print("No remnant. Skipping.")
		caster:Stop()
		caster:GiveMana(150)
		return
	end
	for k, v in pairs( caster.fire_remnant_entities ) do
		local dummy = EntIndexToHScript( k )
		if dummy == nil or not dummy:IsAlive() then
			caster.fire_remnant_entities[k] = nil
		else
			local distance = ( target - v ):Length2D()
			if distance > max_distance then
				index = k
				max_distance = distance
			end
		end
	end
	if index == -1 then
		caster:Stop()
		caster:GiveMana(150)
		return
	end
	-- Inherit variables
	local ability = keys.ability
	
	-- Remove the entity from the list, in cast multiple activate is triggered so it will move to next unit instantly
	-- Set up variables
	caster.fire_remnant_entities[index] = nil
	
	caster:AddNewModifier(caster, ability, "modifier_ember_spirit_fire_remnant_activate_lua", {
		destination = index,
		target_x = target.x,
		target_y = target.y })
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_activate_fire_remnant_buff_datadriven", {})
		
	caster:EmitSound("Hero_EmberSpirit.FireRemnant.Activate")
end
