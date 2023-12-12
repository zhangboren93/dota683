function handleIntervalThink(event)
	local caster = event.caster
	local ability = caster:FindAbilityByName("viper_viper_strike")
	local target = event.target
	local damage = ability:GetSpecialValueFor("damage_tooltip")
	if not target:HasModifier("modifier_viper_viper_strike_slow") then
		target:RemoveModifierByName("modifier_viper_viper_strike_damage_datadriven")
		return
	end
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	})
end
