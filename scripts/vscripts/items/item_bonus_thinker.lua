function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	item2modifier("item_ring_of_aquila", "modifier_ring_of_aquila_bonus_armor", caster, ability)
	item2modifier("item_maelstrom", "modifier_maelstrom_bonus_attack_speed", caster, ability)
end

function item2modifier(itemname, modifier, caster, ability)
	local item = caster:FindItemInInventory(itemname)
	if item ~= nil and item:GetItemState() == 1  then
		if not caster:HasModifier(modifier) then
			ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
		end
	else
		caster:RemoveModifierByName(modifier)
	end
end