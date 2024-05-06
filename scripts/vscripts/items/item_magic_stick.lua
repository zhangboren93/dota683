function ProcsMagicStick(event)
	local caster = event.caster
	local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 
		1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for i=1,#units do
		local item = units[i]:FindItemInInventory("item_magic_stick")
		if item ~= nil and item:GetItemState() == 1 then
			item:SetCurrentCharges(math.min(10, item:GetCurrentCharges() + 1))
		end
		item = units[i]:FindItemInInventory("item_magic_wand")
		if item ~= nil and item:GetItemState() == 1 then
			item:SetCurrentCharges(math.min(20, item:GetCurrentCharges() + 1))
		end
	end
end
