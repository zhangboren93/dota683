if modifier_item_crimson_guard_effect == nil then
    modifier_item_crimson_guard_effect = class({})
end

function modifier_item_crimson_guard_effect:OnCreated(kv)
    self.kv = kv
end

function modifier_item_crimson_guard_effect:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_item_crimson_guard_effect:DeclareFunctions()
    local funcs =
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
    return funcs
end

function modifier_item_crimson_guard_effect:IsBuff()
    return true
end

function modifier_item_crimson_guard_effect:GetModifierPhysicalArmorBonus()
    return 2
end