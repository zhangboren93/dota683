-- Deprecated
if modifier_viper_viper_strike_slow_lua == nil then
    modifier_viper_viper_strike_slow_lua = class({ 
		IsPurgable              = function(self) return false end,
		IsPurgeException        = function(self) return false end,
		IsDebuff                = function(self) return true end,
		RemoveOnDeath           = function(self) return true end,
		DeclareFunctions        = function(self) return 
			{
				MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
				MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			}
		end,
		GetEffectName           = function(self) return "particles/units/heroes/hero_viper/viper_viper_strike_debuff.vpcf" end,
		GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
		GetStatusEffectName     = function(self) return "particles/status_fx/status_effect_poison_viper.vpcf" end,
		StatusEffectPriority    = function(self) return MODIFIER_PRIORITY_HIGH end,
	})
end

function modifier_viper_viper_strike_slow_lua:OnCreated(kv)
    self.kv = kv

	local ability = self:GetAbility()
    self.bonus_movement_speed = ability:GetSpecialValueFor("bonus_movement_speed")
    self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")

	self:StartIntervalThink(1)
end

function modifier_viper_viper_strike_slow_lua:OnRefresh()
    self:OnCreated(self.kv)
end

function modifier_viper_viper_strike_slow_lua:GetModifierMoveSpeedBonus_Percentage()
    return self.bonus_movement_speed / 5 * self:GetStackCount()
end

function modifier_viper_viper_strike_slow_lua:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed / 5 * self:GetStackCount()
end

function modifier_viper_viper_strike_slow_lua:OnIntervalThink()
	if not IsServer() then return end
	local target = self:GetParent()
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("viper_viper_strike_datadriven")
	local damage = ability:GetSpecialValueFor("damage")
	ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	})
	SendOverheadEventMessage(target, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage, nil )
	self:SetStackCount(self:GetStackCount() - 1)
end

function handleProjectileHit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local duration = ability:GetSpecialValueFor("duration")
	if target:TriggerSpellAbsorb(ability) then return end
	local modifier = target:AddNewModifier(caster, ability, "modifier_viper_viper_strike_slow_lua", { duration = duration })
	modifier:SetStackCount(5)
end
