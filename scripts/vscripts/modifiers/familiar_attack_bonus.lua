if modifier_familiar_attack_damage_lua == nil then
    modifier_familiar_attack_damage_lua = class({})
end

function modifier_familiar_attack_damage_lua:OnCreated()
    self.damage_per_charge = self:GetAbility():GetSpecialValueFor("damage_per_charge")
    if IsServer() then
        self:refreshStackCount()
        self:StartIntervalThink(15)
    end
end

function modifier_familiar_attack_damage_lua:OnIntervalThink()
    local new_stack_count = self:GetStackCount() + 1
    if new_stack_count > 7 then
        new_stack_count = 7
    end
    self:SetStackCount(new_stack_count)
end

function modifier_familiar_attack_damage_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_familiar_attack_damage_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_FINISHED
    }
    return funcs
end

function modifier_familiar_attack_damage_lua:IsHidden()
    return false
end

function modifier_familiar_attack_damage_lua:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount() * self.damage_per_charge
end

function modifier_familiar_attack_damage_lua:OnAttackFinished(event)
    if event.attacker == self:GetParent() then
        local new_stack_count = self:GetStackCount() - 1
        if new_stack_count <= 0 then
            new_stack_count = 0
        end
        self:SetStackCount(new_stack_count)
    end
end

function modifier_familiar_attack_damage_lua:refreshStackCount()
    self:SetStackCount(7)
end