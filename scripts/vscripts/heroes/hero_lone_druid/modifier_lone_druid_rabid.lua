modifier_lone_druid_rabid_lua = class({})

function modifier_lone_druid_rabid_lua:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_lone_druid_rabid_lua:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:HasModifier("modifier_lone_druid_rabid") then
		self:Destroy()
	end
end

function modifier_lone_druid_rabid_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_lone_druid_rabid_lua:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetLevel() * 5
end

function modifier_lone_druid_rabid_lua:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetLevel() * 10
end

function modifier_lone_druid_rabid_lua:IsHidden()
	return true
end
