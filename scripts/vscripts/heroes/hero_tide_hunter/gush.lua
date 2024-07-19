function handleProjectileHitUnit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	if target ~= nil and not target:IsInvulnerable() and not target:IsMagicImmune() then

		if target:TriggerSpellAbsorb(ability) then return end

		EmitSoundOn("Ability.GushImpact", target)

		ability:ApplyDataDrivenModifier(caster, target, "modifier_tidehunter_gush_datadriven", {})
		local damageTable = {
			victim = target,
			attacker = caster, 
			damage = ability:GetSpecialValueFor("gush_damage"),
			damage_type = ability:GetAbilityDamageType(),
			ability = ability
		}
		ApplyDamage(damageTable)

		-- Create Particle
		local particle = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf",
			PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControlEnt(particle, 3, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:ReleaseParticleIndex( particle )
	end
end