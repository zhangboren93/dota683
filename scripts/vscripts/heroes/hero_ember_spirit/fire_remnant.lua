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

ember_spirit_fire_remnant_datadriven = class({
	OnUpgrade = function(self)
		local activate_ability = self:GetCaster():FindAbilityByName("ember_spirit_activate_fire_remnant_datadriven")
		local ability = self
		if activate_ability ~= nil then
			activate_ability:SetLevel(ability:GetLevel())
		end

		-- Only start charging at level 1
		if ability:GetLevel() == 1 then
			-- Variables
			local caster = self:GetCaster()
			local modifierName = "modifier_fire_remnant_counter_lua"
			local maximum_charges = ability:GetSpecialValueFor("max_charges")
			local charge_replenish_time = ability:GetSpecialValueFor("charge_restore_time")
			
			-- Initialize stack
			caster.fire_remnant_charges = maximum_charges
			caster.start_charge = false
			caster.fire_remnant_cooldown = 0.0
			
			caster:AddNewModifier(caster, ability, modifierName, {})
			caster:SetModifierStackCount( modifierName, caster, maximum_charges )
			
			-- create timer to restore stack
			caster:SetThink( function()
					-- Restore charge
					if caster.start_charge and caster.fire_remnant_charges < maximum_charges then
						-- Calculate stacks
						local next_charge = caster.fire_remnant_charges + 1
						caster:RemoveModifierByName( modifierName )
						if next_charge ~= maximum_charges then
							caster:AddNewModifier(caster, ability, modifierName, { Duration = charge_replenish_time } )
							fire_remnant_start_cooldown( caster, charge_replenish_time )
						else
							caster:AddNewModifier(caster, ability, modifierName, {} )
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
	end,
	OnSpellStart = function(self)
		-- Check condition
		local caster = self:GetCaster()
		if caster.fire_remnant_charges < 1 then
			return
		else
			caster.fire_remnant_charges = caster.fire_remnant_charges - 1
		end
		
		-- Variables
		local target = self:GetCursorPosition()
		local ability = self
		local modifierCounterName = "modifier_fire_remnant_counter_lua"
		local modifierCounterCooldownName = "modifier_fire_remnant_counter_cooldown_lua"
		local dummyAnimationModifierName = "modifier_fire_remnant_dummy_animation_override_lua"
		local dummyModifierName = "modifier_fire_remnant_dummy_buff_lua"
		local maximum_charges = ability:GetSpecialValueFor("max_charges")
		local charge_replenish_time = ability:GetSpecialValueFor("charge_restore_time" )
		local movespeed_multiplier = ability:GetSpecialValueFor("speed_multiplier")
		local dummyVisionRadius = ability:GetSpecialValueFor("vision_radius")
		local dummyDuration = ability:GetSpecialValueFor("duration")
		
		local intervals_per_second = 33.0
		local movespeed = caster:GetBaseMoveSpeed() * movespeed_multiplier
		local forwardVec = ( target - caster:GetAbsOrigin() ):Normalized()
	
		-- Create dummy and move it to location
		local dummy = CreateUnitByName( caster:GetName(), caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber() )
		--dummy:AddNewModifier( caster, ability, dummyAnimationModifierName, {} )
		dummy:StartGesture(ACT_DOTA_RUN)
		dummy:AddNewModifier( caster, ability, dummyModifierName, {} )
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
			caster:AddNewModifier(caster, ability, modifierCounterName, { Duration = charge_replenish_time } )
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
		caster:AddNewModifier(caster, ability, modifierCounterCooldownName, { duration = 45 } )
		
		-- Move to location at multiplier * speed
		dummy:StartGesture(ACT_DOTA_RUN )
		dummy:AddNewModifier(caster, ability, "modifier_ember_spirit_fire_remnant_add_location_lua", { speed = movespeed, x = target.x, y = target.y })
		caster:EmitSound("Hero_EmberSpirit.FireRemnant.Cast")
	end,
	IsStealable = function() return false end
})

ember_spirit_activate_fire_remnant_datadriven = class({
	GetAssociatedSecondaryAbilities = function() return "ember_spirit_fire_remnant_datadriven" end,
	OnSpellStart = function(self)
		if not IsServer() then return end
		local caster = self:GetCaster()	
		local target = self:GetCursorPosition()
		
		local index = -1
		local max_distance = 0
		if caster.fire_remnant_entities == nil then
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
		local ability = self
		
		-- Remove the entity from the list, in cast multiple activate is triggered so it will move to next unit instantly
		-- Set up variables
		caster.fire_remnant_entities[index] = nil
		
		caster:AddNewModifier(caster, ability, "modifier_ember_spirit_fire_remnant_activate_lua", {
			destination = index,
			target_x = target.x,
			target_y = target.y,
			duration = 2
		})
		caster:AddNewModifier(caster, ability, "modifier_activate_fire_remnant_buff_lua", { duration = 2 })
			
		caster:EmitSound("Hero_EmberSpirit.FireRemnant.Activate")
	end
})
