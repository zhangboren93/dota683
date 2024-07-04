modifier_shredder_chakram_move_lua = class({
	OnCreated = function(self, data)
		if not IsServer() then return end
		self.velocity = Vector(data.vx, data.vy, 0) 
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
	end,
	UpdateHorizontalMotion = function(self, me, dt) 
		if not IsServer() then return end
		me:SetAbsOrigin(GetGroundPosition(me:GetAbsOrigin() + self.velocity * dt, nil))
	end,
	OnDestroy = function(self)
		if not IsServer() then return end
		local ability = self:GetAbility()
		if ability.chakram_projectile ~= nil then
			ability.chakram_projectile = nil
		end
	end
})

