modifier_rubick_fade_bolt_debuff_lua = class({})

function modifier_rubick_fade_bolt_debuff_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE 
	}
end

function modifier_rubick_fade_bolt_debuff_lua:GetModifierPreAttack_BonusDamage()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local ret = ability:GetSpecialValueFor("attack_damage_reduction_tooltip") * -1
	if parent:IsCreep() then
		ret = ability:GetSpecialValueFor("attack_damage_reduction_creep") * -1
	end
	return ret
end

function modifier_rubick_fade_bolt_debuff_lua:IsDebuff()
	return true
end

function modifier_rubick_fade_bolt_debuff_lua:IsPurgable()
	return true
end

function modifier_rubick_fade_bolt_debuff_lua:GetEffectName()
	return "particles/units/heroes/hero_rubick/rubick_fade_bolt_debuff.vpcf"
end
