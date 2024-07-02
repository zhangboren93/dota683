function handleIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	if ability:IsCooldownReady() then
		if not caster:HasModifier("modifier_tidebringer_cleave") then
			caster:AddNewModifier(caster, ability, "modifier_tidebringer_cleave", {})
		end
	end
end
