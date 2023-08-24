function handleAbilityExecuted(event)
	if not IsServer() then return end
	local caster = event.caster
	caster.lastAbilityCastTime = GameTime()
end
