function handleIntervalThink(event)
	local caster = event.caster
	caster:RemoveItem(caster:FindItemInInventory("item_aghanims_shard_roshan"))
	caster:RemoveItem(caster:FindItemInInventory("item_ultimate_scepter_roshan"))
	caster:RemoveItem(caster:FindItemInInventory("item_refresher_shard"))
	caster:FindAbilityByName("roshan_teleport"):SetLevel(0)
	if not caster:HasItemInInventory("item_aegis") then
		caster:AddItemByName("item_aegis")
	end
	if caster.roshanNo > 2 and not caster:HasItemInInventory("item_cheese") then
		caster:AddItemByName("item_cheese")
	end

	local ability = event.ability
	local time = GameRules:GetDOTATime(false, false) 
	local count = math.floor(time / ability:GetSpecialValueFor("interval"))
	if count > 12 then
		count = 12
	end
	local maxHP = 7500 + count * ability:GetSpecialValueFor("health")
	if caster:GetMaxHealth() < maxHP then
		local heal = maxHP - caster:GetMaxHealth()
		caster:SetMaxHealth(7500 + count * ability:GetSpecialValueFor("health"))
		caster:SetThink(function()
			caster:Heal(heal, caster)
		end, "rosh max health increase", 0.2)
	end
	if time == 0 then
		caster:SetHealth(7500)
	end
    local existing = caster:FindAllModifiersByName("roshan_inherent_buffs_active_datadriven")
    if #existing >= count then
    	return
    end
    for i=#existing, count - 1 do
    	ability:ApplyDataDrivenModifier(caster, caster, "roshan_inherent_buffs_active_datadriven", {})
    end
end

function handleAttacked(event)
	local attacker = event.attacker
	if attacker:IsIllusion() then
		attacker:ForceKill(false)
	end
end