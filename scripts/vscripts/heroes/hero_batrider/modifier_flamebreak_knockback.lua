modifier_flamebreak_knockback_lua = class({})

function modifier_flamebreak_knockback_lua:OnCreated(data)
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
		local target = self:GetParent()
		local caster = self:GetCaster()
		self.flamebreakx = data.flamebreakx
		self.flamebreaky = data.flamebreaky
		local knockback_duration = 0.25 - (target:GetAbsOrigin() - Vector(self.flamebreakx, self.flamebreaky, 0)):Length2D() / 1000
		if knockback_duration > 0 then
			target:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", { duration = knockback_duration })
		end
	end
end

function modifier_flamebreak_knockback_lua:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local flamebreak_position = Vector(self.flamebreakx, self.flamebreaky, 0)
		if (me:GetAbsOrigin() - flamebreak_position):Length2D() > 400 then
			self:Destroy()
			return
		end
		me:SetAbsOrigin(me:GetAbsOrigin() + (me:GetAbsOrigin() - GetGroundPosition(flamebreak_position, me)):Normalized() * 1000 * dt)
	end
end

function modifier_flamebreak_knockback_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}
	return funcs
end

function modifier_flamebreak_knockback_lua:GetVisualZDelta()
	return 100
end

function modifier_flamebreak_knockback_lua:IsHidden()
	return true
end
