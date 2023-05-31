function handleIntervalThink(event)
	local caster = event.caster
	local target = event.target
	--print(target:GetName())
	if target:HasModifier("modifier_ogre_magi_ignite") then
		local modifier = target:FindModifierByName("modifier_ogre_magi_ignite")
		local ability_ignite = caster:FindAbilityByName("ogre_magi_ignite")
		local max_duration = ability_ignite:GetSpecialValueFor("duration")
		if modifier:GetDuration() > max_duration then
			modifier:SetDuration(max_duration, true)
		end
	end
end