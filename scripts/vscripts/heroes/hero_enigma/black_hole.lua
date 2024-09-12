function handleSpellStart(event)
	local target_point = event.target_points[1]
	local caster = event.caster
	local ability = event.ability
	local unit = CreateUnitByName("npc_dummy_unit", target_point, false, caster, caster, caster:GetTeam())
	caster.black_hole_unit = unit
	unit:AddNewModifier(caster, ability, "modifier_enigma_black_hole_aura_lua", { duration = 4 }) 
	unit:AddNewModifier(caster, ability, "modifier_kill", { duration = 4 })
	caster:EmitSound("Hero_Enigma.Black_Hole")
end

function handleChannelFinish(event)
	local caster = event.caster
	caster.black_hole_unit:ForceKill(false)
	caster:StopSound("Hero_Enigma.Black_Hole")
end
