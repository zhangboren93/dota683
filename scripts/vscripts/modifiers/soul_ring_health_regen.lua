if modifier_soul_ring_health_regen_lua == nil then
    modifier_soul_ring_health_regen_lua = class({})
end
function modifier_soul_ring_health_regen_lua:OnCreated(kv)
    self.kv = kv
end

function modifier_soul_ring_health_regen_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_soul_ring_health_regen_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
    return funcs
end

-- TODO show soul ring icon & regen values
function modifier_soul_ring_health_regen_lua:IsHidden()
    return true
end

function modifier_soul_ring_health_regen_lua:GetModifierConstantHealthRegen()
    return self.kv.bonus_health_regen
end

function modifier_soul_ring_health_regen_lua:GetTexture()
    return "item_soul_ring"
end