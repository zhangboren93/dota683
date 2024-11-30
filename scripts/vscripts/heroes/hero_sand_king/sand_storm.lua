--[[
	Author: kritth
	Date: 1.1.2015
	Remove the loop sound upon destroying the modifier
]]
function sand_storm_remove_sound( keys )
	local sound_name = "Ability.SandKing_SandStorm.loop"
	local ability = keys.ability
	local caster = keys.caster 
	if ability.sand_storm_unit ~= nil then
		ability.sand_storm_unit:StopSound(sound_name)
	end
end

function handleSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	if ability.sand_storm_unit ~= nil then
		ability.sand_storm_unit:ForceKill(false)
		ability.sand_storm_unit = nil
	end
	CreateUnitByNameAsync("npc_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeam(), function(unit)
		ability.sand_storm_unit = unit
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_sand_storm_vfx_datadriven", {})
		unit:EmitSound("Ability.SandKing_SandStorm.loop")	
	end)
end

function handleDelayedRemove(event)
	local caster = event.caster
	local ability = event.ability 
	if ability.sand_storm_unit ~= nil then
		ability.sand_storm_unit:ForceKill(false)
		ability.sand_storm_unit = nil
	end
end
