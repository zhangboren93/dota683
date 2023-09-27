if modifier_cloak_bonus == nil then
    modifier_cloak_bonus = class({})
end

function modifier_cloak_bonus:OnCreated(kv)
    self.kv = kv
end

function modifier_cloak_bonus:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_cloak_bonus:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
    return funcs
end

function modifier_cloak_bonus:IsHidden()
    return true
end

function modifier_cloak_bonus:GetModifierPhysicalArmorBonus()
    local owner = self:GetParent()
    if owner:HasModifier("modifier_visage_gravekeepers_cloak") then
        return self:GetAbility():GetSpecialValueFor("bonus_armor") * owner:GetModifierStackCount("modifier_visage_gravekeepers_cloak", owner)
    else
        return 0
    end
end

function modifier_cloak_bonus:GetModifierMagicalResistanceBonus()
    local owner = self:GetParent()
    if owner:HasModifier("modifier_visage_gravekeepers_cloak") then
        return self:GetAbility():GetSpecialValueFor("bonus_resist") * owner:GetModifierStackCount("modifier_visage_gravekeepers_cloak", owner)
    else
        return 0
    end
end

-- Deprecated

function handleIntervalThink(event)
    local caster = event.caster
    local ability = event.ability
    local modifier = caster:FindModifierByName("modifier_visage_gravekeepers_cloak")
    if modifier == nil then 
        modifier = caster:FindModifierByName("modifier_visage_gravekeepers_cloak_secondary")
        if modifier == nil then 
            caster:RemoveAllModifiersOfName("modifier_cloak_bonus_datadriven")
            return
        end
        modifier = modifier:GetCaster():FindModifierByName("modifier_visage_gravekeepers_cloak")
    else
    end
    local caster2 = modifier:GetCaster()
    local cloak = caster2:FindAbilityByName("visage_gravekeepers_cloak")
    if cloak:GetLevel() == 0 then
        return
    end
    local cloak_bonus = caster:FindAbilityByName("visage_gravekeepers_cloak_bonus_active_datadriven")
    cloak_bonus:SetLevel(cloak:GetLevel())
    for i=1,modifier:GetStackCount() do
        cloak_bonus:ApplyDataDrivenModifier(caster2, caster, "modifier_cloak_bonus_datadriven", {})
    end
end