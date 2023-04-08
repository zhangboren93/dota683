----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	--"item_quelling_blade", --补刀斧
	"item_wraith_band_datadriven", --系带
	"item_phase_boots", --相位7.21
	--"item_orb_of_corrosion",
	"item_bfury",
	"item_desolator",
	--"item_aghanims_shard",
	"item_black_king_bar", --bkb
	"item_basher",
	"item_abyssal_blade", --大晕锤
	"item_satanic", --撒旦7.07
	"item_assault"
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()

end
