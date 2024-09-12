modifier_enigma_black_hole_pull_lua = class({
	OnCreated = function(self, data) 
		if not IsServer() then return end
		self.centerx = data.centerx
		self.centery = data.centery
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
	end,
	UpdateHorizontalMotion = function(self, me, dt)
		local caster = self:GetCaster()
		if not caster:IsChanneling() then 
			self:Destroy() 
			return 
		end
		local distance = (GetGroundPosition(Vector(self.centerx, self.centery, 0), nil) - me:GetAbsOrigin())
		if distance:Length2D() > 180 then
			me:SetAbsOrigin(me:GetAbsOrigin() + distance:Normalized() * 40 * dt)
		end
	end,
	OnDestroy = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		FindClearSpaceForUnit(parent, parent:GetAbsOrigin(), false)
		parent:RemoveModifierByNameAndCaster("modifier_stunned", self:GetCaster())
	end,
	IsHidden = function() return true end
})
