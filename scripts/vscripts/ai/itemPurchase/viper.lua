-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous, dralois, eteran
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local thisBot = BotsInit.CreateGeneric()

local generic = dofile( GetScriptDirectory().."/itemPurchase/generic" )

generic.ItemsToBuyAsHardCarry = {
	StartingItems = {
		"item_wraith_band_datadriven",
		"item_tango"
	},
	UtilityItems = {
		"item_flask"
	},
	CoreItems = {
		"item_power_treads_agi",
		"item_ring_of_aquila_lua",
		"item_mekansm_2",
        "item_ultimate_scepter"
	},
	ExtensionItems = {
		{
			"item_assault"
		},
		{
			"item_heart_datadriven"
		}
	},
    SellItems = {
    }
}
generic.ItemsToBuyAsMid = {
	StartingItems = {
		"item_wraith_band_datadriven",
		"item_tango"
	},
	UtilityItems = {
		"item_flask"
	},
	CoreItems = {
		"item_power_treads_agi",
		"item_ring_of_aquila_lua",
		"item_mekansm_2",
        "item_ultimate_scepter"
	},
	ExtensionItems = {
		{
			"item_assault"
		},
		{
			"item_heart_datadriven"
		}
	},
    SellItems = {
    }
}
generic.ItemsToBuyAsOfflane = {
	StartingItems = {
		"item_wraith_band_datadriven",
		"item_tango"
	},
	UtilityItems = {
		"item_flask"
	},
	CoreItems = {
		"item_power_treads_agi",
		"item_ring_of_aquila_lua",
		"item_mekansm_datadriven",
        "item_ultimate_scepter"
	},
	ExtensionItems = {
        {
			"item_butterfly_datadriven",
			"item_assault"
		},
		{
			"item_pipe",
			"item_manta"
		}
	},
    SellItems = {
        "item_ring_of_aquila_lua"
    }
}

function thisBot:Init(bot)
    generic:InitTable(bot)
end

function thisBot:GetPurchaseOrder()
    return generic:GetPurchaseOrder()
end

function thisBot:UpdateTeamBuyList(sItem)
    generic:UpdateTeamBuyList( sItem )
end
function thisBot:UpdateTeamBuyList(sItem)
    generic:UpdateTeamBuyList( sItem )
end

function thisBot:ItemPurchaseThink(bot)
    generic:Think(bot)
end

return thisBot
