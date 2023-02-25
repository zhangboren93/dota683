function enableCourier(event)
    local caster = event.caster
    caster:GetPlayerOwner():SpawnCourierAtPosition(caster:GetAbsOrigin())
end

function toggle_share(event)
    event.caster.isSharedWithTeam = true
    CustomGameEventManager:Send_ServerToTeam(event.caster:GetTeam(), "courier_shared", {})
    event.caster:SetThink(function()
        CustomGameEventManager:Send_ServerToTeam(event.caster:GetTeam(), "error_message_clear", {})
    end, "suppress error message", 5)
    event.ability:Destroy()
end