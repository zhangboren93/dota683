function handleAbilityExecuted(event)
	local event_ability = event.event_ability
	local ability = event.ability
	local caster = event.caster
	if event_ability:GetName() == "abaddon_borrowed_time" and caster:HasScepter() then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_borrowed_time_aghs_aura", 
			{ duration = event_ability:GetSpecialValueFor("duration") })
	end
end

function handleAllyTakeDamage(event)
	local damage = event.Damage
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	local heal_amount = damage * ability:GetSpecialValueFor("ally_redirect_dmg_pct") / 100
	local borrowed_time_ability = caster:FindAbilityByName("abaddon_borrowed_time");
	unit:Heal(heal_amount, borrowed_time_ability)
	caster:Heal(heal_amount, borrowed_time_ability)
end
