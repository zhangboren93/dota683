require("../../root_modifiers")
function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    local target = keys.target
    if event_ability:GetName() == "legion_commander_press_the_attack" then
        local bonus = unit:FindAbilityByName("legion_commander_press_the_attack_as_datadriven")
        bonus:SetLevel(event_ability:GetLevel())
        bonus:ApplyDataDrivenModifier(unit, target, "modifier_legion_press_active_datadriven", {})
    elseif event_ability:GetName() == "legion_commander_duel" then
		local duration = event_ability:GetSpecialValueFor("duration")
		unit:AddNewModifier(unit, event_ability, "modifier_legion_commander_duel_ignore_ethreal_lua", { duration = duration })
		target:AddNewModifier(unit, event_ability, "modifier_legion_commander_duel_ignore_ethreal_lua", { duration = duration})
    end
end

function PtAStart(event)
	local target = event.target
    local ability = event.ability
    ability:ApplyDataDrivenModifier(event.caster, target, "modifier_legion_commander_press_the_attack_datadriven", {})
    target:Purge(false, true, false, true, true)
end
