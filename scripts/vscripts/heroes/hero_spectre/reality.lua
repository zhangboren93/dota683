function handleIntervalThink(event)
	local caster = event.caster
	local haunt = caster:FindAbilityByName("spectre_haunt")
	local reality = caster:FindAbilityByName("spectre_reality")
	if haunt:GetLevel() > 0 and reality:GetLevel() == 0 then
		reality:SetLevel(1)
	end
end
