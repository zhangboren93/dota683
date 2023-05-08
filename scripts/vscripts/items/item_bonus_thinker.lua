function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	item2modifier("item_ring_of_aquila", "modifier_ring_of_aquila_bonus_armor", caster, ability)
	item2modifier("item_maelstrom", "modifier_maelstrom_bonus_attack_speed", caster, ability)
	item2modifier("item_shadow_amulet", "modifier_item_shadow_amulet_attack_speed", caster, ability)
	itemPctManaRegen("item_medallion_of_courage", "item_medallion_regen_percentage_modifier", caster, 50)
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

function itemPctManaRegen(itemname, modifiername, caster, pct)
	local item = caster:FindItemInInventory(itemname)
	if item ~= nil and item:GetItemState() == 1  then
		local mana_gen = 0.01 + caster:GetIntellect() * 0.04;
		print(mana_gen)
		local bonus_mana = math.floor(mana_gen * pct)
		print(bonus_mana)
		local modifier = caster:FindModifierByName(modifiername)
		if modifier ~= nil and modifier:GetStackCount() == bonus_mana then
			return
		end
		caster:RemoveModifierByName(modifiername)
		caster:AddNewModifier(caster, item, modifiername, {}):SetStackCount(bonus_mana)
	else
		caster:RemoveModifierByName(modifiername)
	end
end