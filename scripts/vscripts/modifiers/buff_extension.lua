modifier2armor = {}
modifier2armor["modifier_item_crimson_guard_extra"] = 2

if modifier_buff_extension == nil then
    modifier_buff_extension = class({})
end

function modifier_buff_extension:OnCreated(kv)
    self.kv = kv
end

function modifier_buff_extension:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_buff_extension:DeclareFunctions()
    local funcs =
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
    return funcs
end

function modifier_buff_extension:IsHidden()
    return true
end

function modifier_buff_extension:IsBuff()
    return true
end

function modifier_buff_extension:GetModifierPhysicalArmorBonus()
    local result = 0;
    if self:GetParent():HasModifier("modifier_item_crimson_guard_extra") then
        result = result + modifier2armor["modifier_item_crimson_guard_extra"];
    end
    return result
end