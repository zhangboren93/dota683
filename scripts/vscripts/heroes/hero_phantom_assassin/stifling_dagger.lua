function handleProjectileHitUnit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = ability:GetAbilityDamage()
	if target:IsHero() then
		damage = damage / 2
	end
	local coup = caster:FindAbilityByName("phantom_assassin_coup_de_grace_datadriven")
	if coup ~= nil and coup:GetLevel() > 0 then
		local crit_chance = coup:GetSpecialValueFor("crit_chance")
		local crit_bonus = coup:GetSpecialValueFor("crit_bonus")
		if RandomInt(1, 100) <= crit_chance then
			damage = damage * crit_bonus / 100
		end
	end
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = ability
	});
	target:EmitSound("Hero_PhantomAssassin.Dagger.Target")
	ability:ApplyDataDrivenModifier(caster, target, "modifier_stifling_dagger_slow_datadriven", {})
end
