modifier_kunkka_weapon_effect_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.style ~= nil and parent ~= nil then
			print("modifier_juggernaut_weapon_effect_683_lua creates with " .. data.style)
			if data.style == "deft" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_weapon_glow_ambient_default.vpcf", PATTACH_POINT_FOLLOW, parent)
			elseif data.style == "green" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_weapon_glow_ambient_green.vpcf", PATTACH_POINT_FOLLOW, parent)
			elseif data.style == "prpl" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_weapon_glow_ambient_purple.vpcf", PATTACH_POINT_FOLLOW, parent)
			elseif data.style == "gold" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_weapon_glow_ambient_gold.vpcf", PATTACH_POINT_FOLLOW, parent)
			end
			ParticleManager:SetParticleControlEnt(self.particleId, 2, parent, PATTACH_POINT_FOLLOW, "attach_sword", Vector(0, 0, 0), true)
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
