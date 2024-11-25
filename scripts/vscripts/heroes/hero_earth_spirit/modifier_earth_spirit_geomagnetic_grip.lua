require("scripts/vscripts/heroes/hero_earth_spirit/geomagnetic_grip")
modifier_earth_spirit_geomagnetic_grip_lua = class({
	OnCreated = function(self)
		local caster = self:GetCaster()
		local parent = self:GetParent()
		if IsServer() then
			self.destination = (parent:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized() * 128 + caster:GetAbsOrigin()
			print("Destination is: ")
			print(self.destination)
			local speed = (caster:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized()
			if parent:IsHero() then
				self.speed = speed * 600
				self.speed_abs = 600
			else 
				self.speed = speed * 1000
				self.speed_abs = 1000
			end
			if not self:ApplyHorizontalMotionController() then
				self:Destroy()
				return
			end
		end
	end,
	UpdateHorizontalMotion = function(self, me, dt)
		if not IsServer() then return end
		if me:GetName() ~= "npc_dota_earth_spirit_stone" and not shouldApplyGripToUnit(me) then
			self:Destroy()
			return true
		end
		local dist = (self.destination - me:GetAbsOrigin()):Length2D()
		local move_dist = dt * self.speed_abs
		if move_dist > dist then
			self:Destroy()
			return true
		end
		me:SetAbsOrigin(me:GetAbsOrigin() + self.speed * dt)
	end,
	GetEffectName = function() return "particles/units/heroes/hero_earth_spirit/espirit_geomagneticgrip_orientedmagnetic.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end
})
