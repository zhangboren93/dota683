function handleIntervalThink(event)
	local caster = event.caster
	if not caster:HasModifier("modifier_pudge_rot") then
		caster:RemoveModifierByName("modifier_pudge_rot_suicide_active")
	end
	local ability_rot = caster:FindAbilityByName("pudge_rot")
	local nextRotDamage = ability_rot:GetSpecialValueFor("rot_damage") / 5 *
		(1 - caster:Script_GetMagicalArmorValue(false, ability_rot))
	if caster:GetHealth() < nextRotDamage / 2 then
		caster:Kill(ability_rot, caster)
	end
end
