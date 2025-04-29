modifier_land_mine_invis_lua = class({
	IsHidden = function() return true end,
	CheckState = function(self)
		local parent = self:GetParent()
		local revealed = parent:HasModifier("modifier_truesight")
		return {
			[ MODIFIER_STATE_INVISIBLE ] = not revealed
		}
	end
})
