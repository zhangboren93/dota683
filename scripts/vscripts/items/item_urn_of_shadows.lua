if item_urn_bonus_modifier == nil then
    item_urn_bonus_modifier = class({})
end

function item_urn_bonus_modifier:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function item_urn_bonus_modifier:OnCreated(kv)
--    print("item_orchid_regen_percentage_modifier:OnCreated")
    self:StartIntervalThink(0.5)
end

function item_urn_bonus_modifier:IsHidden()
    return true
end

function item_urn_bonus_modifier:OnIntervalThink()
    --print("interval think")
    local hParent = self:GetParent() --the unit.
    if hParent == nil or hParent.FindItemInInventory == nil then
        return
    end
    local item = hParent:FindItemInInventory("item_urn_of_shadows")
    if item ~= nil and item:GetItemState() == 1 then
        --print("sheepstick state: " .. item:GetItemState())
        
        local mana_gen = hParent:GetManaRegen();
        local mana_gen_bonus = item:GetSpecialValueFor("bonus_mana_regen_percentage")
        local bonus_mana = mana_gen * mana_gen_bonus / 100
        -- think interval is 0.5s
        bonus_mana = bonus_mana / 2
        -- print("orchid bonus mana " .. bonus_mana)
        hParent:GiveMana(bonus_mana)


        -- add strength bonus modifier
        if not hParent:HasModifier("modifier_bonus_strength_lua") then
            print("adding strength bonus modifier")
            hParent:AddNewModifier(hParent, nil, "modifier_bonus_strength_lua", {})
        end
    else
        hParent:RemoveModifierByNameAndCaster("modifier_bonus_strength_lua", hParent)
    end
end