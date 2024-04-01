function handleAbilityExecuted(event)
	local event_ability = event.event_ability
	local target_ability = event.TargetAbility
	if event_ability:GetName() == target_ability then
		local duration = event_ability:GetSpecialValueFor(event.DurationName)
		if duration == nil then
			duration = 0.1
		end
		event.target:AddNewModifier(event.caster, event_ability, "modifier_stunned", { duration = duration })
	end
end
