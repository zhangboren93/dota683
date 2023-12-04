function growPassive(event)
	local caster = event.caster
    caster:FindAbilityByName("tiny_grow_move_speed_datadriven"):SetLevel(event.caster:FindAbilityByName("tiny_grow"):GetLevel())
    caster:FindAbilityByName("tiny_coat_armor_datadriven"):SetLevel(event.caster:FindAbilityByName("tiny_craggy_exterior"):GetLevel())

	if caster:HasScepter() then
		if caster:FindAbilityByName("tiny_grow"):GetLevel() > 0 then
			if not caster:HasAbility("tiny_tree_grab") then
				local ability = caster:AddAbility("tiny_tree_grab")
				ability:SetLevel(1)
				caster:AddNewModifier(caster, ability, "modifier_tiny_tree_grab", {})
				print("added tiny scepter ability")
			end
			if not caster:HasModifier("modifier_sven_great_cleave_radius") then
				local ability = caster:FindAbilityByName("tiny_tree_grab")
				caster:AddNewModifier(caster, ability, "modifier_sven_great_cleave_radius", {})
			end
		end
	else
		if caster:HasAbility("tiny_tree_grab") then
			caster:RemoveAbility("tiny_tree_grab")
			caster:RemoveModifierByName("modifier_tiny_tree_grab")
		end
		if caster:HasModifier("modifier_sven_great_cleave_radius") then
			caster:RemoveModifierByName("modifier_sven_great_cleave_radius")
		end
	end
end
