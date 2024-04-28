function handleAttackStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local proc_chance = ability:GetSpecialValueFor("proc_chance")
	if caster:IsIllusion() or target:IsBuilding() then
		return
	end
	if RandomInt(1, 100) <= proc_chance then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_headshot_on_hit_datadriven", { duration = 1 })
	end
end
