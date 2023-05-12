modifier_item_blade_mail_new_active = class({})

function modifier_item_blade_mail_new_active:IsPurgable()
	return false
end

function modifier_item_blade_mail_new_active:DeclareFunctions() 
	return {MODIFIER_EVENT_ON_TAKEDAMAGE} 
end

function modifier_item_blade_mail_new_active:OnTakeDamage(kv)
	if kv.unit == self:GetParent() 
		and not kv.unit:IsOther() 
		and not kv.attacker:IsBuilding() 
		and kv.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() 
		and bit.band(kv.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS 
		and bit.band(kv.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION 
		and not kv.attacker:IsMagicImmune() then
		ApplyDamage({victim = kv.attacker, damage = kv.damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, attacker = self:GetParent(), ability = self:GetAbility()})
	end
end