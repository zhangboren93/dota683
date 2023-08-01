function handleAbilityExecuted(event)
	if event.event_ability:GetName() == "mirana_arrow" then
		event.caster.arrow_start_loc = event.caster:GetAbsOrigin()
	end
end
