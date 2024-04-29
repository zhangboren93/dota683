modifier_item_soul_booster_health_regen_lua = class({})
function modifier_item_soul_booster_health_regen_lua:IsHidden() 
	return true
end
function modifier_item_soul_booster_health_regen_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end
function modifier_item_soul_booster_health_regen_lua:GetModifierConstantHealthRegen()
	return 4
end
