function attack_landed(event)
    if not event.target:IsIllusion() then
        event.ability:ApplyDataDrivenModifier(event.caster, event.caster, "modifier_item_lifesteal_datadriven", { duration = 0.1 })
    end
end