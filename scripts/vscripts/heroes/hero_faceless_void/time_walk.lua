require("../../items/item_magic_stick")
--[[Author: Pizzalol
	Date: 21.09.2015.
	Prepares all the required information for movement]]
function TimeWalk( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local modifier = keys.caster_modifier

	-- Distance calculations
	local speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1))
	local distance = (target_point - caster_location):Length2D()
	local direction = (target_point - caster_location):Normalized()
	local duration = distance/speed

	ProcsMagicStick(keys) 
	-- Saving the data in the ability
	ability.time_walk_distance = distance
	ability.time_walk_speed = speed * 1/30 -- 1/30 is how often the motion controller ticks
	ability.time_walk_direction = direction
	ability.time_walk_traveled_distance = 0

	-- Apply the invlunerability modifier to the caster
	ability:ApplyDataDrivenModifier(caster, caster, modifier, {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_time_walk_slow_aura_datadriven", {duration = duration})

	local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_walk_preimage.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pid, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pid, 1, target_point)
	ParticleManager:SetParticleControlEnt(pid, 2, caster, PATTACH_ABSORIGIN, nil, Vector(0, 0, 1), false)
	ParticleManager:ReleaseParticleIndex(pid)
end

--[[Author: Pizzalol
	Date: 21.09.2015.
	Moves the target until it has traveled the distance to the chosen point]]
function TimeWalkMotion( keys )
	local caster = keys.target
	local ability = keys.ability

	-- Move the caster while the distance traveled is less than the original distance upon cast
	if ability.time_walk_traveled_distance < ability.time_walk_distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.time_walk_direction * ability.time_walk_speed)
		ability.time_walk_traveled_distance = ability.time_walk_traveled_distance + ability.time_walk_speed
	else
		-- Remove the motion controller once the distance has been traveled
		caster:InterruptMotionControllers(false)
        order = {
            UnitIndex = caster:GetEntityIndex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = caster:GetAbsOrigin(),
            Queue = false
        }
        ExecuteOrderFromTable(order)
	end
end
