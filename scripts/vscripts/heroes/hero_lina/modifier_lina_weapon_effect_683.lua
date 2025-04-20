modifier_lina_weapon_effect_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.style ~= nil and parent ~= nil then
			print("modifier_juggernaut_weapon_effect_683_lua creates with " .. data.style)
			if data.style == "deft" then
				self.particleId  = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_flame_hand_default.vpcf", PATTACH_POINT_FOLLOW, parent)
				self.particleId2 = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_flame_hand_default.vpcf", PATTACH_POINT_FOLLOW, parent)
			elseif data.style == "blue" then
				self.particleId  = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_flame_hand_blue.vpcf", PATTACH_POINT_FOLLOW, parent)
				self.particleId2 = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_flame_hand_blue.vpcf", PATTACH_POINT_FOLLOW, parent)
			end
			ParticleManager:SetParticleControlEnt(self.particleId , 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0, 0, 0), true)
			ParticleManager:SetParticleControlEnt(self.particleId2, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0, 0, 0), true)
		end
	end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	OnDestroy = function(self)
		if self.particleId ~= nil then
			ParticleManager:DestroyParticle(self.particleId, false)
		end
		if self.particleId2 ~= nil then
			ParticleManager:DestroyParticle(self.particleId2, false)
		end
	end,
	IsHidden = function() return true end
})
