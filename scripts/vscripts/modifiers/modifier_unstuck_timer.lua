modifier_unstuck_timer_lua = class({})

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

function modifier_unstuck_timer_lua:OnDestroy()
	if not IsServer() then return end
	local parent = self:GetParent()
	if parent:GetTeam() == DOTA_TEAM_GOODGUYS then
		FindClearSpaceForUnit(parent, Vector(-7093, -6542), false)
	else
		FindClearSpaceForUnit(parent, Vector(7015, 6534), false)
	end
end
