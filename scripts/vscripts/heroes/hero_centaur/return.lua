function handleAttack(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target ~= caster then return end
	if attacker:GetTeam() == caster:GetTeam() then return end
	local casterSTR = caster:GetStrength()
	local str_return = ability:GetSpecialValueFor("strength_pct")
	local damage = ability:GetSpecialValueFor( "return_damage" )
	local damageType = ability:GetAbilityDamageType()
	local return_damage = damage + ( casterSTR * str_return / 100)

	-- Damage
	ApplyDamage({ victim = attacker, attacker = caster, damage = return_damage, damage_type = damageType })

	local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf", 
												PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pid, 0, caster,   PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), false)
	ParticleManager:SetParticleControlEnt(pid, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), false)
end
