function handleSpellStart(event)
	local target = event.target
	local ability = event.ability
	if target:TriggerSpellAbsorb(ability) then return end
	local caster = event.caster
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_frostbite.vpcf", PATTACH_ABSORIGIN, target)
	local duration = ability:GetSpecialValueFor("creep_duration")
	if target:IsConsideredHero() then
		duration = ability:GetSpecialValueFor("duration")
	end
	target:AddNewModifier(caster, target, "modifier_stunned", { duration = stun_duration })
	ability:ApplyDataDrivenModifier(caster, target, "modifier_frost_bite_root_datadriven", { duration = duration })
	ability:ApplyDataDrivenModifier(caster, target, "modifier_frost_bite_damage_datadriven", { duration = duration })
	target:EmitSound("hero_Crystal.frostbite")
end

function handleDestroy(event)
	local target = event.target
	target:StopSound("hero_Crystal.frostbite")
end
