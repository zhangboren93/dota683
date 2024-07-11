modifier_requiem_head_lua = class({
	OnCreated = function(self, data) 
		if not IsServer() then return end
		self.velocity = Vector(data.vx, data.vy, 0)
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
	end,
    UpdateHorizontalMotion = function(self, me, dt)
		if IsServer() then
			me:SetAbsOrigin(me:GetAbsOrigin() + self.velocity * dt)
		end
	end,
	CheckState = function() return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	} end,
	GetEffectName = function() return "particles/units/heroes/hero_nevermore/nevermore_requiem_head.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_VISUAL_Z_DELTA } end,
	GetVisualZDelta = function() return 200 end
})
