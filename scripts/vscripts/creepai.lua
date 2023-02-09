if modifier_creep_ai == nil then
    modifier_creep_ai = class({})
end

local AI_STATE_PATHING = 0

function modifier_creep_ai:OnCreated(kv)
    if IsServer() then
        self.kv = kv
        self.state = AI_STATE_PATHING
        self:StartIntervalThink(0.5) 
    end
end

function modifier_creep_ai:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_creep_ai:IsHidden()
    return true
end

function modifier_creep_ai:OnIntervalThink()
    -- for all path corners go the closest one to the direction
    local entity = self:GetParent()
    local direction_right = entity:GetTeam() == DOTA_TEAM_GOODGUYS
    local position = entity:GetAbsOrigin()
    local nextPathPosition = nil
	local pathCorners = {
		"lane_bot_pathcorner_goodguys_1",
		"lane_bot_pathcorner_goodguys_2",
		"lane_bot_pathcorner_goodguys_3",
		"lane_bot_pathcorner_goodguys_4",
		"lane_bot_pathcorner_goodguys_5",
		"lane_bot_pathcorner_goodguys_6",
		"lane_bot_pathcorner_goodguys_7"
	}
    for i=1,#pathCorners do
        local pathCorner = Entities:FindByName(nil, pathCorners[i]):GetAbsOrigin()
        local dx = pathCorner[1] - position[1]
        local dy = pathCorner[2] - position[2]
        if math.abs(dx) + math.abs(dy) > 50 then
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
    if nextPathPosition then
        entity:MoveToPosition(nextPathPosition)
    end
end