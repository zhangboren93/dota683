function handleAbilityExecuted(event)
    local event_ability = event.event_ability
    local caster = event.caster
    local target = event.target
    if event_ability:GetName() == "brewmaster_drunken_haze" then
        caster:EmitSound("Hero_Brewmaster.CinderBrew.Cast")
        target:EmitSound("Hero_Brewmaster.CinderBrew.Target")
    end
end