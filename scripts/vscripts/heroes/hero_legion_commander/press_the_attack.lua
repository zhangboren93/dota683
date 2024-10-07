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
    local modifier = ability:ApplyDataDrivenModifier(event.caster, target, "modifier_legion_commander_press_the_attack_datadriven", {})
	if target.press_attack_particle_id == nil then
		target.press_attack_particle_id = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(target.press_attack_particle_id, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0, 0, 0), false)
	end
    target:Purge(false, true, false, true, true)
end

function handleDestroy(event)
	local target = event.target
	if target.press_attack_particle_id ~= nil then
		ParticleManager:DestroyParticle(target.press_attack_particle_id, false)
		target.press_attack_particle_id = nil
	end
end
