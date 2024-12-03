function handleSpellStart(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	caster:EmitSound("Hero_Morphling.AdaptiveStrikeStr.Cast")
	if target:TriggerSpellAbsorb(ability) then return end
	target:EmitSound("Hero_Morphling.AdaptiveStrikeStr.Target")
	local particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particleId, 1, target, PATTACH_ABSORIGIN, "attach_hitloc", Vector(0, 0, 0), false)
	local damage = ability:GetSpecialValueFor("damage_base")
	local damage_min = ability:GetSpecialValueFor("damage_min")
	local damage_max = ability:GetSpecialValueFor("damage_max")
	local ratio = caster:GetAgility() / caster:GetStrength()
	if ratio > 1.5 then
		ratio = 1
	else
		ratio = ratio / 1.5
	end
	damage = damage + (damage_min + ratio * (damage_max - damage_min)) * caster:GetAgility()
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
	local stun_min = ability:GetSpecialValueFor("stun_min")
	local stun_max = ability:GetSpecialValueFor("stun_max")
	local ratio = caster:GetStrength() / caster:GetAgility()
	local stun_duration = stun_min + (stun_max - stun_min) * (ratio - 0.66) / 0.84
	if stun_duration > stun_max then
		stun_duration = stun_max
	elseif stun_duration < stun_min then
		stun_duration = stun_min
	end
	local knockback_min = ability:GetSpecialValueFor("knockback_min")
	local knockback_max = ability:GetSpecialValueFor("knockback_max")
	local knockback = knockback_min + (knockback_max - knockback_min) * (ratio - 0.66) / 0.84
	if knockback > knockback_max then knockback = knockback_max end
	if knockback < knockback_min then knockback = knockback_min end
	if target:GetUnitName() == "npc_dota_roshan_datadriven" then knockback = 0 end
	print("knockback is " .. knockback .. " stun duration " .. stun_duration)
	local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
	print(direction)
	target:AddNewModifier(caster, ability, "modifier_knockback", {
		center_x = caster:GetAbsOrigin().x, 
		center_y = caster:GetAbsOrigin().y, 
		center_z = caster:GetAbsOrigin().z, 
		knockback_distance = knockback, 
		knockback_duration = knockback / 1000, 
		knockback_height = 50, 
		duration = stun_duration,
		should_stun = true })
end
