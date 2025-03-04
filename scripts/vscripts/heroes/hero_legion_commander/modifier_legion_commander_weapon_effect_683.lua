modifier_legion_commander_weapon_effect_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.style ~= nil and parent ~= nil then
			print("modifier_juggernaut_weapon_effect_683_lua creates with " .. data.style)
			if data.style == "deft" then
				return
			elseif data.style == "whit" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_blade_white.vpcf", PATTACH_POINT_FOLLOW, parent)
			elseif data.style == "gold" then
				self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_blade_gold.vpcf", PATTACH_POINT_FOLLOW, parent)
			end
			ParticleManager:SetParticleControlEnt(self.particleId, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0, 0, 0), true)
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
