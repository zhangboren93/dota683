function enableGlyph(event)
    local team = event.caster:GetTeam()
    local goodTeamTowerNames = {
        "dota_goodguys_tower4_top",
        "dota_goodguys_tower3_mid",
        "dota_goodguys_tower4_bot",
        "dota_goodguys_tower3_top",
        "dota_goodguys_tower1_bot",
        "dota_goodguys_tower3_bot",
        "dota_goodguys_tower2_mid",
        "dota_goodguys_tower2_top",
        "dota_goodguys_tower2_bot",
        "dota_goodguys_tower1_mid",
        "dota_goodguys_tower1_top",
        "good_rax_range_top",
        "good_rax_range_mid",
        "good_rax_melee_bot",
        "good_rax_melee_top",
        "good_rax_melee_mid",
        "good_rax_range_bot",
        "dota_goodguys_fort"
    }
    local badTeamTowerNames = {
        "dota_badguys_tower4_top",
        "dota_badguys_tower3_mid",
        "dota_badguys_tower4_bot",
        "dota_badguys_tower3_top",
        "dota_badguys_tower1_bot",
        "dota_badguys_tower3_bot",
        "dota_badguys_tower2_mid",
        "dota_badguys_tower2_top",
        "dota_badguys_tower2_bot",
        "dota_badguys_tower1_mid",
        "dota_badguys_tower1_top",
        "bad_rax_range_top",
        "bad_rax_range_mid",
        "bad_rax_melee_bot",
        "bad_rax_melee_top",
        "bad_rax_melee_mid",
        "bad_rax_range_bot",
        "dota_badguys_fort"
    }

    local towerNames = {}
    if team == DOTA_TEAM_GOODGUYS then
        GameRules:GetAnnouncer(team):QueueConcept(0.0, 
        {
            announce_event = "glyph_used_good"
        }, nil, GameRules:GetAnnouncer(team), nil)
        towerNames = goodTeamTowerNames
    else
        GameRules:GetAnnouncer(team):QueueConcept(0.0, 
        {
            announce_event = "glyph_used_bad"
        }, nil, GameRules:GetAnnouncer(team), nil)
        towerNames = badTeamTowerNames
    end
    for i = 1,#towerNames do
        local building = Entities:FindByName(nil, towerNames[i])
        if building ~= nil then
            event.ability:ApplyDataDrivenModifier(event.caster, building, "modifier_glyph_active_datadriven", {})
        end
    end
    event.ability:StartCooldown(event.ability:GetCooldown(1))
end