--[[
	Author: kritth
	Date: 6.1.2015.
	Register target
]]
function assassinate_register_target( keys )
	local target = keys.target
	local ability = keys.ability
	local caster = keys.caster
	caster.assassinate_target = target
	ability:ApplyDataDrivenModifier(caster, target, "modifier_assassinate_target_datadriven", { duration = 4 })
	target:AddNewModifier(caster, ability, "modifier_truesight", { duration = 4 })
	if ability.particleId ~= nil then
		ParticleManager:DestroyParticle(ability.particleId, false)
	end
	ability.particleId = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_sniper/sniper_crosshair.vpcf", PATTACH_OVERHEAD_FOLLOW, target, caster:GetTeam())
end

--[[
	Author: kritth
	Date: 6.1.2015.
	Remove debuff from target
]]
function assassinate_remove_target( keys )
	local ability = keys.ability
	if keys.caster.assassinate_target then
		keys.caster.assassinate_target:RemoveModifierByName( "modifier_assassinate_target_datadriven" )
		keys.caster.assassinate_target = nil
		if ability.particleId ~= nil then
			ParticleManager:DestroyParticle(ability.particleId, false)
			ability.particleId = nil
		end
	end
end

function handleProjectileHitUnit(event)
	local target = event.target
	local ability = event.ability
	local damage = ability:GetAbilityDamage()
	local caster = event.caster
	if target:TriggerSpellAbsorb(ability) then
		return
	end
	target:EmitSound("Hero_Sniper.AssassinateDamage")
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL
	})
	target:AddNewModifier(caster, ability, "modifier_stunned", { duration = 0.1 })
	target:RemoveModifierByName("modifier_assassinate_target_datadriven")
end

function handle_target_destroy(event)
	local ability = event.ability
	if ability.particleId ~= nil then
		ParticleManager:DestroyParticle(ability.particleId, false)
		ability.particleId = nil
	end
end

function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
	caster:EmitSound("Ability.Assassinate")
	ProjectileManager:CreateTrackingProjectile({
		Target = target,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		EffectName = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf",
		Ability = ability,
		Source = caster
	})
	caster:EmitSound("Hero_Sniper.AssassinateProjectile")
end
