function handleCreated(event)
	local caster = event.caster
	local target = event.target
	if caster.dark_rift_particle == nil then
		caster.dark_rift_particle = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
	end
end

function handleDestroy(event)
	local caster = event.caster
	if caster.dark_rift_particle ~= nil then
		ParticleManager:DestroyParticle(caster.dark_rift_particle, false)
		caster.dark_rift_particle = nil
	end
end

function handleIntervalThink(event)
	local target = event.target
	if not target:HasModifier("modifier_abyssal_underlord_dark_rift") then
		target:RemoveModifierByName("modifier_abyssal_underlord_dark_rift_target_datadriven")
	end
end
