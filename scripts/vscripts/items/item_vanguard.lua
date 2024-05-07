item_vanguard_lua = class({})
function item_vanguard_lua:GetIntrinsicModifierName()
	return "modifier_item_vanguard_lua"
end

modifier_item_vanguard_lua = class({})
function modifier_item_vanguard_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_item_vanguard_lua:GetModifierHealthBonus()
	return 250
end

function modifier_item_vanguard_lua:GetModifierConstantHealthRegen()
	return 6
end

function modifier_item_vanguard_lua:OnTakeDamage(event)
	if event.unit ~= self:GetParent() 
		or event.damage_type ~= DAMAGE_TYPE_PHYSICAL
		or bit.band(event.damage_flags, DOTA_DAMAGE_FLAG_BYPASSES_BLOCK) ~= 0 then
		return
	end

	if RandomInt(1, 100) > 67 then
		return
	end

	local block_damage = 40
	if event.unit:IsRangedAttacker() then
		block_damage = 20
	end

	if block_damage > event.damage then
		block_damage = event.damage
	end

	event.unit:Heal(block_damage, self:GetAbility())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, event.unit, block_damage, event.unit:GetPlayerOwner())
end

function modifier_item_vanguard_lua:IsHidden()
	return true
end
