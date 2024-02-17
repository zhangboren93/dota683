--[[ ============================================================================================================
	Author: Rook
	Date: February 3, 2015
	Called when the unit lands an attack on a target.  Applies a brief lifesteal modifier if not attacking a structure 
	(Lifesteal blocks in KV files will normally allow the unit to heal when attacking these), depending on whether
	Satanic has been activated.
================================================================================================================= ]]
function modifier_item_satanic_datadriven_on_attack_landed(keys)
	if not keys.target:IsIllusion() and not keys.target:IsBuilding() and keys.target:GetTeam() ~= keys.caster:GetTeam() then
		local hero_intrins = keys.caster:FindAbilityByName("hero_intrinstic_mechanism_datadriven")
		if keys.caster:HasModifier("modifier_item_satanic_datadriven_unholy_rage") then  --The caster has Satanic's active on them.
			hero_intrins:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_item_satanic_datadriven_unholy_rage_lifesteal", {duration = 0.03})
		end
		
		--The bonus lifesteal from Satanic's active effect stacks additively with its passive lifesteal, so always apply the base lifesteal modifier.
		hero_intrins:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_item_satanic_datadriven_lifesteal", {duration = 0.03})
	end
end

item_satanic_datadriven = class({})
function item_satanic_datadriven:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_item_satanic_datadriven_unholy_rage", { duration = 3.5 })
	caster:EmitSound("DOTA_Item.Satanic.Activate")
end

function item_satanic_datadriven:GetIntrinsicModifierName()
	return "modifier_item_satanic_datadriven"
end

function item_satanic_datadriven:OnOrbImpact(event)
	event.caster = self:GetCaster()
	modifier_item_satanic_datadriven_on_attack_landed(event)
end
