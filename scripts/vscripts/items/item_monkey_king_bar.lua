function handleAttackLanded(event)
	local target = event.target
	local attacker = event.attacker
	local mkb = event.ability
	print(target:GetName())
	print(attacker:GetName())
	print(mkb:GetName())
	if not target:IsBuilding() then
		mkb:ApplyDataDrivenModifier(attacker, target, "modifier_item_monkey_king_bar_datadriven_bash", {})
	end
end