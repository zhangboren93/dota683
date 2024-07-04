modifier_spectre_haunt_fix_movespeed_lua = class({
	OnCreated = function(self) self:StartIntervalThink(0.1) end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		if parent:IsStunned() then
			parent:Purge(false, true, false, true, false)
		end
	end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE } end,
	GetModifierMoveSpeed_Absolute = function() return 400 end
})
