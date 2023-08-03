function tombstoneHandleIntervalThink(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	CreateUnitByNameAsync("npc_dota_unit_undying_zombie",
		target:GetAbsOrigin(),
		true, 
		caster,
		caster,
		caster:GetTeam(),
		function(unit)
			unit:AddNewModifier(caster, ability, "modifier_kill", { duration = caster:FindModifierByName("modifier_kill"):GetRemainingTime() })
			unit:MoveToTargetToAttack(target)
			unit.zombie_attack_target = target
		end)
end
