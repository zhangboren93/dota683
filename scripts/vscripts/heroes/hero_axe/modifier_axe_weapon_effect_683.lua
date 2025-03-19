modifier_axe_weapon_effect_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.style ~= nil and parent ~= nil then
			print("modifier_juggernaut_weapon_effect_683_lua creates with " .. data.style)
			if data.style == "deft" then
				return
			elseif data.style == "red" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_weapon_ambient_orange.vpcf", PATTACH_POINT_FOLLOW, parent)
				ParticleManager:SetParticleControl(self.particleId, 15, Vector(254, 0, 0))
				ParticleManager:SetParticleControl(self.particleId, 16, Vector(1, 0, 0))
			elseif data.style == "orange" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_weapon_ambient_orange.vpcf", PATTACH_POINT_FOLLOW, parent)
			end
			ParticleManager:SetParticleControlEnt(self.particleId, 0, parent, PATTACH_POINT_FOLLOW, "attach_weapon", Vector(0, 0, 0), true)
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
