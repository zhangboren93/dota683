function handleProjectileHitUnit(event)
	print("handleProjectileHitUnit")
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local duration = ability:GetSpecialValueFor("duration")
	if target:TriggerSpellAbsorb(ability) then return end
	target:EmitSound("Hero_Chen.PenitenceImpact")
	--ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_penitence_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_penitence_datadriven", { duration = duration }) 
end
