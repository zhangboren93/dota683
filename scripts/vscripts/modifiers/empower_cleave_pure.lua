if modifier_empower_cleave_pure == nil then
    modifier_empower_cleave_pure = class({})
end

function modifier_empower_cleave_pure:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_empower_cleave_pure:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_empower_cleave_pure:IsHidden()
    return true
end

function modifier_empower_cleave_pure:OnAttackLanded(keys)
    if keys.attacker == self:GetParent() then
        --print("OnAttackLanded")
        --print(keys.target:GetName())
        --print(keys.attacker:GetName())
        if not keys.attacker:HasModifier("modifier_magnataur_empower") then
            self:Destroy()
            return
        end
	    keys.attacker.tidetarget = keys.target
    end
end