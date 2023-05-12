function handleAbilityExecuted(event)
	local unit = event.unit
	local ability2 = event.ability
	local event_ability = event.event_ability
	if event_ability:GetName() == "item_blade_mail" then
		unit:AddNewModifier(unit, event_ability, "modifier_item_blade_mail_new_active", {}):SetDuration(4.5, true)
	end
end