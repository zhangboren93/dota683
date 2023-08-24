-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous, dralois
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local thisBot = BotsInit.CreateGeneric()

local generic = dofile( GetScriptDirectory().."/itemPurchase/generic" )

generic.ItemsToBuyAsHardCarry = {
	StartingItems = {
		"item_stout_shield",
		"item_tango",
	--	"item_flask",
	--	"item_branches",
	--	"item_branches",
		"item_quelling_blade_lua"
	},
	UtilityItems = {
		"item_flask"
	},
	CoreItems = {
		"item_power_treads_agi",
		"item_bfury_datadriven",
		"item_vanguard",
		"item_yasha",
		"item_manta",
		"item_abyssal_blade"
	},
	ExtensionItems = {
		{
			"item_butterfly_datadriven",
			"item_monkey_king_bar_datadriven"
		},
		{
			"item_heart_datadriven",
			"item_black_king_bar_datadriven"
		}
	},
    SellItems = {
    }
}

----------------------------------------------------------------------------------------------------

function thisBot:Init(bot)
	print("Antimage init purchase table")
    generic:InitTable(bot)
	DeepPrintTable(generic.StartingItems)
end

function thisBot:GetPurchaseOrder()
    return generic:GetPurchaseOrder()
end

function thisBot:UpdateTeamBuyList(sItem)
    generic:UpdateTeamBuyList( sItem )
end

function thisBot:ItemPurchaseThink(bot)
    generic:Think(bot)
end

return thisBot

----------------------------------------------------------------------------------------------------
