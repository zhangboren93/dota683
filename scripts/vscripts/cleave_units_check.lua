cleave_disabling_units_name = {
	"npc_dota_templar_assassin_psionic_trap",
	"npc_dota_juggernaut_healing_ward",
	"npc_dota_venomancer_plague_ward",
	"npc_dota_weaver_swarm",
	"npc_dota_unit_tombstone",
	"npc_dota_shadow_shaman_ward",
	"npc_dota_tusk_frozen_sigil",
	"npc_dota_phoenix_sun",
	"npc_dota_pugna_nether_ward",
	"npc_dota_gyrocopter_homing_missile",
	"npc_dota_rattletrap_cog",
	"npc_dota_techies_land_mine",
	"npc_dota_techies_stasis_trap",
	"npc_dota_techies_remote_mine_datadriven"
}

function IsCleaveDisablingUnit(unit)
	for i=1,#cleave_disabling_units_name do
		if string.find(unit:GetUnitName(), cleave_disabling_units_name[i]) ~= nil  then
			return true
		end
	end
	return false
end

function passCleaveUnitCheck(attacker, target)
	return (not target:IsBuilding() 
        and     attacker:GetTeam() ~= target:GetTeam() 
		and not attacker:IsIllusion()
        and not attacker:IsRangedAttacker() 
		and not IsCleaveDisablingUnit(target)
		and not target:IsWard())
end
