-------------------------------------------------------------------------------
--- AUTHOR: Keithen
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

BotsInit = require( "game/botsinit" )
local X = BotsInit.CreateGeneric()

----------
local utils = require( GetScriptDirectory().."/utility")
require( GetScriptDirectory().."/constants" )
require( GetScriptDirectory().."/jungle_status")

local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )

local function setHeroVar(bot, var, value)
    gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

local function getHeroVar(bot, var)
    return gHeroVar.GetVar(bot:GetPlayerID(), var)
end

----------

local JunglingStates = {
    FindCamp    = 0,
    MoveToCamp  = 1,
    WaitForSpawn= 2,
    Stack       = 3,
    CleanCamp   = 4
}

function X:GetName()
    return "jungling"
end

function X:OnStart(myBot)
    setHeroVar(myBot, "JunglingState", JunglingStates.FindCamp)
    setHeroVar(myBot, "move_ticks", 0)
    setHeroVar(myBot, "currentCamp", nil)
    setHeroVar(myBot, "waituntil", 0)
    myBot.jungleReloaded = false
end

function X:OnEnd()
    setHeroVar(bot, "move_ticks", 0)
    setHeroVar(bot, "currentCamp", nil)
end

----------------------------------

local function FindCamp(bot)
    -- TODO: just killing the closest one might not be the best strategy
    local jungle = jungle_status.GetJungle(bot:GetTeam())
    local maxcamplvl = bot.SelfRef:GetMaxClearableCampLevel(bot)
    jungle = FindCampsByMaxDifficulty(jungle, maxcamplvl)
    if #jungle == 0 then -- they are all dead
        jungle = utils.deepcopy(utils.tableNeutralCamps[bot:GetTeam()])
        jungle = FindCampsByMaxDifficulty(jungle, maxcamplvl)
    end
    local camp, camp2 = utils.NearestNeutralCamp(bot, jungle)

    if camp2 ~= nil then
        local listAllies = bot:GetUnitList(UNIT_LIST_ALLIED_HEROES)
        for _, ally in pairs(listAllies) do
            local allyID = ally:GetPlayerID()
            if allyID ~= bot:GetPlayerID() and gHeroVar.HasID(allyId) and not ally:IsIllusion() then
                local allyCamp = gHeroVar.GetVar(allyID, "currentCamp")
                if allyCamp ~= nil and allyCamp == camp then
                    utils.myPrint(ally.Name, "took nearest camp, going to another")
                    camp = camp2
                end
            end
        end
    end

    if getHeroVar(bot, "currentCamp") == nil or camp[constants.VECTOR] ~= getHeroVar(bot, "currentCamp")[constants.VECTOR] then
        utils.myPrint("moves to camp")
    end
    setHeroVar(bot, "currentCamp", camp)
    setHeroVar(bot, "JunglingState", JunglingStates.MoveToCamp)
    setHeroVar(bot, "move_ticks", 0)
end

local function MoveToCamp(bot)
    if getHeroVar(bot, "currentCamp") == nil then
        setHeroVar(bot, "JunglingState", JunglingStates.FindCamp)
        return
    end
    
    if GetUnitToLocationDistance(bot, getHeroVar(bot, "currentCamp")[constants.VECTOR]) > 200 then
        if getHeroVar(bot, "move_ticks") > 50 then -- don't do this every frame
            setHeroVar(bot, "JunglingState", JunglingStates.FindCamp) -- crossing the jungle takes a lot of time. Check for camps that may have spawned
            return
        else
            setHeroVar(bot, "move_ticks", getHeroVar(bot, "move_ticks") + 1)
        end
        gHeroVar.HeroMoveToLocation(bot, getHeroVar(bot, "currentCamp")[constants.VECTOR])
        return
    end

    local neutrals = gHeroVar.GetNearbyEnemyCreep(bot, 900)
    if #neutrals == 0 then -- no creeps here
        local jungle = jungle_status.GetJungle(bot:GetTeam())
        jungle = FindCampsByMaxDifficulty(jungle, bot.SelfRef:GetMaxClearableCampLevel(bot))
        if #jungle == 0 then -- jungle is empty
            setHeroVar(bot, "waituntil", utils.NextNeutralSpawn())
            utils.myPrint("waits for spawn")
            setHeroVar(bot, "JunglingState", JunglingStates.WaitForSpawn)
        else
            utils.myPrint("No creeps here :(") -- one of   dumb me, dumb teammates, blocked by enemy, farmed by enemy
            jungle_status.JungleCampClear(bot:GetTeam(), getHeroVar(bot, "currentCamp")[constants.VECTOR])
            utils.myPrint("finds camp")
            setHeroVar(bot, "JunglingState", JunglingStates.FindCamp)
        end
    else
        --print(utils.GetHeroName(bot), "KILLS")
        setHeroVar(bot, "JunglingState", JunglingStates.CleanCamp)
    end
end

local function WaitForSpawn(bot)
    if DotaTime() < getHeroVar(bot, "waituntil") then
        gHeroVar.HeroMoveToLocation(bot, getHeroVar(bot, "currentCamp")[constants.STACK_VECTOR]) -- TODO: use a vector that is closer to the camp
        return
    end
    setHeroVar(bot, "JunglingState", JunglingStates.MoveToCamp)
end

local function Stack(bot)
    if DotaTime() < getHeroVar(bot, "waituntil") then
        local stackLoc = getHeroVar(bot, "currentCamp")[constants.STACK_VECTOR]
        if GetUnitToLocationDistance(bot, stackLoc) > 15 then
            gHeroVar.HeroMoveToLocation(bot, stackLoc)
            return
        end
    end
    setHeroVar(bot, "JunglingState", JunglingStates.FindCamp)
end

local function CleanCamp(bot)
    -- TODO: make sure we have aggro when attempting to stack
    -- TODO: don't attack enemy creeps, unless they attack us / make sure we stay in jungle
    -- TODO: instead of stacking, could we just kill them and move ou of the camp?
    -- TODO: make sure we can actually kill the camp.

    local dtime = DotaTime() % 120
    local stacktime = getHeroVar(bot, "currentCamp")[constants.STACK_TIME]
    if dtime >= stacktime and dtime <= stacktime + 1 then
        setHeroVar(bot, "JunglingState", JunglingStates.Stack)
        --utils.myPrint("stacks")
        setHeroVar(bot, "waituntil", utils.NextNeutralSpawn())
        return
    end

    local neutrals = gHeroVar.GetNearbyEnemyCreep(bot, 900)
    if #neutrals == 0 then -- we did it
        local camp, _ = utils.NearestNeutralCamp(bot, jungle_status.GetJungle(bot:GetTeam())) -- we might not have killed the `currentCamp`
        -- we could have been killing lane creeps, don't mistaken for neutral
        if GetUnitToLocationDistance(bot, camp[constants.VECTOR]) <= 200 then
            jungle_status.JungleCampClear(bot:GetTeam(), camp[constants.VECTOR])
        end
        --utils.myPrint("finds camp")
        setHeroVar(bot, "JunglingState", JunglingStates.FindCamp)
    else
        bot.SelfRef:DoCleanCamp(bot, neutrals)
    end
end

----------------------------------

function FindCampsByMaxDifficulty(jungle, difficulty)
    local result = {}
    for i,camp in pairs(jungle) do
        if camp[constants.DIFFICULTY] <= difficulty then
            result[#result+1] = camp
        end
    end
    return result
end

----------------------------------

local States = {
    [JunglingStates.FindCamp]       = FindCamp,
    [JunglingStates.MoveToCamp]     = MoveToCamp,
    [JunglingStates.WaitForSpawn]   = WaitForSpawn,
    [JunglingStates.Stack]          = Stack,
    [JunglingStates.CleanCamp]      = CleanCamp
}

----------------------------------

function X:Think(bot)
    if utils.IsBusy(bot) then return end
    
    if bot.jungleReloaded then
        self:OnStart(bot.SelfRef)
    end

    States[getHeroVar(bot, "JunglingState")](bot)
end

function X:Desire(bot)
    if getHeroVar(bot, "Role") == constants.ROLE_JUNGLER then
        return BOT_MODE_DESIRE_VERYLOW
    end
    return BOT_MODE_DESIRE_NONE
end

return X
