modifier_item_mask_of_madness_datadriven_berserk = class({})

function modifier_item_mask_of_madness_datadriven_berserk:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_item_mask_of_madness_datadriven_berserk:GetModifierMoveSpeedBonus_Percentage()
	return 30
end

function modifier_item_mask_of_madness_datadriven_berserk:GetModifierAttackSpeedBonus_Constant()
	return 100
end

function modifier_item_mask_of_madness_datadriven_berserk:GetModifierIncomingDamage_Percentage()
	return 30
end

function modifier_item_mask_of_madness_datadriven_berserk:GetStatusEffectName()
	return "particles/items2_fx/mask_of_madness.vpcf"
end
