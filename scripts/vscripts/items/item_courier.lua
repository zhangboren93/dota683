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
	-- Level 4 for flying upgrade visual, Level 10 for respawn time as 120
    if entity:HasModifier("modifier_courier_flying_upgrade_active") then
		-- Level 20 for respawn time as 180
		if entity:GetLevel() ~= 20 then
			entity:UpgradeCourier(20)
		end
        return
    end
    if entity:GetLevel() ~= 10 then
        entity:UpgradeCourier(10)
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
        entity:FindAbilityByName("courier_burst_datadriven"):SetLevel(1)
    else
        if not entity:HasModifier("modifier_courier_ground_visual") then
            ability:ApplyDataDrivenModifier(entity, entity, "modifier_courier_ground_visual", {})
        end
        entity:RemoveModifierByName("modifier_courier_flying")
		entity:FindAbilityByName("courier_burst_datadriven"):SetLevel(0)
    end

	local bottle = entity:FindItemInInventory("item_bottle")
	if bottle ~= nil then
		if bottle:GetCurrentCharges() < 3 then
			if entity:HasModifier("modifier_fountain_aura_buff") then
				bottle:SetCurrentCharges(3)
			else
				ability:ApplyDataDrivenModifier(entity, entity, "modifier_courier_not_full_bottle_datadriven", {})
			end
		end
	end
end

function transforStopChecker(event)
    local entity = event.caster
	if not entity:HasModifier("modifier_courier_transfer_items") then
		CustomGameEventManager:Send_ServerToTeam(entity:GetTeam(), "courier_end_transfer", {})
		entity:RemoveModifierByName("modifier_courier_transfer_stop_checker")
	end
end

function handleBurstSpellStart(event)
	event.ability:ApplyDataDrivenModifier(event.caster, event.caster, "modifier_courier_burst_datadriven", {})
end
