function handleIntervalThink(event)
	local caster = event.caster
	if GameRules.AddonTemplate.custom_game_meta_version == "688" then
		local item1 = caster:FindItemInInventory("item_mystic_staff")
		local item2 = caster:FindItemInInventory("item_soul_booster_datadriven")
		if  item1 ~= nil and item1:GetItemState() == 1 and not item1:IsCombineLocked() and
			item2 ~= nil and item2:GetItemState() == 1 and not item2:IsCombineLocked() and
			not caster:HasItemInInventory("item_recipe_octarine_core_lua") then
			caster:AddItemByName("item_recipe_octarine_core_lua")
		end
	end
end
