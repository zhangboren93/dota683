require("heroes/hero_shredder/chakram")
modifier_shredder_chakram_lua = class({
	OnCreated = function(self) 
		local ability = self:GetAbility()
		self.mana_cost = ability:GetSpecialValueFor("mana_per_second")
		self.auto_return_distance = ability:GetSpecialValueFor("break_distance")
		self.intervalThinkCount = 0 
		self:StartIntervalThink(0.2)
	end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local caster = self:GetCaster()
		local parent = self:GetParent()
		GridNav:DestroyTreesAroundPoint(parent:GetAbsOrigin(), 200, false)
		self.intervalThinkCount = self.intervalThinkCount + 1
		if self.intervalThinkCount % 5 > 0 then
			return
		end
		if parent:HasModifier("modifier_shredder_chakram_return_lua") or parent:HasModifier("modifier_shredder_chakram_return_lua") then
			return
		end
		if 	    caster:GetMana() < self.mana_cost 
			or (caster:GetAbsOrigin() - parent:GetAbsOrigin()):Length2D() > self.auto_return_distance then
			local return_chakram = caster:FindAbilityByName("shredder_return_chakram_datadriven")
			if return_chakram ~= nil and not return_chakram:IsHidden() then
				return_chakram:CastAbility()
			end
		else
			caster:SpendMana(self.mana_cost, self:GetAbility())
		end
	end,
	CheckState = function() return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true
	} end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	} end,
	GetVisualZDelta = function() return 80 end,
	IsAura = function() return true end,
	GetModifierAura = function() return "modifier_shredder_chakram_slow_lua" end,
	GetAuraSearchType = function() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetAuraSearchTeam = function() return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchFlags = function() return DOTA_UNIT_TARGET_FLAG_NONE end,
	GetAuraRadius = function() return 200 end,
	GetAuraDuration = function() return 0.5 end
})

modifier_shredder_chakram_slow_lua = class({
	OnCreated = function(self) 
		local ability = self:GetAbility()
		self.damage = ability:GetSpecialValueFor("damage_per_second") / 2
		self:StartIntervalThink(0.5)
	end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local aura_owner = self:GetAuraOwner()
		if     aura_owner:HasModifier("modifier_shredder_chakram_return_lua") 
			or aura_owner:HasModifier("modifier_shredder_chakram_move_lua") then return end
		ApplyDamage({
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility()
		})
	end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE } end,
	GetModifierMoveSpeedBonus_Percentage = function(self) 
		local parent = self:GetParent()
		local slow = parent:GetHealth() * 100 / parent:GetMaxHealth() - 100
		if slow > -5 then
			slow = -5
		elseif slow < -95 then
			slow = -95
		end
		return slow
	end
})
