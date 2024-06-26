function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local duration = ability:GetSpecialValueFor("duration")
	caster:EmitSound("Hero_EmberSpirit.FlameGuard.Cast")
	caster:EmitSound("Hero_EmberSpirit.FlameGuard.Loop")
	local modifier = caster:AddNewModifier(caster, ability, "modifier_ember_spirit_flame_guard_lua", { duration = duration })
	modifier.flame_guard_absorb_amount = ability:GetSpecialValueFor("absorb_amount")
end
