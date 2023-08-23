modifier_item_heart_regen_lua = class({})

function modifier_item_heart_regen_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

function modifier_item_heart_regen_lua:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("health_regen_percent_per_second") * self:GetParent():GetMaxHealth() / 100
end
