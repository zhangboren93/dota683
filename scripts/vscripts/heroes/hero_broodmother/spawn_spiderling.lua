function handleSpideriteDeath(event)
	local ability = event.ability
	local duration = ability:GetSpecialValueFor("spiderite_duration")
	local target = event.unit
	local location = target:GetAbsOrigin()
	local caster = event.caster
	if not target:HasModifier("modifier_broodmother_spawn_spiderlings") then
		CreateUnitByNameAsync("npc_dota_broodmother_spiderite",
						  location,
						  true,
						  caster,
						  caster, 
						  caster:GetTeam(),
						  function(unit)
							unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
							unit:AddNewModifier(caster, ability, "modifier_kill", { duration = duration })
						  end)
	end
end
