function handleAbilityExecuted(keys)
	local unit = keys.unit
	local ability2 = keys.ability
	local event_ability = keys.event_ability
	local target = keys.target
--	print(event_ability:GetName())
	if event_ability:GetName() == "item_cyclone" and target:IsRealHero() and target:GetTeam() ~= unit:GetTeam() then
		local blink = target:FindItemInInventory("item_blink_datadriven")
		print(blink)
		if blink == nil then
			return
		end
		if blink:IsCooldownReady() or blink:GetCooldownTime() < 2.5 then
			target:SetThink(function()
				blink:EndCooldown()
			end, "enables blink after cyclone", 2.53)
		end
	end
end