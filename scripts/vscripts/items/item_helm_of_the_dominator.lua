require("scripts/vscripts/items/item_lifesteal")

function dominateCreep(event)
	local item = event.ability
	local caster = event.caster
	local target = event.target
	if item.dominatedCreep ~= nil and IsValidEntity(item.dominatedCreep) then
		item.dominatedCreep:ForceKill(false)
	end
	local name = target:GetUnitName()
	local spawn_location = target:GetAbsOrigin()
	target:ForceKill(false)

	local double = CreateUnitByName( name, spawn_location, true, caster, caster, caster:GetTeamNumber())
	double:SetControllableByPlayer(caster:GetPlayerID(), true)
	double:SetMaxHealth(double:GetMaxHealth() + 500)
	double:SetBaseMaxHealth(double:GetBaseMaxHealth() + 500)
	double:Heal(500, caster)
	item.dominatedCreep = double
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
