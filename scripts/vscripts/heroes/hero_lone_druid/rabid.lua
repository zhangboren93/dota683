--[[
	Author: Noya
	Date: 15.01.2015.
	Checks all units owned by the player
	Applies a buff to all of them or just some in particular.
	Checks for both the default and the datadriven synergy ability
]]
function Rabid( event )
	local caster = event.caster
	local targets = event.target_entities
	local ability = event.ability
	local rabid_duration = ability:GetSpecialValueFor("rabid_duration")

	local unit_name = event.unit_name

	local synergyAbility = caster:FindAbilityByName("lone_druid_synergy_datadriven")

	if synergyAbility ~= nil then
		local rabid_duration_bonus = synergyAbility:GetLevelSpecialValueFor( "rabid_duration_bonus", synergyAbility:GetLevel() - 1 )
		
		-- If the ability was leveled up, add the bonus
		if rabid_duration_bonus ~= nil then
			rabid_duration = rabid_duration + rabid_duration_bonus
		end
	end

	-- Iterate over all the units
	for _,unit in pairs(targets) do
		local u = unit:GetUnitName()
		local string_contains_unit = string.find( tostring(u) , tostring(unit_name))
		if unit:GetOwner() == caster:GetOwner() and string_contains_unit == 1 then
			EmitSoundOn("MobaTimeMachine.LoneDruid_RabidBear", unit)
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_rabid_datadriven", { duration = rabid_duration })
		end
	end

	-- Apply to the caster
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_rabid_datadriven", { duration = rabid_duration })

end