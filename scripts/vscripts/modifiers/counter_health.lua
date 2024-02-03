modifier_counter_healthbar = class({})

function modifier_counter_healthbar:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_counter_healthbar:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTHBAR_PIPS
    }
    return funcs
end

function modifier_counter_healthbar:IsHidden() return true end
function modifier_counter_healthbar:IsPurgable() return false end

function modifier_counter_healthbar:GetModifierHealthBarPips()
	return math.ceil(self:GetParent():GetMaxHealth() / 4)
end