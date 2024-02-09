modifier_supernova_sun_form_caster_datadriven = class({})

function modifier_supernova_sun_form_caster_datadriven:OnCreated()
	if not IsServer() then return end
	local parent = self:GetParent()
	parent:AddNoDraw()
end

function modifier_supernova_sun_form_caster_datadriven:OnDestroy()
	if not IsServer() then return end
	local parent = self:GetParent()
	parent:RemoveNoDraw()
end

function modifier_supernova_sun_form_caster_datadriven:CheckState()
	return {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end
