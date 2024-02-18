modifier_item_helm_of_the_dominator_lua = class({})

function modifier_item_helm_of_the_dominator_lua:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(1)
end

function modifier_item_helm_of_the_dominator_lua:OnIntervalThink()
	local parent = self:GetParent()
	if parent and not parent:HasModifier("modifier_generic_orb_effect_item_lua") then
		parent:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_orb_effect_item_lua", {})
	end
end

function modifier_item_helm_of_the_dominator_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_item_helm_of_the_dominator_lua:GetModifierPhysicalArmorBonus()
	return 5
end

function modifier_item_helm_of_the_dominator_lua:GetModifierConstantHealthRegen()
	return 3
end

function modifier_item_helm_of_the_dominator_lua:GetModifierPreAttack_BonusDamage()
	return 20
end

function modifier_item_helm_of_the_dominator_lua:IsHidden()
	return true
end
