modifier_ward_no_collusion_lua = class({})
function modifier_ward_no_collusion_lua:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end

function modifier_ward_no_collusion_lua:IsHidden()
	return true
end
