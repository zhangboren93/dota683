modifier_item_diffusal_lua = class({
	OnCreated = function(self)
		if not IsServer() then return end
		local item = self:GetAbility()
		if item.has_initial_charge_set == nil then
			local initial_charges = item:GetSpecialValueFor("initial_equip_charges")
			item:SetCurrentCharges(initial_charges)
			print(item:GetName() .. " equipped and initial charges set to " .. initial_charges)
			item.has_initial_charge_set = true
		end
	end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end,
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	} end,
	GetModifierBonusStats_Agility = function(self) return self:GetAbility():GetSpecialValueFor("bonus_agility") end,
	GetModifierBonusStats_Intellect = function(self) return self:GetAbility():GetSpecialValueFor("bonus_intellect") end,
	OnAttackLanded = function(self, event) 
		local target = event.target
		local ability = self:GetAbility()
		local feedback_mana_burn = 25
		if event.attacker ~= self:GetParent() then return end
		if event.attacker:IsIllusion() and event.attacker:IsRangedAttacker() then
			return
		elseif event.target:IsMagicImmune() then
			return 
		end
		local mana_burn_avail = target:GetMana()
		if mana_burn_avail <= 0.5 then return end
		if mana_burn_avail > feedback_mana_burn then
			mana_burn_avail = feedback_mana_burn
		end 
		target:Script_ReduceMana(feedback_mana_burn, ability)
		ApplyDamage({
			victim = target,
			attacker = event.attacker,
			damage = mana_burn_avail,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = ability
		})
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	end,
	new = function(self, o)
      o = o or {}
      setmetatable(o, self)
      self.__index = self
      return o
    end
})

modifier_item_diffusal_2_lua = modifier_item_diffusal_lua
