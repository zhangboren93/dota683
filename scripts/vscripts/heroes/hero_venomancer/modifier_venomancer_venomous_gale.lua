modifier_venomancer_venomous_gale_lua = class({})
function modifier_venomancer_venomous_gale_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

-- 15s duration, -50 to 0
function modifier_venomancer_venomous_gale_lua:GetModifierMoveSpeedBonus_Percentage()
	local remaining = self:GetRemainingTime()
	return -10 * remaining / 3
end

function modifier_venomancer_venomous_gale_lua:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(3)
end

function modifier_venomancer_venomous_gale_lua:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local damage = ability:GetSpecialValueFor("tick_damage")
	ApplyDamage({
		victim = parent,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability 
	})
end

function modifier_venomancer_venomous_gale_lua:CheckState()
	local parent = self:GetParent()
	local deniable = parent:GetHealthPercent() < 25
	return {
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = deniable
	}
end

function modifier_venomancer_venomous_gale_lua:IsPurgable()
	return false
end

function modifier_venomancer_venomous_gale_lua:IsPurgeException()
	return true
end

function modifier_venomancer_venomous_gale_lua:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_gale_poison_debuff.vpcf"
end
