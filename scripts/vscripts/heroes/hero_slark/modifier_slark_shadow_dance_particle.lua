modifier_slark_shadow_dance_particle_lua = class({
	OnCreated = function(self)
		if not IsServer() then return end
		self:StartIntervalThink(0.03)
	end,
	OnIntervalThink = function(self)
		self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin())
	end,
	OnDestroy = function(self)
		local caster = self:GetCaster()
		if caster.shadow_dance_pid ~= nil then
			ParticleManager:DestroyParticle(caster.shadow_dance_pid, false)
			caster.shadow_dance_pid = nil
		end
	end,
	CheckState = function() return {
		[ MODIFIER_STATE_ROOTED ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_UNSELECTABLE ] = true,
		[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
		[ MODIFIER_STATE_UNTARGETABLE ] = true
	} end
})
