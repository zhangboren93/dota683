modifier_item_lifesteal_lua = class({
	OnCreated = function(self, data)
		if data.lifesteal then
			self.lifesteal = data.lifesteal
		else
			self.lifesteal = 15
		end 
	end,
	DeclareFunctions = function() return { MODIFIER_EVENT_ON_ATTACK_LANDED } end,
	OnAttackLanded = function(self, event) 
		local attacker = event.attacker
		if self:GetParent() ~= attacker then return end
		local target = event.target
		if target:IsIllusion() or target:IsBuilding() or target:GetTeam() == attacker:GetTeam() then return end
		local lifesteal = self.lifesteal
		if attacker:HasModifier("modifier_item_satanic_datadriven_unholy_rage") then
			lifesteal = lifesteal + 175
		end
		attacker:HealWithParams(event.damage * lifesteal / 100, self:GetAbility(), true, false, attacker, false)
		local particleId = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:ReleaseParticleIndex(particleId)
	end,
	IsHidden = function() return true end
})
