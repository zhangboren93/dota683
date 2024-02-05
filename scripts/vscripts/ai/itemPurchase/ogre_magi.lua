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
		"item_circlet",
		"item_branches",
	},
	CoreItems = {
		"item_boots",
		"item_magic_wand",
		"item_arcane_boots",
		"item_force_staff", --推推7.14
		"item_mekansm_2",
	},
	ExtensionItems = {
		OffensiveItems = {
			"item_sheepstick"
		},
		DiffensiveItems = {
			"item_shivas_guard"
		}
	},
    SellItems = {
		"item_stout_shield",
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
