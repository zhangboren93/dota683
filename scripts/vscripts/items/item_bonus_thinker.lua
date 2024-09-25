item2pctregen = {}
item2pctregen["item_medallion_of_courage"] = 50
item2pctregen["item_soul_ring_datadriven"] = 50
item2pctregen["item_bfury"] = 150
item2pctregen["item_bfury_datadriven"] = 150
item2pctregen["item_sphere"] = 150
item2pctregen["item_refresher_datadriven"] = 200
item2pctregen["item_cyclone"] = 150
item2pctregen["item_orchid"] = 150
item2pctregen["item_sheepstick"] = 150
item2pctregen["item_sobi_mask_datadriven"] = 50
item2pctregen["item_void_stone_datadriven"] = 100
item2pctregen["item_oblivion_staff_datadriven"] = 75 
item2pctregen["item_pers_datadriven"] = 125 
item2pctregen["item_urn_of_shadows_datadriven"] = 50 
item2pctregen["item_bloodstone_datadriven"] = 200 
item2pctregen["item_soul_booster_datadriven"] = 100

function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	item2modifier("item_crimson_guard", 	"modifier_crimson_guard_attribute_bonus", caster, ability)
	item2modifier("item_necronomicon", 		"modifier_necronomicon_intellect_bonus", caster, ability)
	item2modifier("item_necronomicon_2", 	"modifier_necronomicon_2_intellect_bonus", caster, ability)
	item2modifier("item_necronomicon_3", 	"modifier_necronomicon_3_intellect_bonus", caster, ability)
	item2modifier("item_force_staff", 		"modifier_item_force_staff_health_regen", caster, ability)
	itemPctManaRegen(caster)

	-- apply gem effect
	local gem = caster:FindItemInInventory("item_gem")
	if gem ~= nil and gem:GetItemState() == 1 then
		if not caster:HasModifier("modifier_gem_visual_effect_datadriven") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_gem_visual_effect_datadriven", {})
		end
	else
		caster:RemoveModifierByName("modifier_gem_visual_effect_datadriven")
	end 
end

function item2modifier(itemname, modifier, caster, ability)
	local item = caster:FindItemInInventory(itemname)	
	if item ~= nil and item:GetItemState() == 1  then
		if not caster:HasModifier(modifier) then
			print("Applying item bonus modifier " .. modifier)
			ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
		end
	else
		caster:RemoveModifierByName(modifier)
	end
end

function itemPctManaRegen(caster)
	local total_pct = 0
	for i=DOTA_ITEM_SLOT_1,DOTA_ITEM_SLOT_6 do
		local item = caster:GetItemInSlot(i)
		if item ~= nil and item:GetItemState() == 1 and item2pctregen[item:GetName()] ~= nil then
			total_pct = total_pct + item2pctregen[item:GetName()]
		end
	end

	local mana_gen = 1 + caster:GetIntellect(true) * 4;
	local bonus_mana = math.floor(mana_gen * total_pct / 100)

	local modifier = caster:FindModifierByName("item_pct_mana_regen_modifier_lua")
	if modifier ~= nil and modifier:GetStackCount() == bonus_mana then
		return
	end
	caster:RemoveModifierByName("item_pct_mana_regen_modifier_lua")
	caster:AddNewModifier(caster, nil, "item_pct_mana_regen_modifier_lua", {}):SetStackCount(bonus_mana)
end
