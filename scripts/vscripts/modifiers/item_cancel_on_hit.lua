if modifier_cancels_item_on_hit == nil then
    modifier_cancels_item_on_hit = class({})
end
function modifier_cancels_item_on_hit:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_cancels_item_on_hit:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
    return funcs
end

function modifier_cancels_item_on_hit:IsHidden()
    return true
end

function modifier_cancels_item_on_hit:OnTakeDamage(event)
    local entity = self:GetParent()
    if entity == event.unit then
        entity:RemoveModifierByName("modifier_flask_healing")
        entity:RemoveModifierByName("modifier_clarity_potion")
        entity:RemoveModifierByName("modifier_bottle_regeneration")
        entity:RemoveModifierByName("modifier_rune_regen")
    end
end