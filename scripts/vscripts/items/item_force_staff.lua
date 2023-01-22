if item_force_staff_health_regen_modifier == nil then
    item_force_staff_health_regen_modifier = class({})
end

function item_force_staff_health_regen_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
    return funcs
end

function item_force_staff_health_regen_modifier:IsHidden()
    return true
end

function item_force_staff_health_regen_modifier:GetModifierConstantHealthRegen()
    local hero = self:GetParent()
    if hero == nil or hero.FindItemInInventory == nil then
        return 0
    end
    local item = hero:FindItemInInventory("item_force_staff")
    if item == nil or item:GetItemState() ~= 1 then
        return 0
    end
    return item:GetSpecialValueFor("bonus_health_regen")
end