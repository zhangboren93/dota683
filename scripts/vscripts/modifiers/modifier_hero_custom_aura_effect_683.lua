modifier_hero_custom_aura_effect_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.aura ~= nil and parent ~= nil then
			print("modifier_hero_custom_aura_effect_683_lua creates with " .. data.aura)
			local userid = data.userid
			self.particleId = ParticleManager:CreateParticle("particles/items_fx/aura_assault_p"..userid..".vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
			--ParticleManager:SetParticleControlEnt(self.particleId, 0, parent, PATTACH_POINT_FOLLOW, "attach_sword", Vector(0, 0, 0), true)
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
