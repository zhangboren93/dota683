function handleSpellStart(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local duration = ability:GetSpecialValueFor("empower_duration")
	target:AddNewModifier(caster, ability, "modifier_magnataur_empower_cleave_lua", { duration = duration })
	caster:EmitSound("Hero_Magnataur.Empower.Cast")
	target:EmitSound("Hero_Magnataur.Empower.Target")
end
