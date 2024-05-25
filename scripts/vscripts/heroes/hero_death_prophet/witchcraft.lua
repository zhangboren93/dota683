function handleAbilityExecuted(event) 
	local event_ability = event.event_ability 
	local ability = event.ability
	local caster = event.caster
	if not IsServer() then return end
	if event_ability:GetName() == "death_prophet_carrion_swarm" then
		local mana_cost_adjust = ability:GetSpecialValueFor("carrion_swarm_mana_cost_adjust")
		local cd_adjust = ability:GetSpecialValueFor("carrion_swarm_cooldown_adjust")
		caster:GiveMana(-1 * mana_cost_adjust)
		caster:SetThink(function()
			local carrion_swarm = caster:FindAbilityByName("death_prophet_carrion_swarm")
			local new_cd = carrion_swarm:GetCooldown(-1) + cd_adjust
			carrion_swarm:EndCooldown()
			carrion_swarm:StartCooldown(new_cd)
		end, "courier swarm cd adjust", 0.1)
	end
end
