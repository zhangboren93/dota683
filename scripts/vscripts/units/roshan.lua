function handleIntervalThink(event)
	local caster = event.caster
	caster:RemoveItem(caster:FindItemInInventory("item_aghanims_shard_roshan"))
	caster:RemoveItem(caster:FindItemInInventory("item_ultimate_scepter_roshan"))
	caster:RemoveItem(caster:FindItemInInventory("item_refresher_shard"))
	if not caster:HasItemInInventory("item_aegis") then
		caster:AddItemByName("item_aegis")
	end
	--print("roshanNo " .. caster.roshanNo)
	if caster.roshanNo > 3 and not caster:HasItemInInventory("item_cheese") then
		caster:AddItemByName("item_cheese")
	end

	local ability = event.ability
	local time = GameRules:GetDOTATime(false, false) 
	local count = math.floor(time / 240)
	caster:CreatureLevelUp(count - caster:GetLevel() + 18)
end

function handleAttacked(event)
	local attacker = event.attacker
	if attacker:IsIllusion() then
		attacker:ForceKill(false)
	end
end

function handleDeath(event)
	local caster = event.caster
	print(caster:GetName())
	for i=DOTA_ITEM_SLOT_1,DOTA_ITEM_SLOT_2 do
		caster:DropItemAtPositionImmediate(caster:GetItemInSlot(i), caster:GetAbsOrigin())
	end
end