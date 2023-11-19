function handleOrder(event)
	local caster = event.caster
	local ability = event.ability
	aggroCreeps(caster, ability)
end

function handleAttackStart(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	if target == nil 
		or target:GetTeam() == attacker:GetTeam() 
		or target:GetClassname() == "dota_item_drop"
		or target:GetClassname() == "dota_item_rune"
		or not target:IsHero()
		or not ability:IsCooldownReady() 
		or attacker:HasModifier("modifier_no_creep_aggro_on_attack") then
		return
	end
	aggroCreeps(attacker, ability)
end

function handleCreepAttack(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_creep_aggroed_datadriven", {})
	attacker:MoveToTargetToAttack(caster)
	local ai = attacker:FindModifierByName("modifier_creep_ai")
	if ai ~= nil then
		ai.target = {
			unit = caster,
			priority = 3 -- attacking hero
		}
		ai.state = 1 -- attacking
	end
end

function aggroCreeps(caster, ability)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 
		500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	for i=1,#units do
		if units[i]:CanEntityBeSeenByMyTeam(caster) then
			ability:ApplyDataDrivenModifier(caster, units[i], "modifier_creep_aggro_attacking_datadriven", {})
		end
	end
	ability:StartCooldown(3)
end
