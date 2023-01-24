if item_crimson_guard_bonus_modifier == nil then
    item_crimson_guard_bonus_modifier = class({})
end

function item_crimson_guard_bonus_modifier:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function item_crimson_guard_bonus_modifier:OnCreated(kv)
--    print("item_orchid_regen_percentage_modifier:OnCreated")
    self:StartIntervalThink(0.5)
end

function item_crimson_guard_bonus_modifier:IsHidden()
    return true
end

function item_crimson_guard_bonus_modifier:OnIntervalThink()
    --print("interval think")
    local hParent = self:GetParent() --the unit.
    if hParent == nil or hParent.FindItemInInventory == nil then
        return
    end
    local item = hParent:FindItemInInventory("item_crimson_guard")
    if item ~= nil and item:GetItemState() == 1 then
        --print("sheepstick state: " .. item:GetItemState())
        -- add all stats bonus modifier
        if not hParent:HasModifier("modifier_crimson_guard_stats_lua") then
             print("adding all stats modifier")
             hParent:AddNewModifier(
                hParent, nil, 
                "modifier_crimson_guard_stats_lua",
                { bonus_all_stats = item:GetSpecialValueFor("bonus_all_stats")})
        end
    else
        hParent:RemoveModifierByNameAndCaster("modifier_crimson_guard_stats_lua", hParent)
    end
end