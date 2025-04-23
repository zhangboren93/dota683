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
modifier_spect_hero_aura_effect_lua = class({
	OnCreated = function(self, data)
		if not IsServer() then return end
		local userid = data.userid
		local parent = self:GetParent()
		self.particleId = ParticleManager:CreateParticleForTeam(
			"particles/items_fx/aura_shivas_custom.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent, DOTA_TEAM_CUSTOM_1)
		ParticleManager:SetParticleControl(self.particleId, 15, USER2COLOR[userid])
	end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	OnDestroy = function(self)
		if self.particleId ~= nil then
			ParticleManager:DestroyParticle(self.particleId, false)
		end
	end,
	IsHidden = function() return true end
})
