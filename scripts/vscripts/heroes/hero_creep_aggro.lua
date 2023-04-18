function handleOrder(event)
	local caster = event.caster
	local ability = event.ability
	aggroCreeps(caster, ability)
end

function handleAttackStart(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	print(target:GetName())
	print(attacker:GetName())
	print(ability:GetName())
	if target == nil 
		or target:GetTeam() == attacker:GetTeam() 
		or not target:IsHero()
		or not ability:IsCooldownReady() then
		return
	end
	aggroCreeps(attacker, ability)
end

function aggroCreeps(caster, ability)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 
		500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	for i=1,#units do
		if units[i]:CanEntityBeSeenByMyTeam(caster) then
			ability:ApplyDataDrivenModifier(units[i], units[i], "modifier_creep_aggroed_datadriven", {})
			units[i]:MoveToTargetToAttack(caster)
			local ai = units[i]:FindModifierByName("modifier_creep_ai")
			if ai ~= nil then
				ai.target = {
					unit = caster,
					priority = 3 -- attacking hero
				}
				ai.state = 1 -- attacking
			end
		end
	end
	ability:StartCooldown(3)
end