function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	if caster.lastLocation ~= nil then
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