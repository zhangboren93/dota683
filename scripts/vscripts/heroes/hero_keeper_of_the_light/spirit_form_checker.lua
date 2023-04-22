function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    local target = keys.target
    if event_ability:GetName() == "keeper_of_the_light_spirit_form" then
        local recall = unit:FindAbilityByName("keeper_of_the_light_recall")
        recall:SetHidden(false)
        recall:SetLevel(event_ability:GetLevel())
        local recall = unit:FindAbilityByName("keeper_of_the_light_blinding_light")
        recall:SetHidden(false)
        recall:SetLevel(event_ability:GetLevel())
    end
end

function checkAghs(keys) 
    local caster = keys.caster
    if not caster:HasModifier("modifier_keeper_of_the_light_spirit_form") then
        local recall = caster:FindAbilityByName("keeper_of_the_light_blinding_light")
        recall:SetHidden(true)
    end
    if caster:HasScepter() and not caster:HasModifier("modifier_keeper_of_the_light_spirit_form") then
        ability = caster:FindAbilityByName("keeper_of_the_light_spirit_form")
        if ability:GetLevel() > 0 then
            ability:EndCooldown()
            ability:CastAbility()
        end
    end
    if caster:HasScepter() then
        if GameRules:IsDaytime() and not caster:HasModifier("modifier_kotl_spirit_form_unblocked_vision") then
            caster:FindAbilityByName("keeper_of_the_light_spirit_form_checker"):ApplyDataDrivenModifier(
                caster, caster, "modifier_kotl_spirit_form_unblocked_vision", {})
        elseif not GameRules:IsDaytime() and caster:HasModifier("modifier_kotl_spirit_form_unblocked_vision") then
            caster:RemoveModifierByName("modifier_kotl_spirit_form_unblocked_vision")
        end
    end
end