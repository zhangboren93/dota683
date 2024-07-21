modifier_unstuck_timer_lua = class({})

function modifier_unstuck_timer_lua:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_unstuck_timer_lua:OnIntervalThink()
	local time = self:GetCreationTime()
	local time_passed = GameRules:GetGameTime() - time
	print("time_passed " .. time_passed)
	if time_passed >= 60 and IsServer() then
		local parent = self:GetParent()
		if parent:GetTeam() == DOTA_TEAM_GOODGUYS then
			FindClearSpaceForUnit(parent, Vector(-7093, -6542), false)
		else
			FindClearSpaceForUnit(parent, Vector(7015, 6534), false)
		end
	end
end

function modifier_unstuck_timer_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_TAKEDAMAGE 
	}
end

function modifier_unstuck_timer_lua:OnOrder(event)
	self:Destroy()
end

function modifier_unstuck_timer_lua:OnTakeDamage(event)
	if event.unit == self:GetParent() then
		self:Destroy()
	end
end
