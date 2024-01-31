-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous, dralois
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local thisBot = BotsInit.CreateGeneric()

local generic = dofile( GetScriptDirectory().."/itemPurchase/generic" )

generic.ItemsToBuyAsMid = {
	StartingItems = {
		"item_stout_shield",
		"item_tango",
		"item_quelling_blade_lua"
	},
	CoreItems = {
		--"item_magic_wand",
		"item_power_treads",
		"item_desolator_datadriven",
		"item_black_king_bar_datadriven",
		"item_assault",
	},
	ExtensionItems = {
		OffensiveItems = {
			"item_monkey_king_bar_datadriven"
		},
		DiffensiveItems = {
			"item_skadi_datadriven"
		}
	},
    SellItems = {
		"item_stout_shield",
		"item_quelling_blade_lua",
		"item_magic_wand"
    }
}

----------------------------------------------------------------------------------------------------

function thisBot:Init(bot)
    generic:InitTable(bot)
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
