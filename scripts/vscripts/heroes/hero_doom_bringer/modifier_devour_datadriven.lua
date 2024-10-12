--[[Author: Pizzalol
	Date: 04.03.2015.
	Awards the bonus gold to the modifier owner only if the modifier owner is alive]]
local function DevourGold( keys )
	local target = keys.target
	local ability = keys.ability

	local bonus_gold = ability:GetSpecialValueFor("bonus_gold")

	-- Give the gold only if the target is alive
	if target:IsAlive() then
		target:ModifyGold(bonus_gold, false, DOTA_ModifyGold_AbilityGold)
		SendOverheadEventMessage(target:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, target, bonus_gold, target:GetPlayerOwner())
	end
end

modifier_devour_datadriven = class({
	IsDebuff = function() return true end,
	OnDestroy = function(self)
		if not IsServer() then return end
		DevourGold({
			target = self:GetParent(),
			ability = self:GetAbility()
		})	
	end
})
