if modifier_cancels_item_on_hit == nil then
    modifier_cancels_item_on_hit = class({})
end
function modifier_cancels_item_on_hit:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_cancels_item_on_hit:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_cancels_item_on_hit:IsHidden()
    return true
end

function modifier_cancels_item_on_hit:OnTakeDamage()
    local entity = self:GetParent()
    entity:RemoveModifierByName("modifier_flask_healing")
    entity:RemoveModifierByName("modifier_clarity_potion")
    entity:RemoveModifierByName("modifier_bottle_regeneration")
    entity:RemoveModifierByName("modifier_rune_regen")
end

-- starts tranquil cooldown after attack lands
function modifier_cancels_item_on_hit:OnAttackLanded(event)
    local entity = self:GetParent()
    if event.attacker ~= entity then 
        return
    end
    local tranquil = entity:FindItemInInventory("item_tranquil_boots")
    if tranquil ~= nil then
        tranquil:StartCooldown(tranquil:GetSpecialValueFor("break_time"))
    end
end