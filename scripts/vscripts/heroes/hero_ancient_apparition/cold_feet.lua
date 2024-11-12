--[[Author: Pizzalol
	Date: 13.02.2015.
	Saves the target in the caster so that we can transfer it later]]
function ColdFeetInitializeCaster( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	caster:EmitSound("Hero_Ancient_Apparition.ColdFeetCast")

	if target:TriggerSpellAbsorb(ability) then return end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_cold_feet_debuff_datadriven", { duration = 4 })
	CreateUnitByNameAsync("npc_dummy_unit", target:GetAbsOrigin(), false, caster, caster, caster:GetTeam(), function(unit)
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_cold_feet_thinker_datadriven", {})
		unit:AddNewModifier(caster, ability, "modifier_kill", { duration = 4 })
		unit.cold_feet_target = target
	end)
end

--[[Author: Pizzalol
	Date: 13.02.2015.
	Checks if the target is alive to decide if it should kill the thinker
	If the target is alive then it checks if the leash distance is broken
	if it is broken then remove the thinker and the debuff from the target]]
function ColdFeetLeashCheck( keys )
	local caster = keys.caster
	local thinker = keys.target
	local ability = keys.ability
	local modifier = keys.modifier

	local leash_range = ability:GetLevelSpecialValueFor("break_distance", ability:GetLevel() - 1)	
	local target = thinker.cold_feet_target

	if target:IsAlive() and IsValidEntity(target) then
		local thinker_location = thinker:GetAbsOrigin()
		local target_location = target:GetAbsOrigin()
		local distance = (target_location - thinker_location):Length2D()

		if distance > leash_range then
			target:RemoveModifierByNameAndCaster(modifier, caster)
			thinker:RemoveSelf()
		end
	else
		thinker:RemoveSelf()
	end
end
