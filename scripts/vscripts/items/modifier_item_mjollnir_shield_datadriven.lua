require("scripts/vscripts/items/item_mjollnir")
modifier_item_mjollnir_shield_datadriven = class({})
function modifier_item_mjollnir_shield_datadriven:GetEffectName()
	return "particles/items2_fx/mjollnir_shield.vpcf"
end
function modifier_item_mjollnir_shield_datadriven:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACKED 
	}
end
function modifier_item_mjollnir_shield_datadriven:OnAttacked(event)
	if self:GetParent() ~= event.target then return end
	local ability = self:GetAbility()
	local static_chance = ability:GetSpecialValueFor("static_chance")
	if RandomInt(1, 100) <= static_chance then
		event.ability = ability
		event.caster = self:GetCaster()
		shield_triggered(event)
	end
end
