function handleSpellStart(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local duration = ability:GetSpecialValueFor("duration")
	if target:TriggerSpellAbsorb(ability) then return end
	local modifier = ability:ApplyDataDrivenModifier(caster, target, "modifier_amplify_damage_datadriven", { duration = duration})
	target:AddNewModifier(caster, ability, "modifier_slardar_amplify_damage_vision_lua", { duration = duration })
	if target.amplify_dp == nil then
		target.amplify_dp = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
	end
end

function handleDestroy(event)
	local target = event.target
	if target.amplify_dp ~= nil then
		ParticleManager:DestroyParticle(target.amplify_dp, false)
		target.amplify_dp = nil
	end
end
