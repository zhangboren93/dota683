--[[ ============================================================================================================
	Author: Rook
	Date: February 4, 2015
	Called when the unit lands an attack on a target.  Applies a brief lifesteal modifier if not attacking a structure 
	(Lifesteal blocks in KV files will normally allow the unit to heal when attacking these).
================================================================================================================= ]]
function modifier_item_mask_of_madness_datadriven_on_orb_impact(keys)
	if not keys.target:IsIllusion() 
		and not keys.target:IsBuilding()
		and keys.target:GetTeam() ~= keys.caster:GetTeam() then
		keys.caster:FindAbilityByName("hero_intrinstic_mechanism_datadriven"):
					ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_item_mask_of_madness_datadriven_lifesteal", {duration = 0.03})
	end
end

item_mask_of_madness_datadriven = class({})

function item_mask_of_madness_datadriven:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_item_mask_of_madness_datadriven_berserk", { duration = 12})
	caster:EmitSound("DOTA_Item.MaskOfMadness.Activate")
end

function item_mask_of_madness_datadriven:OnOrbImpact(event)
	event.caster = self:GetCaster()
	modifier_item_mask_of_madness_datadriven_on_orb_impact(event)
end

function item_mask_of_madness_datadriven:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_item_lua"
end
