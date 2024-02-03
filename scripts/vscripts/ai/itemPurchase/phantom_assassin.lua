-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local thisBot = BotsInit.CreateGeneric()

local generic = dofile( GetScriptDirectory().."/itemPurchase/generic" )

generic.ItemsToBuyAsHardCarry = {
    StartingItems = {
        "item_tango",
        "item_stout_shield",
		"item_quelling_blade_lua"
	},
	UtilityItems = {
	},
	CoreItems = {
        "item_phase_boots",
		"item_vladmir_2",
		"item_basher",
        "item_black_king_bar_datadriven",
        "item_abyssal_blade",
	},
	ExtensionItems = {
		OffensiveItems = {
			"item_assault",
            "item_monkey_king_bar_datadriven"
		},
		DefensiveItems = {
            "item_skadi_datadriven",
			"item_heart_datadriven"
		}
	},
    SellItems = {
        "item_stout_shield",
		"item_quelling_blade_lua"
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
