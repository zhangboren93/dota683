modifier_item_satanic_datadriven = class({})

function modifier_item_satanic_datadriven:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(1)
end

function modifier_item_satanic_datadriven:OnIntervalThink()
	local parent = self:GetParent()
	if parent and not parent:HasModifier("modifier_generic_orb_effect_item_lua") then
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_generic_orb_effect_item_lua", {})
	end
end

function modifier_item_satanic_datadriven:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_item_satanic_datadriven:GetModifierPreAttack_BonusDamage()
	return 20
end

function modifier_item_satanic_datadriven:GetModifierBonusStats_Strength()
	return 25
end

function modifier_item_satanic_datadriven:GetModifierPhysicalArmorBonus()
	return 5
end

function modifier_item_satanic_datadriven:IsHidden()
	return true
end
