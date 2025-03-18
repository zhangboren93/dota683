modifier_phoenix_fire_spirit_damage_lua = class({
	IsDebuff = function() return true end,
	IsPurgable = function() return true end,
	GetEffectName = function() return "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn.vpcf" end,
	GetEffectAttachType = function() return -1 end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT } end,
	GetModifierAttackSpeedBonus_Constant = function(self) return self:GetAbility():GetSpecialValueFor("attackspeed_slow") end,
	OnCreated = function(self)
		local ability = self:GetAbility()
		local tick_interval = ability:GetSpecialValueFor("tick_interval")
		self:StartIntervalThink(tick_interval)
	end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local damage = ability:GetSpecialValueFor("dps")
		ApplyDamage({
			victim = parent,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		})
	end
})
