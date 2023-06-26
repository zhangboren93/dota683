-- There is a bug where items with initials charges are sold based on charge count. 
-- As a work-arround, we set initial charges when the item is equipped
function handleEquip(event)
	local item = event.ability
	if not item.has_initial_charge_set then
		local initial_charges = item:GetSpecialValueFor("initial_equip_charges")
		item:SetCurrentCharges(initial_charges)
		print(item:GetName() .. " equipped and initial charges set to " .. initial_charges)
		item.has_initial_charge_set = true
	end
end