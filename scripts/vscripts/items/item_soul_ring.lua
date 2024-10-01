function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local mana_gain = ability:GetSpecialValueFor("mana_gain")
	local mana = caster:GetMana()
	local max_mana = caster:GetMaxMana()
	local extra_max_mana = mana_gain + mana - max_mana 
	local duration = ability:GetSpecialValueFor("duration")
	if extra_max_mana < 0 then extra_max_mana = 0 end
	caster:AddNewModifier(caster, ability, "modifier_item_soul_ring_buff_lua", { duration = duration, extra = extra_max_mana })
	caster:GiveMana(mana_gain)
	caster:EmitSound("DOTA_Item.SoulRing.Activate")
	ParticleManager:CreateParticle("particles/items2_fx/soul_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
end

item_soul_ring_datadriven = class({
	GetIntrinsicModifierName = function() return "modifier_item_soul_ring_lua" end,
	OnSpellStart = function(self)
		handleSpellStart({
			caster = self:GetParent(),
			ability = self
		})
	end
})

modifier_item_soul_ring_lua = class({
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	} end,
	GetModifierConstantHealthRegen = function() return 3 end,
	GetModifierConstantManaRegen = function(self) return (0.01+self:GetParent():GetIntellect(false)*0.04)/2 end,
	IsHidden = function() return true end
})
