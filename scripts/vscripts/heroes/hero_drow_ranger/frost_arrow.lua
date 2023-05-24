function handleOrbImpact(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if target:IsHero() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_frost_arrows_slow_datadriven", {duration = 1.5})
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_frost_arrows_slow_datadriven", {duration = 7})
	end
end