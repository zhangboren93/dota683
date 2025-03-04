local function renderParticles(self, parent)
	if self.style == "deft" then
		self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_default.vpcf", PATTACH_POINT_FOLLOW, parent)
		self.particleId2 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_default.vpcf", PATTACH_POINT_FOLLOW, parent)
		self.particleId3 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_blade_default.vpcf", PATTACH_POINT_FOLLOW, parent)
		self.particleId4 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_blade_2_default.vpcf", PATTACH_POINT_FOLLOW, parent)
	elseif self.style == "red" then
		self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_default.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.particleId, 15, Vector(139, 0, 0))
		ParticleManager:SetParticleControl(self.particleId, 16, Vector(1, 0, 0))
		self.particleId2 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_default.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.particleId2, 15, Vector(139, 0, 0))
		ParticleManager:SetParticleControl(self.particleId2, 16, Vector(1, 0, 0))
		self.particleId3 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_blade_default.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.particleId3, 15, Vector(139, 0, 0))
		ParticleManager:SetParticleControl(self.particleId3, 16, Vector(1, 0, 0))
		self.particleId4 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_blade_2_default.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.particleId4, 15, Vector(139, 0, 0))
		ParticleManager:SetParticleControl(self.particleId4, 16, Vector(1, 0, 0))
	elseif self.style == "whit" then
		self.particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_default.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.particleId, 15, Vector(255, 255, 255))
		ParticleManager:SetParticleControl(self.particleId, 16, Vector(1, 0, 0))
		self.particleId2 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_default.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.particleId2, 15, Vector(255, 255, 255))
		ParticleManager:SetParticleControl(self.particleId2, 16, Vector(1, 0, 0))
		self.particleId3 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_blade_default.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.particleId3, 15, Vector(255, 255, 255))
		ParticleManager:SetParticleControl(self.particleId3, 16, Vector(1, 0, 0))
		self.particleId4 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_blade_2_default.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.particleId4, 15, Vector(255, 255, 255))
		ParticleManager:SetParticleControl(self.particleId4, 16, Vector(1, 0, 0))
	end
	ParticleManager:SetParticleControlEnt(self.particleId, 0, parent, PATTACH_POINT_FOLLOW, "attach_weapon_l", Vector(0, 0, 0), true)
	ParticleManager:SetParticleControlEnt(self.particleId2, 0, parent, PATTACH_POINT_FOLLOW, "attach_weapon_r", Vector(0, 0, 0), true)
	ParticleManager:SetParticleControlEnt(self.particleId3, 0, parent, PATTACH_POINT_FOLLOW, "attach_weapon_l", Vector(0, 0, 0), true)
	ParticleManager:SetParticleControlEnt(self.particleId4, 0, parent, PATTACH_POINT_FOLLOW, "attach_weapon_r", Vector(0, 0, 0), true)
end
modifier_terrorblade_weapon_effect_683_lua = class({
	OnCreated = function(self, data)
		local parent = self:GetParent()
		if data.style ~= nil and parent ~= nil then
			print("modifier_juggernaut_weapon_effect_683_lua creates with " .. data.style)
			self.style = data.style
			if not parent:HasModifier("modifier_metamorphosis_datadriven") then
				renderParticles(self, parent)
			end
			self:StartIntervalThink(1)
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
		if self.particleId3 ~= nil then
			ParticleManager:DestroyParticle(self.particleId3, false)
		end
		if self.particleId4 ~= nil then
			ParticleManager:DestroyParticle(self.particleId4, false)
		end
	end,
	IsHidden = function() return true end,
	OnIntervalThink = function(self)
		local parent = self:GetParent()
		if parent == nil then return end
		if parent:HasModifier("modifier_metamorphosis_datadriven") then
			if self.particleId ~= nil then
				ParticleManager:DestroyParticle(self.particleId, false)
				ParticleManager:DestroyParticle(self.particleId2, false)
				ParticleManager:DestroyParticle(self.particleId3, false)
				ParticleManager:DestroyParticle(self.particleId4, false)
				self.particleId = nil
				self.particleId2 = nil
				self.particleId3 = nil
				self.particleId4 = nil
			end
		else
			if self.particleId == nil then
				renderParticles(self, parent)
			end
		end
	end
})
