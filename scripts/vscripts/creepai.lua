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
		self:StartIntervalThink(0.5) 
	end
end

function modifier_creep_ai:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_creep_ai:IsHidden()
	return true
end

function isAttackable(target, attacker) 
	return IsValidEntity(target) and target:IsAlive() and target:CanEntityBeSeenByMyTeam(attacker) and not target:IsInvisible() and not target:IsAttackImmune()
end

function modifier_creep_ai:OnIntervalThink()
	local ret, error = pcall(function() self:OnIntervalThinkInternal() end)
	if not ret then
		self.target = nil
		self.alert_target = nil
		self.state = AI_STATE_PATHING
		print(error)
		GameRules:SendCustomMessage(error, -1, -1)
	end
end

function modifier_creep_ai:OnIntervalThinkInternal()
	local entity = self:GetParent()
	if entity:HasModifier("modifier_creep_aggroed_datadriven") then
		if self.target ~= nil and isAttackable(self.target.unit, entity) then
			return
		else
			entity:RemoveModifierByName("modifier_creep_aggroed_datadriven")
		end
	end
	if self.state == AI_STATE_PATHING then
		local target = self:selectTarget()
		-- TODO alert cooldown 2.1s
		if target == nil and self.alert_target ~= nil and isAttackable(self.alert_target, entity) then
			target = {
				unit = self.alert_target
			}
		end
		if target ~= nil then
			self.state = AI_STATE_ATTACKING
			self.target = target
			entity:MoveToTargetToAttack(target.unit)
		else	
			self:takePath()
		end
	elseif self.state == AI_STATE_ATTACKING then
		if self.target == nil
			or self.target.unit:HasModifier("modifier_creep_aggro_move_datadriven")
			or not isAttackable(self.target.unit, entity) then
			self.target = nil
			self.alert_target = nil
			self.state = AI_STATE_PATHING
			self:OnIntervalThink()
			return
		end
		local distance = (self.target.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length()
		if (distance > self.kv.attackrange) then
			self.target = nil
			self.state = AI_STATE_PATHING
			return
		end
		--entity:MoveToTargetToAttack(self.target.unit)
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
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_ALL, 
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
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
	-- target non aggro move heroes first
	if #heroes > 0 then
		for i=1,#heroes do
			if not heroes[i]:HasModifier("modifier_creep_aggro_move_datadriven") then
				return {
					unit = heroes[i],
					priority = PRIORITY_HERO
				}
			end
		end
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