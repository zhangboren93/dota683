function handleAttackStart(event)
	local target = event.target
	local attacker = event.attacker
	if target:GetTeam() ~= attacker:GetTeam() and not target:IsBuilding() and not attacker:PassivesDisabled() then
		event.ability:ApplyDataDrivenModifier(attacker, attacker, event.ModifierName, {})
	end
end
