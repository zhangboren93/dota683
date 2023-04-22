function handleIntervalThink(event)
    local caster = event.caster
    local ability = event.ability
    local isDaytime = GameRules:IsDaytime()
    if isDaytime and caster:HasModifier("modifier_move_speed_cancel_active_datadriven") then
        caster:RemoveModifierByName("modifier_move_speed_cancel_active_datadriven")
    end
    if not isDaytime and not caster:HasModifier("modifier_move_speed_cancel_active_datadriven") and ability:IsCooldownReady() then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_move_speed_cancel_active_datadriven", {})
    end
end

function handleAttack(event)
    local caster = event.caster
    local ability = event.ability
    caster:RemoveModifierByName("modifier_move_speed_cancel_active_datadriven")
    ability:StartCooldown(ability:GetCooldown(1))
end

function handleTakeDamage(event)
    local attacker = event.attacker
    local ability = event.ability
    local unit = event.unit
    --print(attacker:GetPlayerOwnerID())
    if attacker:GetPlayerOwnerID() >= 0 then
        unit:RemoveModifierByName("modifier_move_speed_cancel_active_datadriven")
        ability:StartCooldown(ability:GetCooldown(1))
    end
end