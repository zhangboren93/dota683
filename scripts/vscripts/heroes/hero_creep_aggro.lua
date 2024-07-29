function handleOrder(event)
	local caster = event.caster
	local ability = event.ability
	aggroCreeps(caster, ability)
end

function handleAttackStart(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	-- Using default creep not , disabling creep agro logic
	--if target == nil 
	--	or target:GetTeam() == attacker:GetTeam() 
	--	or target:GetClassname() == "dota_item_drop"
	--	or target:GetClassname() == "dota_item_rune"
	--	or not target:IsHero()
	--	or not ability:IsCooldownReady() 
	--	or attacker:HasModifier("modifier_no_creep_aggro_on_attack") then
	--	return
	--end
	--aggroCreeps(attacker, ability)
	
	-- attacking rosh outside pit? stop
	if target:GetUnitName() == "npc_dota_roshan_datadriven" then
		--[3342.108643 -1544.372314 0.000000]
		--[3858.819580 -2365.599609 0.000000]
		local pos = attacker:GetAbsOrigin()
		if pos.x < 3342 or pos.y < -2365 then
			print("Attacking roshan out of range")
			attacker:Stop()
			attacker:AddNewModifier(attacker, nil, "modifier_disarmed", { duration =  1 })
		end
	end
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

function handleDestroy(event)
	local target = event.target
	if target:IsAlive() then
		local ai = target:FindModifierByName("modifier_creep_ai")
		if ai ~= nil and ai.target ~= nil then
			ai.target = nil
			ai:OnAggroEnded()
		end
	end
end
