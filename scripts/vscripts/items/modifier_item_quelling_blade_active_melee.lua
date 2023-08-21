modifier_item_quelling_blade_active_melee_lua = class({})

function modifier_item_quelling_blade_active_melee_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_item_quelling_blade_active_melee_lua:GetModifierBaseDamageOutgoing_Percentage()
	return 33
end

function modifier_item_quelling_blade_active_melee_lua:IsHidden()
	return true
end
