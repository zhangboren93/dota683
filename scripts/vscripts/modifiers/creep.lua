if modifier_creep_safe_lane_move_speed_bonus == nil then
    modifier_creep_safe_lane_move_speed_bonus = class({})
end

function modifier_creep_safe_lane_move_speed_bonus:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_creep_safe_lane_move_speed_bonus:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_creep_safe_lane_move_speed_bonus:IsHidden()
    return false
end

function modifier_creep_safe_lane_move_speed_bonus:GetModifierMoveSpeedBonus_Constant()
    return 70
end

function modifier_creep_safe_lane_move_speed_bonus:OnCreated()
	local game_time = GameRules:GetDOTATime(false, false)
	-- watch for axe cutting creep in first 5 minutes
	self.hero_near = false
	if game_time < 290 and IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_creep_safe_lane_move_speed_bonus:OnIntervalThink()
	if not IsServer() then return end
	local parent = self:GetParent()
	local team = parent:GetTeam()
	local loc = parent:GetAbsOrigin()
	--Remove this modifier if there are creeps nearby
	if #FindUnitsInRadius(team, 
			parent:GetAbsOrigin(), nil,
			500,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_CREEP, 0, 0, false) > 0 then
		print("Meeting enemy creeps, removing me")
		self:Destroy()
		return
	end
	-- if pass tier 1 tower, also return
	if team == DOTA_TEAM_GOODGUYS and loc.x > 3700 then
		return
	elseif team == DOTA_TEAM_BADGUYS and loc.x < -3500 then
		return
	end
	
	
	local heroes = FindUnitsInRadius(team,
			parent:GetAbsOrigin(), nil,
			500,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO, 0, 0, false)
	if #heroes == 0 then
		return
	end
	local target_positions = nil
	if team == DOTA_TEAM_BADGUYS then
		target_position = Vector(-5034, 5979, 384)
	else
		target_position = Vector(5187, -5976, 384)
	end

	local lane_creep_name = parent:GetUnitName()
		
	local new_lane_creep = CreateUnitByName(parent:GetUnitName(), parent:GetAbsOrigin(), false, nil, nil, parent:GetTeam())
	new_lane_creep:AddNewModifier(new_lane_creep, nil, "modifier_creep_move_after_reach_t1_lua", {})
	-- Copy the relevant stats over to the creep
	-- TODO set creep facing target
	new_lane_creep:SetBaseMaxHealth(parent:GetMaxHealth())
	new_lane_creep:SetHealth(parent:GetHealth())
	new_lane_creep:SetBaseDamageMin(parent:GetBaseDamageMin())
	new_lane_creep:SetBaseDamageMax(parent:GetBaseDamageMax())
	new_lane_creep:SetMinimumGoldBounty(parent:GetGoldBounty())
	new_lane_creep:SetMaximumGoldBounty(parent:GetGoldBounty())			
	new_lane_creep:SetForwardVector((target_position - parent:GetAbsOrigin()):Normalized())
	new_lane_creep:MoveToPositionAggressive(target_position)
	self:Destroy()
	parent:AddNoDraw()
	parent:ForceKill(false)
end
