function handleCreated(event)
	local target = event.target
	local caster = event.caster
	local ability = caster:FindAbilityByName("kunkka_torrent")
	local damage = ability:GetSpecialValueFor("damage_initial")
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function handleIntervalThink(event)
	local target = event.target
	local caster = event.caster
	local ability = caster:FindAbilityByName("kunkka_torrent")
	local damage = ability:GetSpecialValueFor("damage_per_tick")
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end
