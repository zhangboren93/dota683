function handleIntervalThink(event)
	local caster = event.caster
	local modifier_name = "modifier_huskar_berserkers_blood_datadriven"

	if caster:IsIllusion() then
		caster:RemoveModifier(modifier_name)
		return
	end

	local stack_cnt = math.floor((101 - caster:GetHealthPercent()) / 7)	
	if stack_cnt < 1 then stack_cnt = 1 end

	caster:FindModifierByName(modifier_name):SetStackCount(stack_cnt)
end