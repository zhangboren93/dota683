function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = ability:GetSpecialValueFor("damage")
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	})
	target:EmitSound("DOTA_Item.Dagon.Activate")
	local particleId = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particleId, 0, caster, PATTACH_POINT, "attach_hitloc", Vector(0, 0, 0), false)
	ParticleManager:SetParticleControlEnt(particleId, 1, target, PATTACH_POINT, "attach_hitloc", Vector(0, 0, 0), false)
	ParticleManager:ReleaseParticleIndex(particleId)
end
