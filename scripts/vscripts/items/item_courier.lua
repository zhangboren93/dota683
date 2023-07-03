function enableCourier(event)
    local caster = event.caster
   -- TODO create courier at base
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
    if entity:GetLevel() < 4 then
        entity:UpgradeCourier(4)
    end
    if entity:HasModifier("modifier_courier_flying_upgrade_active") then
        return
    end
    if entity:HasItemInInventory("item_flying_courier_datadriven") then
        ability:ApplyDataDrivenModifier(entity, entity, "modifier_courier_flying_upgrade_active", {})
        entity:SetBaseMaxHealth(150)
        entity:RemoveItem(entity:FindItemInInventory("item_flying_courier_datadriven"))
        entity:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
        entity:RemoveModifierByName("modifier_courier_ground_visual")
        entity:AddNewModifier(entity, entity, "modifier_courier_flying", {})
        entity:SetDayTimeVisionRange(400)
        entity:SetNightTimeVisionRange(400)
        entity:FindAbilityByName("courier_burst"):SetLevel(1)
    else
        if not entity:HasModifier("modifier_courier_ground_visual") then
            ability:ApplyDataDrivenModifier(entity, entity, "modifier_courier_ground_visual", {})
        end
        entity:RemoveModifierByName("modifier_courier_flying")
    end
end

function transforStopChecker(event)
    local entity = event.caster
	if not entity:HasModifier("modifier_courier_transfer_items") then
		CustomGameEventManager:Send_ServerToTeam(entity:GetTeam(), "courier_end_transfer", {})
		entity:RemoveModifierByName("modifier_courier_transfer_stop_checker")
	end
end

function minimapIconChecker(event)
    local entity = event.caster
	if entity.is_primary_courier then
		CreateUnitByNameAsync("npc_dummy_unit_courier", entity:GetAbsOrigin(), true, entity, entity, entity:GetTeam(), function(icon_unit)
			icon_unit:AddNewModifier(entity, nil, "modifier_kill", { duration = 1 })
			event.ability:ApplyDataDrivenModifier(entity, icon_unit, "modifier_courier_minimap_icon", {})
		end)
	end
end
