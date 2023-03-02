function attack_landed(event)
    event.ability:ApplyDataDrivenModifier(event.caster, event.caster, "modifier_item_lifesteal_datadriven", { duration = 0.1 })
end