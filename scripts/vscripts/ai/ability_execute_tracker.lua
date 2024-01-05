function handleAbilityExecuted(event)
	if not IsServer() then return end
	local caster = event.caster
	caster.lastAbilityCastTime = GameRules:GetGameTime()
end

function handleAttack(event)
	if not IsServer() then return end
	local attacker = event.attacker
	attacker.lastAttackTime = GameRules:GetGameTime()
end
