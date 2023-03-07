function handleOrbFire(event)
    if not event.attacker:IsIllusion() then
        event.ability:ApplyDataDrivenModifier(event.target, event.target, "modifier_item_desolator_datadriven_corruption", {})
    end
end