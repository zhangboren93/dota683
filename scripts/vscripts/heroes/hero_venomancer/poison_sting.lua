function handleWardIntervalThink(event)
	local target = event.target
	if target:HasModifier("modifier_poison_sting_debuff_datadriven") then
		target:RemoveModifierByName("modifier_ward_poison_sting_debuff_datadriven")
	end
end
function handleWardAttackLanded(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	if target:IsBuilding() then
		return
	end
	if not target:HasModifier("modifier_poison_sting_debuff_datadriven") then
		ability:ApplyDataDrivenModifier(attacker, target, "modifier_ward_poison_sting_debuff_datadriven", {})
	else
		target:FindModifierByName("modifier_poison_sting_debuff_datadriven"):SetDuration(
			ability:GetSpecialValueFor("duration"), true)
	end
end

function handleDamage(event)
	local damageTable =
	{
		victim 		 = event.target,
		attacker 	 = event.caster,
		damage 		 = event.Damage,
		damage_type	 = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
		ability 	 = event.ability
	}
	ApplyDamage(damageTable)
end
