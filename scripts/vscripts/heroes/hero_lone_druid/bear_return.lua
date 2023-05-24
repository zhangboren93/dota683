function handleTakeDamage(event)
	local attacker = event.attacker
	local unit = event.unit
	if attacker:GetPlayerOwnerID() >= 0 then
		local ability_return = unit:FindAbilityByName("lone_druid_spirit_bear_return")
		if ability_return:IsCooldownReady() or ability_return:GetCooldownTimeRemaining() < 3 then
			ability_return:StartCooldown(3)
		end
	end
end