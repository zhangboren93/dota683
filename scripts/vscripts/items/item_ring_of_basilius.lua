item_ring_of_basilius_datadriven = class({
	GetAbilityTextureName = function(self)
		if self:GetLevel() <= 1 then
			return "item_ring_of_basilius_active"
		else
			return "item_ring_of_basilius_inactive"
		end
	end,
	OnSpellStart = function(self)
		local level = self:GetLevel()
		if level <= 1 then
			self:SetLevel(2)
		else
			self:SetLevel(1)
		end
	end,
	GetIntrinsicModifierName = function() return "modifier_item_ring_of_basilius_lua" end
})
