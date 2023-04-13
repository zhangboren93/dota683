local ItemsToBuyHeroes = {}
-- TODO build up items
ItemsToBuyHeroes["npc_dota_hero_axe"] = {
	"item_tango",
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_bracer",
	"item_bracer",
	"item_tranquil_boots", --相位
    "item_ring_of_health",
    "item_vitality_booster",
	"item_blink", --跳刀
	"item_assault",
	"item_heart_datadriven"
}
ItemsToBuyHeroes["npc_dota_hero_luna"] = {
	"item_tango",
	"item_wraith_band_datadriven",
	"item_wraith_band_datadriven",
    "item_boots",
    "item_boots_of_elves",
	"item_gloves", --假腿7.21
	"item_manta",
	"item_butterfly", --蝴蝶
	"item_satanic"
}
ItemsToBuyHeroes["npc_dota_hero_skywrath_mage"] = {
	"item_tango",
	"item_null_talisman_datadriven",
	"item_null_talisman_datadriven",
	"item_null_talisman_datadriven",
    "item_boots",
	"item_energy_booster",
	"item_sheepstick", --羊刀
	"item_sphere",
}
ItemsToBuyHeroes["npc_dota_hero_lina"] = {
	"item_tango",
	"item_null_talisman_datadriven",
	"item_null_talisman_datadriven",
	"item_phase_boots",
	"item_ultimate_scepter", --蓝杖
	"item_greater_crit",
	"item_skadi",
}
ItemsToBuyHeroes["npc_dota_hero_bristleback"] = {
	"item_tango",
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_bracer",
    "item_ring_of_health",
    "item_vitality_booster",
	"item_phase_boots", --相位
	"item_hood_of_defiance",
	"item_black_king_bar", --BKB
	"item_shivas_guard",
	"item_heart_datadriven",
}
ItemsToBuyHeroes["npc_dota_hero_witch_doctor"] = {
	"item_tango",
	"item_null_talisman_datadriven",
	"item_null_talisman_datadriven",
	"item_boots",
	"item_energy_booster",
	"item_ghost",
	"item_force_staff",
	"item_ultimate_scepter", --蓝杖
	"item_sphere",
}
ItemsToBuyHeroes["npc_dota_hero_zuus"] = {
	"item_tango",
	"item_null_talisman_datadriven",
	"item_null_talisman_datadriven",
	"item_boots",
	"item_energy_booster",
	"item_ultimate_scepter", --蓝杖
	"item_ethereal_blade",
	"item_refresher"
}
ItemsToBuyHeroes["npc_dota_hero_skeleton_king"] = {
	"item_tango",
	"item_tango",
	"item_flask",
	"item_stout_shield",
	"item_power_treads",
	"item_desolator",
	"item_black_king_bar", --bkb
	"item_assault", --强袭
	"item_monkey_king_bar_datadriven"
}
ItemsToBuyHeroes["npc_dota_hero_lion"] = {
	"item_tango",
	"item_null_talisman_datadriven",
	"item_null_talisman_datadriven",
	"item_tranquil_boots",
	"item_force_staff",
	"item_ultimate_scepter", --蓝杖
	"item_sphere"
}
ItemsToBuyHeroes["npc_dota_hero_vengefulspirit"] = {
	"item_tango",
	"item_wraith_band_datadriven",
	"item_wraith_band_datadriven",
	"item_power_treads", --假腿7.21
	"item_medallion_of_courage", --勋章
	"item_skadi",
	"item_butterfly_datadriven"
}
ItemsToBuyHeroes["npc_dota_hero_sniper"] = {
	"item_tango",
	"item_wraith_band_datadriven", --系带
	"item_wraith_band_datadriven", --系带
	"item_power_treads",
	"item_maelstrom",
	"item_desolator",
	"item_hyperstone",
	"item_recipe_mjollnir", --大雷锤
	"item_greater_crit"
}
ItemsToBuyHeroes["npc_dota_hero_phantom_assassin"] = {
	"item_tango",
	"item_wraith_band_datadriven",
	"item_phase_boots", --相位7.21
	"item_bfury",
	"item_desolator",
	"item_black_king_bar", --bkb
	"item_abyssal_blade", --大晕锤
	"item_satanic", --撒旦7.07
}

if modifier_bot_item_purchase == nil then
    modifier_bot_item_purchase = class({})
end

function modifier_bot_item_purchase:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_bot_item_purchase:OnCreated(kv)
    self.progression = 1
    self.itemCostMap = LoadKeyValues("scripts/npc/npc_items_custom.txt")
    self.ItemsToBuy = ItemsToBuyHeroes[self:GetParent():GetName()]
    self:StartIntervalThink(0.5)
end

function modifier_bot_item_purchase:IsHidden()
    return false
end

function modifier_bot_item_purchase:OnIntervalThink()
    if not self:GetParent():HasItemInInventory("item_tpscroll") then
        local item = CreateItem("item_tpscroll", self:GetParent(), self:GetParent())
        self:GetParent():AddItem(item)
    end
    if self.progression < 0 then
        -- has bought everything
        return
    end
	for i=9,14 do
		self:GetParent():SellItem(self:GetParent():GetItemInSlot(i))
	end
    local itemName = self.ItemsToBuy[self.progression]
    local cost = self.itemCostMap[itemName]["ItemCost"]
    --print(ItemsToBuy[self.progression] .. " " .. cost .. " " .. self:GetParent():GetGold())
	if itemName ~= "item_wraith_band_datadriven" 
		and itemName ~= "item_null_talisman_datadriven"
		and itemName ~= "item_bracer"
		and itemName ~= "item_tango"
		and self:GetParent():HasItemInInventory(itemName) then
		self.progression = self.progression + 1
	end
    if cost < self:GetParent():GetGold() then
        self:GetParent():SpendGold(cost, DOTA_ModifyGold_PurchaseItem)
        local item = CreateItem(itemName, self:GetParent(), self:GetParent())
        self:GetParent():AddItem(item)
        self.progression = self.progression + 1
    end
    if self.progression > #self.ItemsToBuy then
        self.progression = -1
    end
end