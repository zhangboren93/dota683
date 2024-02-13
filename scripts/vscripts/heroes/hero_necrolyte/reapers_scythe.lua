--[[Author: Pizzalol
	Date: 06.01.2015.
	Deals damage depending on missing hp
	If the target dies then it increases the respawn time]]
function ReapersScythe( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local target_missing_hp = target:GetMaxHealth() - target:GetHealth()
	local damage_per_health = ability:GetLevelSpecialValueFor("damage_per_health", (ability:GetLevel() - 1))

	if target.toBeKilledByReaper then
		target:Kill(ability, caster)
		return
	end

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.ability = ability
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.damage = target_missing_hp * damage_per_health

	ApplyDamage(damage_table)
end

function handleDamageTaken(event)
	local damage = event.Damage
	local target = event.unit
	if target:GetHealth() < damage then
		target:SetHealth(1)
		target.toBeKilledByReaper = true
	end
end

function handleSpellStart(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:TriggerSpellAbsorb(ability) then return end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_reapers_scythe_datadriven", { duration = 1.5 })
	caster:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
	target:EmitSound("Hero_Necrolyte.ReapersScythe.Target")
	target.toBeKilledByReaper = false
end
