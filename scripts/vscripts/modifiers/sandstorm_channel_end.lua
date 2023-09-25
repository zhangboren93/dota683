if modifier_sandstorm_channel_end == nil then
    modifier_sandstorm_channel_end = class({})
end

function modifier_sandstorm_channel_end:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_sandstorm_channel_end:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_END_CHANNEL
    }
    return funcs
end

function modifier_sandstorm_channel_end:IsHidden()
    return true
end

function modifier_sandstorm_channel_end:OnAbilityEndChannel(event)
    local unit = event.unit
    local ability = event.ability
    if ability:GetName() == "sandking_sand_storm" then
        unit:SetThink(function()
            unit:RemoveModifierByName("modifier_sandking_sand_storm")
        end, "exit sand storm", ability:GetSpecialValueFor("fade_delay"))
    end
end
