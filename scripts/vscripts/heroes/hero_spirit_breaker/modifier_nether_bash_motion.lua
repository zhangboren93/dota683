modifier_nether_bash_motion_lua = class({})
function modifier_nether_bash_motion_lua:IsHidden()
	return true
end

function modifier_nether_bash_motion_lua:OnCreated(data)
	if IsServer() then
		self.directx = data.directx
		self.directy = data.directy
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
	end
end

function modifier_nether_bash_motion_lua:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local ability = self:GetAbility()
		local speed = ability:GetSpecialValueFor("knockback_distance") * 2
		me:SetAbsOrigin(me:GetAbsOrigin() + Vector(self.directx, self.directy, 0) * speed * dt)
	end
end

function modifier_nether_bash_motion_lua:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		parent:RemoveHorizontalMotionController(self)
		parent:RemoveVerticalMotionController(self)
	end
end

function modifier_nether_bash_motion_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
	return funcs
end

function modifier_nether_bash_motion_lua:GetVisualZDelta()
	return 50
end

function modifier_nether_bash_motion_lua:GetEffectName()
	return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
end
