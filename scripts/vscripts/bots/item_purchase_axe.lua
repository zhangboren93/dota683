----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = require(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_tango",
	"item_flask",
	"item_stout_shield",
	--"item_enchanted_mango",
	--"item_quelling_blade",
	"item_tranquil_boots", --相位
	--"item_magic_wand", --大魔棒7.14
	--"item_bracer",
	"item_vanguard",
	"item_blink", --跳刀
	"item_blade_mail",
	--"item_aghanims_shard",
	"item_black_king_bar", --BKB
	--"item_lotus_orb", --清莲宝珠,
	"item_assault",
	--"item_overwhelming_blink",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)

function ItemPurchaseThink()
	ItemPurchaseSystem:ItemPurchaseExtend()
end
