function handleDeath(event)
	local caster = event.caster
	if not caster:IsRealHero() or caster:GetName() == "npc_dota_lone_druid_bear" then
		return
	end
	if caster:IsReincarnating() then
		if caster:GetName() == "npc_dota_hero_skeleton_king" then
			local skre = caster:FindAbilityByName("skeleton_king_reincarnation")
			if not skre:IsCooldownReady() and  skre:GetCooldownTime() >= skre:GetCooldown(skre:GetLevel() - 1)  - 2 then
				caster:SetTimeUntilRespawn(3)
				return
			end
		end
		caster:SetTimeUntilRespawn(5)
		return
	end
	local ability = event.ability
	print("Setting Custom respawn time " .. caster:GetName())

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
