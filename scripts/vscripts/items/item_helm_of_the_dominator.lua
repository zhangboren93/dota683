if item_helm_of_the_dominator_modifier_lua == nil then
    item_helm_of_the_dominator_modifier_lua = class({})
end

function item_helm_of_the_dominator_modifier_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function item_helm_of_the_dominator_modifier_lua:OnCreated(kv)
--    print("item_orchid_regen_percentage_modifier:OnCreated")
    self:StartIntervalThink(0.5)
end

function item_helm_of_the_dominator_modifier_lua:IsHidden()
    return true
end

function item_helm_of_the_dominator_modifier_lua:OnIntervalThink()
    --print("interval think")
    local hParent = self:GetParent() --the unit.
    if hParent == nil or hParent.FindItemInInventory == nil then
        return
    end
    local item = hParent:FindItemInInventory("item_dagon")
    if item == null then item = hParent:FindItemInInventory("item_dagon_2") end
    if item == null then item = hParent:FindItemInInventory("item_dagon_3") end
    if item == null then item = hParent:FindItemInInventory("item_dagon_4") end
    if item == null then item = hParent:FindItemInInventory("item_dagon_5") end
    if item ~= nil and item:GetItemState() == 1 then
        if not hParent:HasModifier("modifier_dagon_damage_lua") then
            print("Adding damage modifier " .. item:GetSpecialValueFor("bonus_damage"))
            hParent:AddNewModifier(
                hParent, nil, 
                "modifier_dagon_damage_lua",
                { bonus_damage = item:GetSpecialValueFor("bonus_damage")})
        end
    else
        hParent:RemoveModifierByName("modifier_dagon_damage_lua")
    end
end
