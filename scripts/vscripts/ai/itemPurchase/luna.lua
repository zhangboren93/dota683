-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous, dralois
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local thisBot = BotsInit.CreateGeneric()

local generic = dofile( GetScriptDirectory().."/itemPurchase/generic" )

generic.ItemsToBuyAsMid = {
	StartingItems = {
		"item_tango",
		"item_wraith_band_datadriven"
	},
	CoreItems = {
		"item_wraith_band_datadriven",
		"item_magic_wand", --大魔棒7.14
		"item_power_treads", --假腿7.21
		"item_mask_of_madness_datadriven", --疯狂面具7.06
		"item_manta",
		"item_black_king_bar_datadriven",
	},
	ExtensionItems = {
		OffensiveItems = {
			"item_butterfly_datadriven", --蝴蝶
			"item_satanic_datadriven",
		},
		DiffensiveItems = {
			"item_assault",
			"item_heart_datadriven"
		}
	},
    SellItems = {
		"item_wraith_band_datadriven",
		"item_wraith_band_datadriven",
		"item_magic_wand", --大魔棒7.14
		"item_mask_of_madness_datadriven", --疯狂面具7.06
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
