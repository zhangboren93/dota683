function handleTakeDamage(event)
	local attacker = event.attacker
	local unit = event.unit
	if unit:GetHealth() == 0 and attacker:GetTeam() ~= unit:GetTeam() and attacker.ModifyGold ~= nil then
		if attacker:HasModifier("modifier_hero_buybacked_gold_penalty") then
		    return
		end
		local illusion_bounty = unit:GetLevel() * 2
		if unit:HasModifier("modifier_phantom_lancer_juxtapose_illusion") then
			illusion_bounty = 5
		end
		if unit:FindModifierByName("modifier_illusion"):GetAbility():GetName() == "chaos_knight_phantasm_datadriven" then
			illusion_bounty = 0
		end
		attacker:ModifyGold(-1 * illusion_bounty, false, DOTA_ModifyGold_Unspecified)
	end
end
