function handleAbilityExecuted(keys)
	local caster = keys.caster
	local event_ability = keys.event_ability
	if event_ability:GetName() == "arc_warden_tempest_double" then
		local health_cost_pct = event_ability:GetSpecialValueFor("health_cost_pct")
		if health_cost_pct > 0 then
			local health_cost = caster:GetHealth() * health_cost_pct / 100
			local mana_cost = caster:GetMana() * health_cost_pct / 100
			caster:Script_ReduceMana(mana_cost, event_ability)
			caster:ModifyHealth(caster:GetHealth() - health_cost, event_abiliy, false, 0)
		end
	end
end