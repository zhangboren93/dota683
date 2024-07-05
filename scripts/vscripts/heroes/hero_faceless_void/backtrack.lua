function handleDamageTaken(event)
	local caster = event.caster
	local damage = event.Damage
	local ability = event.ability 
	local dodge_chance_pct = ability:GetSpecialValueFor("dodge_chance_pct")
	if RandomInt(1, 100) <= dodge_chance_pct then
		local particleId = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf",
			PATTACH_ABSORIGIN_FOLLOW,
			caster)
		ParticleManager:ReleaseParticleIndex(particleId)
		caster:Heal(damage, ability)
	end
end
