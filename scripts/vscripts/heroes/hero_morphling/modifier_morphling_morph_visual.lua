modifier_morphling_morph_visual_lua = class({
	IsHidden = function(self) return true end,
	OnCreated = function(self, data)
		if not IsServer() then return end
		self:StartIntervalThink(1)
	end,
	OnIntervalThink = function(self)
		local parent = self:GetParent()
		local pid = ParticleManager:CreateParticleForTeam(
				"particles/units/heroes/hero_morphling/morphling_replicate_overhead_timer.vpcf", 
				PATTACH_OVERHEAD_FOLLOW, 
				parent,
				parent:GetTeam())
		ParticleManager:SetParticleControl(pid, 1, Vector(0, math.floor(self:GetRemainingTime()), 0))
		ParticleManager:SetParticleControl(pid, 2, Vector(2, 0, 0))

		local caster = self:GetCaster()
		local pid = ParticleManager:CreateParticleForTeam(
				"particles/units/heroes/hero_morphling/morphling_replicate_overhead_timer.vpcf", 
				PATTACH_OVERHEAD_FOLLOW, 
				caster,
				caster:GetTeam())
		ParticleManager:SetParticleControl(pid, 1, Vector(0, math.floor(self:GetRemainingTime()), 0))
		ParticleManager:SetParticleControl(pid, 2, Vector(2, 0, 0))
	end
})
