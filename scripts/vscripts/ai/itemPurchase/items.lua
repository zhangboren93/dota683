--------------------------------------------------------------------------------------------
--- AUTHOR: Nostrademous, pbenologa, dralois
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
--------------------------------------------------------------------------------------------

local X = {}

--------------------------------------------------------------------------------------------
-- Basics (includes secret shop items)
--------------------------------------------------------------------------------------------

X["item_boots_of_elves"]  = {"item_boots_of_elves"}

X["item_belt_of_strength"]  = {"item_belt_of_strength"}

X["item_blade_of_alacrity"]  = {"item_blade_of_alacrity"}

X["item_blades_of_attack"]  = {"item_blades_of_attack"}

X["item_blink"]  = {"item_blink"}

X["item_boots"]  = {"item_boots"}

X["item_bottle"]  = {"item_bottle"}

X["item_broadsword"]  = {"item_broadsword"}

X["item_chainmail"]  = {"item_chainmail"}

X["item_circlet"]  = {"item_circlet"}

X["item_clarity"]  = {"item_clarity"}

X["item_claymore"]  = {"item_claymore"}

X["item_cloak"]  = {"item_cloak"}

X["item_demon_edge"]  = {"item_demon_edge"}

X["item_dust_datadriven"]  = {"item_dust_datadriven"}

X["item_eagle"]  = {"item_eagle"}

X["item_energy_booster"]  = {"item_energy_booster"}

X["item_gauntlets"]  = {"item_gauntlets"}

X["item_gem"]  = {"item_gem"}

X["item_ghost"]  = {"item_ghost"}

X["item_gloves"]  = {"item_gloves"}

X["item_flask"]  = {"item_flask"}

X["item_helm_of_iron_will"]  = {"item_helm_of_iron_will"}

X["item_hyperstone"]  = {"item_hyperstone"}

X["item_branches"]  = {"item_branches"}

X["item_javelin_datadriven"]  = {"item_javelin_datadriven"}

X["item_magic_stick"]  = {"item_magic_stick"}

X["item_mantle"]  = {"item_mantle"}

X["item_mithril_hammer"]  = {"item_mithril_hammer"}

X["item_lifesteal_datadriven"]  = {"item_lifesteal_datadriven"}

X["item_mystic_staff"]  = {"item_mystic_staff"}

X["item_ward_observer"]  = {"item_ward_observer"}

X["item_ogre_axe"]  = {"item_ogre_axe"}

X["item_orb_of_venom"]  = {"item_orb_of_venom"}

X["item_platemail"]  = {"item_platemail"}

X["item_point_booster"]  = {"item_point_booster"}

X["item_quarterstaff"]  = {"item_quarterstaff"}

X["item_quelling_blade_lua"]  = {"item_quelling_blade_lua"}

X["item_reaver"]  = {"item_reaver"}

X["item_ring_of_health"]  = {"item_ring_of_health"}

X["item_ring_of_protection"]  = {"item_ring_of_protection"}

X["item_ring_of_regen"]  = {"item_ring_of_regen"}

X["item_robe"]  = {"item_robe"}

X["item_relic"]  = {"item_relic"}

X["item_sobi_mask_datadriven"]  = {"item_sobi_mask_datadriven"}

X["item_ward_sentry"]  = {"item_ward_sentry"}

X["item_shadow_amulet"]  = {"item_shadow_amulet"}

X["item_slippers"]  = {"item_slippers"}

X["item_smoke_of_deceit"]  = {"item_smoke_of_deceit"}

X["item_staff_of_wizardry"]  = {"item_staff_of_wizardry"}

X["item_stout_shield"]  = {"item_stout_shield"}

X["item_talisman_of_evasion"]  = {"item_talisman_of_evasion"}

X["item_tango"]  = {"item_tango"}

X["item_tpscroll"]  = {"item_tpscroll"}

X["item_ultimate_orb"]  = {"item_ultimate_orb"}

X["item_vitality_booster"]  = {"item_vitality_booster"}

X["item_void_stone_datadriven"]  = {"item_void_stone_datadriven"}

--------------------------------------------------------------------------------------------
-- Items made from basics
--------------------------------------------------------------------------------------------

-- Aghanim's Scepter
X["item_ultimate_scepter"] = { "item_point_booster", "item_staff_of_wizardry", "item_blade_of_alacrity", "item_ogre_axe" }

X["item_arcane_boots"] = { "item_boots", "item_energy_booster"}

-- Armlet of Mordiggian
X["item_armlet"] = { "item_helm_of_iron_will", "item_gloves", "item_blades_of_attack", "item_recipe_armlet" }

-- Assault Cuirass
X["item_assault"] = { "item_platemail", "item_chainmail", "item_hyperstone", "item_recipe_assault" }

X["item_black_king_bar_datadriven"] = { "item_mithril_hammer", "item_ogre_axe", "item_recipe_black_king_bar_datadriven" }

X["item_blade_mail"] = { "item_broadsword", "item_robe", "item_chainmail" }

X["item_boots_of_travel"] = { "item_boots", "item_recipe_travel_boots_datadriven" }

X["item_bracer"] = { "item_gauntlets", "item_circlet", "item_recipe_bracer" }

X["item_buckler_2"] = { "item_branches", "item_chainmail", "item_recipe_buckler_2" }

X["item_butterfly_datadriven"] = { "item_talisman_of_evasion", "item_eagle", "item_quarterstaff" }

-- Crystalys
X["item_lesser_crit"] = { "item_broadsword", "item_blades_of_attack", "item_recipe_lesser_crit" }

X["item_desolator_datadriven"] = { "item_mithril_hammer", "item_mithril_hammer", "item_recipe_desolator_datadriven" }

X["item_diffusal_blade_datadriven"] = { "item_blade_of_alacrity", "item_blade_of_alacrity", "item_robe", "item_recipe_diffusal_blade_datadriven" }

X["item_diffusal_blade_2_datadriven"] = { X["item_diffusal_blade_1"], "item_recipe_diffusal_blade_datadriven" }

X["item_ethereal_blade"] = { "item_ghost", "item_eagle" }

-- Euls
X["item_cyclone"] = { "item_staff_of_wizardry", "item_sobi_mask_datadriven", "item_void_stone_datadriven", "item_recipe_cyclone" }

-- Eye of Skadi
X["item_skadi"] = { "item_point_booster", "item_orb_of_venom", "item_ultimate_orb", "item_ultimate_orb" }

X["item_force_staff"] = { "item_ring_of_health", "item_staff_of_wizardry", "item_recipe_force_staff" }

X["item_hand_of_midas"] = { "item_gloves", "item_recipe_hand_of_midas" }

X["item_headdress_datadriven"] = { "item_branches", "item_ring_of_regen", "item_recipe_headdress_datadriven" }

X["item_heart_datadriven"] = { "item_reaver", "item_vitality_booster", "item_recipe_heart_datadriven" }

X["item_hood_of_defiance_datadriven"] = { "item_ring_of_health", "item_cloak", "item_ring_of_regen", "item_ring_of_regen" }

X["item_maelstrom_datadriven"] = { "item_gloves", "item_mithril_hammer", "item_recipe_maelstrom_datadriven" }

X["item_magic_wand"] = { "item_branches", "item_branches", "item_branches", "item_magic_stick", "item_recipe_magic_wand" }

X["item_mask_of_madness_datadriven"] = { "item_lifesteal", "item_recipe_mask_of_madness_datadriven" }

X["item_medallion_of_courage"] = { "item_chainmail", "item_sobi_mask_datadriven", "item_recipe_medallion_of_courage" }

X["item_monkey_king_bar_datadriven"] = { "item_demon_edge", "item_javelin_datadriven", "item_javelin_datadriven" }

X["item_necronomicon"] = { "item_staff_of_wizardry", "item_belt_of_strength", "item_recipe_necronomicon" }

X["item_necronomicon_2"] = { X["item_necronomicon_1"], "item_recipe_necronomicon" }

X["item_necronomicon_3"] = { X["item_necronomicon_2"], "item_recipe_necronomicon" }

X["item_null_talisman_datadriven"] = { "item_mantle", "item_circlet", "item_recipe_null_talisman_datadriven" }

X["item_oblivion_staff_datadriven"] = { "item_quarterstaff", "item_robe", "item_sobi_mask_datadriven" }

-- Perseverance
X["item_pers_datadriven"] = { "item_ring_of_health", "item_void_stone_datadriven" }

X["item_phase_boots"] = { "item_boots", "item_blades_of_attack", "item_blades_of_attack" }

X["item_poor_mans_shield"] = { "item_stout_shield", "item_slippers", "item_slippers" }

X["item_power_treads_agi"] = { "item_boots", "item_boots_of_elves", "item_gloves" }

X["item_power_treads_int"] = { "item_boots", "item_robe", "item_gloves" }

X["item_power_treads_str"] = { "item_boots", "item_belt_of_strength", "item_gloves" }

X["item_radiance"] = { "item_relic", "item_recipe_radiance" }

X["item_rapier"] = { "item_demon_edge", "item_relic" }

X["item_ring_of_basilius_datadriven"] = {  "item_ring_of_protection", "item_sobi_mask_datadriven" }

X["item_rod_of_atos_datadriven"] = { "item_vitality_booster", "item_staff_of_wizardry", "item_staff_of_wizardry", "item_recipe_rod_of_atos_datadriven" }

X["item_sange_datadriven"] = { "item_belt_of_strength", "item_ogre_axe", "item_recipe_sange_datadriven" }

X["item_satanic_datadriven"] = { X["item_helm_of_the_dominator_datadriven"], "item_reaver", "item_recipe_satanic_datadriven" }

-- Scythe of Vyse
X["item_sheepstick"] = { "item_mystic_staff", "item_ultimate_orb", "item_void_stone_datadriven" }

-- Shadow Blade
X["item_invis_sword"] = { "item_shadow_amulet", "item_claymore" }

X["item_shivas_guard"] = { "item_platemail", "item_mystic_staff", "item_recipe_shivas_guard" }

X["item_basher"] = { "item_javelin_datadriven", "item_belt_of_strength", "item_recipe_basher" }

X["item_soul_booster"] = { "item_point_booster", "item_vitality_booster", "item_energy_booster" }

X["item_soul_ring"] = { "item_ring_of_regen", "item_sobi_mask_datadriven", "item_recipe_soul_ring" }

X["item_tranquil_boots_datadriven"] = { "item_ring_of_protection", "item_ring_of_regen", "item_boots" }

X["item_urn_of_shadows_datadriven"] = { "item_gauntlets", "item_gauntlets", "item_sobi_mask_datadriven", "item_recipe_urn_of_shadows_datadriven" }

X["item_vanguard"] = { "item_stout_shield" , "item_vitality_booster", "item_ring_of_health" }

X["item_wraith_band_datadriven"] = { "item_slippers", "item_circlet", "item_recipe_wraith_band_datadriven" }

X["item_yasha"] = { "item_boots_of_elves", "item_blade_of_alacrity", "item_recipe_yasha" }

X["item_abyssal_blade"] = { X["item_basher"], "item_relic" }

X["item_bloodstone_datadriven"] = { X["item_soul_ring"], X["item_soul_booster"], "item_recipe_bloodstone_datadriven" }

-- Battle Fury
X["item_bfury_datadriven"] = { X["item_pers"], "item_claymore", "item_broadsword" }

X["item_crimson_guard"] = { X["item_buckler"], X["item_vanguard"], "item_recipe_crimson_guard" }

-- Daedalus
X["item_greater_crit"] = { X["item_lesser_crit"], "item_demon_edge", "item_recipe_greater_crit" }

X["item_dagon"] = { X["item_null_talisman_datadriven"], "item_staff_of_wizardry", "item_recipe_dagon" }

X["item_dagon_2"] = { X["item_dagon_1"], "item_recipe_dagon" }

X["item_dagon_3"] = { X["item_dagon_2"], "item_recipe_dagon" }

X["item_dagon_4"] = { X["item_dagon_3"], "item_recipe_dagon" }

X["item_dagon_5"] = { X["item_dagon_4"], "item_recipe_dagon" }

-- Drums
X["item_ancient_janggo_datadriven"] = { X["item_bracer"], "item_robe", "item_recipe_ancient_janggo_datadriven" }

X["item_heavens_halberd_datadriven"] = { X["item_sange_datadriven"], "item_talisman_of_evasion"}

X["item_helm_of_the_dominator_datadriven"] = { "item_lifesteal_datadriven", "item_helm_of_iron_will" }

-- Linken's Sphere
X["item_sphere"] = { X["item_pers_datadriven"], "item_ultimate_orb", "item_recipe_sphere" }

-- Manta Style
X["item_manta"] = { X["item_yasha"], "item_ultimate_orb", "item_recipe_manta" }

X["item_mekansm_2"] = { X["item_buckler_2"], X["item_headdress_datadriven"], "item_recipe_mekansm_2" }

X["item_mjollnir_datadriven"] = { X["item_maelstrom_datadriven"], "item_hyperstone", "item_recipe_mjollnir_datadriven" }

-- Orchid Malevolence
X["item_orchid"] = { X["item_oblivion_staff_datadriven"], X["item_oblivion_staff_datadriven"], "item_recipe_orchid" }

X["item_pipe"] = { X["item_hood_of_defiance_datadriven"], X["item_headdress_datadriven"], "item_recipe_pipe" }

-- Refresher Orb
X["item_refresher"] = { X["item_pers_datadriven"], X["item_oblivion_staff_datadriven"], "item_recipe_refresher" }

X["item_ring_of_aquila_lua"] = { X["item_ring_of_basilius_datadriven"], X["item_wraith_band_datadriven"] }

X["item_sange_and_yasha_datadriven"] = { X["item_sange_datadriven"], X["item_yasha"] }

X["item_veil_of_discord_datadriven"] = { X["item_null_talisman_datadriven"] , "item_helm_of_iron_will", "item_recipe_veil_of_discord_datadriven" }

X["item_vladmir_2"] = { X["item_ring_of_basilius_datadriven"] , "item_lifesteal_datadriven", "item_ring_of_regen", "item_recipe_vladmir_2" }

--------------------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------------------

function X:GetItemValueNumber(item)
    if item == "item_ward_observer" then
        return 10000
    elseif item == "item_dust" then
        return 10000
    elseif item == "item_ward_sentry" then
        return 10000
    elseif item ==  "item_smoke_of_deceit" then
        return 10000
    elseif item == "item_cheese" then
        return 10000
    elseif item == "item_tpscroll" then
        return 1000000
    elseif item == "item_gem" then
        return 10000
    elseif item == "item_courier" then
        return 10000
    elseif item == "item_flying_courier" then
        return 10000
    else
        return GetItemCost(item)
    end
end

function X:GetItemsTable(output, input)
  local input_map
  if type(input) == 'table' then
    input_map = {}
    for i = 1, #input do
            input_map[#input_map+1] = self:GetItemsTable(output, input[i])
    end
  else
    input_map = #output + 1
    output[input_map] = input
  end
  return input_map
end

--------------------------------------------------------------------------------------------

return X;
