function quelling_blade_attack_landed(keys)
	local target = keys.target
    local attacker = keys.attacker
    local ability = keys.ability
    if target:IsCreep() and target:GetTeamNumber() ~= attacker:GetTeamNumber() then
        local damage_bonus = 0
        if attacker:IsRangedAttacker() then
            damage_bonus = ability:GetSpecialValueFor("damage_bonus_ranged")
        else
            damage_bonus = ability:GetSpecialValueFor("damage_bonus")
        end
        local damage_bonus = attacker:GetAttackDamage() * damage_bonus / 100
        ApplyDamage(
            {
                victim = target, 
                attacker = attacker,
                damage = damage_bonus,
                damage_type = DAMAGE_TYPE_PHYSICAL,
            })
    end
end

function quelling_blade_kill_tree(keys)
	local target = keys.target
    local attacker = keys.attacker
    local ability = keys.ability
    if target:GetClassname() == "ent_dota_tree" then
        target:CutDown(attacker:GetTeamNumber())
    end
end