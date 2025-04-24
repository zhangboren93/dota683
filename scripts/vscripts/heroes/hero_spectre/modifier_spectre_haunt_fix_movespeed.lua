modifier_spectre_haunt_fix_movespeed_lua = class({
	OnCreated = function(self) self:StartIntervalThink(0.1) end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		if parent:IsStunned() then
			parent:Purge(false, true, false, true, false)
		end
	end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE } end,
	GetModifierMoveSpeed_Absolute = function()
		local boot_speed = 0
		local parent = self:GetParent()
		if parent ~= nil then
			if parent:HasItemInInventory("item_travel_boots_datadriven") then
				boot_speed = 100
			elseif parent:HasItemInInventory("item_phase_boots") then
				boot_speed = 50
			elseif parent:HasItemInInventory("item_power_treads") then
				boot_speed = 50
			elseif parent:HasItemInInventory("item_arcane_boots") then
				boot_speed = 55
			elseif parent:HasItemInInventory("item_tranquil_boots_datadriven") then
				boot_speed = 60
			elseif parent:HasItemInInventory("item_boots") then
				boot_speed = 50
			end
		end
		return 400 + boot_speed
	end
})
