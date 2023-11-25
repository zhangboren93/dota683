function handleIntervalThink(event)
	local target = event.target
	if not target:HasModifier("modifier_riki_smoke_screen") then
		target:RemoveModifierByName("modifier_riki_smoke_screen_slow_datadriven")
	end
end
