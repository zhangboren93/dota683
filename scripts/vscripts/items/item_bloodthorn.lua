item_bloodthorn_lua = class({
	GetIntrinsicModifierName = function() return "modifier_item_bloodthorn_lua" end,
	OnSpellStart = function(self)
		local caster = self:GetCaster()
		caster:EmitSound("DOTA_Item.Bloodthorn.Activate")
		local target = self:GetCursorTarget()
		if target:TriggerSpellAbsorb(self) then return end
		target:AddNewModifier(self:GetCaster(), self, "modifier_item_bloodthorn_debuff_lua", { duration = 5 })
	end
})
