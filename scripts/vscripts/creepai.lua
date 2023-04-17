if modifier_creep_ai == nil then
    modifier_creep_ai = class({})
end

local AI_STATE_PATHING = 0
local AI_STATE_ATTACKING = 1
local AI_STATE_AGGRO_COOLDOWN = 2

local PRIORITY_SEIGE = 10
local PRIORITY_ATTACKING_HERO = 3
local PRIORITY_CREEP = 2
local PRIORITY_HERO = 1
local PRIORITY_NOT_CREEP = 0 -- building etc
local pathCornersMap = { }
pathCornersMap["gb"] = {
    --"lane_bot_pathcorner_goodguys_1",
	"lane_bot_pathcorner_goodguys_2",
	"lane_bot_pathcorner_goodguys_3",
	"lane_bot_pathcorner_goodguys_4",
	"lane_bot_pathcorner_goodguys_5",
	"lane_bot_pathcorner_goodguys_6",
	"lane_bot_pathcorner_goodguys_7"}
pathCornersMap["gm"] = {
    "lane_mid_pathcorner_goodguys_1",
    "lane_mid_pathcorner_goodguys_2",
    "lane_mid_pathcorner_goodguys_3",
    "lane_mid_pathcorner_goodguys_4",
    "lane_mid_pathcorner_goodguys_5",
    "lane_mid_pathcorner_goodguys_6",
    "lane_mid_pathcorner_goodguys_7",
    "lane_mid_pathcorner_goodguys_8",
    "lane_mid_pathcorner_goodguys_9"}
pathCornersMap["gt"] = {
    "lane_top_pathcorner_goodguys_1",
    "lane_top_pathcorner_goodguys_2",
    "lane_top_pathcorner_goodguys_3",
    "lane_top_pathcorner_goodguys_4",
    "lane_top_pathcorner_goodguys_5",
    "lane_top_pathcorner_goodguys_6",
    "lane_top_pathcorner_goodguys_7"}
pathCornersMap["bb"] = {
    "lane_bot_pathcorner_badguys_1",
    "lane_bot_pathcorner_badguys_2",
    "lane_bot_pathcorner_badguys_7",
    "lane_bot_pathcorner_badguys_5",
    "lane_bot_pathcorner_badguys_6",
    "lane_bot_pathcorner_badguys_3",
    "lane_bot_pathcorner_badguys_4"}
pathCornersMap["bm"] = {
    "lane_mid_pathcorner_badguys_1",
    "lane_mid_pathcorner_badguys_2",
    "lane_mid_pathcorner_badguys_3",
    "lane_mid_pathcorner_badguys_4",
    "lane_mid_pathcorner_badguys_5",
    "lane_mid_pathcorner_badguys_6",
    "lane_mid_pathcorner_badguys_7",
    "lane_mid_pathcorner_badguys_8"}
pathCornersMap["bt"] = {
    "lane_top_pathcorner_badguys_1",
    "lane_top_pathcorner_badguys_2",
    "lane_top_pathcorner_badguys_3",
    "lane_top_pathcorner_badguys_4",
    "lane_top_pathcorner_badguys_5",
    "lane_top_pathcorner_badguys_6"}

function modifier_creep_ai:OnCreated(kv)
    if IsServer() then
        self.kv = kv
        self.state = AI_STATE_PATHING
        self:StartIntervalThink(0.3) 
    end
end

function modifier_creep_ai:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_creep_ai:IsHidden()
    return true
end

function calculateDist(v)
    return math.sqrt(v[1] * v[1] + v[2] * v[2])
end

function modifier_creep_ai:OnIntervalThink()
    if self:GetParent():HasModifier("modifier_creep_aggroed_datadriven") then
        return
    end
    -- for all path corners go the closest one to the direction
    local entity = self:GetParent()
    local position = entity:GetAbsOrigin()
    if self.state == AI_STATE_PATHING then
        local target = self:selectTarget()
        if target ~= nil then
            --print("find target entering attacking state")
            self.state = AI_STATE_ATTACKING
            self.target = target
            entity:MoveToTargetToAttack(target.unit)
        else
           self:takePath()
        end
    elseif self.state == AI_STATE_ATTACKING then
        -- check if there is higher priority target 
        if self.target == nil then
            self.target = self:selectTarget()
            entity:MoveToTargetToAttack(self.target.unit)
            return
        end
        if not self.target.unit:IsAlive() 
            or not self.target.unit:CanEntityBeSeenByMyTeam(entity) 
            or self.target.unit:IsInvisible() then
            self.target = nil
            self.state = AI_STATE_PATHING
            self:OnIntervalThink()
            return
        end
        -- if current target is not within attack range, change target
        local distance = calculateDist(self.target.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin())
        --print(distance .. " " .. self.kv.attackrange)
        if (distance > self.kv.attackrange) then
            self.target = nil
            self.state = AI_STATE_PATHING
            self:OnIntervalThink()
            return
        end
        entity:MoveToTargetToAttack(self.target.unit)
    end
end

function modifier_creep_ai:takePath() 
    local entity = self:GetParent()
    local position = entity:GetAbsOrigin()
    local direction_right = entity:GetTeam() == DOTA_TEAM_GOODGUYS
    local pathCorners = pathCornersMap[self.kv.pathName]
    local nextPathPosition = Entities:FindByName(nil, pathCorners[#pathCorners]):GetAbsOrigin()
    for i=1,#pathCorners do
        local pathCorner = Entities:FindByName(nil, pathCorners[i]):GetAbsOrigin()
        local dx = pathCorner[1] - position[1]
        local dy = pathCorner[2] - position[2]
        if math.abs(dx) + math.abs(dy) > 100 then
            if direction_right then
                if dx + dy > 0 then
                    nextPathPosition = pathCorner
                    break;
                end
            else
                if dx + dy < 0 then
                    nextPathPosition = pathCorner
                    break;
                end
            end
        end
    end 
    entity:MoveToPosition(nextPathPosition)
end

function modifier_creep_ai:selectTarget()
    local entity = self:GetParent()
    local position = entity:GetAbsOrigin()
    --print(self.kv.seige)
    local units = FindUnitsInRadius(
        entity:GetTeam(), position, entity, self.kv.alertRadius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NO_INVIS,
        FIND_CLOSEST, false)
    if self.kv.seige > 0 then
        local buildings = {}
        for i=1,#units do
            if units[i]:IsBuilding() then
                table.insert(buildings, units[i])
            end
        end
        if #buildings > 0 then
            return {
                unit = buildings[1],
                priority = PRIORITY_SEIGE
            }
        end
    end
    local heroes = {}
    for i=1,#units do
        if units[i]:IsHero() then
            table.insert(heroes, units[i])
        end
    end
    local creepunits = {}
    -- by default attack creep unit first
    for i=1,#units do
        if units[i]:IsCreep() then
            table.insert(creepunits, units[i])
        end
    end
    if #creepunits > 0 then
        return {
            unit = creepunits[1],
            priority = PRIORITY_CREEP
        }
    end
    if #heroes > 0 then
        return {
            unit = heroes[1],
            priority = PRIORITY_HERO
        }
    end
    -- attack other units
    if #units > 0 then
        --print("Priority not creep")
        return {
            unit = units[1],
            priority = PRIORITY_NOT_CREEP
        }
    end
end