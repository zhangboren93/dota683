function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	if caster.lastLocation ~= nil and ability:GetLevel() >= 3 then
		local distance = (caster:GetAbsOrigin() - caster.lastLocation):Length()
		if distance < 10 then
			if GameRules:GetDOTATime(false, true) - caster.lastLocationTime >= 4 then
				caster:AddNewModifier(caster, ability, "modifier_invisible", {})
			end
			return
		else
			caster:RemoveModifierByName("modifier_invisible")
		end
	end
	caster.lastLocation = caster:GetAbsOrigin()
	caster.lastLocationTime = GameRules:GetDOTATime(false, true)
end

function LevelUpAbility(event)
	local caster = event.caster
	local this_ability = event.ability		
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	-- The ability to level up
	local ability_name = event.ability_name
	local ability_handle = caster:FindAbilityByName(ability_name)	
	local ability_level = ability_handle:GetLevel()

	-- Check to not enter a level up loop
	if ability_level < this_abilityLevel then
		ability_handle:SetLevel(this_abilityLevel)
	end
end

function GetFrontPoint( event )
	local caster = event.caster
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	local distance = event.Distance
	
	local front_position = origin + fv * distance
	return front_position
end

function SetUnitsMoveForward( event )
	local caster = event.caster
	local target = event.target
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	target:SetForwardVector(fv)
end

function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	caster:EmitSound("Hero_Beastmaster.Call.Hawk")
	local loc = GetFrontPoint({	caster = caster, Distance = 150	})
	local duration = ability:GetSpecialValueFor("duration")
	local unit = CreateUnitByNameAsync("npc_dota_beastmaster_hawk_" .. ability:GetLevel(),
			loc, true, caster, caster, caster:GetTeam(), function(unit) 
				unit:AddNewModifier(caster, ability, "modifier_kill", { duration = duration })
				SetUnitsMoveForward({ caster = caster, target = unit })
				unit:SetIdleAcquire(false)
				unit:SetControllableByPlayer(caster:GetPlayerID(), true)
				unit:FindAbilityByName("beastmaster_hawk_invisibility_datadriven"):SetLevel(ability:GetLevel())
			end)
end

function handleLevelUpThink(event)
	local caster = event.caster
	local ability = event.ability
	local boar = caster:FindAbilityByName("beastmaster_call_of_the_wild_boar")
	if boar == nil then return end
	if boar:GetLevel() > ability:GetLevel() then
		ability:SetLevel(boar:GetLevel())
	end
end
