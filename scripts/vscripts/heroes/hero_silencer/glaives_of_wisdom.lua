--[[Glaives of Wisdom intelligence to damage
	Author: chrislotix
	Date: 10.1.2015.]]

function IntToDamage( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local int_caster = caster:GetIntellect(true)
	local int_damage = ability:GetLevelSpecialValueFor("intellect_damage_pct", (ability:GetLevel() -1)) 
	

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.victim = target

	damage_table.damage = int_caster * int_damage / 100

	ApplyDamage(damage_table)

end

silencer_glaives_of_wisdom_datadriven = class({})
function silencer_glaives_of_wisdom_datadriven:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end
function silencer_glaives_of_wisdom_datadriven:GetProjectileName()
	return "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf"
end
function silencer_glaives_of_wisdom_datadriven:OnOrbFire(event)
	self:GetCaster():EmitSound("Hero_Silencer.GlaivesOfWisdom")
end
function silencer_glaives_of_wisdom_datadriven:OnOrbImpact(event)
	local target = event.target
	target:EmitSound("Hero_Silencer.GlaivesOfWisdom.Damage")
	event.ability = self
	event.caster = self:GetCaster()
	IntToDamage(event)
end
