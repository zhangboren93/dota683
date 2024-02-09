--[[
	Author: Ractidous
	Date: 29.01.2015.
	Deal damage to the egg.
]]
phoenix_supernova_datadriven = class({})

function phoenix_supernova_datadriven:GetBehavior()
	local caster = self:GetCaster()
	if caster:HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK 
	end
end

function phoenix_supernova_datadriven:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	caster:EmitSound("Hero_Phoenix.SuperNova.Cast")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_start.vpcf",
													PATTACH_ABSORIGIN,
													caster)
	ParticleManager:ReleaseParticleIndex(particle)

	caster:AddNewModifier(caster, self, "modifier_supernova_sun_form_caster_datadriven", {
		duration = 6 })

	if caster:HasScepter() and target ~= nil and target ~= caster then
		target:AddNewModifier(caster, self, "modifier_supernova_sun_form_caster_datadriven", {
			duration = 6 })
		caster.supernova_scepter_target = target
	else
		caster.supernova_scepter_target = nil
	end

	local egg = CreateUnitByName("npc_dota_phoenix_sun", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeam())
	egg:EmitSound("Hero_Phoenix.SuperNova.Begin")
	egg:AddNewModifier(caster, self, "modifier_supernova_sun_form_egg_datadriven", { duration = 6 })
	particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf",
											  PATTACH_ABSORIGIN_FOLLOW,
											  egg)
	ParticleManager:ReleaseParticleIndex(particle)
end
