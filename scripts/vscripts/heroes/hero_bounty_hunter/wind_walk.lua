function handleAbilityExecuted(event)
	local event_ability = event.event_ability
	local ability = event.ability
	local caster = event.caster
	if event_ability:GetName() ~= "bounty_hunter_track_datadriven" then
		caster:RemoveModifierByName("modifier_wind_walk_datadriven")
		caster:RemoveModifierByName("modifier_invisible")
	else
		local remaining_duration = caster:FindModifierByName("modifier_wind_walk_datadriven"):GetRemainingTime()
		caster:SetThink(function()
			caster:AddNewModifier(caster, event.ability, "modifier_invisible", { duration = remaining_duration - 0.1 })
		end, "regive invisible visual", 0.1)
	end
end
