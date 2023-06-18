if modifier_viper_orb_cd_on_attack == nil then
	modifier_viper_orb_cd_on_attack = class({})
end

function modifier_viper_orb_cd_on_attack:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_viper_orb_cd_on_attack:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK,
    }
    return funcs
end

function modifier_viper_orb_cd_on_attack:OnAttack(event)
	if IsServer() and event.attacker == self:GetParent() and not self:GetParent():HasModifier("modifier_dont_reset_orb_cd") then
		local attacker = event.attacker
		local orb = attacker:FindAbilityByName("viper_poison_attack_datadriven")
		if orb:GetLevel() > 0 then
			local duration = attacker:GetSecondsPerAttack() - attacker:GetAttackAnimationPoint()
			orb:StartCooldown(duration)
		end
	end
end

function modifier_viper_orb_cd_on_attack:IsHidden()
	return true
end