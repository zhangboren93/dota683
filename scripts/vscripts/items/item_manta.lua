function handleAbilityExecuted(event)
	local target_ability = event.event_ability
	local caster = event.caster
	if target_ability:GetName() == "item_manta" and caster:IsRangedAttacker() then
		caster:SetThink(function()
			target_ability:StartCooldown(50)
		end, "set cooldown for ranged hero", 0.1)
	end
end
