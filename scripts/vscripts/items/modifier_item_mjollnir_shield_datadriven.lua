require("scripts/vscripts/items/item_mjollnir")
modifier_item_mjollnir_shield_datadriven = class({})
function modifier_item_mjollnir_shield_datadriven:GetEffectName()
	return "particles/items2_fx/mjollnir_shield.vpcf"
end
function modifier_item_mjollnir_shield_datadriven:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE 
	}
end
function modifier_item_mjollnir_shield_datadriven:OnTakeDamage(event)
	local parent = self:GetParent()
	if parent ~= event.unit then return end
	local attacker = event.attacker
	if attacker == parent then return end
	if event.damage < 5 then return end
	if bit.band(event.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= 0 then return end
	local ability = self:GetAbility()
	local static_chance = ability:GetSpecialValueFor("static_chance")
	if RandomInt(1, 100) <= static_chance then
		event.ability = ability
		event.caster = self:GetCaster()
		event.target = event.unit
		shield_triggered(event)
	end
end
