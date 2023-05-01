function handleTakeDamage(event)
	if not IsServer() then
		return
	end
	local attacker = event.attacker
	local unit = event.unit
	if attacker:GetTeam() == unit:GetTeam() or not unit:CanEntityBeSeenByMyTeam(attacker) or (attacker:GetAbsOrigin() - unit:GetAbsOrigin()):Length() > 1800 then
		return
	end
	local units = FindUnitsInRadius(unit:GetTeam(), unit:GetAbsOrigin(), unit, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, 0, true)
	for i=1,#units do
		local unit = units[i]
		if unit:HasModifier("modifier_creep_ai") then
			local creep_ai = unit:FindModifierByName("modifier_creep_ai")
			creep_ai.alert_target = attacker
		end
	end
end