function handleAbilityExecuted(keys)
	local unit = keys.unit
	local ability = keys.ability
	local event_ability = keys.event_ability
	if event_ability:GetName() == "nyx_assassin_vendetta" then
		ability:SetLevel(event_ability:GetLevel())
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_vendetta_physical_damage_active", {})
	end
end

function handleIntervalThink(event)
	local caster = event.caster
	if not caster:HasModifier("modifier_nyx_assassin_vendetta") then
		caster:RemoveModifierByName("modifier_vendetta_physical_damage_active")
	end
end

function handleAttackLanded(event)
	local caster = event.caster
	caster:RemoveModifierByName("modifier_vendetta_physical_damage_active")
end