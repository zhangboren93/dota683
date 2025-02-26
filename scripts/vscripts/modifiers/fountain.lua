function handleIntervalThink(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	--local fountain = nil
	---- register last time target is in range of fountain
	--if target:GetTeam() == DOTA_TEAM_GOODGUYS then
	--	fountain = Entities:FindByName(nil, "ent_dota_fountain_good")
	--elseif target:GetTeam() == DOTA_TEAM_BADGUYS then
	--	fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
	--end
	--if fountain == nil then return end
	--if (target:GetAbsOrigin() - fountain:GetAbsOrigin()):Length2D() < 1201 then
	--	target.lastFountainTime = GameRules:GetGameTime()
	--end

	-- if target doesn't have the fountain aura
	--if target.lastFountainTime == nil then return end
	if not target:HasModifier("modifier_fountain_aura_buff") then
--		local duration = 3 - GameRules:GetGameTime() + target.lastFountainTime
--		if duration > 0 then
--			target:AddNewModifier(caster, ability, "modifier_fountain_aura_buff_lua", { duration = duration })
--		end
		target:RemoveModifierByName("modifier_fountain_aura_tp_persist_datadriven")
	else 
		-- refill bottle
		local bottle = target:FindItemInInventory("item_bottle")
		if bottle ~= nil then
			if bottle:GetCurrentCharges() < 3 then
				bottle:SetCurrentCharges(3)
			end
		end
	end
end
