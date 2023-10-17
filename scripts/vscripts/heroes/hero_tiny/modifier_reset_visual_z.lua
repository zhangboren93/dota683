modifier_reset_visual_z = class({})

function modifier_reset_visual_z:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
end

function modifier_reset_visual_z:GetVisualZDelta()
	return 0
end

function modifier_reset_visual_z:IsHidden()
	return true
end
