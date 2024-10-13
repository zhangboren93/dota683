modifier_roshan_inherent_buff_688_lua = class({
	OnCreated = function(self)
		self:StartIntervalThink(1)
	end,
	OnIntervalThink = function(self)
		local time = GameRules:GetDOTATime(false, false)
		local stack_count = math.floor(time / 480)
		if self:GetStackCount() ~= stack_count then
			self:SetStackCount(stack_count)
		end
	end,
	DeclareFunctions = function()
		return {
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS 	
		}
	end,
	GetModifierPhysicalArmorBonus = function(self)
		return 1 + 0.2 * self:GetStackCount()
	end,
	IsHidden = function() return true end
})
