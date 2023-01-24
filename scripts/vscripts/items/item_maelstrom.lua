if item_maelstrom_modifier_lua == nil then
    item_maelstrom_modifier_lua = class({})
end

function item_maelstrom_modifier_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function item_maelstrom_modifier_lua:OnCreated(kv)
--    print("item_orchid_regen_percentage_modifier:OnCreated")
    self:StartIntervalThink(0.5)
end

function item_maelstrom_modifier_lua:IsHidden()
    return true
end

function item_maelstrom_modifier_lua:OnIntervalThink()
    --print("interval think")
    local hParent = self:GetParent() --the unit.
    if hParent == nil or hParent.FindItemInInventory == nil then
        return
    end
    local item = hParent:FindItemInInventory("item_maelstrom")
    if item ~= nil and item:GetItemState() == 1 then
        if not hParent:HasModifier("modifier_maelstrom_as_lua") then
            local bonus_attack_speed = item:GetSpecialValueFor("bonus_attack_speed")
            print("Adding attackspeed modifier " .. bonus_attack_speed)
            hParent:AddNewModifier(
                hParent, nil, 
                "modifier_maelstrom_as_lua",
                { bonus_attack_speed = bonus_attack_speed})
        end
    else
        hParent:RemoveModifierByName("modifier_maelstrom_as_lua")
    end
end
