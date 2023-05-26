if modifier_familiar_attack_damage_lua == nil then
    modifier_familiar_attack_damage_lua = class({})
end

function modifier_familiar_attack_damage_lua:OnCreated()
    if IsServer() then
        self.summon_ability = self:GetParent():GetPlayerOwner():GetAssignedHero():FindAbilityByName("visage_summon_familiars")
        self:refreshStackCount()
    end
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
    return self:GetStackCount() * 1
end

function modifier_familiar_attack_damage_lua:OnAttackFinished(event)
    if event.attacker == self:GetParent() then
        local new_stack_count = self:GetStackCount() - self.summon_ability:GetSpecialValueFor("damage_per_charge")
        if new_stack_count <= 0 then
            new_stack_count = 0
        end
        self:SetStackCount(new_stack_count)
    end
end

function modifier_familiar_attack_damage_lua:refreshStackCount()
    self:SetStackCount(self.summon_ability:GetSpecialValueFor("damage_per_charge") * 7)
end