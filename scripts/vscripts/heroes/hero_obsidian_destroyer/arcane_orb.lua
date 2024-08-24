--[[Arcane Orb
	Author: chrislotix
	Date: 05.01.2015.]]

function ArcaneOrb( keys )
	local ability = keys.ability
	local caster = keys.caster
	local mana = caster:GetMana()
	local target = keys.target
	local summon_damage = ability:GetLevelSpecialValueFor("illusion_damage", (ability:GetLevel() -1))
	local extra_damage = ability:GetLevelSpecialValueFor("mana_pool_damage_pct", (ability:GetLevel() -1)) / 100

	target:EmitSound("Hero_ObsidianDestroyer.ArcaneOrb.Impact")

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.victim = target


	if not target:IsRealHero() and target:IsSummoned() then
		damage_table.damage = mana * extra_damage + summon_damage
	else
		damage_table.damage = mana * extra_damage
	end 

	ApplyDamage(damage_table)
end

function HiddenAbility(keys)
	local caster = keys.caster
	local ability = caster:FindAbilityByName("obsidian_destroyer_dummy_skill")
	ability:SetLevel(1)
	ability:CastAbility()
end

obsidian_destroyer_arcane_orb_datadriven = class({})
function obsidian_destroyer_arcane_orb_datadriven:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end
function obsidian_destroyer_arcane_orb_datadriven:GetProjectileName()
	return "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf"
end
function obsidian_destroyer_arcane_orb_datadriven:OnOrbFire(event)
	local caster = self:GetCaster()
	caster:EmitSound("Hero_ObsidianDestroyer.ArcaneOrb")
	event.caster = caster
	HiddenAbility(event)
end
function obsidian_destroyer_arcane_orb_datadriven:OnOrbImpact(event)
	event.ability = self
	event.caster = self:GetCaster()
	ArcaneOrb(event)
end
