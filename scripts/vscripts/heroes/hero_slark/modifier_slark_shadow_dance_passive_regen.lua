modifier_slark_shadow_dance_passive_regen_lua = class({})

function modifier_slark_shadow_dance_passive_regen_lua:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_slark_shadow_dance_passive_regen_lua:OnIntervalThink()
	if not self:GetParent():HasModifier("modifier_slark_shadow_dance_passive_regen") then
		self:Destroy()
	end
end

function modifier_slark_shadow_dance_passive_regen_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

function modifier_slark_shadow_dance_passive_regen_lua:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_pct_regen") * self:GetParent():GetMaxHealth() / 100
end

function modifier_slark_shadow_dance_passive_regen_lua:IsHidden()
	return true
end
