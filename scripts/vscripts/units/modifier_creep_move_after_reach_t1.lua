RADIANT_T1_LOC 	= Vector(5187, -5976, 384)
DIRE_T1_LOC 	= Vector(-5034, 5979, 384)
RADIANT_T3_LOC 	= Vector(-6627, -3683, 384)
DIRE_T3_LOC 	= Vector(6271, 3295, 384)
modifier_creep_move_after_reach_t1_lua = class({
	OnCreated = function(self)
		self:StartIntervalThink(1)
	end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		local team = parent:GetTeam()
		local loc = parent:GetAbsOrigin()
		--If not attacking move pathing, 
		if not parent:IsAttacking() and not parent:IsMoving() then
			print("Not moving or attacking, taking path")
			if parent:GetTeam() == DOTA_TEAM_GOODGUYS then
			--If has reached t1 towmer, move to enemy t3
				if loc.x < 5100 then
					parent:MoveToPositionAggressive(RADIANT_T1_LOC)
				else
					parent:MoveToPositionAggressive(DIRE_T3_LOC)
				end
			else
				if loc.x > -5000 then
					parent:MoveToPositionAggressive(DIRE_T1_LOC)
				else
					parent:MoveToPositionAggressive(RADIANT_T3_LOC)
				end
			end
		end
	end
})
