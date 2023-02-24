if modifier_tpscroll_travel_cooldown == nil then
    modifier_tpscroll_travel_cooldown = class({})
end

function modifier_tpscroll_travel_cooldown:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_tpscroll_travel_cooldown:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }
    return funcs
end

function modifier_tpscroll_travel_cooldown:IsHidden()
    return true
end

function modifier_tpscroll_travel_cooldown:OnAbilityExecuted(event)
    local ability = event.ability
    local caster = self:GetParent()
    if ability:GetName() == "item_tpscroll" then
        caster:SetThink(function()
            if ability:GetCooldownTimeRemaining() < 45 then
                ability:StartCooldown(50)
            end
        end, "travel tp 50s cooldown", 0.5)
    end
end