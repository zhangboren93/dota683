modifier_creep_preparing_lua = class({})

function modifier_creep_preparing_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE
	}
end

function modifier_creep_preparing_lua:OnDestroy()
	if self:GetParent() == nil then return end
	self:GetParent():RemoveNoDraw()
end

function modifier_creep_preparing_lua:GetBonusVisionPercentage()
	return -100
end

function modifier_creep_preparing_lua:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_ROOTED] = true
	}
end

