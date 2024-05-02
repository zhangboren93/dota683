function handleAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local units = FindUnitsInRadius(
        caster:GetTeam(),
        target:GetAbsOrigin(),
        nil,
        250,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false)
    for i=1,#units do
        if units[i] ~= target then
            local distance = (units[i]:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()
            local damage = event.Damage
            if distance >= 150 then
                damage = damage / 4
            elseif distance >= 50 then
                damage = damage / 2
            end
            ApplyDamage({
                victim = units[i],
                attacker = caster,
                damage = damage,
                damage_type = DAMAGE_TYPE_PHYSICAL,
                ability = ability
            })
        end
    end
end
