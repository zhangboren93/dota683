function handleAttackLanded(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local chance = ability:GetSpecialValueFor("chance")
	local bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	if caster:IsIllusion() or caster:PassivesDisabled() then return end
	if RollPseudoRandomPercentage(chance, DOTA_PSEUDO_RANDOM_SLARDAR_BASH, caster) then
		target:EmitSound("Hero_Slardar.Bash")
		if target:IsCreep() then
			target:AddNewModifier(caster, ability, "modifier_stunned", { duration = 2 })
		else
			target:AddNewModifier(caster, ability, "modifier_stunned", { duration = 1 })
		end
		ApplyDamage({
			victim = target,
			attacker = caster,
			damage = bonus_damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = ability
		})
	end
end
