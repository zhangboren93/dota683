-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
jakiro_liquid_fire_lua = class({ 
	GetIntrinsicModifierName = function(self) return "modifier_generic_orb_effect_lua" end,
	GetProjectileName		 = function(self) return "particles/units/heroes/hero_jakiro/jakiro_base_attack_fire.vpcf" end
})

function jakiro_liquid_fire_lua:OnOrbFire( params )
	self:GetCaster():EmitSound("Hero_Jakiro.LiquidFire")
end

function jakiro_liquid_fire_lua:OnOrbImpact( params )
	local caster = self:GetCaster()

	-- get data
	local duration = self:GetDuration()
	local radius = self:GetSpecialValueFor("radius")

	-- find enemy in radius
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		params.target:GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_jakiro_liquid_fire_burn_lua", { duration = duration })
	end

	-- play effects
	self:PlayEffects( params.target, radius )
end

function jakiro_liquid_fire_lua:PlayEffects( target, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf"
	local sound_cast = "Hero_Jakiro.LiquidFire"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
