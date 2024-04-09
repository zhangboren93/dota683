function handleAttacked(event)
	local caster = event.caster
	local ability = event.ability
	if caster:PassivesDisabled() then
		return
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shredder_reactive_armor_stack_duration", {})
	handleStackCount(caster, ability)
end

function handleDurationDestroy(event)
	local caster = event.caster
	local ability = event.ability
	handleStackCount(caster, ability)
end

function handleUpgrade(event)
	local caster = event.caster
	local ability = event.ability
	handleStackCount(caster, ability)
end

function handleStackCount(caster, ability)
	local modifiers = caster:FindAllModifiersByName("modifier_shredder_reactive_armor_stack_duration")
	if #modifiers == 0 then
		caster:RemoveModifierByName("modifier_shredder_reactive_armor_stack_effect")
		caster:FindModifierByName("modifier_shredder_reactive_armor_datadriven"):SetStackCount(0)
	else
		local stack_count = math.min(ability:GetSpecialValueFor("stack_limit"), #modifiers)
		local effect_modifier = caster:FindModifierByName("modifier_shredder_reactive_armor_stack_effect")
		if effect_modifier == nil then
			effect_modifier = ability:ApplyDataDrivenModifier(caster, caster, "modifier_shredder_reactive_armor_stack_effect", {})
		end
		effect_modifier:SetStackCount(stack_count)
		caster:FindModifierByName("modifier_shredder_reactive_armor_datadriven"):SetStackCount(stack_count)
	end
end