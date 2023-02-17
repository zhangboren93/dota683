if modifier_riki_invis_health_regen == nil then
    modifier_riki_invis_health_regen = class({})
end

function modifier_riki_invis_health_regen:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_riki_invis_health_regen:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
    return funcs
end

function modifier_riki_invis_health_regen:IsHidden()
    return true
end

function modifier_riki_invis_health_regen:GetModifierConstantHealthRegen()
    if self:GetParent():HasModifier("modifier_invisible") then
        return self:GetAbility():GetSpecialValueFor("health_regen")
    else
        return 0
    end
end