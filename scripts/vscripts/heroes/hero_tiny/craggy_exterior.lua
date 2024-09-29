function handleAttackStart( event )
	local attacker = event.attacker
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local percentage = ability:GetSpecialValueFor("stun_chance")

	if target == caster and RandomFloat(0, 1) * 100 < percentage then
		EmitSoundOn("Hero_Tiny.CraggyExterior.Stun", attacker)
		attacker:AddNewModifier(target, ability, "modifier_stunned", {duration = ability:GetSpecialValueFor("stun_duration")})
		ApplyDamage({
			victim = attacker,
			attacker = target,
			damage = ability:GetSpecialValueFor("damage"),
			damage_type = ability:GetAbilityDamageType(),
			ability = ability
		})
	end
end
