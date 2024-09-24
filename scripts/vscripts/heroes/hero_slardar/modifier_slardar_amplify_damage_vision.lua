modifier_slardar_amplify_damage_vision_lua = class({
	IsHidden = function() return true end,
	IsPurgable = function() return true end,
	OnCreated = function(self) self:StartIntervalThink(0.1) end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		local vision_radius = parent:GetCurrentVisionRange()
		local ability = self:GetAbility()
		ability:CreateVisibilityNode(parent:GetAbsOrigin(), vision_radius, 0.1)
	end
})
