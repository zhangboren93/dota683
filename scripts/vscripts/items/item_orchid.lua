if item_orchid_regen_percentage_modifier == nil then
    item_orchid_regen_percentage_modifier = class({})
end

function item_orchid_regen_percentage_modifier:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function item_orchid_regen_percentage_modifier:OnCreated(kv)
--    print("item_orchid_regen_percentage_modifier:OnCreated")
    self:StartIntervalThink(0.5)
end

function item_orchid_regen_percentage_modifier:IsHidden()
    return true
end

function item_orchid_regen_percentage_modifier:OnIntervalThink()
    --print("interval think")
    local hParent = self:GetParent() --the unit.
    if hParent == nil then
        return
    end
    local item = hParent:FindItemInInventory("item_orchid")
    if item ~= nil and item:GetItemState() == 1 then
        --print("sheepstick state: " .. item:GetItemState())
        
        local mana_gen = hParent:GetManaRegen();
        local mana_gen_bonus = item:GetSpecialValueFor("bonus_mana_regen_percentage")
        local bonus_mana = mana_gen * mana_gen_bonus / 100
        -- think interval is 0.5s
        bonus_mana = bonus_mana / 2
        -- print("orchid bonus mana " .. bonus_mana)
        hParent:GiveMana(bonus_mana)
    end
end