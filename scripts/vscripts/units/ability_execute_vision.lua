function handleAbilityExecuted(keys)
	local unit = keys.unit
	local ability = keys.ability
	local event_ability = keys.event_ability
	local target_ability = keys.TargetAbility
	if event_ability:GetName() == target_ability then
		ability:SetLevel(event_ability:GetLevel())
		local facingDirection = unit:GetForwardVector()
		print(facingDirection)
		local vision_location = facingDirection * keys.Distance + unit:GetAbsOrigin()
		unit:SetThink(function()
			local thinker = CreateUnitByName("npc_dummy_unit", vision_location, true, unit, unit, unit:GetTeam())
			thinker:SetDayTimeVisionRange(800)
			thinker:SetNightTimeVisionRange(800)
			thinker:AddNewModifier(unit, ability, "modifier_kill", { duration = keys.Duration })
			ability:ApplyDataDrivenModifier(unit, thinker, "modifier_dummy_unit_unselectable", {})
		end, "face distance vision", keys.Delay)
	end
end