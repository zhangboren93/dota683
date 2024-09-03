modifier_ember_spirit_fire_remnant_add_location_lua = class({
	OnCreated = function(self, data) 
		if IsServer() then
			self.speed = data.speed
			self.target_location = GetGroundPosition(Vector(data.x, data.y, 0), nil)
			if self:ApplyHorizontalMotionController() == false then
				self:Destroy()
				return
			end
		end
	end,
	UpdateHorizontalMotion = function(self, me, dt)
		local loc = me:GetAbsOrigin()
		if (loc - self.target_location):Length2D() <= 50 then
			--me:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
			if me.fire_remnant_particle ~= nil then
				ParticleManager:DestroyParticle(me.fire_remnant_particle, false)
				me.fire_remnant_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_image_b.vpcf", PATTACH_WORLDORIGIN, me)
				ParticleManager:SetParticleControl(me.fire_remnant_particle, 0, me:GetAbsOrigin())
				ParticleManager:SetParticleControl(me.fire_remnant_particle, 1, -1 * me:GetForwardVector())
				ParticleManager:SetParticleControl(me.fire_remnant_particle, 2, Vector(RandomInt(8, 13), 0, 0))
			end
			self:Destroy()
			return
		end
		me:SetAbsOrigin(loc + (self.target_location - loc):Normalized() * self.speed * dt)
	end
})
