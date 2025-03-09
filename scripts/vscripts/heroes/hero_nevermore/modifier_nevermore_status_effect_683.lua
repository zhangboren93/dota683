modifier_nevermore_status_effect_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.style ~= nil and parent ~= nil then
			print("modifier_sf_weapon_effect_683_lua creates with " .. data.style)
			if data.style == "deft" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_trail_default.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
			elseif data.style == "whit" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_trail_custom.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
				ParticleManager:SetParticleControl(self.particleId, 15, Vector(255, 255, 255))
				ParticleManager:SetParticleControl(self.particleId, 16, Vector(1, 0, 0))
			end
			--ParticleManager:SetParticleControlEnt(self.particleId, 0, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		end
	end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	OnDestroy = function(self)
		if self.particleId ~= nil then
			ParticleManager:DestroyParticle(self.particleId, false)
		end
	end,
	IsHidden = function() return true end
})
