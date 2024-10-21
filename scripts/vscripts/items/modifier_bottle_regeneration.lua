modifier_bottle_regeneration_lua = class({
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	} end,
	GetEffectName = function() return "particles/items_fx/bottle.vpcf" end,
	GetModifierConstantHealthRegen = function() return 45 end,
	GetModifierConstantManaRegen = function() return 23 end,
	IsPurgable = function() return true end,
	OnTakeDamage = function(self, event)
		if event.unit ~= self:GetParent() then return end
		if event.attacker:GetTeam() == self:GetParent():GetTeam() then return end
		if event.damage < 20 then return end
		self:Destroy()
	end
})
