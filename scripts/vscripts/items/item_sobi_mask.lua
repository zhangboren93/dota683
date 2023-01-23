function item_sobi_mask_gen_mana(keys)
    local caster = keys.caster
    local ability = keys.ability
    local itemname = keys.ItemName

    local mana_gen = caster:GetManaRegen();
    local mana_gen_bonus = keys.bonus_mana_regen_percentage
    local bonus_mana = mana_gen * mana_gen_bonus / 100
    -- think interval is 0.5s
    bonus_mana = bonus_mana / 2
    local itemcount = 0
	for i=0, 5, 1 do  --Remove all dummy items from the player's inventory.
		local current_item = keys.caster:GetItemInSlot(i)
		if current_item ~= nil then
			if current_item:GetName() == itemname and current_item:GetItemState() == 1 then
                itemcount = itemcount + 1
			end
		end
	end
    bonus_mana = bonus_mana * itemcount
    caster:GiveMana(bonus_mana)
    --print(bonus_mana .. " " .. itemcount)
end