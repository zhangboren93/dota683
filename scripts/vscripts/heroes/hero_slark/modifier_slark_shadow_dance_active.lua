modifier_slark_shadow_dance_active_lua = class({
	CheckState = function() return {
		[ MODIFIER_STATE_INVISIBLE ] = true,
		[ MODIFIER_STATE_UNTARGETABLE ] = true
	} end,
	OnDestroy = function(self)
		local parent = self:GetParent()
		if parent == nil then return end
		if parent.shadow_dance_pid ~= nil then
			ParticleManager:DestroyParticle(parent.shadow_dance_pid, false)
			parent.shadow_dance_pid = nil
		end
	end,
	GetPriority = function() return MODIFIER_PRIORITY_SUPER_ULTRA end
})
