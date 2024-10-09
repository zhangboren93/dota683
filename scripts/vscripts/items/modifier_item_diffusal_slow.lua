modifier_diffusal_purge_slow_datadriven = class({
	OnCreated = function(self)
		self:StartIntervalThink(0.8)
	end,
	IsPurgable = function() return true end,
	GetEffectName = function() return "particles/items_fx/diffusal_slow.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE } end,
	GetModifierMoveSpeedBonus_Percentage = function(self) return self:GetStackCount() * -20 end,
	OnIntervalThink = function(self)
		local stack = self:GetStackCount()
		if stack > 0 then
			self:SetStackCount(stack - 1)
		end
	end,
	CheckState = function(self)
		if self:GetParent():IsCreep() and self:GetElapsedTime() < 3 then
			return {
				[ MODIFIER_STATE_ROOTED ] = true
			}
		end
		return {}
	end
})
