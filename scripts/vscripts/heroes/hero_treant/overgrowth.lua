function handleIntervalThink(event)
	local target = event.target
	if target:HasModifier("modifier_treant_overgrowth") then
		ApplyDamage({
			victim = target,
			attacker = event.caster,
			damage = 175,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = event.ability
		})
	end
end
