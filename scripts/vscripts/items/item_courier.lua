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

function go_to_secret(event)
    if event.caster:GetTeam() == DOTA_TEAM_GOODGUYS then
        event.caster:MoveToPosition(Vector(-4487, 1253, 384))
    else
        event.caster:MoveToPosition(Vector(3462, 235, 384))
    end
end