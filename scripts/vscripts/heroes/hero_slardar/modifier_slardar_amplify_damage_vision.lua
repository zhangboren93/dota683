modifier_slardar_amplify_damage_vision_lua = class({
	IsHidden = function() return true end,
	IsPurgable = function() return true end,
	OnCreated = function(self) self:StartIntervalThink(1) end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local vision_radius = 800
		if GameRules:IsDaytime() then
			vision_radius = 1800
		end
		self:GetAbility():CreateVisibilityNode(self:GetParent():GetAbsOrigin(), vision_radius, 1)
	end
})
