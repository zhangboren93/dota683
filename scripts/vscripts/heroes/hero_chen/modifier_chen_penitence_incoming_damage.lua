modifier_chen_penitence_incoming_damage_lua = class({})

function modifier_chen_penitence_incoming_damage_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_chen_penitence_incoming_damage_lua:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("incoming_damage_pct")
end

function modifier_chen_penitence_incoming_damage_lua:IsPurgable()
	return true
end

function modifier_chen_penitence_incoming_damage_lua:IsHidden()
	return true
end

function modifier_chen_penitence_incoming_damage_lua:IsDebuff()
	return true
end
