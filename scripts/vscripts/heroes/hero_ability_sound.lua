function handleAbilityExecuted(event)
    local event_ability = event.event_ability
    local caster = event.caster
    if event_ability:GetName() == "dazzle_weave" then
        caster:EmitSound("Hero_Dazzle.BadJuJu.Cast")
    end
end