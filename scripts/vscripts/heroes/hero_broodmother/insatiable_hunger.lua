function handleAbilityExecuted(event)
	local event_ability = event.event_ability
	if event_ability:GetName() == "broodmother_insatiable_hunger" then
		local ability = event.ability
		local caster = event.caster
		local bonus_damage = event_ability:GetSpecialValueFor("bonus_damage_tooltip")
		local modifier_count = bonus_damage / 10
		for i=1,modifier_count do
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_insatiable_hunger_damage_datadriven", {})
		end
	end
end
