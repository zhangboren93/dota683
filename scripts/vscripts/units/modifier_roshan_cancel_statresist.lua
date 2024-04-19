modifier_roshan_cancel_status_resistance_lua = class({})
function modifier_roshan_cancel_status_resistance_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end
function modifier_roshan_cancel_status_resistance_lua:GetModifierStatusResistanceStacking()
	return -25
end
function modifier_roshan_cancel_status_resistance_lua:IsHidden()
	return true
end
