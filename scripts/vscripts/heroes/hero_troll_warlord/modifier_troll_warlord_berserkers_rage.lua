modifier_troll_warlord_berserkers_rage_lua = class({
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	GetEffectName = function() return "particles/units/heroes/hero_troll_warlord/troll_warlord_berserk_buff.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	} end,
	GetModifierMoveSpeedBonus_Constant = function(self) return self:GetAbility():GetSpecialValueFor("bonus_move_speed") end,
	GetModifierAttackRangeBonus = function(self) return -372 end,
	GetModifierPhysicalArmorBonus = function(self) return 3 end,
	GetModifierBaseAttackTimeConstant = function(self) return 1.55 end,
	GetModifierHealthBonus = function(self) return 100 end,
	GetModifierBaseAttack_BonusDamage = function(self) return 15 end,
	GetActivityTranslationModifiers = function() return "melee" end,
	GetAttackSound = function() return "Hero_TrollWarlord.ProjectileImpact" end,
	OnAttackLanded = function(self, event)
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local target = event.target
		local attacker = event.attacker
		if attacker ~= parent then return end
		if parent:IsIllusion() then return end
		if parent:GetTeam() == target:GetTeam() then return end
		if target:IsBuilding() then return end
		if parent:PassivesDisabled() then return end
		if RandomInt(1, 100) <= 10 then
            local bashDuration = ability:GetSpecialValueFor("bash_duration")
            local bashDamage = ability:GetSpecialValueFor("bash_damage")
	    	local damage_table = {}
	    	damage_table.attacker = parent
	    	damage_table.victim = target
	    	damage_table.ability = ability
	    	damage_table.damage_type = DAMAGE_TYPE_PHYSICAL 
	    	damage_table.damage = bashDamage
	    	target:AddNewModifier(attacker, ability, "modifier_stunned", { duration = bashDuration})
	    	ApplyDamage(damage_table)
			target:EmitSound("Hero_TrollWarlord.BerserkersRage.Stun")
		end
	end
})
