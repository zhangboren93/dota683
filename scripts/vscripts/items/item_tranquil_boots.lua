function handleIntervalThink(event)
	if event.ability:IsCooldownReady() and not event.caster:HasModifier(event.ModifierName)then
		event.ability:ApplyDataDrivenModifier(event.caster, event.caster, event.ModifierName, {})
	end
end

function handleAttacked(event)
	event.ability:StartCooldown(event.ability:GetCooldown(0))
end

function handleAttackLanded(event)
	event.ability:StartCooldown(event.ability:GetCooldown(0))
end