modifier_item_quelling_blade_hooks_lua = class({})
function modifier_item_quelling_blade_hooks_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL 
	}
end

function modifier_item_quelling_blade_hooks_lua:IsHidden()
	return true
end

function modifier_item_quelling_blade_hooks_lua:GetModifierProcAttack_BonusDamage_Physical(event)
	if not IsServer() or event.attacker ~= self:GetParent() then return end
	local attacker = event.attacker
	local target = event.target
	local damage = event.damage
	if not target:IsCreep() then return end
	if attacker:IsRangedAttacker() then
		return damage * 12 / 100
	else
		return damage * 32 / 100
	end
end
