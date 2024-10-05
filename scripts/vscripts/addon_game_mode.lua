-- Generated from template

require("creepspawn")
require("hero_innate_abilities")
require("kill_bonus")
require("heroes.hero_creep_aggro")
require("building_bounty")
require("root_modifiers")
require("hero_types")
require("ladder_game_mode")
require("end_game")
require("death_match")
require("heroes/hero_respawn_time")
require("game_mode/all_pick")
require("game_mode/captain_draft")
require("game_mode/captain_mode")
require("game_mode/random_draft")
require("game_mode/single_pick")
require("alt_model")
require("game_event_handler")

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

randomBonusGranted = {}
player2BuildingDamage = {}
fwdnocdenabled = 0
sameHeroPickEnabled = false
custom_game_first_pick = "random"
player_last_order_time = {}

function Precache( context )
	--[[
		Precache things we know we'll use.	Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheResource( "particle", "particles/items_fx/immunity_sphere.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_scepter_disarm.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_pitofmalice_stun.vpcf", context)
	PrecacheResource( "soundfile", "soundevents/custom_sounds.vsndevts", context)
	PrecacheResource( "particle", "particles/spray_syf1.vpcf", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
	LinkLuaModifier( "item_pct_mana_regen_modifier_lua",	"items/item_pct_mana_regen.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_equipped_bonus_modifier",		"items/item_equip_bonus.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "item_tpscroll_clear_tree_modifier",	"items/item_tpscroll_clear_trees.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_disable_item_orb",			"libraries/modifiers/modifier_disable_item_orb", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_generic_orb_effect_lua",		"libraries/modifiers/modifier_generic_orb", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_generic_orb_effect_item_lua","libraries/modifiers/modifier_generic_orb_item.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_item_blade_mail_new_active",	"items/item_blade_mail_active.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier( "item_bfury_cleave_lua",               "items/item_bfury.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_quelling_blade_hooks_lua", "items/modifier_item_quelling_blade_hooks.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_heart_regen_lua",		"items/modifier_item_heart_regen.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_ring_of_aquila_lua", 	"items/modifier_item_ring_of_aquila.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_ring_of_basilius_lua", 		"items/modifier_item_ring_of_basilius.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_ring_of_basilius_aura_lua", "items/modifier_item_ring_of_basilius_aura.lua", LUA_MODIFIER_MOTION_NONE)
	--LinkLuaModifier( "modifier_item_ring_of_aquila_aura_lua", 	"items/modifier_item_ring_of_aquila_aura.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_ring_of_aquila_aura_active_lua",	"items/modifier_item_ring_of_aquila_aura_active.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_crimson_guard_lua", 			"items/modifier_item_crimson_guard.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_crimson_guard_extra_lua", 		"items/modifier_item_crimson_guard_extra.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_crimson_guard_nostack_lua", 	"items/modifier_item_crimson_guard_nostack.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_black_king_bar_immune_lua", "items/item_black_king_bar.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_aegis_lua", 		   "items/item_aegis.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_aegis_regen_lua", 	   "items/item_aegis.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_sentry_ward_reveal_invis_aura_lua", 	"modifiers/modifier_sentry_ward_reveal_invis_aura.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_ward_no_collusion_lua", 				"modifiers/modifier_ward_no_collusion.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_helm_of_the_dominator_lua", 	"items/modifier_item_helm_of_the_dominator.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_mask_of_madness_datadriven_berserk", "items/modifier_item_mask_of_madness_datadriven_berserk.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_satanic_datadriven", 			"items/modifier_item_satanic_datadriven.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_satanic_datadriven_unholy_rage","items/modifier_item_satanic_datadriven_unholy_rage.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_desolator_datadriven", 				"items/modifier_item_desolator_datadriven.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_desolator_datadriven_corruption",	"items/modifier_item_desolator_datadriven_corruption.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_maelstrom_datadriven", 				"items/modifier_item_maelstrom_datadriven.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_maelstrom_trigger_no_miss", 				"items/modifier_maelstrom_trigger_no_miss.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_mjollnir_shield_datadriven", 		"items/modifier_item_mjollnir_shield_datadriven.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_vanguard_lua",						"items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_heavens_halberd_datadriven_disarm", "items/modifier_item_heavens_halberd_datadriven_disarm.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_lifesteal_lua",						"items/modifier_item_lifesteal.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_diffusal_lua", 						"items/modifier_item_diffusal.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_diffusal_2_lua", 					"items/modifier_item_diffusal.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_diffusal_purge_slow_datadriven", 		"items/modifier_item_diffusal_slow.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_soul_ring_lua",						"items/item_soul_ring.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_item_soul_ring_buff_lua",				"items/modifier_item_soul_ring_buff.lua", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier( "modifier_counter_healthbar", "modifiers/counter_health.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_tower_bonus_cancel_lua", "modifiers/tower_bonus_cancel.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_fountain_aura_buff_lua", "modifiers/modifier_fountain_aura_buff.lua", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier( "modifier_attribute_regen_adjust", "modifiers/attribute_regen.lua", LUA_MODIFIER_MOTION_NONE)
	--LinkLuaModifier( "modifier_troll_warlord_bash", "modifiers/troll_bash.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_safe_lane_move_speed_bonus", "modifiers/creep.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_cancels_item_on_hit", "modifiers/item_cancel_on_hit.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_ai", "creepai.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_health_bonus", "modifiers/creep_health.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_preparing_lua", "modifiers/modifier_creep_preparing.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_oracle_fortunes_end_purge_lua",	"heroes/hero_oracle/fortunes_end.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_pudge_flesh_magic_resist",		"modifiers/pudge_flesh_magic_resist.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_enchantress_aghs_attack_range",	"modifiers/enchantress_aghs_attack_range.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_sandstorm_channel_end",			"modifiers/sandstorm_channel_end.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_drop_backpack_items",			"modifiers/drop_backpack_items.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_familiar_attack_damage_lua",		"modifiers/familiar_attack_bonus.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_kill_tree_on_death", 			"modifiers/kill_tree_on_death.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_bounty_hunter_track_lua",		"heroes/hero_bounty_hunter/modifier_bounty_hunter_track.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_bounty_hunter_track_aura_lua", 	"heroes/hero_bounty_hunter/modifier_bounty_hunter_track_aura.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_bounty_hunter_track_effect_lua",	"heroes/hero_bounty_hunter/modifier_bounty_hunter_track_effect.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_beastmaster_wild_axes_damage_lua", "heroes/hero_beastmaster/modifier_beastmaster_wild_axes_damage.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_lone_druid_rabid_lua", 			"heroes/hero_lone_druid/modifier_lone_druid_rabid.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_thunder_strike_after_death_lua", "heroes/hero_disruptor/modifier_thunder_strike_after_death.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_blood_rage_lua",					"heroes/hero_bloodseeker/bloodrage.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_cloak_bonus",					"heroes/hero_visage/cloak_bonus.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_death_prophet_silence_lua",					"heroes/hero_death_prophet/silence.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_doom_bringer_scorched_earth_buff_lua",		"heroes/hero_doom_bringer/scorched_earth.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_doom_bringer_scorched_earth_buff_aura_lua",	"heroes/hero_doom_bringer/scorched_earth.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_frost_arrows_slow_datadriven",		"heroes/hero_drow_ranger/frost_arrow.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_ability_elder_dragon_form",			"heroes/hero_dragon_knight/elder_dragon_form.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_ability_elder_dragon_form_corrosive", "heroes/hero_dragon_knight/elder_dragon_form.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_earth_spirit_boulder_smash_stun_lua", "heroes/hero_earth_spirit/modifier_earth_spirit_boulder_smash_stun.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_lycan_shapeshift_attackrange",		"heroes/hero_lycan/shapeshift.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_dream_coil_lua",						"heroes/hero_puck/dream_coil.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_dream_coil_thinker_lua",				"heroes/hero_puck/dream_coil.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_ability_epicenter",					"heroes/hero_sand_king/epicenter.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_ability_epicenter_slow",				"heroes/hero_sand_king/epicenter.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_damage_absorb_lua",					"heroes/hero_templar_assassin/modifier_refraction.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_ursa_enrage_model", 					"heroes/hero_ursa/enrage.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_viper_poison_attack_debuff_datadriven", 	"heroes/hero_viper/poison_attack.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_viper_nethertoxin_lua",					"heroes/hero_viper/nethertoxin.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_windrunner_windrun_aura_lua",		 "heroes/hero_windrunner/windrun.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_windrunner_windrun_slow_lua",		 "heroes/hero_windrunner/windrun.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_burning_spear_datadriven_debuff", 	"heroes/hero_huskar/modifier_burning_spear_datadriven_debuff.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_burning_spear_datadriven_debuff_counter",	"heroes/hero_huskar/modifier_burning_spear_datadriven_debuff_counter", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_huskar_burning_spear_lua", 			"heroes/hero_huskar/modifier_huskar_burning_spear.lua", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier( "modifier_bot_item_purchase",				"bots2/modifier_bot_item_purchase.lua", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier( "modifier_tidebringer_cleave",				"heroes/hero_kunkka/tidebringer_cleave.lua", LUA_MODIFIER_MOTION_NONE)
	-- shared between sven and tiny aghs
	LinkLuaModifier( "modifier_elder_titan_earth_splitter_disarm", "heroes/hero_elder_titan/modifier_earth_splitter_disarm.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_sven_great_cleave_radius", 		"heroes/hero_sven/great_cleave_radius.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_magnataur_empower_cleave_lua",	"heroes/hero_magnataur/empower_cleave.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_melting_strike_debuff_lua",		"heroes/hero_invoker/modifier_melting_strike_debuff.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_eidelon_check_attacks_lua", 		"heroes/hero_enigma/modifier_eidelon_check_attacks.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_enigma_black_hole_aura_lua", 	"heroes/hero_enigma/modifier_enigma_black_hole_aura.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_tempest_spawn_hide_from_map_lua","heroes/hero_arc_warden/modifier_tempest_spawn_hide_from_map.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_clinkz_searing_arrow_lua", 		"heroes/hero_clinkz/modifier_clinkz_searing_arrows.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_death_ward_attack_scepter_lua",	"heroes/hero_witch_doctor/modifier_death_ward_attack_scepter.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_chen_penitence_incoming_damage_lua",	"heroes/hero_chen/modifier_chen_penitence_incoming_damage.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_warlock_fatal_bonds_lua", 		"heroes/hero_warlock/modifier_warlock_fatal_bonds.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_slark_shadow_dance_passive_regen_lua", "heroes/hero_slark/modifier_slark_shadow_dance_passive_regen.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_requiem_slow_lua", 				"heroes/hero_nevermore/modifier_requiem_slow.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_rattletrap_cog_buff_lua",		"heroes/hero_rattletrap/power_cogs.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_electric_vortex_self_slow_lua",  "heroes/hero_storm_spirit/modifier_electric_vortex_self_slow.lua", LUA_MODIFIER_MOTION_NONE)
	--LinkLuaModifier( "modifier_torrent_slow_lua", 				"heroes/hero_kunkka/modifier_torrent_slow.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_venomancer_venomous_gale_lua", 	"heroes/hero_venomancer/modifier_venomancer_venomous_gale.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_luna_moon_glaive_lua", 			"heroes/hero_luna/modifier_luna_moon_glaive.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_abyssal_underlord_pit_of_malice_thinker_lua",	"heroes/hero_abyssal_underlord/modifier_abyssal_underlord_pit_of_malice_thinker.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_abyssal_underlord_pit_of_malice_ensare_lua",		"heroes/hero_abyssal_underlord/modifier_abyssal_underlord_pit_of_malice_ensare.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_enchantress_enchant_lua",		"heroes/hero_enchantress/enchant.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_enchantress_enchant_slow_lua",	"heroes/hero_enchantress/enchant.lua", LUA_MODIFIER_MOTION_NONE)
	--LinkLuaModifier( "modifier_viper_viper_strike_slow_lua",	"heroes/hero_viper/viper_strike.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_spectre_dispersion_lua", 		"heroes/hero_spectre/modifier_spectre_dispersion_lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_rubick_fade_bolt_debuff_lua", 	"heroes/hero_rubick/modifier_rubick_fade_bolt_debuff.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_supernova_sun_form_caster_datadriven", 	"heroes/hero_phoenix/modifier_supernova_sun_form_caster_datadriven.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_supernova_sun_form_egg_datadriven", 		"heroes/hero_phoenix/modifier_supernova_sun_form_egg_datadriven.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_supernova_burn_datadriven", 				"heroes/hero_phoenix/modifier_supernova_burn_datadriven", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_supernova_effect_dummy_lua", 			"heroes/hero_phoenix/modifier_supernova_effect_dummy.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_brewmaster_thunder_clap_creep_lua", 		"heroes/hero_brewmaster/modifier_brewmaster_thunder_clap_creep.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_slark_pounce_leash_lua", 				"heroes/hero_slark/pounce.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_tusk_walrus_punch_visual_lua", 			"heroes/hero_tusk/walrus_punch.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_batrider_sticky_napalm_debuff_lua", 		"heroes/hero_batrider/sticky_napalm.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_ice_vortex_slow_lua", 					"heroes/hero_ancient_apparition/modifier_ice_vortex_slow.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_legion_commander_duel_ignore_ethreal_lua", "heroes/hero_legion_commander/modifier_legion_commander_duel_ignore_ethreal.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_blur_enemy_lua", 						"heroes/hero_phantom_assassin/modifier_blur_enemy.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_ember_spirit_flame_guard_lua", 			"heroes/hero_ember_spirit/modifier_ember_spirit_flame_guard.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_ember_spirit_searing_chains_lua", 		"heroes/hero_ember_spirit/modifier_ember_spirit_searing_chains.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_fire_remnant_counter_lua",				"heroes/hero_ember_spirit/modifier_fire_remnant_counter.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_fire_remnant_counter_cooldown_lua", 		"heroes/hero_ember_spirit/modifier_fire_remnant_counter_cooldown.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_fire_remnant_dummy_buff_lua", 			"heroes/hero_ember_spirit/modifier_fire_remnant_dummy_buff.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_activate_fire_remnant_buff_lua",			"heroes/hero_ember_spirit/modifier_activate_fire_remnant_buff.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_shredder_chakram_lua", 					"heroes/hero_shredder/modifier_shredder_chakram.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_shredder_chakram_slow_lua", 				"heroes/hero_shredder/modifier_shredder_chakram.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_shredder_chakram_death_lua", 			"heroes/hero_shredder/chakram.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_shredder_chakram_remove_rubick_lua", 	"heroes/hero_shredder/chakram.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_spectre_haunt_fix_movespeed_lua", 		"heroes/hero_spectre/modifier_spectre_haunt_fix_movespeed.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_techies_stasis_trap_explode_sound_lua", 	"heroes/hero_techies/modifier_techies_stasis_trap_explode_sound.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_jakiro_liquid_fire_burn_lua", 			"heroes/hero_jakiro/modifier_jakiro_liquid_fire_burn.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_treant_natures_guise_lua", 				"heroes/hero_treant/modifier_treant_natures_guise.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_undying_zombie_deathstrike_active_lua",  "heroes/hero_undying/modifier_undying_zombie_deathstrike_active.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_slardar_amplify_damage_vision_lua", 		"heroes/hero_slardar/modifier_slardar_amplify_damage_vision.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_skeleton_king_alt_model_lua", 			"heroes/hero_skeleton_king/modifier_skeleton_king_alt_model.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_centaur_alt_model_lua", 					"heroes/hero_centaur/modifier_centaur_alt_model.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_riki_alt_model_lua", 					"heroes/hero_riki/modifier_riki_alt_model.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_ursa_alt_model_lua", 					"heroes/hero_ursa/modifier_ursa_alt_model.lua", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier( "modifier_courier_transfer_items_lua", 		"units/courier_transfer_items.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_courier_transfer_items_active_lua", 	"units/courier_transfer_items.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_courier_take_stash_items_lua", 		"units/courier_take_stash_items.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_courier_take_stash_return_to_base", 	"units/courier_take_stash_items.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_courier_minimap_icon_follow_lua", 	"units/courier_minimap_icon_follow.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_roshan_cancel_status_resistance_lua",	"units/modifier_roshan_cancel_statresist.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_unstuck_timer_lua",					"modifiers/modifier_unstuck_timer.lua", LUA_MODIFIER_MOTION_NONE)

	-- attack animations
	LinkLuaModifier( "modifier_clinkz_attack_animation", 		"heroes/hero_clinkz/clinkz_attack_animation_trigger.lua", LUA_MODIFIER_MOTION_NONE)
	--LinkLuaModifier( "modifier_primal_beast_attack_animation_lua",	"heroes/hero_primal_beast/modifier_primal_beast_attack_animation.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_hero_attack_point_adjust_lua", 	"heroes/modifier_hero_attack_point_adjust.lua", LUA_MODIFIER_MOTION_NONE)
 
	-- horizontal motion controllers
	LinkLuaModifier( "modifier_item_force_staff_active_lua", 				"items/item_force_staff.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
	LinkLuaModifier( "modifier_elder_titan_echo_stomp_lua", 				"heroes/hero_elder_titan/modifier_elder_titan_echo_stomp.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
	LinkLuaModifier( "modifier_batrider_flamebreak_projectile_lua", 		"heroes/hero_batrider/modifier_batrider_flamebreak_projectile.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
	LinkLuaModifier( "modifier_flamebreak_knockback_lua", 					"heroes/hero_batrider/modifier_flamebreak_knockback.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
	LinkLuaModifier( "modifier_nether_bash_motion_lua", 					"heroes/hero_spirit_breaker/modifier_nether_bash_motion.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
	LinkLuaModifier( "modifier_rattletrap_cog_push_lua",					"heroes/hero_rattletrap/power_cogs.lua", LUA_MODIFIER_MOTION_HORIZONTAL	)
	LinkLuaModifier( "modifier_spirit_breaker_charge_of_darkness_lua", 		"heroes/hero_spirit_breaker/modifier_charge_of_darkness.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
	LinkLuaModifier( "modifier_tusk_snowball_moving_lua", 					"heroes/hero_tusk/modifier_tusk_snowball_moving.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
	LinkLuaModifier( "modifier_shredder_chakram_move_lua",					"heroes/hero_shredder/modifier_shredder_chakram_move.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
	LinkLuaModifier( "modifier_shredder_chakram_return_lua", 				"heroes/hero_shredder/modifier_shredder_chakram_return.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
	LinkLuaModifier( "modifier_requiem_head_lua",							"heroes/hero_nevermore/modifier_requiem_head.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
	LinkLuaModifier( "modifier_ember_spirit_fire_remnant_add_location_lua", "heroes/hero_ember_spirit/modifier_ember_spirit_fire_remnant_add_location.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
	LinkLuaModifier( "modifier_ember_spirit_fire_remnant_activate_lua", 	"heroes/hero_ember_spirit/modifier_ember_spirit_fire_remnant_activate.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
	LinkLuaModifier( "modifier_enigma_black_hole_pull_lua", 				"heroes/hero_enigma/modifier_enigma_black_hole_pull.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

	-- both motion modifier
	LinkLuaModifier( "modifier_toss_flying_lua", 				"heroes/hero_tiny/modifier_toss_flying.lua", LUA_MODIFIER_MOTION_BOTH)

	-- attack type & armor type
	LinkLuaModifier( "modifier_creep_siege_alter",				"units/attack_types.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_piercing_extra",			"units/attack_types.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_irresolute_extra",			"units/attack_types.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_light",					"units/attack_types.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_irresolute_alter",			"units/attack_types.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_piercing_alter",			"units/attack_types.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier( "modifier_creep_move_after_reach_t1_lua",  "units/modifier_creep_move_after_reach_t1.lua", LUA_MODIFIER_MOTION_NONE)
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	self.isValidRankedGame = isMapRanked()
	self.hasGameEnded = false
	self.playerId2LadderScore = {}
	self.playerRepicked = {}
	self.RandomDraftHeroPool = {}
	self.captain_pick_phase = 0
	self.captain_normal_time = 40;
	self.captain_radiant_extra_time = 110;
	self.captain_dire_extra_time = 110;
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	
	GameRules:SetStartingGold(625)
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP, 19)
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR, 0.14)
	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA, 13)
	
	GameRules:GetGameModeEntity():SetCustomBackpackSwapCooldown(0)
	--GameRules:GetGameModeEntity():SetCustomBackpackCooldownPercent(100)
	GameRules:GetGameModeEntity():SetCustomBuybackCooldownEnabled(true)
	GameRules:GetGameModeEntity():SetCustomBuybackCostEnabled(true)
	GameRules:GetGameModeEntity():SetCustomGlyphCooldown(10000)
	GameRules:GetGameModeEntity():SetCustomScanCooldown(10000)
	GameRules:GetGameModeEntity():SetInnateMeleeDamageBlockAmount(0)
	GameRules:GetGameModeEntity():SetInnateMeleeDamageBlockPercent(0)
	GameRules:GetGameModeEntity():SetInnateMeleeDamageBlockPerLevelAmount(0)
	GameRules:GetGameModeEntity():SetRandomHeroBonusItemGrantDisabled(true)
	GameRules:GetGameModeEntity():SetGiveFreeTPOnDeath(false)
	GameRules:GetGameModeEntity():SetAllowNeutralItemDrops(false)
	GameRules:GetGameModeEntity():SetNeutralStashEnabled(false)
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(25)
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel({
		0,
		200,
		500,
		900,
		1400,
		2000,
		2600,
		3200,
		4400,
		5400,
		6000,
		8200,
		9000,
		10400,
		11900,
		13500,
		15200,
		17000,
		18900,
		20900,
		23000,
		25200,
		27500,
		29900,
		32400,
	})
	GameRules:GetGameModeEntity():SetFreeCourierModeEnabled(false)
	GameRules:GetGameModeEntity():SetUseDefaultDOTARuneSpawnLogic(false)
	GameRules:GetGameModeEntity():SetBountyRuneSpawnInterval(10000)
	GameRules:GetGameModeEntity():SetPowerRuneSpawnInterval(120)
	GameRules:GetGameModeEntity():SetXPRuneSpawnInterval(10000)
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_XP, false)
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled(false)
	GameRules:GetGameModeEntity():SetDaynightCycleAdvanceRate(1.25)
	GameRules:GetGameModeEntity():SetTPScrollSlotItemOverride("item_dummy_tpblock_datadriven")
	GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled(true)
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen(4)
	GameRules:GetGameModeEntity():SetFountainConstantManaRegen(14)
	GameRules:GetGameModeEntity():SetFountainPercentageManaRegen(4)
	GameRules:GetGameModeEntity():SetHudCombatEventsDisabled(true)
	GameRules:GetGameModeEntity():SetMaximumAttackSpeed(600)
	GameRules:SetGoldPerTick(0)
	GameRules:SetGoldTickTime(1000)
	GameRules:SetTreeRegrowTime(300)
	GameRules:SetHeroSelectionTime(80)
	GameRules:SetCreepSpawningEnabled(true)
	GameRules:SetRuneSpawnTime(120)

	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(CAddonTemplateGameMode, "OrderFilter"), self)

	-- rune 2 bounty at time 0 and 1 bounty & other per spawn afterwards
	self.runeSpawnedAtTime = {}
	GameRules:GetGameModeEntity():SetRuneSpawnFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "RuneSpawnFilter"), self)
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "BountyRunePickupFilter"), self)
	GameRules:GetGameModeEntity():SetModifyGoldFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "ModifyGoldFilter"), self)
	GameRules:GetGameModeEntity():SetModifyExperienceFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "ModifyExperienceFilter"), self)
	GameRules:GetGameModeEntity():SetHealingFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "HealingFilter"), self)
	GameRules:GetGameModeEntity():SetModifierGainedFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "ModifierGainedFilter"), self)
	GameRules:GetGameModeEntity():SetDamageFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "DamageFilter"), self)
	GameRules:GetGameModeEntity():SetAbilityTuningValueFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "AbilityTuningValueFilter"), self)
	GameRules:GetGameModeEntity():SetTrackingProjectileFilter(
		Dynamic_Wrap(CAddonTemplateGameMode, "TrackingProjectileFilter"), self)

	ListenToGameEvent('npc_spawned', function(event)
		HandleNpcSpawned(self, event.entindex, event.is_respawn)
	end, nil)
	ListenToGameEvent('entity_killed', function(event)
		HandleEntityKilled(self, event.entindex_killed, event.entindex_attacker, event.entindex_inflictor)
	end, nil)
	ListenToGameEvent('dota_rune_activated_server', function(event)
		HandleRuneActivated(event.PlayerID, event.rune)
	end, nil)
	ListenToGameEvent('player_chat', function(event)
		HandlePlayerChat(self, event.teamonly, event.text, event.playerid)
	end, nil)
	ListenToGameEvent('entity_hurt', function(event)
		HandleEntityHurt(event.entindex_killed, event.entindex_attacker, event.damage)
	end, nil)
	ListenToGameEvent("dota_hero_swap", function(event)
		print("dota_hero_swap " .. event.playerid1 .. " " .. event.playerid2)
		HandleHeroSwap(event.playerid1, event.playerid2)
	end, nil)
	ListenToGameEvent("dota_buyback", function(event)
		HandleBuyback(event.entindex, event.player_id)
	end, nil)
	ListenToGameEvent("hero_selected", function(event)
		HandlePlayerPickHero(event.hero_unit)
	end, nil)
	ListenToGameEvent("dota_game_state_change", function(event)
		print("dota_game_state_change " .. event.old_state .. " to " .. event.new_state) 
		HandleGameStateChange(self, event)
	end, nil)
	ListenToGameEvent("dota_item_picked_up", function(event) HandleItemPickedUp(event.itemname, event.PlayerID)	end, nil)
	ListenToGameEvent("dota_item_physical_destroyed", function(event) HandleItemDestroyed(event.itemname, event.HeroEntityIndex)	end, nil)
	ListenToGameEvent("dota_ability_channel_finished", Dynamic_Wrap(CAddonTemplateGameMode, 'HandleChannelFinish'), self)
	ListenToGameEvent("dota_item_purchased", Dynamic_Wrap(CAddonTemplateGameMode, "HandleItemPurchased"), self)
	ListenToGameEvent("dota_inventory_item_added", Dynamic_Wrap(CAddonTemplateGameMode, "HandleInventoryItemAdded"), self)

	CustomGameEventManager:RegisterListener("ladder_hero_banned", CAddonTemplateGameMode.handleLadderHeroBanned)
	CustomGameEventManager:RegisterListener("captain_client_pick", CAddonTemplateGameMode.handleCaptainClientPick)
	CustomGameEventManager:RegisterListener("fwd-command-issue", handleFWDCommand)
	CustomGameEventManager:RegisterListener("game_mode_select", CAddonTemplateGameMode.handleGameModeSelect)
end

function HandlePlayerChat(self, teamonly, text, playerid)
	--print("HandlePlayerChat " .. teamonly .. " " .. text .. " " .. playerid)
	if teamonly == 0 and GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		if not isMapRanked() then
			if text == '-vsbot' then
				self.botEnabled = true
				GameRules:SendCustomMessage("Bot模式开启", -1, -1)
				GameRules:SetCustomGameDifficulty(2) -- 2 for hard as default
			end
		end
	end
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if (self.game_mode == nil or self.game_mode == "AP") and text == '-repick' then
			handleAPRepick(self, playerid)
			return
		end
	end
	if text == "-unstuck" then
		-- if hero hasn't move for 1 minutes or hasn't been attacked in 1 minute, move hero to base
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		hero:AddNewModifier(hero, nil, "modifier_unstuck_timer_lua", { duration = 62, suicide = 0 })
	end
	if text == "-suicide" then
		-- if hero hasn't move for 1 minutes or hasn't been attacked in 1 minute, move hero to base
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		hero:AddNewModifier(hero, nil, "modifier_unstuck_timer_lua", { duration = 62, suicide = 1 })
	end
	if text == "-respawn" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		local current_time = GameRules:GetGameTime()
		if not hero:IsAlive() then
			if current_time - hero.last_alive_time > 150 then
				hero:RespawnHero(false, false)
			else
				GameRules:SendCustomMessage("手动复活需要死亡150秒。当前死亡时长：" .. math.floor(current_time - hero.last_alive_time), -1, -1)
			end
		end
	end
	if string.find(text, "-yy ") and teamonly == 0 then
		local sound_name = "MobaTimeMachine.YY_" .. string.sub(text,5)
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		hero:EmitSound(sound_name)
	end
	if string.find(text, "-pq ") and teamonly == 0 then
		local particle = "particles/spray_" .. string.sub(text, 5) .. ".vpcf"
		print("Creating particle " .. particle)
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		local pid = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, hero)
		local hero_location = hero:GetAbsOrigin() + hero:GetForwardVector() * 200
		hero_location.z = hero_location.z + 20
		ParticleManager:SetParticleControl(pid, 0, hero_location)
	end
	if self.botEnabled then
		if text == "-gold" then
			PlayerResource:ModifyGold(playerid, 10000, true, DOTA_ModifyGold_HeroKill)
		elseif text == '-lvlup' then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			for i=1,24 do
				hero:HeroLevelUp(false)
			end
		end
	end
	if text == "-alt" and teamonly == 0 and GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		handleAltText(playerid)
		return
	end
	if text == "-test" then
		--local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
	end
	local time = GameRules:GetDOTATime(false, false)
	if text == "-afk" then
		local player = PlayerResource:GetPlayer(playerid)
		local team = player:GetTeam()
		local team_pc = PlayerResource:GetPlayerCountForTeam(team)
		for i=1,team_pc do
			local player_id = PlayerResource:GetNthPlayerIDOnTeam(team, i)
			local player = PlayerResource:GetPlayer(player_id)
			local hero = player:GetAssignedHero()
			if player_last_order_time[player_id] == nil then
				player_last_order_time[player_id] = 0
			end
			if hero ~= nil and player_last_order_time[player_id] ~= nil then
				local hero_name = string.sub(hero:GetName(), string.len("npc_dota_hero")+2)
				local afk_time = time - player_last_order_time[player_id]
				GameRules:SendCustomMessageToTeam("Player "..player_id.." "..hero_name.." afk for "..math.floor(afk_time).."s.", -1, -1, team)
				if afk_time > 300 then
					GameRules:SendCustomMessageToTeam("Type '-kickafk "..player_id.."' to kick player.", -1, -1, team)
				end
			end
		end
		return
	end
	if string.find(text,'-kickafk') ~= nil then
		local kick_player_id = tonumber(string.sub(text, string.len('-kickafk') + 2))
		if playerid == kick_player_id then return end
		local kick_player = PlayerResource:GetPlayer(kick_player_id)
		local player = PlayerResource:GetPlayer(playerid)
		if kick_player:GetTeam() ~= player:GetTeam() then return end
		if player_last_order_time[kick_player_id] == nil then
			player_last_order_time[kick_player_id] = 0
		end
		local afk_time = player_last_order_time[kick_player_id] - time
		if time <= 300 then return end
		local hero = kick_player:GetAssignedHero()
		if hero == nil then return end
		local hero_name = string.sub(hero:GetName(), string.len("npc_dota_hero")+2)
		GameRules:SendCustomMessage("Kicking player "..kick_player_id.." "..hero_name, -1, -1)
		local team = kick_player:GetTeam()
		local team_pc = PlayerResource:GetPlayerCountForTeam(team)
		for i=1,team_pc do
			local controllable_player = PlayerResource:GetNthPlayerIDOnTeam(team, i)
			if controllable_player ~= kick_player_id then
				hero:SetControllableByPlayer(controllable_player, false)
			end
		end
		for i=0,DOTA_STASH_SLOT_6 do 
			local item = hero:GetItemInSlot(i)
			if item ~= nil and item:GetPurchaser() == hero then
				item:SetShareability(ITEM_FULLY_SHAREABLE)
			end
		end
	end
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	local ret,error = pcall(function()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION and IsServer() then
		if self.hero_selection_state == nil then
			self.hero_selection_state = "INI"
		end
		if self.hero_selection_state == "INI" then
			if self.game_mode == "RD" then
				initRDHeroSelection(self)
			elseif self.game_mode == "LD" then
				pickLadderHeroes(self)
				if self.isValidRankedGame then
					CustomGameEventManager:Send_ServerToAllClients("hero_select_player_ladder_scores", self.playerId2LadderScore)
				end
				self.hero_selection_state = "BAN"
			elseif self.game_mode == "SP" then
				initSPHeroSelection(self)
				self.hero_selection_state = "SP_PICK"
			elseif self.game_mode == "CM" then
				self.hero_selection_state = "CD_RAD_BAN_1"
 	   			CustomGameEventManager:Send_ServerToAllClients("captain_draft_start", {})
			elseif self.game_mode == "CD" then
				self.hero_selection_state = "CDD_RAD_BAN_1"
				initCaptainDraft(custom_game_first_pick)
			else
				print("[WARN] unhandled hero selection state: "..self.hero_selection_state)
			end
		end
		if self.hero_selection_state == "BAN" and GameRules:GetDOTATime(true, true) > -60 then
			print("Ban time over")
			for i,v in pairs(ladder_heroes_2_ban) do
				if v < 2 then
					print("Adding hero to whitelist " .. i)
					GameRules:RemoveHeroFromBlacklist(i)
					if same_ability_heroes[i] ~= nil then
						GameRules:RemoveHeroFromBlacklist(same_ability_heroes[i])
					end
				end
			end
			CustomGameEventManager:Send_ServerToAllClients("ladder_pick_start", {})
			self.hero_selection_state = "PIC"
		end
		if self.hero_selection_state == "CD_RAD_BAN_1" then
			captainModeCountTime(self)
		end

		handleRDHeroTime(self)

		if self.hero_selection_state == "CDD_RAD_BAN_1" then
			--Check if time has run out for team
			countDownRDTeamTimer(2)
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME and (self.botEnabled or GetMapName() == "vsbot") and self.botInitialized == nil then
		local botHeroPool = {
			"npc_dota_hero_axe",
			--"npc_dota_hero_ogre_magi",
			"npc_dota_hero_luna",
			"npc_dota_hero_skywrath_mage",
			"npc_dota_hero_lina",

			"npc_dota_hero_bristleback",
			"npc_dota_hero_witch_doctor",
			--"npc_dota_hero_venomancer",
			"npc_dota_hero_zuus",
			"npc_dota_hero_skeleton_king",

			"npc_dota_hero_lion",
			--"npc_dota_hero_abaddon",
			"npc_dota_hero_vengefulspirit",
			"npc_dota_hero_sniper",
			"npc_dota_hero_phantom_assassin",
		}
		Tutorial:StartTutorialMode()	
		GameRules:SetSameHeroSelectionEnabled(true)
		-- pick 5 random hero to play
		local lanes = {"bot", "bot", "mid", "top", "top"}
		for i=1,5 do
			local heroNumber = RandomInt(1, #botHeroPool)	
			Tutorial:AddBot(botHeroPool[heroNumber], lanes[i], "unfair", false)
			table.remove(botHeroPool, heroNumber)
		end
		GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
		GameRules:SetCreepSpawningEnabled(true)
		self.botInitialized = true
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		local time = GameRules:GetDOTATime(true, true) 
		if time > -2 then
			randomUnpickedPlayers()
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		if self.timeofdayset == nil then
			GameRules:SetTimeOfDay(0.250005)
			self.timeofdayset = true
		end
		local roshan = Entities:FindAllByClassname("npc_dota_roshan")
		if #roshan > 0 and self.first_roshan_spawned == nil then
			roshan[1]:ForceKill(false)
			print("spawn first roshan.")
			CreateUnitByName("npc_dota_roshan_datadriven", Vector(4320, -1824, 160), true, nil, nil, DOTA_TEAM_NEUTRALS)
			self.first_roshan_spawned = true
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		handleGameInProgressTimer(self, player2BuildingDamage)
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end

	if (GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME or GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION) 
		and (self.game_mode == nil or self.game_mode == "AP") then
		local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
		for i=1,n do
			local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
			if PlayerResource:HasRandomed(playerid) and not randomBonusGranted[playerid] and not self.playerRepicked[playerid] then
				PlayerResource:ModifyGold(playerid, 200, false, DOTA_ModifyGold_Unspecified)
				randomBonusGranted[playerid] = true
			end
		end
		local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
		for i=1,n do
			local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
			if PlayerResource:HasRandomed(playerid) and not randomBonusGranted[playerid] and not self.playerRepicked[playerid] then
				PlayerResource:ModifyGold(playerid, 200, false, DOTA_ModifyGold_Unspecified)
				randomBonusGranted[playerid] = true
			end
		end
		-- if has randomed hero, remove its arcana
		for i=0,PlayerResource:GetPlayerCount() - 1 do
			local hero_name = PlayerResource:GetSelectedHeroName(i)
			if same_ability_heroes[hero_name] ~= nil then
				GameRules:AddHeroToBlacklist(same_ability_heroes[hero_name])
			end
		end
	end

	-- send times to UI
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME or GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- send glyph cooldown time to clients
		--print("send glyph cooldown time to clients")
		CustomGameEventManager:Send_ServerToTeam(DOTA_TEAM_GOODGUYS, "team_glyph_cooldown_tick", {
			cd = math.floor(Entities:FindByName(nil, "ent_dota_fountain_good"):FindAbilityByName("glyph_datadriven"):GetCooldownTimeRemaining()) })
		CustomGameEventManager:Send_ServerToTeam(DOTA_TEAM_BADGUYS, "team_glyph_cooldown_tick", {
			cd = math.floor(Entities:FindByName(nil, "ent_dota_fountain_bad"):FindAbilityByName("glyph_datadriven"):GetCooldownTimeRemaining()) })
	end
	end)
	if not ret then
		print(error)
		GameRules:SendCustomMessage("Game main thinker failed.", -1, -1)
		GameRules:SendCustomMessage(error, -1, -1)
	end

	if GetMapName() == "dota" and PlayerResource:GetPlayerCount() == 1 and fwdnocdenabled == 1 then
		local currentEntity = nil
		while true do
			currentEntity = Entities:Next(currentEntity)
			if currentEntity == nil then
				break
			end
			if currentEntity.IsRealHero and currentEntity:IsRealHero() then
				currentEntity:GetAbilityByIndex(0):EndCooldown()
				currentEntity:GetAbilityByIndex(1):EndCooldown()
				currentEntity:GetAbilityByIndex(2):EndCooldown()
				currentEntity:GetAbilityByIndex(5):EndCooldown()
				currentEntity:SetMana(currentEntity:GetMaxMana())
				for slot=DOTA_ITEM_SLOT_1,DOTA_ITEM_SLOT_6 do
					local item = currentEntity:GetItemInSlot(slot)
					if item ~= nil then
						item:EndCooldown()
					end
				end
			end
		end
	end
	return 2
end

function hasRoomForItem(courier)
	for i=DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
		if courier:GetItemInSlot(i) == nil then
			return true
		end
	end
	return false
end

-- Add the order filter to your game mode entity
function CAddonTemplateGameMode:OrderFilter(event)
	--print("OrderFilter " .. event.order_type .. " " .. event.issuer_player_id_const)
	--DeepPrintTable(event)
	if event.order_type == DOTA_UNIT_ORDER_GLYPH then
		local player = PlayerResource:GetPlayer(event.issuer_player_id_const)
		local team = player:GetTeam()
		local fountain = nil
		if team == DOTA_TEAM_GOODGUYS then
			fountain = Entities:FindByName(nil, "ent_dota_fountain_good")
		else
			fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
		end
		local glyph = fountain:FindAbilityByName("glyph_datadriven")
		glyph:CastAbility()
		return false
	end
	if event.order_type == DOTA_UNIT_ORDER_RADAR then
		return false
	end
	if event.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
		local target = EntIndexToHScript(event.entindex_target)
		if target:GetClassname() == "dota_item_drop" or target:GetClassname() == "dota_item_rune" then
			return true
		end
		if	    target:GetClassname() == 'npc_dota_templar_assassin_psionic_trap'
		  	and target:GetHealth() * 100.0 / target:GetMaxHealth() > 50 then
			for i,v in pairs(event.units) do
				local unit = EntIndexToHScript(v)
				if unit:GetTeam() == target:GetTeam() then
					print("cannot deny psionic trap more than 50% HP.")
					return false
				end
			end
		end
	end
	if     event.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION 
		or event.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET 
		or event.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE 
		or event.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
		for i,v in pairs(event.units) do
			local unit = EntIndexToHScript(v)
			if unit:HasModifier("modifier_item_travel_boots_caster_effect") and event.queue == 0 then
				print("Moving when teleporting")
				return false
			end
			if event.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or event.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE then
				if unit:HasModifier("modifier_spirit_breaker_charge_of_darkness_lua") then
					return false
				end
			end
		end
	elseif event.order_type == DOTA_UNIT_ORDER_CAST_POSITION 
		or event.order_type == DOTA_UNIT_ORDER_CAST_TARGET
		or event.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
		local ability = EntIndexToHScript(event.entindex_ability)
		if bit.band(ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL) == 0 then
			for i,v in pairs(event.units) do
				local unit = EntIndexToHScript(v)
				if unit:HasModifier("modifier_item_travel_boots_caster_effect") and event.queue == 0 then
					return false
				end
			end
		end
		if ability:GetName() == "kunkka_ghostship" then
			-- Always land ghost ship at 1000 range
			local player_hero = PlayerResource:GetPlayer(event.issuer_player_id_const):GetAssignedHero()
			local target_position = Vector(event.position_x, event.position_y, event.position_z)
			local hero_position = player_hero:GetAbsOrigin()
			local new_target_position = hero_position + (target_position - hero_position):Normalized() * 1000
			event.position_x = new_target_position.x
			event.position_y = new_target_position.y
			return true
		elseif ability:GetName() == "item_ultimate_scepter" then
			-- alchemist cannot give aghs to friendly
			return false
		elseif ability:GetName() == "lion_mana_drain" then
			local target = EntIndexToHScript(event.entindex_target)
			for i,v in pairs(event.units) do
				local unit = EntIndexToHScript(v)
				if unit:GetTeam() == target:GetTeam() then
					print("Lion's mana drain cannot target allies.")
					return false
				end
			end
		end
	end
	if event.order_type == DOTA_UNIT_ORDER_DROP_ITEM 
		or event.order_type == DOTA_UNIT_ORDER_GIVE_ITEM then
		local item = EntIndexToHScript(event.entindex_ability)
		if item:GetName() == "item_dummy_backpackblock_datadriven" then
			return false
		end
	end
	if event.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM then
		if event.shop_item_name == "item_recipe_flying_courier_datadriven" then
			local target = EntIndexToHScript(event.units["0"])
			if target:IsRealHero() then
				local couriers = Entities:FindAllByClassname("npc_dota_courier")
				for i=1,#couriers do
					if couriers[i]:GetTeam() == target:GetTeam() and 
						not couriers[i]:HasModifier("modifier_courier_flying_upgrade_active") and 
						couriers[i]:IsInRangeOfShop(DOTA_SHOP_HOME, true) then
						-- instead issue the purchase command from the courier
						event.units["0"] = couriers[i]:GetEntityIndex()
						return true
					end
				end
			end
		end
	end
	if event.order_type == DOTA_UNIT_ORDER_MOVE_ITEM then
		local item = EntIndexToHScript(event.entindex_ability)
		local unit = EntIndexToHScript(event.units['0'])
		if item:GetItemSlot() > DOTA_STASH_SLOT_1 and unit:GetName() == "npc_dota_courier" then 
			local hasEmptySpace = false
			for i=0,DOTA_ITEM_SLOT_6 do
				if unit:GetItemInSlot(i) == nil then
					hasEmptySpace = true
				end
			end
			if not hasEmptySpace then
				print("Unit has no space to hold item")
				return false
			end
		end
	end
	-- Remave meepo ult
	if event.order_type == DOTA_UNIT_ORDER_TRAIN_ABILITY then
		local unit = EntIndexToHScript(event.units['0'])
		local ability = EntIndexToHScript(event.entindex_ability)
		if unit:GetName() == "npc_dota_hero_meepo" and ability:GetName() == "meepo_divided_we_stand" then
			if unit:HasScepter() then
				if unit:GetLevel() + 4 < ability:GetLevel() * 7 then
					return false
				end
			else
				if unit:GetLevel() - 3 < ability:GetLevel() * 7 then
					return false
				end
			end
		end
	end
	player_last_order_time[event.issuer_player_id_const] = GameRules:GetDOTATime(false, false)
	return true
end

function CAddonTemplateGameMode:RuneSpawnFilter(event)
	local time = GameRules:GetDOTATime(false, false) 
	if time < 10 then
		event.rune_type = DOTA_RUNE_BOUNTY 
	else
		local nthRuneSpawned = math.floor((time + 10) / 60)
		local recentRuneSpawn = self.runeSpawnedAtTime[nthRuneSpawned]
		local runeTypes = {DOTA_RUNE_DOUBLEDAMAGE, DOTA_RUNE_HASTE, DOTA_RUNE_ILLUSION, DOTA_RUNE_INVISIBILITY, DOTA_RUNE_REGENERATION}
		if nthRuneSpawned % 2 == 1 then
			print("Cancelling first XP rune spawn event")
			return false
		end
		if recentRuneSpawn == nil then
			if RandomInt(0, 1) == 0 then
				event.rune_type = DOTA_RUNE_BOUNTY
			else
				event.rune_type = runeTypes[RandomInt(1, #runeTypes)]
			end
			self.runeSpawnedAtTime[nthRuneSpawned] = event.rune_type
		else
			if recentRuneSpawn ~= DOTA_RUNE_BOUNTY then
				event.rune_type = DOTA_RUNE_BOUNTY
			else
				event.rune_type = runeTypes[RandomInt(1, #runeTypes)]
			end
		end
	end
	return true
end

function CAddonTemplateGameMode:BountyRunePickupFilter(event)
	event.xp_bounty = 0
	event.gold_bounty = 0
	return true
end

function HandleNpcSpawned(self, entityIndex, is_respawn)
	local entity = EntIndexToHScript(entityIndex)
	if entity:IsHero() and is_respawn == 0 then
		if not entity:HasAbility("hero_intrinstic_mechanism_datadriven") then
			entity:AddAbility("hero_intrinstic_mechanism_datadriven"):SetLevel(1)
		end
		if not entity:HasAbility("hero_ability_executed_hook_datadriven") then
			entity:AddAbility("hero_ability_executed_hook_datadriven"):SetLevel(1)
		end
	end
	if entity:IsRealHero() and is_respawn == 0 then
		-- modifiers
		entity:AddNewModifier(entity, nil, "modifier_tower_bonus_cancel_lua", {})
		entity:AddNewModifier(entity, nil, "modifier_attribute_regen_adjust" , {})
		entity:AddNewModifier(entity, nil, "modifier_cancels_item_on_hit" , {})
		entity:AddNewModifier(entity, nil, "item_tpscroll_clear_tree_modifier", {})
		entity:AddNewModifier(entity, nil, "modifier_no_creep_aggro_on_cast_orb_lua", {})
		if self.botEnabled and entity:GetTeam() == DOTA_TEAM_BADGUYS and GetMapName() == 'dota' then
			entity:AddNewModifier(entity, nil, "modifier_bot_item_purchase", {})
		elseif GetMapName() ~= 'vsbot' then
			entity:AddNewModifier(entity, nil, "modifier_drop_backpack_items", {})
		end

		-- remove useless abilities
		entity:RemoveAbility("ability_pluck_famango")	-- 摘莲花
		entity:RemoveAbility("ability_lamp_use")		-- 占领观察者
		entity:RemoveAbility("ability_capture")			-- 占领前哨
		entity:RemoveAbility("abyssal_underlord_portal_warp")	-- 使用孽主的“恶魔之扉”传送门

		-- thinkers
		entity:SetThink(function()
			entity:RemoveItem(entity:FindItemInInventory("item_tpscroll"))
		end, "remove tpscroll", 0.5)

		if self.game_mode == 'DM' then
			entity:AddAbility("doom_bringer_devils_bargain")
		end

		local player = entity:GetPlayerOwner()
		if player ~= nil then
			-- add custom glyph to fountain
			local fountain = nil
			if entity:GetTeam() == DOTA_TEAM_GOODGUYS then
				fountain = Entities:FindByName(nil, "ent_dota_fountain_good")
			elseif entity:GetTeam() == DOTA_TEAM_BADGUYS then
				fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
			end
			if fountain ~= nil then
				fountain:SetControllableByPlayer(entity:GetPlayerID(), true)
			end
		end


		if entity:GetName() == "npc_dota_hero_meepo" then
			if self.mainMeepo == nil then
				print("Registering meepo spawned")
				self.mainMeepo = entity
			else
				print("Secondary meepo spawned")
				entity.mainMeepo = self.mainMeepo 
			end
			entity:FindAbilityByName("meepo_divided_we_stand_aghs_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_pudge" then
			entity:AddNewModifier(entity, entity:FindAbilityByName("pudge_flesh_heap"), "modifier_pudge_flesh_magic_resist", {})
		elseif entity:GetName() == "npc_dota_hero_visage" then
			entity:AddNewModifier(entity, entity:FindAbilityByName("visage_gravekeepers_cloak"), "modifier_cloak_bonus", {})
			entity:SetThink(function()
				if entity:HasScepter() and not entity:HasAbility("special_bonus_unique_visage_6") then
					local ability = entity:AddAbility("special_bonus_unique_visage_6")
					ability:SetLevel(1)
					print("added visage ahgs ability")
				end
				if not entity:HasScepter() and entity:HasAbility("special_bonus_unique_visage_6") then
					entity:RemoveAbility("special_bonus_unique_visage_6")
					print("removed visage ahgs ability")
				end
				return 1
			end, "visage scepter", 1);
		elseif entity:GetName() == "npc_dota_hero_enchantress" then
			entity:AddNewModifier(entity, nil, "modifier_enchantress_aghs_attack_range", {})
		elseif entity:GetName() == "npc_dota_hero_keeper_of_the_light" then
			entity:FindAbilityByName("keeper_of_the_light_spirit_form_checker"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_slark" then
			entity:FindAbilityByName("slark_shadow_dance_heal_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_sand_king" then
			entity:AddNewModifier(entity, entity, "modifier_sandstorm_channel_end", {})
		elseif entity:GetName() == "npc_dota_hero_lone_druid" then
			entity:FindAbilityByName("lone_druid_true_form_checker_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_undying" then
			entity:FindAbilityByName("undying_flesh_golem_aura_datadriven"):SetLevel(1)
--		elseif entity:GetName() == "npc_dota_hero_chen" then
--			entity:FindAbilityByName("chen_penitence_incoming_dmg_checker"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_invoker" then
			entity:SetThink(function()
				entity:FindAbilityByName("invoker_invoke"):SetLevel(0)
			end, "reset invoker invoke", 0.5)
		elseif entity:GetName() == "npc_dota_hero_earth_spirit" then
			entity:AddItemByName("item_aghanims_shard")
			entity:AddAbility("special_bonus_unique_earth_spirit_2"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_rubick" or entity:GetName() == "npc_dota_hero_ringmaster" then
			--  TODO move following abilities to hooks
			entity:AddAbility("obsidian_destroyer_imprison_int_steal_datadriven"):SetLevel(1)
			entity:AddAbility("slark_shadow_dance_heal_datadriven"):SetLevel(1)

			entity:AddAbility("spirit_breaker_empowering_haste_activate_debuff_datadriven"):SetLevel(1)
			entity:AddAbility("sven_gods_strength_aghs_datadriven"):SetLevel(1)
			entity:AddAbility("undying_flesh_golem_aura_datadriven"):SetLevel(1)
			entity:AddAbility("legion_commander_press_the_attack_as_datadriven"):SetLevel(1)
		elseif entity:GetName() == "npc_dota_hero_troll_warlord" then
			entity:SetThink(function()
				entity:FindAbilityByName("troll_warlord_berserkers_rage"):SetLevel(0)
			end, "troll unset 1st skill", 0.1)
		end
		local innate_ability = hero_innate_abilities[entity:GetName()]
		if innate_ability ~= nil then
			if type(innate_ability) == "table" then
				for i=1,#innate_ability do
					entity:FindAbilityByName(innate_ability[i]):SetLevel(1)
				end
			else
				entity:FindAbilityByName(innate_ability):SetLevel(1)
			end
		end
		-- debug abilities' name
		--for i = 0, 34 do
		--	local ability = entity:GetAbilityByIndex(i)
		--	if ability ~= nil then
		--		print(ability:GetAbilityName())
		--	else
		--		print("null ability")
		--	end
		--end
	end

	if entity:HasAbility("creep_siege_alter") then
		entity:FindAbilityByName("creep_siege_alter"):SetLevel(1)
	end
	if entity:HasAbility("creep_piercing_extra") then
		entity:FindAbilityByName("creep_piercing_extra"):SetLevel(1)
	end
	if entity:HasAbility("creep_irresolute_extra") then
		entity:FindAbilityByName("creep_irresolute_extra"):SetLevel(1)
	end
	if entity:HasAbility("creep_light") then
		entity:FindAbilityByName("creep_light"):SetLevel(1)
	end
	if entity:HasAbility("creep_weak") then
		entity:FindAbilityByName("creep_weak"):SetLevel(1)
	end
	if entity:HasAbility("creep_basic") then
		entity:FindAbilityByName("creep_basic"):SetLevel(1)
	end
	if entity:HasAbility("creep_strong") then
		entity:FindAbilityByName("creep_strong"):SetLevel(1)
	end
	if entity:HasAbility("creep_hero_armor") then
		entity:FindAbilityByName("creep_hero_armor"):SetLevel(1)
	end
	if entity:HasAbility("creep_irresolute_alter") then
		entity:FindAbilityByName("creep_irresolute_alter"):SetLevel(1)
	end
	if entity:HasAbility("creep_piercing_alter") then
		entity:FindAbilityByName("creep_piercing_alter"):SetLevel(1)
	end
	if entity:HasAbility("twin_gate_portal_warp") then -- 移除双生门传送
		entity:RemoveAbility("twin_gate_portal_warp")
	end

	entity:SetThink(function() -- 狼人小狼致残
		if entity:HasAbility("lycan_summon_wolves_critical_strike") then
			entity:RemoveAbility("lycan_summon_wolves_critical_strike")
		end
	end, "Disable original critical strike", 0.1)
	
	if not entity:IsWard() and not entity:HasAbility("unit_intrinstic_mechanism_datadriven") then
		entity:AddAbility("unit_intrinstic_mechanism_datadriven"):SetLevel(1)
	end

	if entity:GetModelName() == "models/creeps/roshan/roshan.vmdl" then
		if self.roshanCount == nil then
			self.roshanCount = 1
		end
		entity.roshanNo = self.roshanCount
		self.roshanCount = self.roshanCount + 1
		entity:AddNewModifier(entity, nil, "modifier_roshan_cancel_status_resistance_lua", {})
		entity:AddNewModifier(entity, nil, "modifier_counter_healthbar", {})
	end

	if entity:GetName() == "npc_dota_creep_lane" then
		entity:SetThink(function()
			entity:RemoveModifierByName("modifier_creep_bonus_xp")
			entity:RemoveAbilityFromIndexByName("flagbearer_creep_aura_effect")
			entity:SetBaseMagicalResistanceValue(0)
			if (entity:GetAbsOrigin()[2] < -5460 or entity:GetAbsOrigin()[2] > 4745) 
				and not entity:HasModifier("modifier_creep_safe_lane_move_speed_bonus") 
				and not entity:HasModifier("modifier_creep_move_after_reach_t1_lua")
				and entity:IsAlive()
			then
				local current_time = GameRules:GetDOTATime(false, true)
				local time_fraction = 30 - current_time % 30
				entity:AddNewModifier(nil, nil, "modifier_creep_safe_lane_move_speed_bonus", {}):SetDuration(25 + time_fraction, true)
			end
		end, "remove flag bearer bonus", 1)
	end

	if string.find(entity:GetName(), "npc_dota_brewmaster_earth") ~= nil then
		entity:SetThink(function()
			local owner = entity:GetOwner()
			if owner:HasScepter() then
				local ability = entity:AddAbility("brewmaster_thunder_clap")
				ability:SetLevel(owner:FindAbilityByName("brewmaster_thunder_clap"):GetLevel())
			end
		end, "Add brewmaster ability", 0.1)
	end

	if string.find(entity:GetName(), "npc_dota_brewmaster_fire") ~= nil then
		entity:SetThink(function()
			local owner = entity:GetOwner()
			if owner:HasScepter() then
				local ability = entity:AddAbility("brewmaster_drunken_brawler_datadriven")
				ability:SetLevel(owner:FindAbilityByName("brewmaster_drunken_brawler_datadriven"):GetLevel())
			end
		end, "Add brewmaster ability", 0.1)
	end

	if string.find(entity:GetName(), "npc_dota_brewmaster_storm") ~= nil then
		entity:SetThink(function()
			local owner = entity:GetOwner()
			if owner:HasScepter() then
				local ability = entity:AddAbility("brewmaster_drunken_haze_datadriven")
				ability:SetLevel(owner:FindAbilityByName("brewmaster_drunken_haze_datadriven"):GetLevel())
			end
		end, "Add brewmaster ability", 0.1)
	end

	if string.find(entity:GetName(), "npc_dota_brewmaster_void") ~= nil then
		entity:AddNoDraw()
		entity:ForceKill(false)
	end

	if entity:GetName() == "npc_dota_lone_druid_bear" then
		entity:FindAbilityByName("lone_druid_bear_damage_return_cd"):SetLevel(1)
	end

	if entity:GetName() == "npc_dota_tusk_frozen_sigil" then
		entity:FindAbilityByName("tusk_frozen_sigil_aura_datadriven"):SetLevel(
			entity:GetOwner():FindAbilityByName("tusk_frozen_sigil"):GetLevel())
		entity:AddNewModifier(entity, entity, "modifier_counter_healthbar", {})
	end
	if entity:HasAbility("pugna_nether_ward_aura_datadriven") then
		entity:FindAbilityByName("pugna_nether_ward_aura_datadriven"):SetLevel(
			entity:GetOwner():FindAbilityByName("pugna_nether_ward"):GetLevel())
	end
	if entity:GetName() == "npc_dota_visage_familiar" then
		entity:FindAbilityByName("neutral_spell_immunity"):SetLevel(1)
		local ability = entity:GetOwner():FindAbilityByName("visage_summon_familiars")
		entity:AddNewModifier(entity, ability, "modifier_familiar_attack_damage_lua", {})
	elseif entity:GetName() == "npc_dota_courier" then
		entity:FindAbilityByName("courier_flying_upgrade_datadriven"):SetLevel(1)
		if is_respawn > 0 then
			CustomGameEventManager:Send_ServerToTeam(entity:GetTeam(), "courier_spawned", { id = tostring(entity:GetEntityIndex()), respawn = 1 })
		end
		entity:FindAbilityByName("courier_use_clarity_datadriven"):SetLevel(1)
		-- Creates another minimap icon unit that moves with the courier
		if is_respawn == 0 then
			entity:SetThink(function()
				CreateUnitByNameAsync("npc_dummy_unit_courier", 
					entity:GetAbsOrigin(),
					true, nil, nil, entity:GetTeam(),
					function(unit)
						unit:AddNewModifier(entity, nil, "modifier_courier_minimap_icon_follow_lua", {})
					end)
			end, "spawn team minimap icon", 0.1)
		end
	elseif entity:GetName() == "npc_dota_beastmaster_hawk" then
		--print("owned by " .. entity:GetPlayerOwnerID())
		entity:SetControllableByPlayer(entity:GetPlayerOwnerID(), false)
		entity:FindAbilityByName("beastmaster_hawk_invisibility_datadriven"):SetLevel(
			entity:GetPlayerOwner():GetAssignedHero():FindAbilityByName("beastmaster_call_of_the_wild_hawk"):GetLevel())
	elseif entity:GetName() == "npc_dota_venomancer_plagueward" then
		entity:SetThink(function()
			local hero_veno = entity:GetOwner()
			if hero_veno:IsRealHero() and hero_veno:HasAbility("venomancer_poison_sting_datadriven") then
				local ability_sting = hero_veno:FindAbilityByName("venomancer_poison_sting_datadriven")
				if ability_sting:GetLevel() > 0 then
					entity:AddAbility("venomancer_ward_poison_sting_datadriven"):SetLevel(ability_sting:GetLevel())
				end
			end
		end, "Add ward passive", 0.1)
	end
	if entity:HasAbility("harpy_storm_chain_lightning") and entity:GetTeam() == DOTA_TEAM_NEUTRALS then
		local ability = entity:FindAbilityByName("harpy_storm_chain_lightning")
		entity:SetThink(function()
			if entity:GetTeam() == DOTA_TEAM_NEUTRALS then
				ability:SetLevel(0)
				return 1
			else
				ability:SetLevel(1)
			end
		end, "neutral don't cast chain lightening", 0.1)
	end
	if entity:HasAbility("dark_troll_warlord_ensnare") and entity:GetTeam() == DOTA_TEAM_NEUTRALS then
		local ability = entity:FindAbilityByName("dark_troll_warlord_ensnare")
		entity:SetThink(function()
			if entity:GetTeam() == DOTA_TEAM_NEUTRALS then
				ability:SetLevel(0)
				return 1
			else
				ability:SetLevel(1)
			end
		end, "neutral don't cast ensnare", 0.1)
	end
	if entity:HasAbility("undying_tombstone_spawn_zombies_datadriven") then
		entity:FindAbilityByName("undying_tombstone_spawn_zombies_datadriven"):SetLevel(
			entity:GetOwner():FindAbilityByName("undying_tombstone"):GetLevel())
	end
	if entity:IsTempestDouble() then
		local main_dog = entity:GetPlayerOwner():GetAssignedHero()
		entity:AddNewModifier(entity, nil, "modifier_tempest_spawn_hide_from_map_lua", { duration = 0.03 })
		entity:SetThink(function()
			FindClearRandomPositionAroundUnit(entity, main_dog, 64)
			entity:Stop()
		end, "tempest move to other", 0.03)
	end
	if entity.intStealOnRespawn ~= nil then
		local debuff = entity:FindModifierByName("modifier_silencer_brain_drain_debuff_datadriven")
		if debuff ~= nil then
			local stack = debuff:GetStackCount()
			if stack == 0 then
				stack = 2
			else
				stack = stack + 1
			end
			debuff:SetStackCount(stack)
		else
			entity.intStealOnRespawn:ApplyDataDrivenModifier(entity.intStealOnRespawn:GetCaster(), entity, "modifier_silencer_brain_drain_debuff_datadriven", {})
		end
		entity.intStealOnRespawn = nil
	end
end

function HandleEntityKilled(self, entityIdx, attackerIdx, inflictorIdx)
	local entity = EntIndexToHScript(entityIdx)
	local attacker = EntIndexToHScript(attackerIdx)
	local ability = nil
	if inflictorIdx ~= nil then
		ability = EntIndexToHScript(inflictorIdx)
	end
	local name = entity:GetName()
	if name == "dota_badguys_tower1_mid"
		or name == "dota_badguys_tower1_top"
		or name == "dota_badguys_tower1_bot" then
		local fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
		fountain:FindAbilityByName("glyph_datadriven"):EndCooldown()
	elseif name == "dota_goodguys_tower1_mid"
		or name == "dota_goodguys_tower1_top"
		or name == "dota_goodguys_tower1_bot" then
		local fountain = Entities:FindByName(nil, "ent_dota_fountain_good")
		fountain:FindAbilityByName("glyph_datadriven"):EndCooldown()
	elseif entity:HasModifier("roshan_inherent_buffs_checker_datadriven") then
		print("roshan killed")
		self.nextRoshanTime = GameRules:GetDOTATime(false, false) + RandomInt(480, 660);
		print("next rosh respawn time is " .. self.nextRoshanTime);
		local team = attacker:GetTeam()
		if team == DOTA_TEAM_GOODGUYS or team == DOTA_TEAM_BADGUYS then
			if team == DOTA_TEAM_GOODGUYS then
				GameRules:GetAnnouncer(team):SpeakConcept({
					announce_event = "roshan_killed_good"
				})
			else
				GameRules:GetAnnouncer(team):SpeakConcept({
					announce_event = "roshan_killed_bad"
				})
			end
			local n = PlayerResource:GetPlayerCountForTeam(team)
			for i=1,n do
				local playerid = PlayerResource:GetNthPlayerIDOnTeam(team, i)
				PlayerResource:ModifyGold(playerid, 200, false, DOTA_ModifyGold_RoshanKill)
				local player = PlayerResource:GetPlayer(playerid)
				SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player:GetAssignedHero(), 200, player)
			end
			CustomGameEventManager:Send_ServerToAllClients("combat_event_roshan_killed", {
				kpid = attacker:GetPlayerOwnerID(),
			})
		end
	end
	if ability ~= nil and ability:GetName() == "necrolyte_reapers_scythe_datadriven" and entity:IsRealHero() and not entity:IsReincarnating() then
		entity.necrospawnminus = 30
		if attacker:HasScepter() then
			entity:SetBuyBackDisabledByReapersScythe(true)
			print("renabling buyback after " .. entity:GetLevel() * 4)
			entity:SetThink(function()
				entity:SetBuyBackDisabledByReapersScythe(false)
			end, "", {}, entity:GetLevel() * 4 + 30)
		end
	end
	if entity:HasModifier("modifier_doom_bringer_devour") then
		entity:RemoveModifierByName("modifier_doom_bringer_devour")
	end
	if IsServer() and entity:IsRealHero() and (not entity:IsReincarnating()) then
		if entity:HasModifier("modifier_winter_wyvern_winters_curse_aura") and attacker:GetTeam() == entity:GetTeam() then
			print("Crediting WW on Winters curse team kill")
			attacker = entity:FindModifierByName("modifier_winter_wyvern_winters_curse_aura"):GetCaster()
		end
		local ret,error = pcall(function() handleKillBonus(self, attacker, entity) end)
		if not ret then
			print(error)
			GameRules:SendCustomMessage(error, -1, -1)
		end
		local buyback_cost = 100 + entity:GetLevel() * entity:GetLevel() * 1.5 + GameRules:GetDOTATime(false, false) * 0.25
		print("Set buyback cost to " .. buyback_cost)
		PlayerResource:SetCustomBuybackCost(entity:GetPlayerID(), buyback_cost)
		entity.last_dead_time = GameRules:GetDOTATime(false, false)
		entity:ModifyGold(-30 * entity:GetLevel(), false, DOTA_ModifyGold_Death)
		local event = {}
		event.caster = entity
		local ret,error = pcall(function() handleDeathRespawnTime(event) end)
		if not ret then
			print(error)
			GameRules:SendCustomMessage(error, -1, -1)
		end
		for i=1,PlayerResource:NumPlayers() do
			if PlayerResource:GetTeam(i-1) == entity:GetTeam() then
				EmitSoundOnClient("notification.teammate.death", PlayerResource:GetPlayer(i-1))
			else
				EmitSoundOnClient("notification.teammate.kill", PlayerResource:GetPlayer(i-1))
			end
		end
	end
	if attacker:IsOwnedByAnyPlayer() and entity:IsBuilding() and attacker:GetTeam() ~= entity:GetTeam() then
		-- grant building kill bonus
		local bounty = entity:GetGoldBounty()
		PlayerResource:ModifyGold(attacker:GetPlayerOwnerID(), bounty, false, DOTA_ModifyGold_Building)
		local playerId = attacker:GetPlayerOwnerID()
		local player = PlayerResource:GetPlayer(playerId)
		SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, entity, bounty, player)
	end
	if entity:IsBuilding() and building2teambounty[entity:GetName()] ~= nil then
		-- grant team bounty
		local team_bounty = building2teambounty[entity:GetName()]
		local is_deny = false
		if attacker:GetTeam() == entity:GetTeam() then
			is_deny = true
			team_bounty = team_bounty / 2
		end
		local grant_team = DOTA_TEAM_GOODGUYS
		local teamname = "近卫"
		if entity:GetTeam() == DOTA_TEAM_GOODGUYS then
			grant_team = DOTA_TEAM_BADGUYS
			teamname = "天灾"
		end
		local playerCount = PlayerResource:GetPlayerCountForTeam(grant_team)
		for i=1,playerCount do
			local playerId = PlayerResource:GetNthPlayerIDOnTeam(grant_team, i)
			local player = PlayerResource:GetPlayer(playerId)
			PlayerResource:ModifyGold(playerId, team_bounty, false, DOTA_ModifyGold_Building)
			SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player:GetAssignedHero(), team_bounty, player)
		end
		if is_deny then
			CustomGameEventManager:Send_ServerToAllClients("team_bounty_building_destroyed", {
				kpid = attacker:GetPlayerOwnerID(),
				bname = entity:GetName(),
				gold = team_bounty
			})
		else
			local attacker_player_id = -1;
			if attacker:IsOwnedByAnyPlayer() then
				attacker_player_id = attacker:GetPlayerOwnerID();
			end
			CustomGameEventManager:Send_ServerToAllClients("team_bounty_building_destroyed", {
				kpid = attacker_player_id,
				bname = entity:GetName(),
				gold = team_bounty
			})
		end		
	end
	if entity:IsCourier() then
		local kpid = -1
		if attacker:IsOwnedByAnyPlayer() then
			kpid = attacker:GetPlayerOwnerID()
		end
		CustomGameEventManager:Send_ServerToAllClients("courier_killed", { 
			id = tostring(entity:GetEntityIndex()),
			respawn = 60 + entity:GetLevel() * 6,
			kpid = kpid,
		});
	end
	if entity:IsFort() then
		--End game, send player status to clients
        if entity:GetTeam() == DOTA_TEAM_GOODGUYS then
            GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
        else
            GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
        end

		sendEndGameStats(player2BuildingDamage)
	end
	--if IsServer() and entity:IsCreep() and not entity:IsNeutralUnitType() then
	--	-- find creeps nearby whose target is me, preempty trigger its interval think
	--	local units = FindUnitsInRadius(
	--		entity:GetTeam(),
	--		entity:GetAbsOrigin(),
	--		nil,
	--		600,
	--		DOTA_UNIT_TARGET_TEAM_ENEMY,
	--		DOTA_UNIT_TARGET_CREEP,
	--		DOTA_UNIT_TARGET_FLAG_NOT_DOMINATED,
	--		FIND_ANY_ORDER,
	--		false)
	--	for i=1,#units do
	--		local ai = units[i]:FindModifierByName("modifier_creep_ai")
	--		if ai ~= nil and ai.target ~=nil and ai.target.unit == entity then
	--			ai:HandleTargetKilled()
	--		end
	--	end
	--end
	if (entity:GetName() == "npc_dota_ward_base" or entity:GetName() == "npc_dota_ward_base_truesight")
		and attacker:IsControllableByAnyPlayer()
		and attacker:GetTeam() ~= entity:GetTeam() then
		local kpid = attacker:GetPlayerOwnerID()
		CustomGameEventManager:Send_ServerToAllClients("player_ward_killed", {
			kpid = kpid, ward = entity:GetName() })
	end
end

function HandleRuneActivated(playerid, rune)
	local player = PlayerResource:GetPlayer(playerid)
	if rune == DOTA_RUNE_BOUNTY then
		local hero = player:GetAssignedHero()
		local time = GameRules:GetDOTATime(false, false)
		local bounty = 100
		local exp = 100
		if time > 90 then
			bounty = 50 + 2 * math.floor(time / 60)
			exp = 50 + 5 * math.floor(time / 60)
		end
		print("bounty picked up " .. bounty .. " " .. exp)
		hero:ModifyGold(bounty, false, DOTA_ModifyGold_BountyRune)
		hero:AddExperience(exp, DOTA_ModifyXP_TomeOfKnowledge, false, false)
		local bottle = hero:FindItemInInventory("item_bottle")
		if bottle ~= nil and bottle:GetItemState() == 1 then
			bottle:SetCurrentCharges(3)
		end
	end
	CustomGameEventManager:Send_ServerToTeam(player:GetTeam(), "player_rune_activated", {
		pid = playerid, rune_type = rune })
end

function HandleEntityHurt(entindex_killed, entindex_attacker, damage)
	local target = EntIndexToHScript(entindex_killed)
	local attacker = EntIndexToHScript(entindex_attacker)
	if attacker:HasAbility("unit_intrinstic_mechanism_datadriven") and damage > 0 then 
		local ability = attacker:FindAbilityByName("unit_intrinstic_mechanism_datadriven")
		attacker:RemoveModifierByName("modifier_move_speed_cancel_active_datadriven")
		ability:StartCooldown(ability:GetCooldown(1))
	end
	if attacker:GetPlayerOwner() ~= nil and target:IsRealHero() then
		if target.time_attacked == nil then
			target.time_attacked = {}
		end
		target.time_attacked[attacker:GetPlayerOwnerID()] = GameRules:GetDOTATime(true, false)
	end
	if target:IsBuilding() and attacker:IsOwnedByAnyPlayer() then
		local building_damage = player2BuildingDamage[attacker:GetPlayerOwnerID()]
		local owner_id = attacker:GetPlayerOwnerID()
		if building_damage then
			player2BuildingDamage[owner_id] = building_damage + damage
		else
			player2BuildingDamage[owner_id] = damage
		end
	end
end

function randomUnpickedPlayers()
	local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	for i=1,n do
		local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
		print(PlayerResource:GetSelectedHeroName(playerid))
		if PlayerResource:GetSelectedHeroName(playerid) == "" then
			PlayerResource:GetPlayer(playerid):MakeRandomHeroSelection()
		end
	end
	local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
	for i=1,n do
		local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
		print(PlayerResource:GetSelectedHeroName(playerid))
		if PlayerResource:GetSelectedHeroName(playerid) == "" then
			PlayerResource:GetPlayer(playerid):MakeRandomHeroSelection()
		end
	end
end

function CAddonTemplateGameMode:ModifyGoldFilter(event)
	if event.reason_const == DOTA_ModifyGold_WardKill and event.gold > 0 then
		event.gold = 50
	end
	if event.reason_const == DOTA_ModifyGold_HeroKill then
		print("Blocking default hero kill gold " .. event.gold)
		return false
	end
	if event.reason_const == DOTA_ModifyGold_Building then
		print("Blocking default building bounty")
		return false
	end
	local hero = PlayerResource:GetPlayer(event.player_id_const):GetAssignedHero()
	if (event.reason_const == DOTA_ModifyGold_Building
		or event.reason_const == DOTA_ModifyGold_CreepKill
		or event.reason_const == DOTA_ModifyGold_NeutralKill)
		and hero:HasModifier("modifier_hero_buybacked_gold_penalty")
	then
		--print("Blocking buybacked hero from gaining unreliable gold")
		return false
	end 
	if event.reason_const == DOTA_ModifyGold_CourierKill or event.reason_const == DOTA_ModifyGold_CourierKilledByThisPlayer then
		print("Give courier gold to player " .. event.player_id_const)
		event.gold = 150
	end
	return true
end

function CAddonTemplateGameMode:ModifyExperienceFilter(event)
	if event.reason_const == DOTA_ModifyXP_Unspecified and event.experience > 50 then
		print("cap unspecified XP")
		event.experience = 50
	elseif event.reason_const == DOTA_ModifyXP_HeroKill then
		return false
	end
	return true
end

function CAddonTemplateGameMode:HealingFilter(event)
	if event.entindex_healer_const == nil then
		return true
	end
	local ability = EntIndexToHScript(event.entindex_inflictor_const)
	local target = EntIndexToHScript(event.entindex_target_const)
	local caster = EntIndexToHScript(event.entindex_healer_const)
	if ability:GetName() == "keeper_of_the_light_spirit_form_illuminate" and not GameRules:IsDaytime() then
		return false
	elseif ability:GetName() == "undying_soul_rip" and target:GetName() == "npc_dota_unit_undying_tombstone" then
		local damage_per_unit = ability:GetSpecialValueFor("damage_per_unit")
		local max_units = ability:GetSpecialValueFor("max_units")
		local radius = ability:GetSpecialValueFor("radius")
		local units = FindUnitsInRadius(
			caster:GetTeam(),
			caster:GetAbsOrigin(), 
			nil,
			radius, 
			DOTA_UNIT_TARGET_TEAM_BOTH,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false)
		local filtered_units = {}
		for i=1,#units do
			if units[i] ~= caster and units[i] ~= target then
				table.insert(filtered_units, units[i])
			end
		end
		local damage_count = #filtered_units
		if damage_count > max_units then
			damage_count = max_units
		end
		event.heal = damage_count * damage_per_unit
	elseif ability:GetName() == "shadow_shaman_shackles" then return false
	elseif ability:GetName() == "pudge_dismember" and not target:HasScepter() then return false
	end
	return true
end

function CAddonTemplateGameMode:ModifierGainedFilter(event)
	--print("ModifierGainedFilter " .. event.name_const)
	local parent = EntIndexToHScript(event.entindex_parent_const)

	if string.find(event.name_const, "_datadriven") == nil
		and string.find(event.name_const, "_lua") == nil
		then

	if event.name_const == "modifier_dark_seer_wall_slow" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		ApplyDamage({ victim = parent, attacker = caster, damage = ability:GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL })
	elseif event.name_const == "modifier_lycan_shapeshift" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_lycan_shapeshift_attackrange", {duration = ability:GetSpecialValueFor("duration")})
	elseif event.name_const == "modifier_morphling_adaptive_strike" and parent:GetName() ~= "npc_dota_creep_siege" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local damage = ability:GetSpecialValueFor("damage_base")
		local damage_min = ability:GetSpecialValueFor("damage_min")
		local damage_max = ability:GetSpecialValueFor("damage_max")
		local ratio = caster:GetAgility() / caster:GetStrength()
		if ratio > 1.5 then
			ratio = 1
		else
			ratio = ratio / 1.5
		end
		damage = damage + (damage_min + ratio * (damage_max - damage_min)) * caster:GetAgility()
		ApplyDamage({ victim = parent, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	elseif event.name_const == "modifier_windrunner_windrun" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_windrunner_windrun_aura_lua", {duration = ability:GetSpecialValueFor("duration")})
	elseif event.name_const == "modifier_abyssal_underlord_firestorm_burn" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local burn_datadriven = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
		burn_datadriven:ApplyDataDrivenModifier(caster, parent, "modifier_underlord_firestorm_burn_active_datadriven", {})
	elseif event.name_const == "modifier_earth_spirit_boulder_smash" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_earth_spirit_boulder_smash_stun_lua", {duration = event.duration})
	elseif event.name_const == "modifier_elder_titan_earth_splitter" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		if caster:HasScepter() then
			local ability = EntIndexToHScript(event.entindex_ability_const)
			parent:AddNewModifier(caster, ability, "modifier_elder_titan_earth_splitter_disarm", {duration = ability:GetSpecialValueFor("slow_duration")})
		end
	elseif event.name_const == "modifier_knockback" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		if caster:GetName() == "npc_dota_hero_spirit_breaker" then
			local ability = EntIndexToHScript(event.entindex_ability_const)
			caster:AddNewModifier(caster, ability, "modifier_spirit_breaker_greater_bash_speed", {duration = ability:GetSpecialValueFor("movespeed_duration")})
		end
	elseif event.name_const == "modifier_illusion" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local hook = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
		if hook ~= nil then
			hook:ApplyDataDrivenModifier(caster, parent, "modifier_illusion_bounty_cancel_datadriven", {})
		end
		-- remove modifiers which are not inherited.
		parent:RemoveModifierByName("modifier_templar_assassin_psi_blades")
		-- inherit caster's buffs
		local modifiers = caster:FindAllModifiers()
		for i=1,#modifiers do
			if modifiers[i]:GetName() == "modifier_chemical_rage" then
				caster:FindAbilityByName("alchemist_chemical_rage_datadriven"):ApplyDataDrivenModifier(caster, parent, "modifier_chemical_rage", { }) 
				break
			elseif modifiers[i]:GetName() == "modifier_skeleton_king_alt_model_lua" then
				setAltModel(parent)
			end
		end
	elseif event.name_const == "modifier_techies_stasis_trap" then
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(parent, nil, "modifier_kill", { duration = ability:GetSpecialValueFor("duration") })
		parent:AddNewModifier(parent, nil, "modifier_techies_stasis_trap_explode_sound_lua", {})
	elseif event.name_const == "modifier_techies_stasis_trap_stunned" then
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		parent:AddNewModifier(caster, ability, "modifier_stunned", { duration = ability:GetSpecialValueFor("stun_duration")})
		return false
	elseif event.name_const == "modifier_techies_minefield_sign_thinker" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		caster:FindAbilityByName("hero_ability_executed_hook_datadriven"):ApplyDataDrivenModifier(caster, parent, "modifier_techies_minesign_datadriven", {})
		return false
	elseif event.name_const == "modifier_arc_warden_magnetic_field_thinker_attack_range" then
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		parent:AddNewModifier(caster, ability, "modifier_arc_warden_magnetic_field_thinker_attack_speed", {})	
		parent:AddNewModifier(caster, ability, "modifier_arc_warden_magnetic_field_thinker_evasion", {})	
	elseif event.name_const == "modifier_visage_summon_familiars_stone_form_buff" then
		parent:FindModifierByName("modifier_familiar_attack_damage_lua"):refreshStackCount()
	elseif event.name_const == "modifier_bane_nightmare" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local nightmare_damage = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
		if caster:GetTeam() ~= parent:GetTeam() then
			caster:SetThink(function()
				if parent:HasModifier("modifier_bane_nightmare") then
					ApplyDamage({victim = parent, attacker = caster, damage = 20, damage_type = DAMAGE_TYPE_PURE})
					nightmare_damage:ApplyDataDrivenModifier(caster, parent, "modifier_bane_nightmare_damage_active", {})
				end
			end, "nightmare_damage later", 1.5)
		end
	elseif event.name_const == "modifier_bane_fiends_grip" then 
		local caster = EntIndexToHScript(event.entindex_caster_const)
		if caster:HasScepter() then
			local hook = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
			local ability = EntIndexToHScript(event.entindex_ability_const)
			hook:ApplyDataDrivenModifier(caster, caster, "modifier_bane_fiends_grip_scepter", {duration = ability:GetSpecialValueFor("AbilityChannelTime")})
		end
	elseif event.name_const == "modifier_enchantress_untouchable_slow" and parent:IsMagicImmune() then 
		return false
	elseif event.name_const == "modifier_medusa_stone_gaze_stone" then
		if parent:IsIllusion() then
			print("stone gaze kills illusion " .. parent:GetName())
			parent:ForceKill(false)
			return false
		end
		local caster = EntIndexToHScript(event.entindex_caster_const)
		print("Applying magic resist to stoned units")
		caster:FindAbilityByName("hero_ability_executed_hook_datadriven"):ApplyDataDrivenModifier(
			caster, parent, "modifier_stone_gaze_magic_resist_datadriven", {})
	elseif event.name_const == "modifier_slark_pounce_leash" then 
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_slark_pounce_leash_lua", { duration = 3.5})
		return false
	elseif event.name_const == "modifier_lich_frostnova_slow" then 
		local modifier = parent:FindModifierByName("modifier_lich_chainfrost_slow")
		if modifier ~= nil then
			if modifier:GetDuration() < 4.0 then
				modifier:SetDuration(4.0, true)
			end
			return false
		end
	elseif event.name_const == "modifier_lich_chainfrost_slow" then 
		local modifier = parent:FindModifierByName("modifier_lich_frostnova_slow")
		if (modifier ~= nil) then
			if (modifier:GetDuration() < 4.0) then
				modifier:SetDuration(4.0, true)
			end
			return false
		end
	elseif event.name_const == "modifier_medusa_stone_gaze_slow" then
		-- add a modifier to remove the debuff when is not facing the medusa
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local cancel_ability = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
		if cancel_ability ~= nil then
			cancel_ability:ApplyDataDrivenModifier(caster, parent, "modifier_medusa_stone_gaze_cancel_when_turned", {})
			cancel_ability:ApplyDataDrivenModifier(caster, parent, "modifier_medusa_stone_gaze_slow_full_duration", { 
				duration = caster:FindModifierByName("modifier_medusa_stone_gaze"):GetRemainingTime() })
		end
	elseif event.name_const == "modifier_elder_titan_echo_stomp" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_elder_titan_echo_stomp_lua", { duration = ability:GetSpecialValueFor("sleep_duration") })
		return false
	elseif event.name_const == "modifier_invoker_deafening_blast_knockback" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_stunned", { duration = ability:GetSpecialValueFor("knockback_duration") })
	elseif event.name_const == "modifier_obsidian_destroyer_astral_imprisonment_prison" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local passive_ability = caster:FindAbilityByName("obsidian_destroyer_imprison_int_steal_datadriven")
	    if parent:IsRealHero() and passive_ability ~= nil and caster:GetTeam() ~= parent:GetTeam() then
			passive_ability:SetLevel(ability:GetLevel())
			passive_ability:ApplyDataDrivenModifier(caster, parent, "modifier_od_imprison_int_steal", {})
			passive_ability:ApplyDataDrivenModifier(caster, caster, "modifier_od_imprison_int_gain", {})
	    end
	elseif event.name_const == "modifier_oracle_fates_edict" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local passive_ability = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
		local duration = ability:GetSpecialValueFor("duration")
		passive_ability:ApplyDataDrivenModifier(caster, parent, "modifier_oracle_fates_edict_alter", { duration = duration })
		return(false)
	elseif event.name_const == "modifier_oracle_false_promise_timer" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_oracle_false_promise_invis", {});
	elseif event.name_const == "modifier_chen_penitence" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local duration = ability:GetSpecialValueFor("duration")
		parent:AddNewModifier(caster, ability, "modifier_chen_penitence_incoming_damage_lua", { duration = duration })
	elseif event.name_const == "modifier_crystal_maiden_frostbite" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_stunned", {duration = 0.1})
		if parent:IsCreep() then
			-- extend duration to 10 seconds
			parent:SetThink(function()
				parent:FindModifierByName("modifier_crystal_maiden_frostbite"):SetDuration(10, true)
			end, "neutral frostbite duration", 0.1)
		end
	elseif event.name_const == "modifier_doom_bringer_scorched_earth_effect" then
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local duration = ability:GetSpecialValueFor("duration")
		parent:AddNewModifier(caster, ability, "modifier_doom_bringer_scorched_earth_buff_aura_lua", { duration = duration })
	elseif event.name_const == "modifier_nyx_assassin_vendetta" then
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local passive_ability = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
		local modifier_count = ability:GetSpecialValueFor("bonus_damage_physical") / 50
		for i=1,modifier_count do
			passive_ability:ApplyDataDrivenModifier(parent, parent, "modifier_vendetta_physical_damage_active", {})
		end
	elseif event.name_const == "modifier_slark_shadow_dance_passive_regen" then
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(parent, ability, "modifier_slark_shadow_dance_passive_regen_lua", {})
	elseif event.name_const == "modifier_storm_spirit_electric_vortex_pull" then
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		caster:AddNewModifier(caster, ability, "modifier_electric_vortex_self_slow_lua", { duration = 3 })
	elseif event.name_const == "modifier_nyx_assassin_impale" then
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		parent:SetThink(function() 
			ApplyDamage({victim = parent, attacker = caster, damage = ability:GetSpecialValueFor("impale_damage_tooltip"), damage_type = DAMAGE_TYPE_MAGICAL})
		end, "impale damage late", 0.5) 
	elseif event.name_const == "modifier_beastmaster_axe_invulnerable" then
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		parent:AddNewModifier(caster, ability, "modifier_beastmaster_wild_axes_damage_lua", {})
	elseif event.name_const == "modifier_lone_druid_rabid" then
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		parent:AddNewModifier(caster, ability, "modifier_lone_druid_rabid_lua", {})
	elseif event.name_const == "modifier_fountain_aura_buff" then
		if not parent:HasModifier("modifier_fountain_aura_tp_persist_datadriven") then
			local passive_ability = parent:FindAbilityByName("hero_ability_executed_hook_datadriven")
			if passive_ability ~= nil then
				local caster = EntIndexToHScript(event.entindex_caster_const)
				passive_ability:ApplyDataDrivenModifier(caster, parent, "modifier_fountain_aura_tp_persist_datadriven", {})
			end
		end
	elseif event.name_const == "modifier_riki_smoke_screen" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local passive_ability = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
		passive_ability:ApplyDataDrivenModifier(caster, parent, "modifier_riki_smoke_screen_slow_datadriven", {})
	elseif event.name_const == "modifier_venomancer_venomous_gale" then
		-- replace default gale modifier to make it undispellable
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_venomancer_venomous_gale_lua", { duration = ability:GetSpecialValueFor("duration") })
		return false
	elseif event.name_const == "modifier_abyssal_underlord_pit_of_malice_thinker" then 
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_abyssal_underlord_pit_of_malice_thinker_lua", {})
		parent:AddNewModifier(caster, ability, "modifier_kill", { duration = ability:GetSpecialValueFor("pit_duration") })
		return false
	elseif event.name_const == "modifier_treant_overgrowth" then
		-- if target is in range of tree eyes, then apply damage modifier
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local eyes_in_the_forest = caster:FindAbilityByName("treant_eyes_in_the_forest")
		local overgrowth_aoe = eyes_in_the_forest:GetSpecialValueFor("overgrowth_aoe")
		local trees = Entities:FindAllByNameWithin("npc_dota_treant_eyes", parent:GetAbsOrigin(), overgrowth_aoe)
		if #trees > 0 then
			local passive_ability = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
			local duration = ability:GetSpecialValueFor("duration")
			passive_ability:ApplyDataDrivenModifier(caster, parent, "modifier_treant_overgrowth_damage_datadriven", { duration = duration });
		end
	elseif event.name_const == "modifier_viper_viper_strike_debuff" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local passive_ability = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
		passive_ability:ApplyDataDrivenModifier(caster, parent, "modifier_viper_viper_strike_damage_datadriven", {})
		--parent:AddNewModifier(caster, ability, "modifier_viper_viper_strike_slow_lua", {duration = ability:GetSpecialValueFor("duration")})
		return false
	elseif event.name_const == "modifier_rune_doubledamage" then
		local passive_ability = parent:FindAbilityByName("hero_ability_executed_hook_datadriven")
		passive_ability:ApplyDataDrivenModifier(parent, parent, "modifier_rune_doubledamage_datadriven", {})
		return false
	elseif event.name_const == "modifier_rune_haste" then
		local passive_ability = parent:FindAbilityByName("hero_ability_executed_hook_datadriven")
		passive_ability:ApplyDataDrivenModifier(parent, parent, "modifier_rune_haste_datadriven", {})
		return false
	elseif event.name_const == "modifier_rune_regen" then
		local passive_ability = parent:FindAbilityByName("hero_ability_executed_hook_datadriven")
		passive_ability:ApplyDataDrivenModifier(parent, parent, "modifier_rune_regen_datadriven", {})
		return false
	elseif event.name_const == "modifier_rune_invis" then
		parent:SetThink(function() 
			parent:AddNewModifier(parent, nil, "modifier_invisible", { duration = 45 })
		end, "invis fade", 2)
		return false
	elseif event.name_const == "modifier_item_buff_ward" then
		-- creates a dummy ward on location
		local new_unit_name = "npc_dota_observer_wards"
		local lifetime = 420
		local is_sentry = parent:GetName() == "npc_dota_ward_base_truesight"
		local caster = EntIndexToHScript(event.entindex_caster_const)
		if is_sentry then
			new_unit_name = "npc_dota_sentry_wards"
			lifetime = 240
		end
		local fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
		if parent:GetTeam() == DOTA_TEAM_GOODGUYS then
			fountain = Entities:FindByName(nil, "ent_dota_fountain_good")
		end
		local new_ward = CreateUnitByName(new_unit_name, parent:GetAbsOrigin(), true, caster, caster, parent:GetTeam())
		new_ward:AddNewModifier(fountain, nil, "modifier_kill", { duration = lifetime })
		new_ward:AddNewModifier(fountain, nil, "modifier_invisible", { duration = lifetime })
		new_ward:AddNewModifier(fountain, nil, "modifier_ward_no_collusion_lua", {})
		if is_sentry then
			new_ward:AddNewModifier(fountain, nil, "modifier_sentry_ward_reveal_invis_aura_lua", {})
		end
		parent:Destroy()
		return false
	elseif event.name_const == "modifier_rubick_fade_bolt_debuff" then 
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		parent:AddNewModifier(caster, ability, "modifier_rubick_fade_bolt_debuff_lua", { duration = 10 })
		return false
	elseif event.name_const == "modifier_magnataur_reverse_polarity" and parent:IsCreep() then
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local creep_stun_duration = ability:GetSpecialValueFor("creep_stun_duration")
		parent:AddNewModifier(caster, ability, "modifier_stunned", { duration = creep_stun_duration })
	elseif event.name_const == "modifier_invoker_cold_snap" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = caster:FindAbilityByName("invoker_cold_snap_datadriven")
		ability:SetLevel(1)
		local quas_level = caster:FindAbilityByName("invoker_quas"):GetLevel() - 1
		local duration = ability:GetLevelSpecialValueFor("duration", quas_level) 
		ability:ApplyDataDrivenModifier(caster, parent, "modifier_cold_snap_datadriven", { duration = duration })
		return false
	elseif event.name_const == "modifier_brewmaster_thunder_clap" and parent:IsCreep() then
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local duration_creep = ability:GetSpecialValueFor("duration_creep")
		local caster = EntIndexToHScript(event.entindex_caster_const)
		parent:AddNewModifier(caster, ability, "modifier_brewmaster_thunder_clap_creep_lua", { duration = duration_creep })
		return false
	elseif event.name_const == "modifier_satyr_trickster_purge" and parent:IsSummoned() then
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local caster = EntIndexToHScript(event.entindex_caster_const)
		ApplyDamage({victim = parent, attacker = caster, damage = 400, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	elseif event.name_const == "modifier_magnataur_skewer_slow" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local passive_ability = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
		passive_ability:ApplyDataDrivenModifier(caster, parent, "modifier_magnataur_skewer_attack_speed_datadriven", { duration = 2.5 })
	elseif event.name_const == "modifier_cold_feet" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local passive_ability = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
		passive_ability:ApplyDataDrivenModifier(caster, parent, "modifier_cold_feet_damage_datadriven", { duration = 4 })
	elseif event.name_const == "modifier_ice_blast" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local passive_ability = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local duration = ability:GetSpecialValueFor("frostbite_duration")
		passive_ability:ApplyDataDrivenModifier(caster, parent, "modifier_ice_blast_damage_datadriven", { duration = duration })
	elseif event.name_const == "modifier_rattletrap_cog" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)

		local spacing = ability:GetSpecialValueFor("spacing")
		local cog_vector = 
		{
			Vector(-spacing, spacing, 0), Vector(0, spacing, 0), Vector(spacing, spacing, 0),
			Vector(-spacing, 0, 0), Vector(spacing, 0, 0),
			Vector(-spacing, -spacing, 0), Vector(0, -spacing, 0), Vector(spacing, -spacing, 0)
		}
		if caster.power_cogs_cnt == nil then
			caster.power_cogs_cnt = 1
		else
			caster.power_cogs_cnt = caster.power_cogs_cnt % 8 + 1
		end
		if caster.power_cogs_cnt == 8 then
			local vOrigin = caster:GetAbsOrigin()
			local units = FindUnitsInRadius(caster:GetTeam(), 
				vOrigin, 
				nil, 
				ability:GetSpecialValueFor("cogs_radius") + 60,
				DOTA_UNIT_TARGET_TEAM_BOTH,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_ANY_ORDER,
			false)

			for k,v in pairs(units) do
				FindClearSpaceForUnit(v, vOrigin, false)
			end 
		end
		local new_position = caster:GetAbsOrigin() + cog_vector[caster.power_cogs_cnt]

		parent:SetThink(function()
			parent:SetAbsOrigin(new_position)
			parent:AddNewModifier(caster, ability, 'modifier_rattletrap_cog_buff_lua',
			{
				duration 	= event.duration,
				x 			= (parent:GetAbsOrigin() - caster:GetAbsOrigin()).x,
				y 			= (parent:GetAbsOrigin() - caster:GetAbsOrigin()).y,
				center_x	= caster:GetAbsOrigin().x,
				center_y	= caster:GetAbsOrigin().y,
				center_z	= caster:GetAbsOrigin().z
			})
			modifier = parent:FindModifierByName("modifier_rattletrap_cog")
			modifier:StartIntervalThink(-1)
		end, "init power cog", 0)
	elseif event.name_const == "modifier_rattletrap_cog_pinball" then
		-- kill the cog if attacked by clockwerk itself
		local caster = EntIndexToHScript(event.entindex_caster_const)
		parent:ForceKill(false)
		return false
	elseif event.name_const == "modifier_ice_vortex" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_ice_vortex_slow_lua", {})
	elseif event.name_const == "modifier_spectre_haunt" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_spectre_haunt_fix_movespeed_lua", {})
	elseif event.name_const == "modifier_ember_spirit_searing_chains" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local duration = ability:GetSpecialValueFor("duration")
		parent:AddNewModifier(caster, ability, "modifier_ember_spirit_searing_chains_lua", { duration = duration })
		return false
	elseif event.name_const == "modifier_winter_wyvern_splinter_blast_slow" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		local passive_ability = caster:FindAbilityByName("hero_ability_executed_hook_datadriven")
		passive_ability:ApplyDataDrivenModifier(caster, parent, "modifier_winter_wyvern_splinter_blast_slow_datadriven", {})
		return false
	elseif event.name_const == "modifier_slardar_amplify_damage" then
		local caster = EntIndexToHScript(event.entindex_caster_const)
		local ability = EntIndexToHScript(event.entindex_ability_const)
		parent:AddNewModifier(caster, ability, "modifier_slardar_amplify_damage_vision_lua", { duration = 25 })
	elseif event.name_const == "modifier_lion_impale" and parent:IsMagicImmune() then return false
	elseif event.name_const == "modifier_fountain_invulnerability" then return false
	elseif event.name_const == "modifier_eul_cyclone" then return false
	elseif event.name_const == "modifier_tombstone_hp" then return false
	elseif event.name_const == "modifier_courier_passive_bonus" then return false
	elseif event.name_const == "modifier_beastmaster_call_of_the_wild_hawk" then return false
	elseif event.name_const == "modifier_undying_tombstone_zombie_aura" then return false
	elseif event.name_const == "modifier_spirit_bear_attack_damage" then return false
	elseif event.name_const == "modifier_lone_druid_spirit_bear_attack_check" then return false
	elseif event.name_const == "modifier_fountain_fury_swipes_damage_increase" then return false
	elseif event.name_const == "modifier_lion_finger_of_death_kill_counter" then return false
	elseif event.name_const == "modifier_earth_spirit_boulder_smash_debuff" then return false
--	elseif event.name_const == "modifier_nevermore_requiem_slow" then return false
--	elseif event.name_const == "modifier_nevermore_requiem_fear" then return false
	elseif event.name_const == "modifier_windrunner_windrun_invis" then return false
	elseif event.name_const == "modifier_windrunner_windrun_invis_thinker" then return false
	elseif event.name_const == "modifier_neutral_sleep_ai" then return false
	elseif event.name_const == "modifier_riki_smoke_screen_ally" then return false
	elseif event.name_const == "modifier_abyssal_underlord_pit_of_malice_ensare" then return false
	elseif event.name_const == "modifier_winter_wyvern_arctic_burn_slow" then return false 
	end

	end
	if root_modifiers[event.name_const] then
		if parent:IsChanneling() then
			parent:InterruptChannel()
		end
	end
	return true
end

function CAddonTemplateGameMode:DamageFilter(event)
	local attacker = EntIndexToHScript(event.entindex_attacker_const)
	local victim = EntIndexToHScript(event.entindex_victim_const)

	-- No damage to glyphed towers
	if victim:HasModifier("modifier_glyph_active_datadriven") then
		return true
	end

	if event.entindex_inflictor_const ~= nil then
		local inflictor = EntIndexToHScript(event.entindex_inflictor_const)
		if inflictor:GetName() == "bounty_hunter_shuriken_toss" then
			local victim = EntIndexToHScript(event.entindex_victim_const)
			victim:AddNewModifier(attacker, attacker:FindAbilityByName("bounty_hunter_shuriken_toss"), "modifier_stunned", {duration = 0.03})
		elseif inflictor:GetName() == "item_cyclone" then
			return false
		elseif inflictor:GetName() == "item_ethereal_blade" then
			--print(victim:Script_GetMagicalArmorValue(false, attacker))
			if attacker:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
				event.damage = (attacker:GetStrength() * 2 + 75) * (1 - victim:Script_GetMagicalArmorValue(false, attacker))
			elseif attacker:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
				event.damage = (attacker:GetAgility() * 2 + 75) * (1 - victim:Script_GetMagicalArmorValue(false, attacker))
			else
				event.damage = (attacker:GetIntellect(true) * 2 + 75) * (1 - victim:Script_GetMagicalArmorValue(false, attacker))
			end
			--print("Etheral damage " .. event.damage)
		elseif inflictor:GetName() == "centaur_return" and victim:IsBuilding() then
			event.damage = event.damage * 2
		elseif inflictor:GetName() == "death_prophet_exorcism" and victim:IsBuilding() then
			event.damage = event.damage * 2
		elseif inflictor:GetName() == "invoker_emp" then
			event.damage = event.damage / (1 - victim:Script_GetMagicalArmorValue(false, inflictor))
			event.damagetype_const = DAMAGE_TYPE_PURE
		elseif inflictor:GetName() == "phoenix_sun_ray" then
			event.damage = event.damage / (1 - victim:Script_GetMagicalArmorValue(false, inflictor))
		elseif inflictor:GetName() == "earth_spirit_rolling_boulder" and event.damage > 0 then
			-- fix rolling boulder damage without strength component
			local victim = EntIndexToHScript(event.entindex_victim_const)
			event.damage = 100 * (1 - victim:Script_GetMagicalArmorValue(false, inflictor))
		elseif inflictor:GetName() == "pudge_meat_hook" and victim:IsCreep() then
			local original_damage = inflictor:GetSpecialValueFor("damage")
			if event.damage > original_damage then
				event.damage = original_damage
			end
		elseif inflictor:GetName() == "mirana_arrow" and victim:IsCreep() then
			local original_damage = inflictor:GetAbilityDamage()
			if attacker.arrow_start_loc ~= nil then
				local arrow_range = (victim:GetAbsOrigin() - attacker.arrow_start_loc):Length()
				local bonus_damage = inflictor:GetSpecialValueFor("arrow_bonus_damage")
				original_damage = original_damage + math.min(1, arrow_range / 3000) * bonus_damage
			end
			if event.damage > original_damage then
				event.damage = original_damage
			end
		elseif inflictor:GetName() == "enigma_midnight_pulse" then
			-- apply damage as pure instead of magical & percentage of max health
			event.damage = victim:GetMaxHealth() * inflictor:GetSpecialValueFor("damage_percent") / 100
		elseif inflictor:GetName() == "lion_impale"	then
			if victim:IsMagicImmune() then
				event.damage = 0
			end
		elseif inflictor:GetName() == "tiny_avalanche" then
			if victim:HasModifier("modifier_toss_flying_lua") then
				event.damage = event.damage * 2
			end
		end
		if victim:GetName() == "npc_dota_creep_siege" then
			if inflictor:GetName() ~= "dragon_knight_breathe_fire_datadriven" 
				and inflictor:GetName() ~= "keeper_of_the_light_illuminate"
				and inflictor:GetName() ~= "keeper_of_the_light_spirit_form_illuminate"
				and inflictor:GetName() ~= "abaddon_death_coil_datadriven"
				and inflictor:GetName() ~= "clinkz_death_pact_datadriven"
				and inflictor:GetName() ~= "doom_bringer_devour_datadriven"
				and inflictor:GetName() ~= "warlock_shadow_word"
				and inflictor:GetName() ~= "kunkka_tidebringer_datadriven"
				and inflictor:GetName() ~= "medusa_split_shot" 
				and inflictor:GetName() ~= "axe_counter_helix_datadriven" 
				and inflictor:GetName() ~= "item_bfury_datadriven" 
				and inflictor:GetName() ~= "magnataur_empower_datadriven" 
				and inflictor:GetName() ~= "sven_great_cleave"
				and inflictor:GetName() ~= "gyrocopter_rocket_barrage"
				and inflictor:GetName() ~= "gyrocopter_flak_cannon"
				and inflictor:GetName() ~= "beastmaster_wild_axes" then
				event.damage = 0
			end
		end
    else
		--print(victim:GetName())
        if attacker:HasModifier("modifier_ember_spirit_sleight_of_fist_in_progress") and victim:IsCreep() then
            event.damage = event.damage / 2
        end
	end
	-- record last attacked by hero time
	--if attacker:IsHero() and event.damage > 0 then
	--	victim.lastAttackedByHeroTime = GameRules:GetGameTime()
	--end
	--if attacker:IsCreep() and event.damage > 0 then
	--	victim.damagedByCreepTime = GameRules:GetGameTime()
	--elseif attacker:IsConsideredHero() and event.damage > 0 then
	--	victim.damagedByHeroTime = GameRules:GetGameTime()
	--	victim.damagedByHero = attacker
	--elseif attacker:IsBuilding() then
	--	victim.damagedByTowerTime = GameRules:GetGameTime()
	--end

	return true
end

cold_snap_freeze_cooldown = {0.77, 0.74, 0.71, 0.69, 0.66, 0.63, 0.6}
tornado_lift_duration = {0.8, 1.1, 1.4, 1.7, 2, 2.3, 2.5}
chaos_meteor_travel_distance = {465, 615, 770, 920, 1070, 1220, 1370}
function CAddonTemplateGameMode:AbilityTuningValueFilter(event)
	local ability = EntIndexToHScript(event.entindex_ability_const)
	local caster = EntIndexToHScript(event.entindex_caster_const)
	--print("AbilityTuningValueFilter " .. ability:GetName() .. " " .. event.value_name_const)
	if ability:GetName() == "ogre_magi_ignite_datadriven" and event.value_name_const == "AbilityCastRange" then
		local ability_multicast = caster:FindAbilityByName("ogre_magi_multicast_datadriven")
		if ability_multicast ~= nil and ability_multicast:GetLevel() > 0 then
			event.value = event.value + ability_multicast:GetSpecialValueFor("ignite_range")
			return true
		end
	-- invoker skills aghs won't give extra level
	elseif ability:GetName() == "invoker_sun_strike" and event.value_name_const == "damage" then
		local ability_exort = caster:FindAbilityByName("invoker_exort")
		if ability_exort ~= nil then
			event.value = 37.5 + 62.5 * ability_exort:GetLevel()
			return true
		end
	elseif ability:GetName() == "invoker_cold_snap" then
		local ability_quas = caster:FindAbilityByName("invoker_quas")
		if ability_quas == nil then
			return false
		end
		if event.value_name_const == "duration" then
			event.value = 2.5 + 0.5 * ability_quas:GetLevel()
		elseif event.value_name_const == "freeze_cooldown" then
			event.value = cold_snap_freeze_cooldown[ability_quas:GetLevel()]
		elseif event.value_name_const == "freeze_damage" then
			event.value = 7 * ability_quas:GetLevel()
		end
		return true
	elseif ability:GetName() == "invoker_ghost_walk" then
		local ability_quas = caster:FindAbilityByName("invoker_quas")
		local ability_wex = caster:FindAbilityByName("invoker_wex")
		if ability_quas == nil or ability_wex == nil then
			return false
		end
		if event.value_name_const == "enemy_slow" then
			event.value = -15 - 5 * ability_quas:GetLevel()
		elseif event.value_name_const == "self_slow" then
			event.value = -40 + 10 * ability_wex:GetLevel()
		end
		return true
	elseif ability:GetName() == "invoker_tornado" then
		local ability_quas = caster:FindAbilityByName("invoker_quas")
		local ability_wex = caster:FindAbilityByName("invoker_wex")
		if ability_quas == nil or ability_wex == nil then
			return false
		end
		if event.value_name_const == "travel_distance" then
			event.value = 400 + 400 * ability_wex:GetLevel()
		elseif event.value_name_const == "lift_duration" then
			event.value = tornado_lift_duration[ability_quas:GetLevel()]
		elseif event.value_name_const == "wex_damage" then
			event.value = 45 * ability_wex:GetLevel()
		end
		return true
	elseif ability:GetName() == "invoker_emp" then
		local ability_wex = caster:FindAbilityByName("invoker_wex")
		if ability_wex == nil then
			return false
		end
		if event.value_name_const == "mana_burned" then
			event.value = 25 + 75 * ability_wex:GetLevel()
		end
		return true
	elseif ability:GetName() == "invoker_alacrity" then
		local ability_wex = caster:FindAbilityByName("invoker_wex")
		local ability_exort = caster:FindAbilityByName("invoker_exort")
		if ability_wex == nil or ability_exort == nil then
			return false
		end
		if event.value_name_const == "bonus_attack_speed" then
			event.value = 10 + 10 * ability_wex:GetLevel()
		elseif event.value_name_const == "bonus_damage" then
			event.value = 10 + 10 * ability_exort:GetLevel()
		end
		return true
	elseif ability:GetName() == "invoker_chaos_meteor" then
		local ability_wex = caster:FindAbilityByName("invoker_wex")
		local ability_exort = caster:FindAbilityByName("invoker_exort")
		if ability_wex == nil or ability_exort == nil then
			return false
		end
		if event.value_name_const == "travel_distance" then
			event.value = chaos_meteor_travel_distance[ability_wex:GetLevel()]
		elseif event.value_name_const == "main_damage" then
			event.value = 40 + 17.5 * ability_exort:GetLevel()
		elseif event.value_name_const == "burn_dps" then
			event.value = 8 + 3.5 * ability_exort:GetLevel()
		end
		return true
	elseif ability:GetName() == "invoker_forge_spirit" then
		local ability_quas = caster:FindAbilityByName("invoker_quas")
		local ability_exort = caster:FindAbilityByName("invoker_exort")
		if ability_quas == nil or ability_exort == nil then
			return false
		end
		if event.value_name_const == "spirit_damage" then
			event.value = 20 + 9 * ability_exort:GetLevel()
		elseif event.value_name_const == "spirit_mana" then
			event.value = 50 + 50 * ability_exort:GetLevel()
		elseif event.value_name_const == "spirit_armor" then
			event.value = -1 + 1 * ability_exort:GetLevel()
		elseif event.value_name_const == "spirit_attack_range" then
			event.value = 235 + 65 * ability_quas:GetLevel()
		elseif event.value_name_const == "spirit_hp" then
			event.value = 200 + 100 * ability_quas:GetLevel()
		elseif event.value_name_const == "spirit_duration" then
			event.value = 10 + 10 * ability_quas:GetLevel()
		elseif event.value_name_const == "extra_spirit_count_quas" then
			if ability_quas:GetLevel() >= 4 then
				event.value = 1
			else
				event.value = 0
			end
		elseif event.value_name_const == "extra_spirit_count_exort" then
			if ability_exort:GetLevel() >= 4 then
				event.value = 1
			else
				event.value = 0
			end
		end
		return true
	elseif ability:GetName() == "invoker_ice_wall" then
		local ability_quas = caster:FindAbilityByName("invoker_quas")
		local ability_exort = caster:FindAbilityByName("invoker_exort")
		if ability_quas == nil or ability_exort == nil then
			return false
		end
		if event.value_name_const == "duration" then
			event.value = 1.5 + 1.5 * ability_quas:GetLevel()
		elseif event.value_name_const == "slow" then
			event.value = -20 * ability_quas:GetLevel()
		elseif event.value_name_const == "damage_per_second" then
			event.value = 6 * ability_exort:GetLevel()
		end
		return true
	elseif ability:GetName() == "invoker_deafening_blast" then
		local ability_quas = caster:FindAbilityByName("invoker_quas")
		local ability_wex = caster:FindAbilityByName("invoker_wex")
		local ability_exort = caster:FindAbilityByName("invoker_exort")
		if ability_quas == nil or ability_wex == nil or ability_exort == nil then
			return false
		end
		if event.value_name_const == "damage" then
			event.value = 40 * ability_exort:GetLevel()
		elseif event.value_name_const == "knockback_duration" then
			event.value = 0.25 * ability_quas:GetLevel()
		elseif event.value_name_const == "disarm_duration" then
			event.value = 0.5 + 0.5 * ability_wex:GetLevel()
		end
		return true
	elseif ability:GetName() == "lone_druid_rabid" then
		if event.value_name_const == "rabid_duration" then
			local ability_synergy = caster:FindAbilityByName("lone_druid_synergy_datadriven")
			if ability_synergy == nil or ability_synergy:GetLevel() == 0 then
				return false
			end
			event.value = event.value + ability_synergy:GetSpecialValueFor("rabid_duration_bonus")
			return true
		end
	elseif ability:GetName() == "item_manta" then
		if event.value_name_const == "images_take_damage_percent" then
			if caster:IsRangedAttacker() then
				event.value = 300
				return true
			end
		end
	elseif ability:GetName() == "death_prophet_exorcism" then
		if event.value_name_const == "spirits" then
			local witchcraft = caster:FindAbilityByName("death_prophet_witchcraft_datadriven")
			if witchcraft:GetLevel() > 0 then
				event.value = event.value + witchcraft:GetSpecialValueFor("exorcism_extra_spirits")
				return true
			end
		end
	elseif ability:GetName() == "pudge_dismember" and event.value_name_const == "AbilityChannelTime" then
		local target = ability:GetCursorTarget()
		if target ~= nil and target:IsCreep() then
			event.value = ability:GetSpecialValueFor("creep_dismember_duration_tooltip")
			return true
		end
	end
end

function CAddonTemplateGameMode:TrackingProjectileFilter(event)
	local ability = EntIndexToHScript(event.entindex_ability_const)
	if ability ~= nil and ability:GetName() == "winter_wyvern_splinter_blast" then
		event.dodgeable = 0
	end
	return true
end

function CAddonTemplateGameMode:handleLadderHeroBanned(event)
	local hero = slot_2_heroes[event.hero_id_suffix]
	print("hero banned " .. hero)
	ladder_heroes_2_ban[hero] = ladder_heroes_2_ban[hero] + 1
	CustomGameEventManager:Send_ServerToAllClients("ladder_hero_ban_s2c", {id_suffix = event.hero_id_suffix})
end

captain_radiant_pick = {}
captain_radiant_ban = {}
captain_dire_pick = {}
captain_dire_ban = {}

function CAddonTemplateGameMode:handleCaptainClientPick(event)
	DeepPrintTable(event)
	if GameRules.AddonTemplate.game_mode == "CD" then
		handleCaptainDraftPickEvent(event)
		return
	end
	local captain_pick_phase = GameRules.AddonTemplate.captain_pick_phase
	if captain_pick_phase == event.pp then
		if captain_pick_phase == 0 
			or captain_pick_phase == 2 
			or captain_pick_phase == 8 
			or captain_pick_phase == 10
			or captain_pick_phase == 17
			then
			if PlayerResource:GetPlayer(event.pid):GetTeam() ~= DOTA_TEAM_GOODGUYS then
				print("pick by wrong team")
				return
			end
			table.insert(captain_radiant_ban, event.sh)
			DeepPrintTable(captain_radiant_ban)
		elseif captain_pick_phase == 1 
			or captain_pick_phase == 3 
			or captain_pick_phase == 9
			or captain_pick_phase == 11
			or captain_pick_phase == 16
			then
			if PlayerResource:GetPlayer(event.pid):GetTeam() ~= DOTA_TEAM_BADGUYS then
				print("pick by wrong team")
				return
			end
			table.insert(captain_dire_ban, event.sh)
			DeepPrintTable(captain_dire_ban)
		elseif captain_pick_phase == 4 
			or captain_pick_phase == 6
			or captain_pick_phase == 12
			or captain_pick_phase == 14
			or captain_pick_phase == 18
			then
			if PlayerResource:GetPlayer(event.pid):GetTeam() ~= DOTA_TEAM_GOODGUYS then
				print("pick by wrong team")
				return
			end
			table.insert(captain_radiant_pick, event.sh)
			DeepPrintTable(captain_radiant_pick)
		elseif captain_pick_phase == 5
			or captain_pick_phase == 7
			or captain_pick_phase == 13
			or captain_pick_phase == 15
			or captain_pick_phase == 19
			then
			if PlayerResource:GetPlayer(event.pid):GetTeam() ~= DOTA_TEAM_BADGUYS then
				print("pick by wrong team")
				return
			end
			table.insert(captain_dire_pick, event.sh)
			DeepPrintTable(captain_dire_pick)
		end
		if (captain_pick_phase == 19) then
			GameRules:GetGameModeEntity():SetThink(function()
				print("Setting radiant pick")
				for i=1,PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) do
					local playerId = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
					for j=1,#captain_radiant_pick do
						local hero_name = "npc_dota_hero_"..captain_radiant_pick[j]
						print("Adding hero " .. hero_name .. " to player " .. playerId)
						GameRules:AddHeroToPlayerAvailability(playerId, DOTAGameManager:GetHeroIDByName(hero_name))
					end
				end
				print("Setting dire pick")
				for i=1,PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS) do
					local playerId = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
					for j=1,#captain_dire_pick do
						GameRules:AddHeroToPlayerAvailability(playerId, DOTAGameManager:GetHeroIDByName("npc_dota_hero_"..captain_dire_pick[j]))
					end
				end
				CustomGameEventManager:Send_ServerToAllClients("captain_player_pick_start", {})
			end, "captain pick ends", 5)
		end
		CustomGameEventManager:Send_ServerToAllClients(
			"captain_hero_pick_s2c", { pp = captain_pick_phase, sh = event.sh })
		GameRules.AddonTemplate.captain_pick_phase = captain_pick_phase + 1
		GameRules.AddonTemplate.captain_normal_time = 40
	end
end

--[[
-- Deprecated
function CAddonTemplateGameMode:handleHeroBarPingMiss(event)
	local missing_player_id = event.mpid;
	local reporting_player_id = event.pid;
	local missing_hero = PlayerResource:GetPlayer(missing_player_id):GetAssignedHero():GetName()
	local team = PlayerResource:GetPlayer(reporting_player_id):GetTeam()
	GameRules:SendCustomMessageToTeam(string.sub(missing_hero, 15) .. "_miss", team, -1, -1)
end]]--

function handleFWDCommand(userid, event)
	if GetMapName() ~= "dota" or PlayerResource:GetPlayerCount() ~= 1 then
		return
	end
	if event.type == 'ally' then
		local player = PlayerResource:GetPlayer(event.playerid)
		CreateUnitByNameAsync("npc_dota_hero_" .. event.heroname, Vector(
			event.position["0"], event.position["1"], event.position["2"]), 
			true, nil, nil, player:GetTeam(), function(unit)
				unit:SetControllableByPlayer(event.playerid, true)
			end)
	elseif event.type == 'enem' then
		local player = PlayerResource:GetPlayer(event.playerid)
		local team
		if player:GetTeam() == DOTA_TEAM_GOODGUYS then
			team = DOTA_TEAM_BADGUYS 
		else
			team = DOTA_TEAM_GOODGUYS
		end
		CreateUnitByNameAsync("npc_dota_hero_" .. event.heroname, Vector(
			event.position["0"], event.position["1"], event.position["2"]), 
			true, nil, nil, team, function(unit)
				unit:SetControllableByPlayer(event.playerid, true)
			end)
	elseif event.type == 'rune' then
		CreateRune(GetGroundPosition(
			Vector(event.position["0"], event.position["1"], event.position["2"]), nil),
			event.rune)
	elseif event.type == 'item' then
		for _,val in pairs(event.entities) do
			EntIndexToHScript(val):AddItemByName(event.itemname)
		end
	elseif event.type == 'lvlup' then
		for _,val in pairs(event.entities) do
			EntIndexToHScript(val):HeroLevelUp(true)
		end
	elseif event.type == 'lvlmax' then
		for _,val in pairs(event.entities) do
			for i=1,25 do
				EntIndexToHScript(val):HeroLevelUp(false)
			end
		end
	elseif event.type == 'nocd' then
		fwdnocdenabled = event.state
	end
end

function HandleBuyback(entindex, player_id)
	local entity = EntIndexToHScript(entindex)
	entity.buybacked = true
	local gold_penalty_duration = entity:GetLevel() * 4 + entity.last_dead_time - GameRules:GetDOTATime(false, false);
	print("gold_penalty_duration "..gold_penalty_duration)
	entity:FindAbilityByName("hero_intrinstic_mechanism_datadriven"):ApplyDataDrivenModifier(
		entity, entity, "modifier_hero_buybacked_gold_penalty", { duration = gold_penalty_duration });
	PlayerResource:SetCustomBuybackCooldown(player_id, 420)
end

function HandlePlayerPickHero(hero)
	if same_ability_heroes[hero] ~= nil then
		GameRules:AddHeroToBlacklist(same_ability_heroes[hero])
	end
end

function HandleItemPickedUp(itemname, playerid)
	if itemname == "item_aegis_lua" then
		CustomGameEventManager:Send_ServerToAllClients("aegis_picked_up", { kpid = playerid })
	end
end

function HandleItemDestroyed(itemname, heroindex)
	if itemname == "item_aegis_lua" then
		local attacker = EntIndexToHScript(heroindex)
		CustomGameEventManager:Send_ServerToAllClients("aegis_destroyed", { kpid = attacker:GetPlayerOwnerID() })
	end
end

function HandleHeroSwap(player1, player2)
	if not isMapRanked() then
		if PlayerResource:HasRandomed(player1) then
			PlayerResource:ModifyGold(player1, -100, false, DOTA_ModifyGold_SelectionPenalty)
		end
		if PlayerResource:HasRandomed(player2) then
			PlayerResource:ModifyGold(player2, -100, false, DOTA_ModifyGold_SelectionPenalty)
		end
	end
end

function bitand(a, b)
    local result = 0
    local bitval = 1
    while a > 0 and b > 0 do
      if a % 2 == 1 and b % 2 == 1 then -- test the rightmost bits
          result = result + bitval      -- set the current bit
      end
      bitval = bitval * 2 -- shift left
      a = math.floor(a/2) -- shift right
      b = math.floor(b/2)
	end
    return result
end

function CAddonTemplateGameMode:HandleChannelFinish(event)
	-- DeepPrintTable(event)
	local caster = EntIndexToHScript(event.caster_entindex)
	if event.abilityname == "bane_fiends_grip" then
		caster:RemoveModifierByName("modifier_bane_fiends_grip_scepter")
	end
end

function CAddonTemplateGameMode:HandleItemPurchased(event)
	local time = GameRules:GetDOTATime(true, true)
	print("HandleItemPurchased " .. event.itemname .. " " .. event.PlayerID .. " " .. time)
	if event.itemname == "item_tpscroll" and (self.game_mode == "DM" or time < 0)  then
		local hero = PlayerResource:GetPlayer(event.PlayerID):GetAssignedHero()
		-- DM allways resets cooldown if tp purchased from base
		if hero:IsInRangeOfShop(DOTA_SHOP_HOME, true) then
			local item = hero:FindItemInInventory("item_tpscroll")
			item:EndCooldown()
		end
	end
end

function CAddonTemplateGameMode:HandleInventoryItemAdded(event)
	local time = GameRules:GetDOTATime(false, true)
	print("HandleInventoryItemAdded " .. event.itemname .. " " .. event.inventory_player_id .. " " .. event.is_courier .. " " .. time)
	if event.itemname == "item_tpscroll" or time < 0 then return end
	local hero = PlayerResource:GetPlayer(event.inventory_player_id):GetAssignedHero()
	hero:QueueTeamConceptNoSpectators(1, {
		custom_behaviour = "purchase",
		itemname = event.itemname
	}, nil, hero, nil)
end

function getAllPlayerIds() 
	local playerIds = {}
	for i=1,PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) do
		local player = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
		table.insert(playerIds, {player, PlayerResource:GetSteamAccountID(player)})
	end
	for i=1,PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS) do
		local player = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
		table.insert(playerIds, {player, PlayerResource:GetSteamAccountID(player)})
	end
	for i=1,PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_NOTEAM) do
		local player = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_NOTEAM, i)
		table.insert(playerIds, {player, PlayerResource:GetSteamAccountID(player)})
	end
	return playerIds
end

function CAddonTemplateGameMode:handleFirstBlood()
	self.firstBlood = true
	if isMapRanked() and self.isValidRankedGame and not self.hasGameEnded then
		uploadGameToServer(LADDER_HOST)
	end
end

function CAddonTemplateGameMode:handleGameModeSelect(data)
	print("handleGameModeSelect")
	DeepPrintTable(data)
	if GetMapName() == "dota" and GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		if data.sp ~= nil then
			if data.sp == 1 and not sameHeroPickEnabled then
				GameRules:SetSameHeroSelectionEnabled(true)
				sameHeroPickEnabled = true
				GameRules:SendCustomMessage("开启相同英雄选择", -1, -1)
			elseif data.sp == 0 and sameHeroPickEnabled then
				GameRules:SetSameHeroSelectionEnabled(false)
				sameHeroPickEnabled = false
				GameRules:SendCustomMessage("关闭相同英雄选择", -1, -1)
			end
			CustomGameEventManager:Send_ServerToAllClients("game_mode_selected_from_server", { pid = data.pid, sp = data.sp })
			return
		elseif data.fp ~= nil then
			if data.fp ~= custom_game_first_pick then
				if data.fp == 'random' then
					GameRules:SendCustomMessage("随机阵营先选", -1, -1)
				elseif data.fp == 'rad' then
					GameRules:SendCustomMessage("近卫先选", -1, -1)
				elseif data.fp == "dire" then
					GameRules:SendCustomMessage("天灾先选", -1, -1)
				end
				custom_game_first_pick = data.fp
				CustomGameEventManager:Send_ServerToAllClients("game_mode_selected_from_server", { pid = data.PlayerID, fp = data.fp})
			end
			return
		end
		GameRules.AddonTemplate.botEnabled = false
		local hasGameModeChanged = (data.gm == "ap" and GameRules.AddonTemplate.game_mode ~= "AP") or
								   (data.gm == "dm" and GameRules.AddonTemplate.game_mode ~= "DM") or
								   (data.gm == "rd" and GameRules.AddonTemplate.game_mode ~= "RD") or
								   (data.gm == "js" and GameRules.AddonTemplate.game_mode ~= "JS") or
								   (data.gm == "sp" and GameRules.AddonTemplate.game_mode ~= "SP") or
								   (data.gm == "cm" and GameRules.AddonTemplate.game_mode ~= "CM") or
								   (data.gm == "cd" and GameRules.AddonTemplate.game_mode ~= "CD") 
		if data.gm == 'ap' then
			GameRules.AddonTemplate.game_mode = "AP"
			GameRules:SetHeroSelectionTime(80)
			GameRules:GetGameModeEntity():SetPlayerHeroAvailabilityFiltered(false)
			GameRules:SendCustomMessage("AP模式开启", -1, -1)
		elseif data.gm == 'dm' then
			GameRules.AddonTemplate.game_mode = "DM"
			GameRules:GetGameModeEntity():SetPlayerHeroAvailabilityFiltered(false)
			GameRules:SendCustomMessage("开启死亡随机模式", -1, -1)
		elseif data.gm == 'rd' then
			GameRules.AddonTemplate.game_mode = "RD"
			GameRules:SetHeroSelectionTime(120)
			GameRules:GetGameModeEntity():SetPlayerHeroAvailabilityFiltered(true)
			GameRules:SendCustomMessage("开启RD模式", -1, -1)
		elseif data.gm == 'js' then
			GameRules.AddonTemplate.game_mode = "LD"
			GameRules:SetHeroSelectionTime(80)
			GameRules:GetGameModeEntity():SetPlayerHeroAvailabilityFiltered(false)
			GameRules:SendCustomMessage("开启JS模式", -1, -1)
		elseif data.gm == 'sp' then
			GameRules.AddonTemplate.game_mode = "SP"
			GameRules:SetHeroSelectionTime(80)
			GameRules:GetGameModeEntity():SetPlayerHeroAvailabilityFiltered(true)
			GameRules:SendCustomMessage("开启SP模式", -1, -1)
		elseif data.gm == 'cm' then
			GameRules.AddonTemplate.game_mode = "CM"
			GameRules:SetHeroSelectionTime(40 * 10 + 110 * 2 + 60)
			GameRules:GetGameModeEntity():SetPlayerHeroAvailabilityFiltered(true)
			GameRules:SendCustomMessage("开启CM模式", -1, -1)
		elseif data.gm == 'cd' then
			GameRules.AddonTemplate.game_mode = "CD"
			GameRules:SetHeroSelectionTime(360)
			GameRules:GetGameModeEntity():SetPlayerHeroAvailabilityFiltered(true)
			GameRules:SendCustomMessage("开启CD模式", -1, -1)
		else
			print("Invalid game mode selected " .. data.gm)
			return
		end
		if hasGameModeChanged then
			CustomGameEventManager:Send_ServerToAllClients("game_mode_selected_from_server", { pid = data.pid, gm = data.gm })
		end
	end
end
