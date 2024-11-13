require("scripts/vscripts/items/item_maelstrom")
modifier_maelstrom_trigger_no_miss = class({})
function modifier_maelstrom_trigger_no_miss:CheckState()
	return {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
end
function modifier_maelstrom_trigger_no_miss:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end
function modifier_maelstrom_trigger_no_miss:OnAttackLanded(event)
	if event.attacker ~= self:GetParent() then return end
	event.ability = self:GetAbility()
	event.caster = self:GetCaster()
	modifier_item_maelstrom_datadriven_on_orb_impact(event)
end

function modifier_maelstrom_trigger_no_miss:IsHidden()
	return true
end
