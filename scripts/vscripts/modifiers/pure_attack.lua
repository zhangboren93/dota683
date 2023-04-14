function pure_attack(event)
    local damage = event.caster:GetAttackDamage()
    local armor = event.target:GetPhysicalArmorValue(false)
    damage = damage * (1 - 0.06 * armor / (1 + 0.06 * math.abs(armor)))
    damage_type = DAMAGE_TYPE_PURE
	ApplyDamage({
        victim = event.target,
        attacker = event.caster,
        damage = damage,
        damage_type = damage_type })
end