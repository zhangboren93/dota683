function handleDeath(event)
	local caster = event.caster
	if caster:IsReincarnating() then
		return
	end
	local ability = event.ability
	local bonus_respawn_time = ability:GetLevelSpecialValueFor("bonus_respawn_time", caster:GetLevel() - 1)
	print(caster:GetName())
	print(ability:GetName())
	print(bonus_respawn_time)

	local new_time_until_respawn = caster:GetRespawnTime() + bonus_respawn_time
	if new_time_until_respawn < 0 then
		new_time_until_respawn = 0
	end
	caster:SetTimeUntilRespawn(new_time_until_respawn)
end