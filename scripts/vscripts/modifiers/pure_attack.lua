function pure_attack(event)
    local damage = event.caster:GetAttackDamage()
    damage_type = DAMAGE_TYPE_PURE
    if event.target:IsBuilding() then
        damage_type = DAMAGE_TYPE_PHYSICAL
    end
	ApplyDamage({
        victim = event.target,
        attacker = event.caster,
        damage = damage,
        damage_type = damage_type })
end