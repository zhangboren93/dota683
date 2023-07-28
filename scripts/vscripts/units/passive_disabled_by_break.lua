function handleIntervalThink(event)
	local caster = event.caster
	local modifier = event.ModifierName
	local ability = event.ability
	if caster:PassivesDisabled() then
		caster:RemoveModifierByName(modifier)
	elseif not caster:HasModifier(modifier) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
	end
end
