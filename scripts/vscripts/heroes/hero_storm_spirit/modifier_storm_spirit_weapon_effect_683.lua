modifier_storm_spirit_weapon_effect_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.style ~= nil and parent ~= nil then
			if data.style == "deft" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_head_ambient_default.vpcf", PATTACH_POINT_FOLLOW, parent)
			elseif data.style == "green" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_head_ambient_green.vpcf", PATTACH_POINT_FOLLOW, parent)
			elseif data.style == "red" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_head_ambient_red.vpcf", PATTACH_POINT_FOLLOW, parent)
			elseif data.style == "gold" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_head_ambient_gold.vpcf", PATTACH_POINT_FOLLOW, parent)
			end
			ParticleManager:SetParticleControlEnt(self.particleId, 0, parent, PATTACH_POINT_FOLLOW, "attach_hat", Vector(0, 0, 0), true)
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
