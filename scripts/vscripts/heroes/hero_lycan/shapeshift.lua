modifier_lycan_shapeshift_attackrange = class({ 
	IsHidden				= function(self) return false end,
	IsPurgable				= function(self) return false end,
	DeclareFunctions        = function(self) return 
	{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	end,
})

function modifier_lycan_shapeshift_attackrange:GetModifierPreAttack_CriticalStrike(event)
	if IsServer() then
		local target = event.target
		if target:GetClassname() == "dota_item_drop"
			or target:GetClassname() == "dota_item_rune"
			or target:IsBuilding()
			or target:IsWard()
				then return 0
		end
		if RandomInt(1, 100) <= 30 then
			return 170
		end
	end
end