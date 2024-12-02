require("../../root_modifiers")

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
