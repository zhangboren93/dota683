function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    local target = keys.target
    if event_ability:GetName() == "lone_druid_true_form" then
        unit:FindAbilityByName("lone_druid_true_form_druid"):SetLevel(1)
        unit:SwapAbilities("lone_druid_true_form", "lone_druid_true_form_druid", false, true)
        unit:SetThink(function()
            unit:RemoveAbility("lone_druid_spirit_bear_demolish")
            unit:RemoveAbility("lone_druid_spirit_bear_entangle")
            unit:AddAbility("lone_druid_true_form_battle_cry"):SetLevel(event_ability:GetLevel())
        end, "remove ld passive", 3)
    elseif event_ability:GetName() == "lone_druid_true_form_druid" then
        unit:SwapAbilities("lone_druid_true_form", "lone_druid_true_form_druid", true, false)
        unit:RemoveAbility("lone_druid_true_form_battle_cry")
    end
end