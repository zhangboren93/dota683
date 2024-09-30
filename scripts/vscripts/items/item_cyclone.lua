require("items/item_sphere")
function handleAbilityExecuted(keys)
	local unit = keys.unit
	local ability2 = keys.ability
	local event_ability = keys.event_ability
	local target = keys.target
	if event_ability:GetName() == "item_cyclone" then

		if is_spell_blocked_by_linkens_sphere_a(target, unit) then return end

		local RemovePositiveBuffs = not (target:GetTeam() == unit:GetTeam())
		local RemoveDebuffs = target:GetTeam() == unit:GetTeam()
		local BuffsCreatedThisFrameOnly = false
		local RemoveStuns = false
		local RemoveExceptions = false
		target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
		ability2:ApplyDataDrivenModifier(unit, target, "modifier_eul_cyclone_datadriven", {}):SetDuration(2.5, true)
	end
end

function handleDestroy(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if target:GetTeam() ~= caster:GetTeam() then
		ApplyDamage({
			victim = target,
			attacker = caster,
			damage = 50,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability })
	end
	target:StopThink("cyclone height move")
    target:SetThink(function()
	    FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
    end, "cyclone find space", 0.1)
	target:StopSound("DOTA_Item.Cyclone.Activate")
end

--[[ ============================================================================================================
        Author: Noya, edited by Rook
        Date: April 06, 2015
        Progressively sends the cycloned unit to a max height, then up and down between an interval, and finally back
        to the original ground position.
        Additional parameters: keys.CycloneInitialHeight, keys.CycloneMinHeight, and keys.CycloneMaxHeight
================================================================================================================= ]]
function modifier_invoker_tornado_datadriven_cyclone_on_created(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability

    -- Position variables
    local target_origin = target:GetAbsOrigin()
    local target_initial_x = target_origin.x
    local target_initial_y = target_origin.y
    local target_initial_z = target_origin.z
    local position = Vector(target_initial_x, target_initial_y, target_initial_z)  --This is updated whenever the target has their position changed.

    local duration = 2.5
    local ground_position = GetGroundPosition(position, target)
    local cyclone_initial_height = 350 + ground_position.z
    local cyclone_min_height = 300 + ground_position.z
    local cyclone_max_height = 400 + ground_position.z
    local tornado_start = GameRules:GetGameTime()

    -- Height per time calculation
    local time_to_reach_initial_height = duration / 10  --1/10th of the total cyclone duration will be spent ascending and descending to and from the initial height.
    local initial_ascent_height_per_frame = ((cyclone_initial_height - position.z) / time_to_reach_initial_height) * .03  --This is the height to add every frame when the unit is first cycloned, and applies until the caster reaches their max height.

    local up_down_cycle_height_per_frame = initial_ascent_height_per_frame / 3  --This is the height to add or remove every frame while the caster is in up/down cycle mode.
    if up_down_cycle_height_per_frame > 7.5 then  --Cap this value so the unit doesn't jerk up and down for short-duration cyclones.
        up_down_cycle_height_per_frame = 7.5
    end

    local final_descent_height_per_frame = nil  --This is calculated when the unit begins descending.

    -- Time to go down
    local time_to_stop_fly = duration - time_to_reach_initial_height

    -- Loop up and down
    local going_up = true

    -- Loop every frame for the duration
	target:SetThink(function()
        local time_in_air = GameRules:GetGameTime() - tornado_start

        -- First send the target to the cyclone's initial height.
        if position.z < cyclone_initial_height and time_in_air <= time_to_reach_initial_height then
            --print("+",initial_ascent_height_per_frame,position.z)
            position.z = position.z + initial_ascent_height_per_frame
            target:SetAbsOrigin(position)
        return 0.03

        -- Go down until the target reaches the ground.
        elseif time_in_air > time_to_stop_fly and time_in_air <= duration then
            --Since the unit may be anywhere between the cyclone's min and max height values when they start descending to the ground,
            --the descending height per frame must be calculated when that begins, so the unit will end up right on the ground when the duration is supposed to end.
            if final_descent_height_per_frame == nil then
                    local descent_initial_height_above_ground = position.z - ground_position.z
                    --print("ground position: " .. GetGroundPosition(position, target).z)
                    --print("position.z : " .. position.z)
                    final_descent_height_per_frame = (descent_initial_height_above_ground / time_to_reach_initial_height) * .03
            end

            --print("-",final_descent_height_per_frame,position.z)
            position.z = position.z - final_descent_height_per_frame
            target:SetAbsOrigin(position)
            return 0.03

        -- Do Up and down cycles
        elseif time_in_air <= duration then
            -- Up
            if position.z < cyclone_max_height and going_up then
                    --print("going up")
                    position.z = position.z + up_down_cycle_height_per_frame
                    target:SetAbsOrigin(position)
                    return 0.03

            -- Down
            elseif position.z >= cyclone_min_height then
                    going_up = false
                    --print("going down")
                    position.z = position.z - up_down_cycle_height_per_frame
                    target:SetAbsOrigin(position)
                    return 0.03

            -- Go up again
            else
                    --print("going up again")
                    going_up = true
                    return 0.03
            end
        end
    end, "cyclone height move", 0)
end

function modifier_invoker_tornado_datadriven_cyclone_on_interval_think(keys)
    local target = keys.target
	local total_degrees = 20
	
	--Rotate as close to 20 degrees per .03 seconds (666.666 degrees per second) as possible, but such that the target lands facing their initial direction.
	if keys.target.invoker_tornado_degrees_to_spin == nil then
		local ideal_degrees_per_second = 288
		local ideal_full_spins = (ideal_degrees_per_second / 360) * 2.5
		ideal_full_spins = math.floor(ideal_full_spins + .5)  --Round the number of spins to aim for to the closest integer.
		local degrees_per_second_ending_in_same_forward_vector = (360 * ideal_full_spins) / 2.5
		
		keys.target.invoker_tornado_degrees_to_spin = degrees_per_second_ending_in_same_forward_vector * .03
	end
	
	target:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0, keys.target.invoker_tornado_degrees_to_spin, 0), target:GetForwardVector()))
end
