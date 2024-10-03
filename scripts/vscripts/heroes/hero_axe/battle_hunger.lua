function handleSpellStart(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	caster:EmitSound("Hero_Axe.Battle_Hunger")
	if target:TriggerSpellAbsorb(ability) then return end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_axe_battle_hunger_datadriven", { duration = 10 })
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_battle_hunger_self_movespeed_datadriven", { duration = 1.1 })
end

function handleIntervalThink(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage_per_second = ability:GetSpecialValueFor("damage_per_second")
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage_per_second,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_battle_hunger_self_movespeed_datadriven", { duration = 1.1 })
end

function handleKill(event)
	local attacker = event.attacker
	attacker:RemoveModifierByName("modifier_axe_battle_hunger_datadriven")
end
