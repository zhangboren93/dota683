modifier_item_lifesteal_lua = class({
	DeclareFunctions = function() return { MODIFIER_EVENT_ON_ATTACK_LANDED } end,
	OnAttackLanded = function(self, event) 
		local attacker = event.attacker
		if self:GetParent() ~= attacker then return end
		local target = event.target
		if target:IsIllusion() or target:IsBuilding() or target:GetTeam() == attacker:GetTeam() then return end
		--print("Heal for " .. (event.damage * 15 / 100))
		attacker:HealWithParams(event.damage * 15 / 100, self:GetAbility(), true, false, attacker, false)
	end,
	IsHidden = function() return true end
})
