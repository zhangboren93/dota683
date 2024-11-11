modifier_broodmother_spin_web_lua = class({
	OnCreated = function(self)
		local parent = self:GetParent()
		local ability = self:GetAbility()
		self.fade_start_time = GameRules:GetGameTime()
		self:StartIntervalThink(0.1)
	end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local time = GameRules:GetGameTime()
		local is_invis_visual = time - self.fade_start_time >= 2 
		if is_invis_visual and not parent:HasModifier("modifier_broodmother_spin_web_invis_datadriven") then
			ability:ApplyDataDrivenModifier(caster, parent, "modifier_broodmother_spin_web_invis_datadriven", {})
		end
		if not is_invis_visual then
			parent:RemoveModifierByName("modifier_broodmother_spin_web_invis_datadriven")
		end
	end,
	CheckState = function(self)
		local time = GameRules:GetGameTime()
		local parent = self:GetParent()
		local is_invis = parent:HasModifier("modifier_broodmother_spin_web_invis_datadriven") and not parent:HasModifier("modifier_truesignt")
		local is_free_path = not parent:HasModifier("modifier_broodmother_spin_web_disable_datadriven")
		return {
			[ MODIFIER_STATE_INVISIBLE ] = is_invis,
			[ MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY ] = is_free_path,
			[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true
		}
	end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	} end,
	OnTakeDamage = function(self, event)
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		if event.unit ~= parent then return end
		if not IsServer() then return end
		ability:ApplyDataDrivenModifier(caster, parent, "modifier_broodmother_spin_web_disable_datadriven", {})
	end,
	OnAbilityExecuted = function(self, event)
		local parent = self:GetParent()
		if event.unit ~= parent then return end
		self.fade_start_time = GameRules:GetGameTime()
	end,
	OnAttack = function(self, event)
		local parent = self:GetParent()
		if event.attacker ~= parent then return end
		self.fade_start_time = GameRules:GetGameTime()
	end,
	GetModifierMoveSpeedBonus_Percentage = function(self)
		local ability = self:GetAbility()
		local time = GameRules:GetGameTime()
		local parent = self:GetParent()
		local is_free_path = not parent:HasModifier("modifier_broodmother_spin_web_disable_datadriven")
		local bonus_movespeed = ability:GetSpecialValueFor("bonus_movespeed")
		if is_free_path then 
			return bonus_movespeed * 2 
		else
			return bonus_movespeed
		end
	end,
	GetModifierConstantHealthRegen = function(self)
		local ability = self:GetAbility()
		return ability:GetSpecialValueFor("health_regen")
	end,
	OnDestroy = function(self)
		if not IsServer() then return end
		self:GetParent():RemoveModifierByName("modifier_broodmother_spin_web_invis_datadriven")
	end
})
