function handleSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local barrier_debuff_duration = ability:GetSpecialValueFor("barrier_debuff_duration")
	local units = FindUnitsInRadius(caster:GetTeam(),
		caster:GetAbsOrigin(), nil,
		ability:GetSpecialValueFor("barrier_radius"),
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		FIND_ANY_ORDER,	false)
	for i=1,#units do
		local unit = units[i]
		if not unit:HasModifier("modifier_item_pipe_barrier_debuff_datadriven") then
			unit:AddNewModifier(caster, ability, "modifier_item_pipe_barrier_lua",
				{ duration = ability:GetSpecialValueFor("barrier_duration") })
			if barrier_debuff_duration > 0 then
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_item_pipe_barrier_debuff_datadriven",
					{ duration = barrier_debuff_duration })
			end
		end
	end
	caster:EmitSound("DOTA_Item.Pipe.Activate")
end
