function handleAttackLanded(event)
	local target = event.target
	local attacker = event.attacker
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf",
		PATTACH_CUSTOMORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_CUSTOMORIGIN_FOLLOW , "attach_hitloc", Vector(0, 0, 0), false)
	ParticleManager:SetParticleControlTransformForward(particle, 1, target:GetAbsOrigin(), -attacker:GetForwardVector())
	ParticleManager:ReleaseParticleIndex(particle)
end
						
