-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous, dralois, eteran
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local thisBot = BotsInit.CreateGeneric()

local generic = dofile( GetScriptDirectory().."/itemPurchase/generic" )

generic.ItemsToBuyAsHardCarry = {
    StartingItems = {
        "item_tango",
        "item_wraith_band_datadriven"
    },
    UtilityItems = {
        "item_flask"
    },
    CoreItems = {
        "item_phase_boots",
        "item_ring_of_aquila_lua",
        "item_maelstrom_datadriven",
        "item_mjollnir_datadriven",
    },
    ExtensionItems = {
        OffensiveItems = {
            "item_monkey_king_bar_datadriven",
            "item_skadi_datadriven",
            "item_greater_crit"
        },
        DefensiveItems = {
            "item_black_king_bar_datadriven",
        }
    },
    SellItems = {
        "item_ring_of_aquila_lua"
    }
}
generic.ItemsToBuyAsMid = generic.ItemsToBuyAsHardCarry

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
