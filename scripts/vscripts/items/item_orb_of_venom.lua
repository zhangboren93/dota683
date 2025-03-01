item_orb_of_venom_lua = class({
	GetIntrinsicModifierName = function()
		return "modifier_generic_orb_effect_item_lua"
	end,
	OnOrbImpact = function(self, event)
		local caster = self:GetCaster()
		local target = event.target
		if caster:IsIllusion() then return end
		if target:IsBuilding() then return end
		if target:GetTeam() == caster:GetTeam() then return end
		local duration = self:GetSpecialValueFor("poison_duration")
		target:AddNewModifier(caster, self, "modifier_item_orb_of_venom_ranged_lua", { duration = duration })
	end
})
