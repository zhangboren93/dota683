function handleTakeDamage(event)
	local entity = event.unit

	if event.inflictor == nil or event.original_damage >= 20 then
		entity:RemoveModifierByName("modifier_item_flask_datadriven_active")
	end
end
