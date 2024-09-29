modifier_item_crimson_guard_extra_lua = class({
	OnCreated = function(self)
	end,
	OnDestroy = function(self)
		if self.particleId ~= nil then
			ParticleManager:DestroyParticle(self.particleId, false)
		end
	end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	} end,
	GetModifierPhysicalArmorBonus = function() return 2 end,
	GetModifierPhysical_ConstantBlock = function() return 50 end,
	IsPurgable = function() return true end
})
