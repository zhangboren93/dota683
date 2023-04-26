function handleAbilityExecuted(keys)
	local unit = keys.unit
	local ability = keys.ability
	local event_ability = keys.event_ability
	if event_ability:GetName() == "juggernaut_omni_slash" then
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_juggernaut_omni_slash_as_checker", {})
		local count = math.floor((410 - unit:GetDisplayAttackSpeed()) / 10)
		--print(count)
		for i=1,count do
			ability:ApplyDataDrivenModifier(unit, unit, "modifier_juggernaut_omni_slash_as_active", {})
		end
		count = math.floor((220 - unit:GetAttackDamage()) / 10)
		--print(count)
		for i=1,count do
			ability:ApplyDataDrivenModifier(unit, unit, "modifier_juggernaut_omni_slash_dmg_active", {})
		end
	end
end

function handleAttackStart(event)
	local ability = event.ability
	local caster = event.attacker
	if not caster:HasModifier("modifier_juggernaut_omnislash") then
		caster:RemoveAllModifiersOfName("modifier_juggernaut_omni_slash_as_active")
		caster:RemoveAllModifiersOfName("modifier_juggernaut_omni_slash_dmg_active")
		caster:RemoveModifierByName("modifier_juggernaut_omni_slash_as_checker")
	end
end