function handleIntervalThink(event)
	local caster = event.caster
	caster:RemoveItem(caster:FindItemInInventory("item_aghanims_shard_roshan"))
	caster:RemoveItem(caster:FindItemInInventory("item_ultimate_scepter_roshan"))
	caster:RemoveItem(caster:FindItemInInventory("item_refresher_shard"))
	--print("roshanNo " .. caster.roshanNo)
	if caster.roshanNo == nil then
		return
	end
	if caster.roshanNo > 2 and not caster:HasItemInInventory("item_cheese") then
		caster:AddItemByName("item_cheese")
	end

	local ability = event.ability
	local time = GameRules:GetDOTATime(false, false) 
	local count = math.floor(time / 240)
	caster:CreatureLevelUp(count - caster:GetLevel() + 18)

	local slam = caster:FindAbilityByName("roshan_slam")
	if slam:IsCooldownReady() and #FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil,
			350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, false) > 2 then
		slam:CastAbility()
	end
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
	-- Drop aegis on death since roshan doesn't carry it anymore
	local aegis = CreateItem("item_aegis_lua", nil, nil)
	CreateItemOnPositionSync(caster:GetAbsOrigin(), aegis)
end

function handleFurySwipeDuration(event)
	local caster = event.caster
	local modifier = caster:FindModifierByName("modifier_ursa_fury_swipes_damage_increase")
	if modifier ~= nil and modifier:GetRemainingTime() > 6 then
		modifier:SetDuration(6, true)
	end
end
