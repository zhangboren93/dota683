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
		"item_soul_ring",
		"item_phase_boots",
		"item_vanguard_lua",
		"item_hood_of_defiance_datadriven",
		"item_heart_datadriven",
	},
	ExtensionItems = {
		OffensiveItems = {
			"item_assault"
		},
		DiffensiveItems = {
			"item_shivas_guard"
		}
	},
    SellItems = {
		"item_stout_shield",
		"item_quelling_blade_lua"
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
