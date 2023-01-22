if item_refresher_modifier_lua == nil then
    item_refresher_modifier_lua = class({})
end

function item_refresher_modifier_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function item_refresher_modifier_lua:OnCreated(kv)
--    print("item_orchid_regen_percentage_modifier:OnCreated")
    self:StartIntervalThink(0.5)
end

function item_refresher_modifier_lua:IsHidden()
    return true
end

function item_refresher_modifier_lua:OnIntervalThink()
    --print("interval think")
    local hParent = self:GetParent() --the unit.
    if hParent == nil or hParent.FindItemInInventory == nil then
        return
    end
    local item = hParent:FindItemInInventory("item_refresher")
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
        if not hParent:HasModifier("modifier_refresher_bonus_lua") then
            print("adding refresher bonus modifier")
            hParent:AddNewModifier(
                hParent, nil, 
                "modifier_refresher_bonus_lua", 
                {
                    bonus_intellect = item:GetSpecialValueFor("bonus_intellect"),
                    bonus_attack_speed = item:GetSpecialValueFor("bonus_attack_speed"),
                    bonus_damage = item:GetSpecialValueFor("bonus_damage")
                })
        end
    else
        hParent:RemoveModifierByNameAndCaster("modifier_refresher_bonus_lua", hParent)
    end
end