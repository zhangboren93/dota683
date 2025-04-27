UNLIFESTEALABLE_UNITS = {
	npc_dota_venomancer_plague_ward_1 = true,
	npc_dota_venomancer_plague_ward_2 = true,
	npc_dota_venomancer_plague_ward_3 = true,
	npc_dota_venomancer_plague_ward_4 = true,
	npc_dota_shadow_shaman_ward_1 = true,
	npc_dota_shadow_shaman_ward_2 = true,
	npc_dota_shadow_shaman_ward_3 = true,
	npc_dota_observer_wards = true,
	npc_dota_sentry_wards = true,
	npc_dota_juggernaut_healing_ward = true,
	npc_dota_tusk_frozen_sigil1 = true,
	npc_dota_tusk_frozen_sigil2 = true,
	npc_dota_tusk_frozen_sigil3 = true,
	npc_dota_tusk_frozen_sigil4 = true,
	npc_dota_phoenix_sun = true,
	npc_dota_weaver_swarm = true,
	npc_dota_techies_land_mine = true,
	npc_dota_techies_remote_mine_datadriven = true,
	npc_dota_techies_stasis_trap = true
}
function IsUnitLifeStealable(unit)
	--print("IsUnitLifeStealable " .. unit:GetUnitName())
	if UNLIFESTEALABLE_UNITS[unit:GetUnitName()] then
		return false
	end
	return true
end
