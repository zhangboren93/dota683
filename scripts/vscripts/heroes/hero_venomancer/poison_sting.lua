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