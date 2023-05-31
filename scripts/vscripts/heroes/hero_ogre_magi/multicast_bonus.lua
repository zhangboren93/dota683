function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    local target = keys.target
    if event_ability:GetName() == "ogre_magi_fireblast" then
        unit:SetThink(function()
            local multicast = unit:FindAbilityByName("ogre_magi_multicast")
            local newCooldown = event_ability:GetCooldown(event_ability:GetLevel()) + multicast:GetSpecialValueFor("blast_cooldown")
            event_ability:EndCooldown()
            event_ability:StartCooldown(newCooldown)
            unit:SpendMana(multicast:GetSpecialValueFor("blast_mana_cost"), event_ability)
        end, "reset blast cooldown", 0.1)
    elseif event_ability:GetName() == "ogre_magi_ignite" then
       ability:ApplyDataDrivenModifier(unit, target, "modifier_ignite_no_ex_duration_checker", {}) 
    elseif event_ability:GetName() == "ogre_magi_bloodlust" then
        unit:SetThink(function()
            local multicast = unit:FindAbilityByName("ogre_magi_multicast")
            local newCooldown = event_ability:GetCooldown(event_ability:GetLevel()) + multicast:GetSpecialValueFor("blood_cooldown")
            event_ability:EndCooldown()
            event_ability:StartCooldown(newCooldown)
        end, "reset blood cooldown", 0.1)
    end
end