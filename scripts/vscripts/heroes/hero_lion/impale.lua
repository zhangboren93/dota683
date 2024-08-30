function handleProjectileHitUnit(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local duration = ability:GetSpecialValueFor("duration")

	if target == nil or target:IsInvulnerable() then return end
	if target:TriggerSpellAbsorb(self) then return end
	
	target:AddNewModifier(caster, ability, "modifier_lion_impale", { duration = duration }) -- Dota2 Original modifier

	local air_time = 0.52
--[[	target:AddNewModifier(caster, ability, "modifier_stunned", { duration = duration })
	local knockbackProperties =
	{
		center_x = target.x,
		center_y = target.y,
		center_z = target.z,
		duration = air_time,
		knockback_duration = air_time,
		knockback_distance = 0,
		knockback_height = 350
	}
	target:AddNewModifier(caster, nil, "modifier_knockback", knockbackProperties)

	EmitSoundOn("Hero_Lion.ImpaleHitTarget", target) ]]--	

	local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_impale_hit_spikes.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(fx, 2, target:GetAttachmentOrigin(target:ScriptLookupAttachment("attach_hitloc")))
	ParticleManager:ReleaseParticleIndex(fx)

	target:StopThink("lion impale damage afterwards")
	target:SetThink(function()
		local damageTable =
		{
			victim = target,
			attacker = caster, 
			damage = ability:GetAbilityDamage(),
			damage_type = ability:GetAbilityDamageType(),
			ability = ability
		}
		ApplyDamage(damageTable)     
	end, "lion impale damage afterwards", air_time)
end
