function enableCourier(event)
    local caster = event.caster
   -- caster:GetPlayerOwner():SpawnCourierAtPosition(caster:GetAbsOrigin()):Destroy()
    caster:GetPlayerOwner():SpawnCourierAtPosition(caster:GetAbsOrigin())
end

function go_to_secret(event)
    if event.caster:GetTeam() == DOTA_TEAM_GOODGUYS then
        event.caster:MoveToPosition(Vector(-4487, 1253, 384))
    else
        event.caster:MoveToPosition(Vector(3462, 235, 384))
    end
end

function flyingUpgradeChecker(event)
    -- DeepPrintTable(event)
    local entity = event.caster
    local ability = event.ability
    if entity:HasModifier("modifier_courier_flying_upgrade_active") then
        entity:SetModel("models/props_gameplay/donkey_wings.vmdl")
        return
    end
    if entity:HasItemInInventory("item_flying_courier_datadriven") then
        ability:ApplyDataDrivenModifier(entity, entity, "modifier_courier_flying_upgrade_active", {})
        entity:SetBaseMaxHealth(150)
        entity:RemoveItem(entity:FindItemInInventory("item_flying_courier_datadriven"))
        entity:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
        entity:SetModel("models/props_gameplay/donkey_wings.vmdl")
        entity:RemoveModifierByName("modifier_courier_ground_visual")
    else
        entity:SetModel("models/props_gameplay/donkey.vmdl")
        if not entity:HasModifier("modifier_courier_ground_visual") then
            ability:ApplyDataDrivenModifier(entity, entity, "modifier_courier_ground_visual", {})
        end
    end
end