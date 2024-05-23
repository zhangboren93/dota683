function handleIntervalThink(event)
	local caster = event.caster
	local target = event.target
	local ability = caster:FindAbilityByName(event.AbilityName)
	local damage = ability:GetSpecialValueFor(event.DamageKey)
	ApplyDamage({
		attacker = caster,
		victim = target,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	})
end
