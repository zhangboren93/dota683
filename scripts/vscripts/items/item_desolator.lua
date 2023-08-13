function handleOrbFire(event)
	if event.target:HasModifier("modifier_building_immune_to_deso") then
		return
	end
    if not event.attacker:IsIllusion() then
        event.ability:ApplyDataDrivenModifier(event.target, event.target, "modifier_item_desolator_datadriven_corruption", {})
		event.target:EmitSound("Item_Desolator.Target")
    end
end
