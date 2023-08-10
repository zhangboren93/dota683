function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	balenceOrbBonus(caster, ability, "invoker_quas", "modifier_invoker_quas_instance", "modifier_invoker_quas_regen_unit")
	balenceOrbBonus(caster, ability, "invoker_wex", "modifier_invoker_wex_instance", "modifier_invoker_wex_as_unit")
	balenceOrbBonus(caster, ability, "invoker_exort", "modifier_invoker_exort_instance", "modifier_invoker_exort_damage_unit")
end

function balenceOrbBonus(caster, ability, orb, orb_modifier, bonus_modifier)
	local target_ability = caster:FindAbilityByName(orb)
	local target_modifier_count = #caster:FindAllModifiersByName(orb_modifier) * target_ability:GetLevel()
	local actual_modifier_count = #caster:FindAllModifiersByName(bonus_modifier)
	if target_modifier_count > actual_modifier_count then
		for i=actual_modifier_count,target_modifier_count - 1 do
			ability:ApplyDataDrivenModifier(caster, caster, bonus_modifier, {})
		end
	elseif target_modifier_count < actual_modifier_count then
		for i=target_modifier_count, actual_modifier_count - 1 do
			caster:RemoveModifierByName(bonus_modifier)
		end
	end
end
