modifier_item_quelling_blade_active_ranged_lua = class({})

function modifier_item_quelling_blade_active_ranged_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_item_quelling_blade_active_ranged_lua:GetModifierBaseDamageOutgoing_Percentage()
	return 12
end

function modifier_item_quelling_blade_active_ranged_lua:IsHidden()
	return true
end

