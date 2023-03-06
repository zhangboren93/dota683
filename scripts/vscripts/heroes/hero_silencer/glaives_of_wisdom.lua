--[[Glaives of Wisdom intelligence to damage
	Author: chrislotix
	Date: 10.1.2015.]]

function IntToDamage( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local int_caster = caster:GetIntellect()
	local int_damage = ability:GetLevelSpecialValueFor("intellect_damage_pct", (ability:GetLevel() -1)) 
	

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.victim = target

	damage_table.damage = int_caster * int_damage / 100

	ApplyDamage(damage_table)

end

function stealInt(event)
	local unit = event.unit
	local ability = event.ability
	print(unit:GetName())
	print(ability:GetName())
	if unit:IsRealHero() then 
		print("Losing int when respawned")
		unit.loseIntOnRespawn = true
		unit.silencerAbility = ability
	end
end

function stealIntBuffCount(event)
	local ability = event.ability
	local unit = event.target
	print(ability:GetName())
	print(unit:GetName())
	if not unit:HasModifier("modifier_int_steal_bonus_stacks_datadriven") then
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_int_steal_bonus_stacks_datadriven", {})
	end
	local modifier = unit:FindModifierByName("modifier_int_steal_bonus_stacks_datadriven")
	modifier:IncrementStackCount()
end