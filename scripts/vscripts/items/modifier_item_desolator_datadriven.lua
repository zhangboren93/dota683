modifier_item_desolator_datadriven = class({})
function modifier_item_desolator_datadriven:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(1)
end

function modifier_item_desolator_datadriven:OnIntervalThink()
	local parent = self:GetParent()
	if parent and not parent:HasModifier("modifier_generic_orb_effect_item_lua") then
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_generic_orb_effect_item_lua", {})
	end
end

function modifier_item_desolator_datadriven:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_item_desolator_datadriven:GetModifierPreAttack_BonusDamage()
	return 60
end

function modifier_item_desolator_datadriven:IsHidden()
	return true
end
