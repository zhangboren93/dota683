-- key ability name
-- adpl: attack damage per level
-- as: attack speed
-- attack: attack damage
-- attackppl: attack damage percentage per level
-- duration: mdps duration
-- mdamage: magic damage
-- mdamagepl: magic damage per level
-- mdps: magic damage per second
-- mdpspl: magic damage per second per level
-- pdamagepl: pure damage per level
-- slow: slow duration
-- slowpl: slow duration per level
-- stun: stun duration
-- stunpl: stun duration per level
HERO_ABILITY_POWER = {}
HERO_ABILITY_POWER["antimage_mana_break_datadriven"] = {
	adpl = {17, 24, 31, 38} -- attack damage per level
}
HERO_ABILITY_POWER["antimage_mana_void"] = {
	stun = "mana_void_ministun", -- stun duration
	mdamagepl = {300, 425, 550}
}

HERO_ABILITY_POWER["lina_dragon_slave"] = {
	mdamage = "dragon_slave_damage" -- magic damage
}
HERO_ABILITY_POWER["lina_light_strike_array"] = {
	mdamage = "light_strike_array_damage",
	stun = "light_strike_array_stun_duration"
}
HERO_ABILITY_POWER["lina_fiery_soul_datadriven"] = {
	as = "fiery_soul_attack_speed_bonus" -- attack speed
}
HERO_ABILITY_POWER["lina_laguna_blade"] = {
	mdamage = "damage"
}

HERO_ABILITY_POWER["viper_poison_attack_datadriven"] = {
	mdps = "damage", -- magic damage per seconds
	slow = "duration"
}
HERO_ABILITY_POWER["viper_nethertoxin_datadriven"] = {
	attack = "hero_damage_60" -- attack damage
}
HERO_ABILITY_POWER["viper_corrosive_skin_datadriven"] = {
	mdps = "damage"
}
HERO_ABILITY_POWER["viper_viper_strike"] = {
	mdps = "damage_tooltip",
	slow = "duration",
	duration = "duration"
}

HERO_ABILITY_POWER["venomancer_venomous_gale"] = {
	mdamage = "strike_damage",
	mdpspl = {0, 10, 20, 30},
	duration = "duration",
	slow = "duration"
}
HERO_ABILITY_POWER["venomancer_poison_sting_datadriven"] = {
	mdps = "damage",
	duration = "duration"
}
HERO_ABILITY_POWER["venomancer_plague_ward"] = {
	attack = "ward_damage_tooltip"
}
HERO_ABILITY_POWER["venomancer_poison_nova_datadriven"] = {
	mdps = "damage",
	duration = "duration"
}

HERO_ABILITY_POWER["crystal_maiden_crystal_nova"] = {
	mdamage = "nova_damage",
	slow = "duration"
}
HERO_ABILITY_POWER["crystal_maiden_frostbite"] = {
	mdps = "damage_per_second",
	duration = "duration",
	stun = "duration"
}
HERO_ABILITY_POWER["crystal_maiden_freezing_field"] = {
	mdps = "damage",
	duration = "AbilityDuration",
	slow = "AbilityDuration"
}

HERO_ABILITY_POWER["drow_ranger_frost_arrows"] = {
	slow = "frost_arrow_hero_duration_tooltip"
}
HERO_ABILITY_POWER["drow_ranger_wave_of_silence"] = {
	silence = "silence_duration"
}

HERO_ABILITY_POWER["phantom_assassin_stifling_dagger_datadriven"] = {
	pdamagepl = {30, 50, 70, 90},
	slow = "AbilityDuration"
}
HERO_ABILITY_POWER["phantom_assassin_phantom_strike_datadriven"] = {
	as = "bonus_attack_speed"
}
HERO_ABILITY_POWER["phantom_assassin_coup_de_grace_datadriven"] = {
	attackppl = {19.5, 36, 52.5}
}

HERO_ABILITY_POWER["spirit_breaker_charge_of_darkness"] = {
	stun = "stun_duration",
}
HERO_ABILITY_POWER["spirit_breaker_greater_bash"] = {
	stunpl = {0.17, 0.20, 0.23, 0.27},
	attackpl = {19, 24, 29, 34}
}
HERO_ABILITY_POWER["spirit_breaker_nether_strike_datadriven"] = {
	mdamage = "damage",
	stunpl = {1, 1.3, 1.6}
}

HERO_ABILITY_POWER["sniper_shrapnel"] = {
	slow = "duration",
	mdps = "shrapnel_damage",
	duration = "duration"
}
HERO_ABILITY_POWER["sniper_headshot_datadriven"] = {
	attackpl = {6, 16, 26, 36},
	slowpl = {0.2, 0.2, 0.2, 0.2}
}
HERO_ABILITY_POWER["sniper_assassinate_datadriven"] = {
	mdamage = "AbilityDamage"
}

HERO_ABILITY_POWER["abaddon_death_coil_datadriven"] = {
	mdamage = "target_damage"
}
HERO_ABILITY_POWER["abaddon_frostmourne_datadriven"] = {
	slow = "debuff_duration",
	as = "attack_speed"
}

HERO_ABILITY_POWER["skeleton_king_hellfire_blast"] = { 
	mdamage = "AbilityDamage",
	stun = "blast_stun_duration",
	mdps = "blast_dot_damage",
	duration = "blast_dot_duration",
	slow = "blast_dot_duration"
}
HERO_ABILITY_POWER["skeleton_king_mortal_strike_datadriven"] = {
	attackppl = {7.5, 15, 22.5, 30}
}

HERO_ABILITY_POWER["bristleback_viscous_nasal_goo"] = {
	slow = "base_move_slow"
}
HERO_ABILITY_POWER["bristleback_quill_spray"] = {
	pdamagepl = {80, 105, 130, 150}
}

HERO_ABILITY_POWER["luna_lucent_beam"] = {
	mdamage = "beam_damage",
	stun = "stun_duration"
}
HERO_ABILITY_POWER["luna_eclipse"] = {
	mdamagepl = {520, 600, 600}
}