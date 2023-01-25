if modifier_tower_bonus_cancel_lua == nil then
    modifier_tower_bonus_cancel_lua = class({})
end

function modifier_tower_bonus_cancel_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_tower_bonus_cancel_lua:OnCreated(kv)
--    print("item_orchid_regen_percentage_modifier:OnCreated")
    self:StartIntervalThink(0.1)
end

function modifier_tower_bonus_cancel_lua:IsHidden()
    return true
end

function modifier_tower_bonus_cancel_lua:OnIntervalThink()
    local hParent = self:GetParent() --the unit.
    if hParent.FindModifierByName == nil then
        return
    end
    local tower_aura = hParent:FindModifierByName("modifier_tower_aura_bonus")
    if tower_aura ~= nil then
        local tower = tower_aura:GetCaster()
        local modifiers = tower:FindAllModifiers()
        local aura_modifiers = tower:FindAllModifiersByName("modifier_tower_aura")
        if #aura_modifiers == 1 then
            aura_modifiers[1]:Destroy()
        end
    end
end