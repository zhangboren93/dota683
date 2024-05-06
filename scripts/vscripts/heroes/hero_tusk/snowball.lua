require("../../items/item_magic_stick")
function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local windup = ability:GetSpecialValueFor("snowball_windup")
	ProcsMagicStick(event)
	local dummyUnit = CreateUnitByName("npc_dummy_unit_snowball",
						caster:GetAbsOrigin(),
						false,
						caster,
						caster,
						caster:GetTeam())
	caster:EmitSound("Hero_Tusk.Snowball.Cast")
	caster:EmitSound("Hero_Tusk.Snowball.Loop")
	ability:ApplyDataDrivenModifier(caster, dummyUnit, "modifier_tusk_snowball_moving_lua", { 
		duration = 7, target = target:GetEntityIndex() })
	ability:ApplyDataDrivenModifier(caster, dummyUnit, "modifier_kill", { duration = 7 })
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_tusk_snowball_start_datadriven", { duration = windup }) 
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_tusk_snowball_follow_datadriven", { duration = 7 })
	local launchAbility = caster:FindAbilityByName("tusk_launch_snowball_datadriven")
	launchAbility:SetLevel(1)
	caster:SwapAbilities("tusk_launch_snowball_datadriven", "tusk_snowball_datadriven", true, false)
	caster.snowballAllies = {}
	caster.snowballUnit = dummyUnit
	gatherAllyHeroes(caster, ability)
	if caster.targetParticle == nil then
		caster.targetParticle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_tusk/tusk_snowball_target.vpcf",
			PATTACH_OVERHEAD_FOLLOW, target, caster:GetTeam())
	end
end

function handleModifierStartDestroy(event)
	local ability = event.ability
	local caster = event.caster
	local duration = ability:GetSpecialValueFor("snowball_duration")
	caster:SwapAbilities("tusk_launch_snowball_datadriven", "tusk_snowball_datadriven", false, true)
end

function handleFollowIntervalThink(event)
	local caster = event.caster
	if caster.snowballUnit ~= nil then
		caster:SetAbsOrigin(caster.snowballUnit:GetAbsOrigin())
	end
end

function handleLaunch(event)
	local caster = event.caster
	caster:RemoveModifierByName("modifier_tusk_snowball_start_datadriven")
end

function handleStartIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	gatherAllyHeroes(caster, ability)
end

function gatherAllyHeroes(caster, ability)
	local alliedUnits = FindUnitsInRadius(caster:GetTeam(),
		caster:GetAbsOrigin(),
		caster, 100, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
		FIND_ANY_ORDER,
		false)
	for i=1,#alliedUnits do
		if alliedUnits[i] ~= caster and not alliedUnits[i]:HasModifier("modifier_tusk_snowball_ally_datadriven") then
			table.insert(caster.snowballAllies, alliedUnits[i])
			ability:ApplyDataDrivenModifier(caster, alliedUnits[i], "modifier_tusk_snowball_ally_datadriven", { duration = 7 })
			ability:ApplyDataDrivenModifier(caster, alliedUnits[i], "modifier_tusk_snowball_follow_datadriven", { duration = 7 })
			alliedUnits[i]:EmitSound("Hero_Tusk.Snowball.Ally")
		end
	end
end
