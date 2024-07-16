modifier_treant_natures_guise_lua = class({
	CheckState = function(self) 
		local parent = self:GetParent()
		local invis = true
		if parent:HasModifier("modifier_truesight") then
			invis = false
		else
			if not parent:HasModifier("modifier_invisible") then
				parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invisible", { duration = self:GetRemainingTime() })
			end
		end
		return { [ MODIFIER_STATE_INVISIBLE ] = invis }
	end,
	OnCreated = function(self)
		self.away_from_tree_count = 0
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self:StartIntervalThink(0.1)
	end,
	OnIntervalThink = function(self)
		if not IsServer() then return true end
		local parent = self:GetParent()
    	local neartrees = GridNav:IsNearbyTree(parent:GetAbsOrigin(), self.radius, false)
		if not neartrees then
			self.away_from_tree_count = self.away_from_tree_count + 1
			if self.away_from_tree_count >= 10 then
				self:Destroy()
			end
		else
			self.away_from_tree_count = 0
		end
	end,
	DeclareFunctions = function() return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	} end,
	OnAttack = function(self, event)
		local parent = self:GetParent()
		if event.attacker == parent then
			self:Destroy()
			return
		end
	end,
	OnAbilityExecuted = function(self, event)
		local ability = event.ability
		if  ability:GetName() == "treant_natures_guise_datadriven" or
			ability:GetName() == "treant_leech_seed" or
			ability:GetName() == "treant_living_armor_datadriven" or
			ability:GetName() == "treant_overgrowth" then
			return
		end
		self:Destroy()
	end,
	OnDestroy = function(self)
		if not IsServer() then return end
		self:GetParent():RemoveModifierByName("modifier_invisible")
	end,
	IsPurgable = function() return true end,
	GetModifierMoveSpeedBonus_Percentage = function() return 10 end
})
