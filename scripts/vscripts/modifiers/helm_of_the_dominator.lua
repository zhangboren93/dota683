if modifier_helm_damage_lifesteal_lua == nil then
    modifier_helm_damage_lifesteal_lua = class({})
end
function modifier_helm_damage_lifesteal_lua:OnCreated(kv)
    self.kv = kv
    print(kv.bonus_damage)
end

function modifier_helm_damage_lifesteal_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_helm_damage_lifesteal_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_helm_damage_lifesteal_lua:IsHidden()
    return false
end

function modifier_helm_damage_lifesteal_lua:GetModifierPreAttack_BonusDamage()
    return self.kv.bonus_damage
end

function modifier_helm_damage_lifesteal_lua:OnAttackLanded(event)
    local target = event.target
    if event.attacker == self:GetParent() 
        and event.damage_type == DAMAGE_TYPE_PHYSICAL then
        -- TODO account for physical damage immunity
        local targetArmor = target:GetPhysicalArmorValue(false);
        local mitigatedDamage = event.damage * (1 - 0.06 * targetArmor /(1 + 0.06 * targetArmor))
        self:GetParent():Heal(mitigatedDamage * self.kv.lifesteal_percent / 100, nil)
    end
end