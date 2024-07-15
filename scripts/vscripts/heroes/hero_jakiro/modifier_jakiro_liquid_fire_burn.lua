modifier_jakiro_liquid_fire_burn_lua = class({
	OnCreated = function(self) self:StartIntervalThink(0.5) end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local damage = ability:GetSpecialValueFor("damage") / 2
		ApplyDamage({
			victim = parent,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		})
	end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT } end,
	GetModifierAttackSpeedBonus_Constant = function(self) return self:GetAbility():GetSpecialValueFor("slow_attack_speed_pct") end,
	GetStatusEffectName = function() return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf" end,
	IsPurgable = function() return true end
})
