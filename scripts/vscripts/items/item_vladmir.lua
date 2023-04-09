function VladmirAuraApply(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	if not target:IsIllusion() and not target:IsBuilding() then
		ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_item_vladmir_datadriven_lifesteal", {duration = 0.03})
	end
end