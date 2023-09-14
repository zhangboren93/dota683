function handleIntervalThink(event)
	if event.ability:IsCooldownReady() then
		event.ability:ApplyDataDrivenModifier(event.caster, event.caster, event.ModifierName, {})
	end
end

function handleAttacked(event)
	event.ability:StartCooldown(event.ability:GetCooldown(0))
end

function handleAttackLanded(event)
	if event.attacker:HasModifier("modifier_no_creep_aggro_on_attack") then
		return
	end
	event.attacker:RemoveModifierByName("modifier_tranquil_active_datadriven")
	event.ability:StartCooldown(event.ability:GetCooldown(0))
end
