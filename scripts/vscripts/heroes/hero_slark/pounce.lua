function handleLeashCreated(event)
	local target = event.target
	local caster = event.caster
	caster.leash_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_pounce_leash.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(caster.leash_particle, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(caster.leash_particle, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
	caster.leash_loc = caster:GetAbsOrigin()
end

function handleLeashDestroy(event)
	local caster = event.caster
	ParticleManager:DestroyParticle(caster.leash_particle, false)
	ParticleManager:ReleaseParticleIndex(caster.leash_particle)
end

function handleLeashIntervalThink(event)
	local target = event.target
	local caster = event.caster
	if (target:GetAbsOrigin() - caster.leash_loc):Length() > 425 then
		target:RemoveModifierByName("modifier_slark_pounce_leash_datadriven")
		return
	end

	if target:IsCurrentlyHorizontalMotionControlled() then
		return
	end

	if (target:GetAbsOrigin() - caster.leash_loc):Length() > 325 then
		target:SetAbsOrigin(caster.leash_loc + 
			(target:GetAbsOrigin() - caster.leash_loc):Normalized() * 325)
	end
end
