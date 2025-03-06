USER2COLOR = {
	Vector(52,  118, 255),
	Vector(103, 255, 192),
	Vector(192, 0,   192),
	Vector(243, 240, 12),
	Vector(255, 108, 0),
	Vector(254, 135, 195),
	Vector(162, 181, 72),
	Vector(102, 217, 247),
	Vector(0,   132, 34),
	Vector(165, 106, 0)
}

modifier_hero_custom_aura_effect_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.aura ~= nil and parent ~= nil then
			print("modifier_hero_custom_aura_effect_683_lua creates with " .. data.aura)
			local userid = data.userid
			if data.aura == 1 then
				self.particleId = ParticleManager:CreateParticle("particles/items_fx/aura_assault_p"..userid..".vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
			elseif data.aura == 2 then
				self.particleId = ParticleManager:CreateParticle("particles/items_fx/aura_endurance_custom.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
				ParticleManager:SetParticleControl(self.particleId, 15, USER2COLOR[userid])
			end
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
