function quelling_blade_kill_tree(keys)
	local target = keys.target
    local attacker = keys.attacker
    local ability = keys.ability
    if target:GetClassname() == "ent_dota_tree" then
        target:CutDown(attacker:GetTeamNumber())
    end
    if target:GetName() == "npc_dota_ward_base" or target:GetName() == "npc_dota_ward_base_truesight" then
        target:Kill(ability, attacker)
    end
end

function quelling_blade_attack_start(event)
    local target = event.target
    local attacker = event.attacker
    local ability = event.ability
    if target:IsCreep() and target:GetTeamNumber() ~= attacker:GetTeamNumber() and target:GetName() ~= "npc_dota_roshan" then
        if attacker:IsRangedAttacker() then
            ability:ApplyDataDrivenModifier(attacker, attacker, "item_quelling_blade_active_ranged_modifier", {})
        else
           -- print("Adding bonus damage modifier")
            ability:ApplyDataDrivenModifier(attacker, attacker, "item_quelling_blade_active_melee_modifier", {})
        end
    else
        attacker:RemoveModifierByName("item_quelling_blade_active_ranged_modifier")
        attacker:RemoveModifierByName("item_quelling_blade_active_melee_modifier")
    end
end