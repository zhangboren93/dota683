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
pathCornersMap["gbn"] = {
	"lane_bot_pathcorner_goodguys_2",
	"lane_bot_pathcorner_goodguys_11",
	"lane_bot_pathcorner_goodguys_5",
	"lane_bot_pathcorner_goodguys_12",
	"lane_bot_pathcorner_goodguys_7",
	"lane_bot_pathcorner_goodguys_3",
	"lane_bot_pathcorner_goodguys_4",
}
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
	"lane_top_pathcorner_goodguys_7",
	"lane_top_pathcorner_goodguys_8",
	"lane_top_pathcorner_goodguys_9"}
pathCornersMap["bb"] = {
	"lane_bot_pathcorner_badguys_1",
	"lane_bot_pathcorner_badguys_2",
	"lane_bot_pathcorner_badguys_3",
	"lane_bot_pathcorner_badguys_4",
	"lane_bot_pathcorner_badguys_5",
	"lane_bot_pathcorner_badguys_6",
	"lane_bot_pathcorner_badguys_7",
	"lane_bot_pathcorner_badguys_8",
	"lane_bot_pathcorner_badguys_9",
	"lane_bot_pathcorner_badguys_10"}
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
	"lane_top_pathcorner_badguys_6",
	"lane_top_pathcorner_badguys_7",
	"lane_top_pathcorner_badguys_8"}

function modifier_creep_ai:OnCreated(kv)
	if IsServer() then
		self.kv = kv
		local currentTime = GameRules:GetDOTATime(true, true)
		self.nextTargetSelectTime = currentTime
		self.nextTakePathTime = currentTime
		self:StartIntervalThink(0.2)
		self:GetParent():SetThink(function()
			self:OnIntervalThink()
		end, "creep ai think immediate", 0.1)
	end
end

function modifier_creep_ai:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_creep_ai:IsHidden()
	return true
end

function isAttackable(target, attacker) 
	return (IsValidEntity(target) 
		and target:IsAlive() 
		and attacker:CanEntityBeSeenByMyTeam(target) 
		and not target:IsInvisible() 
		and not target:IsAttackImmune() 
		and not target:HasModifier("modifier_bane_nightmare") 
		and not target:IsInvulnerable()
		and target:GetTeam() ~= attacker:GetTeam())
end

function modifier_creep_ai:OnIntervalThink()
	local ret, error = pcall(function() self:OnIntervalThinkInternal() end)
	if not ret then
		self.target = nil
		self.alert_target = nil
		print(error)
		GameRules:SendCustomMessage(error, -1, -1)
	end
end

function modifier_creep_ai:OnIntervalThinkInternal()
	if not IsServer() then
		return
	end
	--print("OnIntervalThinkInternal " .. GameRules:GetDOTATime(false, false) .. " " ..self:GetParent():GetEntityIndex())
	local entity = self:GetParent()
	if entity:IsDominated() then
		self:Destroy()
	end
	if entity:HasModifier("modifier_creep_preparing_lua") then
		return
	end
	if entity:HasModifier("modifier_creep_aggroed_datadriven") then
		if self.target ~= nil and isAttackable(self.target.unit, entity) then
			return
		else
			entity:RemoveModifierByName("modifier_creep_aggroed_datadriven")
		end
	end

	-- Attack units within attack range, not building
	if self.target ~= nil 
		and IsValidEntity(self.target.unit) 
		and not self.target.unit:HasModifier("modifier_creep_aggro_move_datadriven") 
		and isAttackable(self.target.unit, entity) 
		and not self.target.unit:IsBuilding() then
		local distance = (self.target.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length()
		if distance <= self.kv.attackrange then
			if not entity:IsAttackingEntity(self.target.unit) then
				entity:MoveToTargetToAttack(self.target.unit)
			end
			return
		end
	end

	local currentTime = GameRules:GetDOTATime(true, true)

	if self.nextTargetSelectTime < currentTime then
		self.nextTargetSelectTime = currentTime + 1
		local target = self:selectTarget()
		if target ~= nil and (self.target ~= nil and self.target.unit == target.unit) then
			self.target = target
			self.target.last_loc = target.unit:GetAbsOrigin()
			self.target.last_loc_time = currentTime
			--	print("move to target attack")
			entity:MoveToTargetToAttack(self.target.unit)
			--DebugDrawLine(entity:GetAbsOrigin(), self.target.unit:GetAbsOrigin(), 0, 0, 255, false, 1) 
			return
		end
	end

	if self.target ~= nil and not IsValidEntity(self.target.unit) then
		self.target = nil
	end

	local targetCanBeSeen = false
	if self.target ~= nil then 
		targetCanBeSeen = entity:CanEntityBeSeenByMyTeam(self.target.unit)
	end
	if self.target == nil or not isAttackable(self.target.unit, entity) then
		if entity:IsAttacking() then
			self.target = {
				unit = entity:GetAttackTarget(),
				last_loc = entity:GetAttackTarget():GetAbsOrigin(),
				last_loc_time = currentTime
			}
		else
			-- move to target location if lose vision
			if self.target ~= nil and not targetCanBeSeen 
				and self.target.last_loc ~= nil 
				and (entity:GetAbsOrigin() - self.target.last_loc):Length() > 100 then
				entity:MoveToPosition(self.target.last_loc)
				--DebugDrawLine(entity:GetAbsOrigin(), self.target.last_loc, 255, 0, 0, false, 0.2)
			else
				if self.target ~= nil then
					self.target.last_loc = nil
					self.target.last_loc_time = nil
				end
				self:takePath(currentTime)
			end
		end
		return
	end

	if targetCanBeSeen then
		self.target.last_loc = self.target.unit:GetAbsOrigin()
		self.target.last_loc_time = currentTime
	end

	-- attack the alert target
	if self.alert_target ~= nil and self.alert_target ~= self.target.unit and isAttackable(self.alert_target, entity) then
		-- if alert target is higher priority than current target
		local alert_target_prio = 0
		if self.alert_target:IsHero() then
			alert_target_prio = 1
		elseif self.alert_target:IsCreep() then
			alert_target_prio = 2
		end
		local current_target_prio = 0
		if self.target.unit:IsHero() then
			current_target_prio = 1
		elseif self.target.unit:IsCreep() then
			current_target_prio = 2
		end
		
		if alert_target_prio > current_target_prio then
			self.target = {
				unit = self.alert_target,
				last_loc = self.alert_target:GetAbsOrigin(),
				last_loc_time = currentTime
			}
			entity:MoveToTargetToAttack(self.target.unit)
			--DebugDrawLine(entity:GetAbsOrigin(), self.target.last_loc, 255, 255, 0, false, 2)
			return
		end
	end

	if not isAttackable(self.target.unit, entity) then
		self:takePath(currentTime)
	end
end

function modifier_creep_ai:takePath(currentTime) 
	if self.kv.pathName == nil then
		return
	end
	--print("takePath " .. self.kv.pathName .. " pathCorners ")
	
	-- takePath throttle 1 per second
	if currentTime < self.nextTargetSelectTime then
		return
	end
	self.nextTakePathTime = currentTime + 1
	
	local entity = self:GetParent()
	local position = entity:GetAbsOrigin()
	local direction_right = entity:GetTeam() == DOTA_TEAM_GOODGUYS
	local pathCorners = pathCornersMap[self.kv.pathName]
	local nextPathPosition = Entities:FindByName(nil, pathCorners[#pathCorners]):GetAbsOrigin()
	for i=1,#pathCorners do
		local pathCorner = Entities:FindByName(nil, pathCorners[i]):GetAbsOrigin()
		local dx = pathCorner[1] - position[1]
		local dy = pathCorner[2] - position[2]
		if math.abs(dx) + math.abs(dy) > 800 then
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
--	-- Move in direction aggressively (considering 1s think interval)
--	if (position - nextPathPosition):Length2D() < 500 then
--		nextPathPosition = (nextPathPosition - position):Normalized() * 500 + position
--	end
	entity:MoveToPositionAggressive(nextPathPosition)
	--DebugDrawLine(entity:GetAbsOrigin(), nextPathPosition, 0, 255, 0, false, 1)
end

function modifier_creep_ai:selectTarget()
	local entity = self:GetParent()
	local position = entity:GetAbsOrigin()
	local units = {}
	if self.kv.seige > 0 then
		units = FindUnitsInRadius(
			entity:GetTeam(), position, entity, self.kv.attackrange, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_ALL, 
			DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST, false)
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

	units = self:findUnitsInRadiusFiltered(
		entity, position, self.kv.attackrange, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
	for i=1,#units do
		if units[i]:IsAttackingEntity(entity) then
		--	print("Find unit attacking me")
			return {
				unit = units[i]
			}
		end
	end
	for i=1,#units do
		local attackTarget = units[i]:GetAttackTarget()
		if attackTarget ~= nil and attackTarget:GetTeam() == entity:GetTeam() then
			--don't attack hero who has just used orb cast on allies
			if not units[i]:HasModifier("modifier_no_creep_aggro_on_cast_orb_lua") then
				return {
					unit = units[i]
				}
			end
		end
	end
	if #units > 0 then
		return { unit = units[1] }
	end

	units = self:findUnitsInRadiusFiltered(
		entity, position, self.kv.alertRadius, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
	if #units > 0 then
		for i=1,#units do
			-- find unit not transferring aggro and not techies' mine
			if not units[i]:HasModifier("modifier_creep_aggro_move_datadriven") then
	--			print("find unit not transferring aggro")
				return {
					unit = units[i],
				}
			end
		end
		--print("find unit transferring aggro")
		return {
			unit = units[1],
		}
	end

	if self.alert_target ~= nil and isAttackable(self.alert_target, entity) then
	--	print("find alert unit")
		return {
			unit = self.alert_target
		}
	end

	if self.target ~= nil and isAttackable(self.target.unit, entity) then
	--	print("find current target")
		return {
			unit = self.target.unit
		}
	end
	return nil
end

function modifier_creep_ai:findUnitsInRadiusFiltered(entity, position, range, target_type)
	local units_unfiltered = FindUnitsInRadius(
		entity:GetTeam(), position, nil, range, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		target_type, 
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST, false)
	-- remove techies mine
	local units = {}
	for i=1,#units_unfiltered do
		-- find unit not transferring aggro and not techies' mine
	--	print(units_unfiltered[i]:GetName())
	--	print(not units_unfiltered[i]:HasModifier("modifier_bane_nightmare")) 
		if units_unfiltered[i]:GetName() ~= "npc_dota_techies_mines" and not units_unfiltered[i]:HasModifier("modifier_bane_nightmare") then
			table.insert(units, units_unfiltered[i])
		end
	end
	return units
end

function modifier_creep_ai:OnAggroEnded()
	print("OnAggroEnded")
	-- attack the alert target
	local currentTime = GameRules:GetDOTATime(true, true)
	local entity = self:GetParent()
	if self.alert_target ~= nil and isAttackable(self.alert_target, entity) then
		self.target = {
			unit = self.alert_target,
			last_loc = self.alert_target:GetAbsOrigin(),
			last_loc_time = currentTime
		}
		entity:MoveToTargetToAttack(self.target.unit)
		--DebugDrawLine(entity:GetAbsOrigin(), self.target.last_loc, 255, 255, 0, false, 2)
		return
	end
	-- find target
	local target = self:selectTarget()
	if target ~= nil then
		self.target = target
		self.target.last_loc = target.unit:GetAbsOrigin()
		self.target.last_loc_time = currentTime
		entity:MoveToTargetToAttack(self.target.unit)
		return
	end
	-- take path
	self:takePath(currentTime)
end

function modifier_creep_ai:OnHandleAlertTarget(target)
	self.alert_target = target
	if self.target == nil or not isAttackable(self.target.unit, self:GetParent()) then 
		self.target = {
			unit = target,
			last_loc = target:GetAbsOrigin(),
			last_loc_time = GameRules:GetDOTATime(true, true)
		}
		self:GetParent():MoveToTargetToAttack(target)
	end
end
