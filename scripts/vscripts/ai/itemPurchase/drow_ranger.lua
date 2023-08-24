-------------------------------------------------------------------------------
--- AUTHOR: pbenologa
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local thisBot = BotsInit.CreateGeneric()

local generic = dofile( GetScriptDirectory().."/itemPurchase/generic" )

generic.ItemsToBuyAsHardCarry = {
    StartingItems = {
        "item_slippers",
        "item_flask",
        "item_tango",
        "item_branches",
        "item_branches",
	},
	UtilityItems = {
	},
	CoreItems = {
        "item_ring_of_aquila_lua",
		"item_power_treads_agi",
		"item_maelstrom_datadriven",
		"item_ultimate_scepter",
		"item_mjollnir_datadriven",
		"item_lesser_crit",
		"item_greater_crit"
	},
	ExtensionItems = {
		OffensiveItems = {
			"item_butterfly_datadriven",
			"item_monkey_king_bar_datadriven"
		},
		DefensiveItems = {
			"item_black_king_bar_datadriven"
		}
	},
    SellItems = {
        "item_branches",
        "item_branches",
        "item_ring_of_aquila_lua"
    }
}

generic.ItemsToBuyAsMid = {
    StartingItems = {
        "item_wraith_band_datadriven",
        "item_tango"
	},
	UtilityItems = {
	},
	CoreItems = {
        "item_ring_of_aquila_lua",
		"item_power_treads_agi",
		"item_yasha",
        "item_manta",
		"item_maelstrom_datadriven",
		"item_mjollnir_datadriven"
	},
	ExtensionItems = {
		OffensiveItems = {
			"item_butterfly_datadriven",
			"item_monkey_king_bar_datadriven"
		},
		DefensiveItems = {
			"item_black_king_bar_datadriven",
		    "item_ultimate_scepter"
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

function thisBot:ItemPurchaseThink(bot)
    generic:Think(bot)
end

return thisBot
