function tombstoneHandleIntervalThink(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	CreateUnitByNameAsync("npc_dota_unit_undying_zombie",
		target:GetAbsOrigin(),
		true, 
		caster:GetOwner(),
		caster:GetOwner(),
		caster:GetTeam(),
		function(unit)
			local duration = 0.1
			if caster:IsAlive() then
				duration = caster:FindModifierByName("modifier_kill"):GetRemainingTime() 
			end
			unit:AddNewModifier(caster, ability, "modifier_kill", { duration = duration })
			unit:MoveToTargetToAttack(target)
			unit.zombie_attack_target = target
			unit.tombstone = caster
			unit:FindAbilityByName("undying_tombstone_zombie_deathstrike_datadriven"):SetLevel(
				ability:GetLevel())
			unit:FindAbilityByName("neutral_spell_immunity"):SetLevel(1)
			unit:FindAbilityByName("creep_piercing"):SetLevel(1)
		end)
end

function deathstrikeHandleIntervalThink(event)
	local target = event.target
	local attack_target = target.zombie_attack_target
	local ability = event.ability
	local threshold = ability:GetSpecialValueFor("health_threshold_pct")
	local fixed_threshold = ability:GetSpecialValueFor("health_threshold_fixed")
	if not target.tombstone:IsAlive() or not attack_target:IsAlive() or not target:CanEntityBeSeenByMyTeam(attack_target) then
		target:ForceKill(false)
		return
	end
	target:MoveToTargetToAttack(attack_target)
	if attack_target:GetHealth() * 100 < attack_target:GetMaxHealth() * threshold
		or attack_target:GetHealth() < fixed_threshold then
		target:AddNewModifier(target, ability, "modifier_undying_zombie_deathstrike_active_lua", { duration = 1 })
	else
		target:RemoveModifierByName("modifier_undying_zombie_deathstrike_active")
	end
end
