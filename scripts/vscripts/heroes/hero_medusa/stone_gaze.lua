function handleStoneGazedIntervalThink(event)
	local target = event.target
	if not target:HasModifier("modifier_medusa_stone_gaze_slow") then
		target:RemoveModifierByName("modifier_medusa_stone_gaze_facing")
		target:RemoveModifierByName("modifier_medusa_stone_gaze_cancel_when_turned")
	end
end
