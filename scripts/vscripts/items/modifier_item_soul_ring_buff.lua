modifier_item_soul_ring_buff_lua = class({
	OnCreated = function(self, data)
		self.extra = data.extra
		self.pay_mana = 150
	end,
	DeclareFunctions = function()
		return {
			MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
			MODIFIER_EVENT_ON_SPENT_MANA
		}
	end,
	GetModifierExtraManaBonus = function(self) return self.extra end,
	IsPurgable = function() return false end,
	OnSpentMana = function(self, event)
		local ability = event.ability
		if ability:GetName() == "item_soul_ring_datadriven" then return end
		local mana_cost = ability:GetManaCost(-1)
		self.pay_mana = self.pay_mana - mana_cost
	end,
	OnDestroy = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		local ability = self:GetAbility()
		if self.pay_mana > 0 then
			parent:SpendMana(self.pay_mana - self.extra, ability)
		end
	end
})
