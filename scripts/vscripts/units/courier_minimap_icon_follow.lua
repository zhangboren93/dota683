modifier_courier_minimap_icon_follow_lua = class({
	OnCreated = function(self) self:StartIntervalThink(1) end,
	OnIntervalThink = function(self) 
		if not IsServer() then return end
		self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin())
	end,
	CheckState = function(self)
		local caster_alive = self:GetCaster():IsAlive()
		local local_player = Entities:GetLocalPlayer()
		local local_player_own = false
		if local_player ~= nil then
			local_player_own = self:GetCaster():GetOwnerEntity() == local_player:GetAssignedHero()
		end
		return {
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = not caster_alive or local_player_own
		}
	end
})
