function enableCourier(event)
    local caster = event.caster
    caster:GetPlayerOwner():SpawnCourierAtPosition(caster:GetAbsOrigin())
end

function toggle_share(event)
    event.caster.isSharedWithTeam = true
    -- TODO share courier alert to team
    event.ability:Destroy()
end