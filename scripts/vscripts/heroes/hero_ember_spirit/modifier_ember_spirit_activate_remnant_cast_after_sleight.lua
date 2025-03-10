modifier_ember_spirit_activate_remnant_cast_after_sleight_lua = class({
	OnCreated = function(self, data)
		self.target_x = data.target_x
		self.target_y = data.target_y
		self:StartIntervalThink(0.1)
	end,
	OnIntervalThink = function(self)
		local parent = self:GetParent()
		if parent == nil then return end
		if not parent:HasModifier("modifier_ember_spirit_sleight_of_fist_in_progress") then
			print("Sleigth of Fist ends.")
			parent:CastAbilityOnPosition(Vector(self.target_x, self.target_y, 0),
				self:GetAbility(),
				parent:GetPlayerID())
			self:Destroy()
		end
	end
	--DeclareFunctions = function() return { MODIFIER_EVENT_ON_MODIFIER_REMOVED } end,
	--OnModifierRemoved = function(self, event)
	--	local parent = self:GetParent()
	--	if parent == nil then return end
	--	print("OnModifierRemoved")
	--	DeepPrintTable(event)
	--end
})
