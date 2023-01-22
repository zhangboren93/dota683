if item_necronomicon_intellect_modifier == nil then
    item_necronomicon_intellect_modifier = class({})
end

function item_necronomicon_intellect_modifier:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function item_necronomicon_intellect_modifier:OnCreated(kv)
--    print("item_orchid_regen_percentage_modifier:OnCreated")
    self:StartIntervalThink(0.5)
end

function item_necronomicon_intellect_modifier:IsHidden()
    return true
end

function item_necronomicon_intellect_modifier:OnIntervalThink()
    --print("interval think")
    local hParent = self:GetParent() --the unit.
    if hParent == nil or hParent.FindItemInInventory == nil then
        return
    end
    local item = hParent:FindItemInInventory("item_necronomicon")
    if item ~= nil and item:GetItemState() == 1 then
        if hParent:FindModifierByName("modifier_necronomicon_bonus_intellect") == nil then
            print("adding intellect bonus modifier")
            hParent:AddNewModifier(
                hParent, nil, 
                "modifier_necronomicon_bonus_intellect",
                { bonus_intellect = item:GetSpecialValueFor("bonus_intellect")})
        end
    else
        hParent:RemoveModifierByName("modifier_necronomicon_bonus_intellect")
    end
    item = hParent:FindItemInInventory("item_necronomicon_2")
    if item ~= nil and item:GetItemState() == 1 then
        if hParent:FindModifierByName("modifier_necronomicon_2_bonus_intellect") == nil then
            print("adding intellect bonus modifier")
            hParent:AddNewModifier(
                hParent, nil, 
                "modifier_necronomicon_2_bonus_intellect", 
                { bonus_intellect = item:GetSpecialValueFor("bonus_intellect")})
        end
    else
        hParent:RemoveModifierByName("modifier_necronomicon_2_bonus_intellect")
    end
    item = hParent:FindItemInInventory("item_necronomicon_3")
    if item ~= nil and item:GetItemState() == 1 then
        if hParent:FindModifierByName("modifier_necronomicon_3_bonus_intellect") == nil then
            print("adding intellect bonus modifier")
            hParent:AddNewModifier(
                hParent, nil, 
                "modifier_necronomicon_3_bonus_intellect", 
                { bonus_intellect = item:GetSpecialValueFor("bonus_intellect")})
        end
    else
        hParent:RemoveModifierByName("modifier_necronomicon_3_bonus_intellect")
    end
end
