--[[Author: Pizzalol
	Date: 09.02.2015.
	Forces the target to attack the caster]]
function BerserkersCall( keys )
	local caster = keys.caster
	local target = keys.target

	-- Clear the force attack target
	target:SetForceAttackTarget(nil)

	-- Give the attack order if the caster is alive
	-- otherwise forces the target to sit and do nothing
	if caster:IsAlive() then
		local order = 
		{
			UnitIndex = target:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = caster:entindex()
		}

		ExecuteOrderFromTable(order)
	else
		target:Stop()
	end

	-- Set the force attack target to be the caster
	target:SetForceAttackTarget(caster)
end

-- Clears the force attack target upon expiration
function BerserkersCallEnd( keys )
	local target = keys.target

	target:SetForceAttackTarget(nil)
end

function handleSpellStart(event)
	local caster = event.caster
	caster:EmitSound("Hero_Axe.Berserkers_Call")
	caster:EmitSound("Hero_Axe.BerserkersCall.Start")
	local ability = event.ability
	local duration = ability:GetSpecialValueFor("duration")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_berserkers_call_armor_datadriven",
		{ duration = duration })
	local units = FindUnitsInRadius(
		caster:GetTeam(), 
		caster:GetAbsOrigin(), nil,
		ability:GetSpecialValueFor("radius"), 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER, false)
	for i=1,#units do
		ability:ApplyDataDrivenModifier(caster, units[i], "modifier_axe_berserkers_call_datadriven", { duration = duration })
		units[i]:Interrupt()
	end
end
