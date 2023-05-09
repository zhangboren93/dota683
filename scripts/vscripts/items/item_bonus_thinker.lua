item2pctregen = {}
item2pctregen["item_medallion_of_courage"] = 50
item2pctregen["item_soul_ring"] = 50

function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	item2modifier("item_ring_of_aquila", "modifier_ring_of_aquila_bonus_armor", caster, ability)
	item2modifier("item_maelstrom", "modifier_maelstrom_bonus_attack_speed", caster, ability)
	item2modifier("item_shadow_amulet", "modifier_item_shadow_amulet_attack_speed", caster, ability)
	item2modifier("item_soul_ring", "modifier_item_soul_ring_health_regen", caster, ability)
	itemPctManaRegen(caster)
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

function itemPctManaRegen(caster)
	local total_pct = 0
	for i,v in pairs(item2pctregen) do
		local item = caster:FindItemInInventory(i)
		if item ~= nil and item:GetItemState() == 1  then
			total_pct = total_pct + v
		end
	end
	local mana_gen = 1 + caster:GetIntellect() * 4;
	local bonus_mana = math.floor(mana_gen * total_pct / 100)

	local modifier = caster:FindModifierByName("item_pct_mana_regen_modifier_lua")
	if modifier ~= nil and modifier:GetStackCount() == bonus_mana then
		return
	end
	caster:RemoveModifierByName("item_pct_mana_regen_modifier_lua")
	caster:AddNewModifier(caster, nil, "item_pct_mana_regen_modifier_lua", {}):SetStackCount(bonus_mana)
end