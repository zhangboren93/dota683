viper_poison_attack_lua = class({})

function viper_poison_attack_lua:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

function viper_poison_attack_lua:ProcsMagicStick()
	return false
end

function viper_poison_attack_lua:IsStealable() return false end

function viper_poison_attack_lua:GetProjectileName()
	return "particles/units/heroes/hero_viper/viper_poison_attack.vpcf"
end

-- Orb Effects
function viper_poison_attack_lua:OnOrbFire( params )
	self:GetCaster():EmitSound("hero_viper.poisonAttack.Cast")
end

function viper_poison_attack_lua:OnOrbImpact( params )
	local caster = self:GetCaster()
	local target = params.target
	target:AddNewModifier(caster, self, "modifier_viper_poison_attack_debuff_datadriven", {duration = self:GetSpecialValueFor("duration")})	
	target:EmitSound("Hero_Viper.PoisonAttack.Target")
end

if modifier_viper_poison_attack_debuff_datadriven == nil then
	modifier_viper_poison_attack_debuff_datadriven = class({ 
		IsDebuff			    = function(self) return true end,
		IsPurgable			    = function(self) return true end,
		DeclareFunctions        = function(self) return 
			{
				MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
				MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			}
		end,
		GetEffectName           = function(self) return "particles/units/heroes/hero_viper/viper_poison_debuff.vpcf" end,
		GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
	})
end

function modifier_viper_poison_attack_debuff_datadriven:OnCreated()
	local ability = self:GetAbility()
	self.as_slow = ability:GetSpecialValueFor("bonus_attack_speed")
	self.ms_slow = ability:GetSpecialValueFor("bonus_movement_speed")
	self.damage = ability:GetSpecialValueFor("damage")

	if not IsServer() then return end
	self.damageTable =
	{
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = self:GetAbility(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
	}
	self:StartIntervalThink( 1 )
end

function modifier_viper_poison_attack_debuff_datadriven:OnRefresh( kv )
	local ability = self:GetAbility()
	self.as_slow = ability:GetSpecialValueFor("bonus_attack_speed")
	self.ms_slow = ability:GetSpecialValueFor("bonus_movement_speed")
	self.damage = ability:GetSpecialValueFor("damage")
end

function modifier_viper_poison_attack_debuff_datadriven:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_viper_poison_attack_debuff_datadriven:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

function modifier_viper_poison_attack_debuff_datadriven:OnIntervalThink()
	ApplyDamage(self.damageTable)
end