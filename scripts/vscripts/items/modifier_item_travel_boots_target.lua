modifier_item_travel_boots_target_lua = class({
	OnDestroy = function(self)
		local ability = self:GetAbility()
		if ability.particleId ~= nil then
        	ParticleManager:DestroyParticle(ability.particleId, true)
			ability.particleId = nil
		end
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_item_travel_boots_caster_effect") then
			caster:Stop()
		end
        if IsServer() then
            caster:StopSound("Portal.Loop_Disappear")
            ability.teleportUnit:StopSound("Portal.Loop_Appear")
        end
	end
})
