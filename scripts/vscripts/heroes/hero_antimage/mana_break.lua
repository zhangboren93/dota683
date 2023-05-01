--[[Mana drain and damage part of Mana Break
	Author: Pizzalol
	Date: 11.07.2015.]]
function ManaBreak( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local manaBurn = ability:GetLevelSpecialValueFor("mana_per_hit", (ability:GetLevel() - 1))
	local manaDamage = ability:GetLevelSpecialValueFor("damage_per_burn", (ability:GetLevel() - 1))

	local damageTable = {}
	damageTable.attacker = caster
	damageTable.victim = target
	damageTable.damage_type = ability:GetAbilityDamageType()
	damageTable.ability = ability

	-- If the target is not magic immune then reduce the mana and deal damage
	if not target:IsMagicImmune() and target:GetMana() > 0 then
		-- Checking the mana of the target and calculating the damage
		if(target:GetMana() >= manaBurn) then
			damageTable.damage = manaBurn * manaDamage
		else
			damageTable.damage = target:GetMana() * manaDamage
		end
		target:Script_ReduceMana(manaBurn, ability)

		ApplyDamage(damageTable)
		
		ability:ApplyDataDrivenModifier(caster, target, "modifier_mana_break_orb_effect_datadriven", {})
	end
end