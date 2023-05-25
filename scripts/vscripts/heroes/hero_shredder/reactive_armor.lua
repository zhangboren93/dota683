function handleAttacked(event)
	local caster = event.caster
	local ability = event.ability
	if caster:PassivesDisabled() then
		return
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shredder_reactive_armor_stack_duration", {})
	local modifiers = caster:FindAllModifiersByName("modifier_shredder_reactive_armor_stack_duration")
	if #modifiers <= ability:GetSpecialValueFor("stack_limit") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_shredder_reactive_armor_stack_effect", {})
		caster:FindModifierByName("modifier_shredder_reactive_armor_datadriven"):SetStackCount(#modifiers)
	end
end

function handleDurationDestroy(event)
	local caster = event.caster
	local ability = event.ability
	local modifiers = caster:FindAllModifiersByName("modifier_shredder_reactive_armor_stack_duration")
	if #modifiers <= ability:GetSpecialValueFor("stack_limit") then
		caster:FindModifierByName("modifier_shredder_reactive_armor_datadriven"):SetStackCount(#modifiers)
		local effect_modifiers = caster:FindAllModifiersByName("modifier_shredder_reactive_armor_stack_effect")
		for i=1,#effect_modifiers - #modifiers do
			effect_modifiers[i]:Destroy()
		end
	end
end