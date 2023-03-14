if modifier_omniknight_guardian_angel_regen == nil then
    modifier_omniknight_guardian_angel_regen = class({})
end

function modifier_omniknight_guardian_angel_regen:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_omniknight_guardian_angel_regen:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
    return funcs
end

function modifier_omniknight_guardian_angel_regen:IsHidden()
    return false
end

function modifier_omniknight_guardian_angel_regen:GetModifierConstantHealthRegen()
    return 25
end
function modifier_omniknight_guardian_angel_regen:GetTexture()
    return "omniknight_guardian_angel"
end

function modifier_omniknight_guardian_angel_regen:IsDebuff()
    return false
end