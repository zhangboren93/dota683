function handleAbilityExecuted(event)
	local target_ability = event.event_ability
	local caster = event.caster
	if target_ability:GetName() == "phoenix_sun_ray" then
		caster:FindAbilityByName("phoenix_sun_ray_toggle_move"):SetHidden(false)
	end
end
