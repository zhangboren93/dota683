function handleDeath(event)
	local caster = event.caster
	if caster:IsReincarnating() then
		return
	end
	local ability = event.ability
	print(caster:GetName())

	local new_time_until_respawn = 4 * caster:GetLevel()
	local bs = caster:FindItemInInventory("item_bloodstone_datadriven")
	if bs ~= nil then
		new_time_until_respawn = new_time_until_respawn - 4 * bs:GetCurrentCharges()
	end
	caster:SetThink(function()
		-- respawn time by necro
		if caster.necrospawnminus ~= nil then
			new_time_until_respawn = new_time_until_respawn + caster.necrospawnminus
		end
		-- buy back respawn time
		print(caster.buybacked)
		if caster.buybacked ~= nil then
			new_time_until_respawn = new_time_until_respawn * 1.25
		end
		if new_time_until_respawn < 0 then
			new_time_until_respawn = 0
		end
		print("New respawn time " .. new_time_until_respawn)
	
		caster:SetTimeUntilRespawn(new_time_until_respawn)
		caster.necrospawnminus = nil
		caster.buybacked = nil
	end, "set time until respawn", 0.5)
end