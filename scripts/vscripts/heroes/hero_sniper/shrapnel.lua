function handleAbilityExecuted(event)
	local event_ability = event.event_ability
	if event_ability:GetName() == "sniper_shrapnel" then
		local target_point = event_ability:GetCursorPosition()
		event_ability:CreateVisibilityNode(target_point,
			event_ability:GetSpecialValueFor("radius"),
			event_ability:GetSpecialValueFor("damage_delay"))
	end
end
