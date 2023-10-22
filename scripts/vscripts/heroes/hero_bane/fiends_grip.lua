function handleAttacked(event)
	-- Variables
	local caster = event.caster
	local attacker = event.attacker
	local ability = caster:FindAbilityByName("bane_nightmare")

	if attacker:GetTeamNumber() ~= caster:GetTeamNumber() then
		attacker:AddNewModifier(caster, ability, "modifier_bane_nightmare", { duration = ability:GetSpecialValueFor("duration")})
	end
end
