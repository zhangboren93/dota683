modifier_antimage_weapon_effect_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.style ~= nil and parent ~= nil then
			print("modifier_antimage_weapon_effect_683_lua creates with " .. data.style)
			if data.style == "deft" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blade_default.vpcf", PATTACH_POINT_FOLLOW, parent)
			elseif data.style == "prpl" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blade_purple.vpcf", PATTACH_POINT_FOLLOW, parent)
			elseif data.style == "gold" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blade_default_gold.vpcf", PATTACH_POINT_FOLLOW, parent)
			end
			ParticleManager:SetParticleControlEnt(self.particleId, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0, 0, 0), true)
			ParticleManager:SetParticleControlEnt(self.particleId, 1, parent, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0, 0, 0), true)
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
