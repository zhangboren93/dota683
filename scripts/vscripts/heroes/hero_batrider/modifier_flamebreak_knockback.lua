modifier_flamebreak_knockback_lua = class({})

function modifier_flamebreak_knockback_lua:OnCreated()
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
		local target = self:GetParent()
		local caster = self:GetCaster()
		local knockback_duration = 0.25 - (target:GetAbsOrigin() - caster.flamebreak_position):Length2D() / 1000
		if knockback_duration > 0 then
			target:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", { duration = knockback_duration })
		end
	end
end

function modifier_flamebreak_knockback_lua:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local flamebreak_position = self:GetCaster().flamebreak_position
		if (me:GetAbsOrigin() - flamebreak_position):Length() > 400 then
			self:Destroy()
			return
		end
		me:SetAbsOrigin(me:GetAbsOrigin() + (me:GetAbsOrigin() - flamebreak_position):Normalized() * 1000 * dt)
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
