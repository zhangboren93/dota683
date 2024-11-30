function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasScepter() then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sven_gods_strength_aghs_aura", {})
	end
end
