modifier_supernova_burn_datadriven = class({})

function modifier_supernova_burn_datadriven:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_supernova_burn_datadriven:GetEffectName()
	return "particles/units/heroes/hero_phoenix/phoenix_supernova_radiance.vpcf"
end

function modifier_supernova_burn_datadriven:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_supernova_burn_datadriven:OnIntervalThink()
	if not IsServer() then return end
	local ability = self:GetAbility()
	local damage_per_sec = ability:GetSpecialValueFor("damage_per_sec")
	ApplyDamage({
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage_per_sec,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	})
end
