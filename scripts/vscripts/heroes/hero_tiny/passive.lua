function growMoveSpeed(event)
    event.caster:FindAbilityByName("tiny_grow_move_speed_datadriven"):SetLevel(event.caster:FindAbilityByName("tiny_grow"):GetLevel())
    event.caster:FindAbilityByName("tiny_coat_armor_datadriven"):SetLevel(event.caster:FindAbilityByName("tiny_craggy_exterior"):GetLevel())
end

function handleAbilityExecuted(event)
	local event_ability = event.event_ability
	if event_ability:GetName() == "tiny_tree_grab" and not event.caster:HasModifier("modifier_sven_great_cleave_radius") then
		event.caster:AddNewModifier(event.caster, event_ability, "modifier_sven_great_cleave_radius", {})
	end
end
