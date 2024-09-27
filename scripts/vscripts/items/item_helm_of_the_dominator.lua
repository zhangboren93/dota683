require("scripts/vscripts/items/item_lifesteal")

function dominateCreep(event)
	local item = event.ability
	local caster = event.caster
	local target = event.target
	if item.dominatedCreep ~= nil and IsValidEntity(item.dominatedCreep) then
		item.dominatedCreep:ForceKill(false)
	end

	target:AddNewModifier(caster, item, "modifier_life_stealer_infest_creep", {}) -- Dota2 Original modifier
	target:RemoveModifierByName("modifier_life_stealer_infest_creep")
	target:RemoveAbility("life_stealer_consume")
	target:AddNewModifier(caster, item, "modifier_dominated", {})

	target:SetMaxHealth(target:GetMaxHealth() + 500)
	target:SetBaseMaxHealth(target:GetBaseMaxHealth() + 500)
	target:Heal(500, caster)
	item.dominatedCreep = target
end

item_helm_of_the_dominator_datadriven = class({})

function item_helm_of_the_dominator_datadriven:OnSpellStart()
	local event = {}
	event.ability = self
	event.caster = self:GetCaster()
	event.target = self:GetCursorTarget()
	dominateCreep(event)
end

function item_helm_of_the_dominator_datadriven:GetIntrinsicModifierName()
	return "modifier_item_helm_of_the_dominator_lua"
end

function item_helm_of_the_dominator_datadriven:OnOrbImpact(event)
	event.caster = self:GetCaster()
	attack_landed(event)
end
