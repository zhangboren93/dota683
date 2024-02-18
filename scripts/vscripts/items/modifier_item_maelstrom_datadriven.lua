require("scripts/vscripts/items/item_maelstrom")

modifier_item_maelstrom_datadriven = class({})

function modifier_item_maelstrom_datadriven:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_item_maelstrom_datadriven:OnAttack(event)
	if event.attacker ~= self:GetParent() then return end
	-- won't work if attacker triggers ability orb
	local modifier_orb = self:GetParent():FindModifierByName("modifier_generic_orb_effect_lua")
	if modifier_orb ~= nil and modifier_orb.records[event.record] then
		return
	end
	event.ability = self:GetAbility()
	event.caster = self:GetCaster()
	handleOrbFire(event)
end

function modifier_item_maelstrom_datadriven:GetModifierPreAttack_BonusDamage()
	return 24
end

function modifier_item_maelstrom_datadriven:GetModifierAttackSpeedBonus_Constant()
	return 25
end

function modifier_item_maelstrom_datadriven:IsHidden()
	return true
end

function modifier_item_maelstrom_datadriven:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end
