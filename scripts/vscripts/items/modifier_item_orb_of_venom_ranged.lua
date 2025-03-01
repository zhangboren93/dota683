modifier_item_orb_of_venom_ranged_lua = class({
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE 
	} end,
	GetModifierMoveSpeedBonus_Percentage = function(self)
		local caster = self:GetCaster()
		if caster:IsRangedAttacker() then
			return self:GetAbility():GetSpecialValueFor("poison_movement_speed_range")
		else
			return self:GetAbility():GetSpecialValueFor("poison_movement_speed_melee")
		end
	end,
	OnCreated = function(self)
		self:StartIntervalThink(1)
	end,
	OnIntervalThink = function(self)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local damage = ability:GetSpecialValueFor("poison_damage")
		ApplyDamage({
			attacker = caster,
			victim = parent,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		})
	end,
	GetEffectName = function() return "particles/items2_fx/orb_of_venom.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end
})
