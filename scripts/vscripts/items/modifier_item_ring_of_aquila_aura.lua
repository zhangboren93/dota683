modifier_item_ring_of_aquila_aura_lua = class({})

function modifier_item_ring_of_aquila_aura_lua:GetAuraDuration()
	return 0.1
end

function modifier_item_ring_of_aquila_aura_lua:GetAuraRadius()
	return 900
end

function modifier_item_ring_of_aquila_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_item_ring_of_aquila_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_item_ring_of_aquila_aura_lua:GetModifierAura()
	return "modifier_item_ring_of_aquila_aura_active_lua"
end

function modifier_item_ring_of_aquila_aura_lua:IsAura()
	return true
end

function modifier_item_ring_of_aquila_aura_lua:GetAuraEntityReject(entity)
	if entity == self:GetParent() then return false end
	return self:GetAbility():GetToggleState()
end

function modifier_item_ring_of_aquila_aura_lua:IsHidden()
	return true
end
