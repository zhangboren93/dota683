function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	local item = caster:FindItemInInventory("item_ring_of_aquila")
	if item ~= nil and item:GetItemState() == 1  then
		if not caster:HasModifier("modifier_ring_of_aquila_bonus_armor") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_ring_of_aquila_bonus_armor", {})
		end
	else
		caster:RemoveModifierByName("modifier_ring_of_aquila_bonus_armor")
	end
end