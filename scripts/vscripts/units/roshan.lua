function handleIntervalThink(event)
	local caster = event.caster
	caster:RemoveItem(caster:FindItemInInventory("item_aghanims_shard_roshan"))
	caster:RemoveItem(caster:FindItemInInventory("item_ultimate_scepter_roshan"))
	caster:RemoveItem(caster:FindItemInInventory("item_refresher_shard"))

	local ability = event.ability
	local time = GameRules:GetDOTATime(false, false) 
	local count = math.floor(time / ability:GetSpecialValueFor("interval"))
    local existing = caster:FindAllModifiersByName("roshan_inherent_buffs_active_datadriven")
    if #existing >= count then
    	return
    end
    for i=#existing, count - 1 do
    	ability:ApplyDataDrivenModifier(caster, caster, "roshan_inherent_buffs_active_datadriven", {})
    	caster:SetMaxHealth(6000 + count * ability:GetSpecialValueFor("health"))
    end
end

function handleAttacked(event)
	local attacker = event.attacker
	if attacker:IsIllusion() then
		attacker:ForceKill(false)
	end
end