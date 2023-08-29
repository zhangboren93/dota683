item_ring_of_aquila_lua = class({})

function item_ring_of_aquila_lua:GetAbilityTextureName()
	if self:GetToggleState() then
		return "item_ring_of_aquila_inactive"
	else
		return "item_ring_of_aquila"
	end
end

function item_ring_of_aquila_lua:GetIntrinsicModifierName()
	return "modifier_item_ring_of_aquila_lua"
end

function item_ring_of_aquila_lua:OnToggle()
end

function item_ring_of_aquila_lua:ResetToggleOnRespawn()
	return false
end
