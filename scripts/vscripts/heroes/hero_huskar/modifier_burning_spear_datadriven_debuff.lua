require("scripts/vscripts/heroes/hero_huskar/burning_spear")

modifier_burning_spear_datadriven_debuff = class({})

function modifier_burning_spear_datadriven_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_burning_spear_datadriven_debuff:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_burning_spear_datadriven_debuff:OnIntervalThink()
	if not IsServer() then return end
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	ApplyDamage({
		victim = parent,
		attacker = caster,
		damage = ability:GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	})
end

function modifier_burning_spear_datadriven_debuff:OnDestroy()
	if not IsServer() then return end
	local event = {
		modifier_counter_name = "modifier_burning_spear_datadriven_debuff_counter",
		caster = self:GetCaster(),
		target = self:GetParent(),
		ability = self:GetAbility()
	}
	DecreaseStackCount(event)
end

function modifier_burning_spear_datadriven_debuff:IsHidden()
	return true
end
