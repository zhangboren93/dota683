function enableCourier(event)
    local caster = event.caster
    caster:GetPlayerOwner():SpawnCourierAtPosition(caster:GetAbsOrigin())
end

function toggle_share(event)
    local team = event.caster:GetTeam()
    local count = PlayerResource:GetPlayerCountForTeam(team) 
    for i=1,count do
        local playerId = PlayerResource:GetNthPlayerIDOnTeam(team, i)
        print("Sharing courier with player " .. playerId)
        event.caster:SetControllableByPlayer(playerId, false)
    end
    GameRules:SendCustomMessageToTeam("已分享信使",
        event.caster:GetPlayerOwnerID(),
        event.caster:GetPlayerOwnerID(),
        team)
    event.ability:Destroy()
end