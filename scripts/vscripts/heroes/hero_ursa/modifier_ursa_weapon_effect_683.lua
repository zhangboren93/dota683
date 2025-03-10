modifier_ursa_weapon_effect_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.style ~= nil and parent ~= nil then
			print("modifier_juggernaut_weapon_effect_683_lua creates with " .. data.style)
			if data.style == "deft" then
				return
			elseif data.style == "red" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_wendigo_arms_ambient_custom.vpcf", PATTACH_POINT_FOLLOW, parent)
				ParticleManager:SetParticleControl(self.particleId, 15, Vector(226, 42, 17))
			elseif data.style == "blue" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_wendigo_arms_ambient_custom.vpcf", PATTACH_POINT_FOLLOW, parent)
				ParticleManager:SetParticleControl(self.particleId, 15, Vector(39, 251, 255))
			end
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
