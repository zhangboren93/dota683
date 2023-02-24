if item_equipped_bonus_modifier == nil then
    item_equipped_bonus_modifier = class({})
end

function item_equipped_bonus_modifier:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function item_equipped_bonus_modifier:OnCreated(kv)
    self.kv = kv
    self:StartIntervalThink(0.5)
end

function item_equipped_bonus_modifier:IsHidden()
    return true
end

function item_equipped_bonus_modifier:OnIntervalThink()
    local hParent = self:GetParent() --the unit.
    if hParent == nil or hParent.FindItemInInventory == nil then
        return
    end
    local item = hParent:FindItemInInventory(self.kv.item)
    if item ~= nil and item:GetItemState() == 1 then
        if not hParent:HasModifier(self.kv.modifier) then
            hParent:AddNewModifier(hParent, nil, self.kv.modifier, {})
        end
    else
        hParent:RemoveModifierByName(self.kv.modifier)
    end
end
