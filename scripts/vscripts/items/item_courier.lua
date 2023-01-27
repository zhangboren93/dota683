function enableCourier(event)
    local caster = event.caster
    caster:GetPlayerOwner():SpawnCourierAtPosition(caster:GetAbsOrigin())
end

function toggle_share(event)
    event.caster.isSharedWithTeam = true
    GameRules:SendCustomMessageToTeam("已分享信使",
        event.caster:GetPlayerOwnerID(),
        event.caster:GetPlayerOwnerID(),
        event.caster:GetTeam())
    event.ability:Destroy()
end