function DisToDamage(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
    local disPct = ability:GetSpecialValueFor("distance_damage_pct")
    local damageCap = ability:GetSpecialValueFor("distance_damage_cap")
    local loc1 = caster:GetAbsOrigin()
    local loc2 = target:GetAbsOrigin()
    local dist = math.sqrt((loc1[1] - loc2[1]) * (loc1[1] - loc2[1]) + (loc1[2] - loc2[2]) * (loc1[2] - loc2[2]))
    local damage = dist * disPct / 100
    if damage > damageCap then
        damage = damageCap
    end
    print("Dist " .. dist .. " damage " .. damage)

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.victim = target

	damage_table.damage = damage

	ApplyDamage(damage_table)
end