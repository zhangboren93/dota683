modifier_melting_strike_debuff_lua = class({})

function modifier_melting_strike_debuff_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_melting_strike_debuff_lua:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * -1
end

function modifier_melting_strike_debuff_lua:IsDebuff()
	return true
end

function modifier_melting_strike_debuff_lua:IsPurgable()
	return true
end

function modifier_melting_strike_debuff_lua:GetAbilityTextureName()
	return "forged_spirit_melting_strike"
end
