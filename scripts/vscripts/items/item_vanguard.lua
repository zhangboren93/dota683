item_vanguard_lua = class({})
function item_vanguard_lua:GetIntrinsicModifierName()
	return "modifier_item_vanguard_lua"
end

modifier_item_vanguard_lua = class({ 
	GetAttributes = function( self ) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
})

function modifier_item_vanguard_lua:OnCreated()
	local ability = self:GetAbility()
	self.bonus_health		= ability:GetSpecialValueFor("bonus_health")
	self.bonus_health_regen = ability:GetSpecialValueFor("bonus_health_regen")
	self.block_damage_melee = ability:GetSpecialValueFor("block_damage_melee")
	self.block_damage_ranged = ability:GetSpecialValueFor("block_damage_ranged")
	self.block_chance		= ability:GetSpecialValueFor("block_chance")
	self.work_for_illusion	= ability:GetSpecialValueFor("work_for_illusion")
end

function modifier_item_vanguard_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_vanguard_lua:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_vanguard_lua:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_vanguard_lua:GetModifierPhysical_ConstantBlock(event)
	local parent = self:GetParent()
	if parent:IsIllusion() and self.work_for_illusion == 0 then return 0 end

	if bit.band(event.damage_flags, DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK) ~= 0 then return end

	if RollPseudoRandomPercentage(self.block_chance,
		DOTA_PSEUDO_RANDOM_ITEM_VANGUARD, parent) then
		
		if parent:IsRangedAttacker() then
			return self.block_damage_ranged
		else
			return self.block_damage_melee
		end
	end
end

function modifier_item_vanguard_lua:IsHidden()
	return true
end
