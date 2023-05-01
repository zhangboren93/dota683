function handleAttackStart(event)
	print(event.attacker:GetName())
	print(event.target:GetName())
	print(event.ability:GetName())
	local target = event.target
	local attacker = event.attacker
	if target:GetTeam() ~= attacker:GetTeam() and not target:IsBuilding() then
		event.ability:ApplyDataDrivenModifier(attacker, attacker, event.ModifierName, {})
	end
end