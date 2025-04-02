function handleAbilityExecuted(event)
	local caster = event.caster
	if event.event_ability:GetName() == "rubick_spell_steal" then
		caster:RemoveAbilityByHandle(caster:GetAbilityByIndex(3))
		caster:RemoveAbilityByHandle(caster:GetAbilityByIndex(4))
		local target = event.target
		local necromastery = target:FindModifierByName("modifier_necromastery")
		if necromastery ~= nil then
			caster.necromastery_count = necromastery:GetStackCount()
		end
	elseif event.event_ability:GetName() == "spectre_haunt" then
		caster:RemoveAbility("spectre_reality")
		local reality = caster:FindAbilityByName("spectre_reality_datadriven")
		if reality == nil then
			reality = caster:AddAbility("spectre_reality")
		end
		reality:SetLevel(1)
	end
end
