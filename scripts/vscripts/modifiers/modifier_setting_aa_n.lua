modifier_setting_aa_datadriven_0 = class({
	OnCreated = function(self)
		if (IsServer()) then return end
		self.state = 0
		self:StartIntervalThink(0.1)
	end,
	OnIntervalThink = function(self)
		if IsServer() then return end
		local stack_count = self:GetStackCount()
		if self.state == 0 then
			if stack_count == GetLocalPlayerID() + 1 then
				SendToConsole("dota_player_units_auto_attack_mode 0")
				self.state = 1
			end
		elseif self.state == 1 then
			SendToConsole("dota_player_units_auto_attack_mode 2")
			self.state = 2
		end
	end
})
modifier_setting_aa_datadriven_1 = class({
	OnCreated = function(self)
		if (IsServer()) then return end
		self.state = 0
		self:StartIntervalThink(0.1)
	end,
	OnIntervalThink = function(self)
		if IsServer() then return end
		local stack_count = self:GetStackCount()
		if stack_count == GetLocalPlayerID() + 1 then
			SendToConsole("dota_player_units_auto_attack_mode 0")
		end
	end
})
modifier_setting_aa_datadriven_2 = class({
	OnCreated = function(self)
		if (IsServer()) then return end
		self:StartIntervalThink(0.1)
	end,
	OnIntervalThink = function(self)
		if IsServer() then return end
		local stack_count = self:GetStackCount()
		if stack_count == GetLocalPlayerID() + 1 then
			SendToConsole("dota_player_units_auto_attack_mode 1")
		end
	end
})
