function handleDeath(event)
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	if unit:GetIntellect(false) <= 0 then return end
	local buff = caster:FindModifierByName("modifier_silencer_brain_drain_buff_datadriven")
	if buff ~= nil then
		local stack = buff:GetStackCount()
		if stack == 0 then
			stack = 2
		else
			stack = stack + 1
		end
		buff:SetStackCount(stack)
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_silencer_brain_drain_buff_datadriven", {})
	end
	unit.intStealOnRespawn = ability
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, 2, caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, unit, 2, caster)
end
