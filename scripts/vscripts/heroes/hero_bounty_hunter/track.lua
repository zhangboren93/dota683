function handleSpellStart(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local duration = ability:GetSpecialValueFor("duration")
	if target:TriggerSpellAbsorb(ability) then return end
	local modifier = target:AddNewModifier(caster, ability, "modifier_bounty_hunter_track_lua", { duration = duration })
	target:EmitSound("Hero_BountyHunter.Target")
	if modifier.particleId == nil then
		modifier.particleId = ParticleManager:CreateParticleForTeam(
			"particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, target, caster:GetTeam())
		ParticleManager:SetParticleControlEnt(modifier.particleId, 0, target, PATTACH_ABSORIGIN_FOLLOW, "", Vector(0, 0, 0), false)
		ParticleManager:SetParticleControlEnt(modifier.particleId, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), false)
		target:AddNewModifier(caster, ability, "modifier_bounty_hunter_track_aura_lua", { duration = duration })
		modifier.particleId2 = ParticleManager:CreateParticleForTeam(
			"particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, target, caster:GetTeam())
	end
end
