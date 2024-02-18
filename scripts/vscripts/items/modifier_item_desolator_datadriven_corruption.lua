modifier_item_desolator_datadriven_corruption = class({})
function modifier_item_desolator_datadriven_corruption:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_item_desolator_datadriven_corruption:GetModifierPhysicalArmorBonus()
	return -7
end
