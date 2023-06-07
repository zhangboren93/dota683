function handleAbilityExecuted(event)
	local event_ability = event.event_ability
	if event_ability:GetName() == "elder_titan_ancestral_spirit" then
		local ability = event.ability
		local spirits = Entities:FindAllByClassname("npc_dota_elder_titan_ancestral_spirit")
		for i=1,#spirits do
			spirits[i]:FindAbilityByName(ability:GetName()):SetLevel(ability:GetLevel())
		end
	end
end