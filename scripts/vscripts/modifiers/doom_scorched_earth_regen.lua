-- Deprecated

if modifier_doom_scorched_earth_regen == nil then
    modifier_doom_scorched_earth_regen = class({})
end

function modifier_doom_scorched_earth_regen:OnCreated(kv)
    print(kv.health_regen)
    self.kv = kv
end

function modifier_doom_scorched_earth_regen:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_doom_scorched_earth_regen:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
    return funcs
end

function modifier_doom_scorched_earth_regen:IsHidden()
    return false
end

function modifier_doom_scorched_earth_regen:GetModifierConstantHealthRegen()
    return self.kv.health_regen
end

function modifier_doom_scorched_earth_regen:GetTexture()
    return "doom_bringer_scorched_earth"
end

function modifier_doom_scorched_earth_regen:IsDebuff()
    return false
end