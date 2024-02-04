-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous, dralois
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local thisBot = BotsInit.CreateGeneric()

local generic = dofile( GetScriptDirectory().."/itemPurchase/generic" )

generic.ItemsToBuyAsMid = {
	StartingItems = {
		"item_null_talisman_datadriven",
		"item_tango",
	},
	CoreItems = {
		"item_boots",
		"item_magic_wand", --大魔棒7.14
		"item_arcane_boots",
		"item_hood_of_defiance_datadriven", --纷争7.20
		"item_mekansm_2",
		"item_shivas_guard", --希瓦
	},
	ExtensionItems = {
		OffensiveItems = {
			"item_radiance", --梅肯
		},
		DiffensiveItems = {
			"item_heart_datadriven"
		}
	},
    SellItems = {
		"item_null_talisman_datadriven",
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
