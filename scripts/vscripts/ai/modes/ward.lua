-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local X = BotsInit.CreateGeneric()

----------
require( GetScriptDirectory().."/constants" )

local utils = require( GetScriptDirectory().."/utility" )
local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )

require( GetScriptDirectory().."/item_usage" )

local function setHeroVar(bot, var, value)
    gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

local function getHeroVar(bot, var)
    return gHeroVar.GetVar(bot:GetPlayerID(), var)
end

function X:GetName()
    return "ward"
end

function X:OnStart(myBot)
end

function X:OnEnd()
    setHeroVar(bot, "WardType", nil)
    setHeroVar(bot, "WardLocation", nil)
    setHeroVar(bot, "WardCheckTimer", GameTime())
end

function X:Think(bot)
    if utils.IsBusy(bot) then return end
    
    local wardType = getHeroVar(bot, "WardType") or "item_ward_observer"
    local dest = getHeroVar(bot, "WardLocation")
    if dest ~= nil then
        local dist = GetUnitToLocationDistance(bot, dest)
        if dist <= constants.WARD_CAST_DISTANCE then
            local ward = item_usage.HaveWard(wardType)
            if ward then
                gHeroVar.HeroPushUseAbilityOnLocation(bot, ward, dest, constants.WARD_CAST_DISTANCE)
                getHeroVar(bot, "Self"):ClearMode()
            end
        else
            local nearbyEnemies = gHeroVar.GetNearbyEnemies(bot, 1600)
            local nearbyETowers = gHeroVar.GetNearbyEnemyTowers(bot, 1600)
            if #nearbyEnemies > 0 or #nearbyETowers > 0 then
                local listDangerHandles = { unpack(nearbyEnemies), unpack(nearbyETowers) }
                dest = utils.DirectionAwayFromDanger(bot, listDangerHandles, dest)
            end
            
            if not modifiers.IsInvisible(bot) then
                if item_usage.UseGlimmerCape() then return end                
                if item_usage.UseMovementItems(dest) then return end
            end
            
            gHeroVar.HeroMoveToLocation(bot, dest)
        end
    end
end

function X:Desire(bot)
    if bot:IsIllusion() then return BOT_MODE_DESIRE_NONE end

	-- TODO place lane wards
    ---- we need to lane first before we know where to ward properly
    --if getHeroVar(bot, "CurLane") == nil or getHeroVar(bot, "CurLane") == 0 then
    --    return BOT_MODE_DESIRE_NONE
    --end
    --
    --local nearbyEnemies = gHeroVar.GetNearbyEnemies(bot, Min(1600, bot:GetCurrentVisionRange()))
    --if #nearbyEnemies > 0 then
    --    return BOT_MODE_DESIRE_NONE
    --end
    --
    --local WardCheckTimer = getHeroVar(bot, "WardCheckTimer")
    --local bCheck = true
    --local newTime = GameTime()
    --
    --if WardCheckTimer then
    --    bCheck, newTime = utils.TimePassed(WardCheckTimer, 1.0)
    --end
    --
    --if bCheck then
    --    setHeroVar(bot, "WardCheckTimer", newTime)
    --    local ward = item_usage.HaveWard(bot, "item_ward_observer")
    --    if ward then
    --        local alliedMapWards = bot:GetUnitList(UNIT_LIST_ALLIED_WARDS)
    --        if #alliedMapWards < 2 then --FIXME: don't hardcode.. you get more wards then you can use this way
    --            local wardLocs = utils.GetWardingSpot(getHeroVar(bot, "CurLane"))

    --            if wardLocs == nil or #wardLocs == 0 then return BOT_MODE_DESIRE_NONE end

    --            -- FIXME: Consider ward expiration time
    --            local wardLoc = nil
    --            for _, wl in ipairs(wardLocs) do
    --                local bGoodLoc = true
    --                for _, value in ipairs(alliedMapWards) do
    --                    if utils.GetDistance(value:GetLocation(), wl) < 1600 then
    --                        bGoodLoc = false
    --                    end
    --                end
    --                if bGoodLoc then
    --                    wardLoc = wl
    --                    break
    --                end
    --            end

    --            if wardLoc ~= nil and utils.EnemiesNearLocation(bot, wardLoc, 2000) < 2 then
    --                setHeroVar(bot, "WardType", ward:GetName())
    --                setHeroVar(bot, "WardLocation", wardLoc)
    --                return BOT_MODE_DESIRE_LOW 
    --            end
    --        end
    --    end
    --    
    --    return BOT_MODE_DESIRE_NONE
    --end
    --
    --local me = getHeroVar(bot, "Self")
    --if me:getCurrentMode():GetName() == "ward" then
    --    return me:getCurrentModeValue()
    --end
    
    return BOT_MODE_DESIRE_NONE
end

return X
