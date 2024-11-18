modifier_item_mask_of_madness_datadriven_berserk = class({})

function modifier_item_mask_of_madness_datadriven_berserk:OnCreated()
	if self.particleId == nil then
		self.particleId = ParticleManager:CreateParticle("particles/items2_fx/mask_of_madness.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end

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

function modifier_item_mask_of_madness_datadriven_berserk:OnDestroy()
	ParticleManager:DestroyParticle(self.particleId, false)
	self.particleId = nil
end
