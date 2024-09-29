function growPassive(event)
	local caster = event.caster
    caster:FindAbilityByName("tiny_grow_move_speed_datadriven"):SetLevel(event.caster:FindAbilityByName("tiny_grow"):GetLevel())

	if caster:HasScepter() then
		if caster:FindAbilityByName("tiny_grow"):GetLevel() > 0 then
			if not caster:HasAbility("tiny_tree_grab") then
				local ability = caster:AddAbility("tiny_tree_grab")
				ability:SetLevel(1)
				print("added tiny scepter ability")
			end
			if not caster:HasModifier("modifier_tiny_tree_grab") then
				local ability = caster:FindAbilityByName("tiny_tree_grab")
				caster:AddNewModifier(caster, ability, "modifier_tiny_tree_grab", {})
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
	if not caster:HasModifier("modifier_clinkz_attack_animation") then
		caster:AddNewModifier(caster, event.ability, "modifier_clinkz_attack_animation", {})
	end
end
