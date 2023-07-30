function handleAbilityExecuted(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local event_ability = event.event_ability
	if event_ability:GetName() == "doom_bringer_scorched_earth" then
		ability:SetLevel(event_ability:GetLevel())
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_doom_bringer_scorched_earth_regen_datadriven", {})
	end
	if event_ability:GetName() == "doom_bringer_doom" and caster:HasScepter() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_doom_apply_break_active", {})
	end
	if event_ability:GetName() == "doom_bringer_devour" then
		if target:HasAbility("harpy_storm_chain_lightning") then
			caster:SetThink(function()
				caster:FindAbilityByName("harpy_storm_chain_lightning"):SetLevel(1)
			end, "devour enables storm chain", 0.1)
		end
		if target:HasAbility("dark_troll_warlord_ensnare") then
			caster:SetThink(function()
				caster:FindAbilityByName("dark_troll_warlord_ensnare"):SetLevel(1)
			end, "devour enables ensnare", 0.1)
		end
	end
end
