function handleAbilityExecuted(event)
	local event_ability = event.event_ability
	local ability = event.ability
	local caster = event.caster
	if event_ability:GetName() == "batrider_sticky_napalm" then
		local location = event_ability:GetCursorPosition()
		CreateUnitByNameAsync("npc_dummy_unit_sticy_napalm_vision",
			location,
			false,
			caster,
			caster,
			caster:GetTeam(),
			function(unit)
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_batrider_sticky_napalm_vision_datadriven", { })
				unit:AddNewModifier(caster, ability, "modifier_kill", { duration = 2 })
			end)
	end
end
