--[[
	Author: Noya
	Date: 14.1.2015.
	If cast on an ally it will heal, if cast on an enemy it will do damage
]]
require("../../items/item_sphere")
require("../../items/item_magic_stick")
function DeathCoil( event )
	-- Variables
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor( "target_damage" , ability:GetLevel() - 1  )
	local self_damage = ability:GetLevelSpecialValueFor( "self_damage" , ability:GetLevel() - 1  )
	local heal = ability:GetLevelSpecialValueFor( "heal_amount" , ability:GetLevel() - 1 )
	local projectile_speed = ability:GetSpecialValueFor( "projectile_speed" )
	local particle_name = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"

	ProcsMagicStick(event)

	-- Play the ability sound
	caster:EmitSound("Hero_Abaddon.DeathCoil.Cast")
	target:EmitSound("Hero_Abaddon.DeathCoil.Target")

	if is_spell_blocked_by_linkens_sphere_a(target, caster) then return end

	-- If the target and caster are on a different team, do Damage. Heal otherwise
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		ApplyDamage({ victim = target, attacker = caster, damage = damage,	damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
	else
		target:Heal( heal, caster)
	end

	-- Self Damage
	ApplyDamage({ victim = caster, attacker = caster, damage = self_damage,	damage_type = DAMAGE_TYPE_PURE, ability = ability })

	local particle_id = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_death_coil_explosion.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle_id, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0, 0, 0), false)
	ParticleManager:ReleaseParticleIndex(particle_id)
end
