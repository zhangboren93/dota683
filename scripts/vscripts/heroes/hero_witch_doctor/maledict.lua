function Maledict(keys)
	local vPosition = keys.target_points[1]
	local ability = keys.ability
	local caster = keys.caster

	local radius = ability:GetSpecialValueFor("radius")

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(), vPosition,
		nil, radius,
		ability:GetAbilityTargetTeam(),
		ability:GetAbilityTargetType(), 
		ability:GetAbilityTargetFlags(),
		0, false
	)

	if #enemies > 0 then
		EmitSoundOn("Hero_WitchDoctor.Maledict_Cast", caster)
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier( caster, enemy, "modifier_maledict_datadriven", {} )
		end
	else
		EmitSoundOn("Hero_WitchDoctor.Maledict_CastFail", caster)
	end
end

--[[Author: YOLOSPAGHETTI
	Date: March 15, 2016
	Checks the target's health as the debuff is applied to reference on every interval]]
function CheckHealth(keys)
	local target = keys.target
	
	EmitSoundOn(keys.sound, target)
	target.maledict_health = target:GetHealth()
end

function DealBurst(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local burst_ticks = ability:GetSpecialValueFor("ticks")
	local total_ticks = ability:GetDuration()
	local tick_interval = total_ticks / burst_ticks
	
	-- Increments every tick
	if target.maledict_tick == nil then
		target.maledict_tick = 1
	else
		target.maledict_tick = target.maledict_tick + 1
	end
	
	-- Applies the damage-based burst damage on the required interval
	if target.maledict_tick % tick_interval == 0 then
		-- Play the sound on the victim.
		EmitSoundOn(keys.sound, target)
		-- Particle not attached properly
		local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN_FOLLOW, target) 
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(particle, 1, Vector(4, 0, 0))
		ParticleManager:DestroyParticle(particle, false)
		ParticleManager:ReleaseParticleIndex(particle)
		
		local bonus_damage = ability:GetLevelSpecialValueFor("bonus_damage", (ability:GetLevel() -1)) / 100
		-- Applies burst damage based on the percentage of the target's current health from their initial health (during CheckHealth)
		local damage = (target.maledict_health - target:GetHealth()) * bonus_damage
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType()})
		-- If we are on the last tick, stops the sound and resets the ticks
		if target.maledict_tick == total_ticks then
			StopSoundEvent(keys.sound2, target)
			target.maledict_tick = 0
		end
	end
end

function handleDestroy(event)
	local target = event.target
	StopSoundEvent("Hero_WitchDoctor.Maledict_Loop", target)
	target.maledict_tick = 0
end
