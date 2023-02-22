----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_wraith_band_datadriven", --系带
	"item_power_treads",
	"item_maelstrom",
	"item_desolator",
	--"item_hurricane_pike",
	"item_black_king_bar", --bkb
	"item_hyperstone",
	"item_recipe_mjollnir", --大雷锤
	"item_greater_crit",
	--"item_ultimate_scepter_2"
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
