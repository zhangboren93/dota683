function handleAltText(playerid)
	local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
	if hero:GetName() == "npc_dota_hero_skeleton_king" and not hero:HasModifier("modifier_skeleton_king_alt_model_lua") then
		setAltModel(hero)
		local ability = hero:FindAbilityByName("skeleton_king_hellfire_blast")
		local ability_level = ability:GetLevel()
		hero:RemoveAbility("skeleton_king_hellfire_blast")
		ability = hero:AddAbility("skeleton_king_hellfire_blast_2")
		ability:SetLevel(ability_level)
	elseif hero:GetName() == "npc_dota_hero_centaur" and not hero:HasModifier("modifier_centaur_alt_model_lua") then
		hero:SetOriginalModel("models/creeps/neutral_creeps/n_creep_centaur_lrg/n_creep_centaur_lrg.vmdl")
		hero:SetModel("models/creeps/neutral_creeps/n_creep_centaur_lrg/n_creep_centaur_lrg.vmdl")
		hero:ManageModelChanges()
		hero:AddNewModifier(hero, nil, "modifier_centaur_alt_model_lua", {})
		local ability = hero:FindAbilityByName("centaur_double_edge")
		local ability_level = ability:GetLevel()
		hero:RemoveAbility("centaur_double_edge")
		ability = hero:AddAbility("centaur_double_edge_2")
		ability:SetLevel(ability_level)
	elseif hero:GetName() == "npc_dota_hero_earth_spirit" then
		hero:SetOriginalModel("models/heroes/brewmaster/brewmaster_earthspirit.vmdl")
		hero:SetModel("models/heroes/brewmaster/brewmaster_earthspirit.vmdl")
		hero:ManageModelChanges()
	elseif hero:GetName() == "npc_dota_hero_ursa" and not hero:HasModifier("modifier_ursa_alt_model_lua") then
		hero:SetOriginalModel("models/creeps/neutral_creeps/n_creep_furbolg/n_creep_furbolg_disrupter.vmdl")
		hero:SetModel("models/creeps/neutral_creeps/n_creep_furbolg/n_creep_furbolg_disrupter.vmdl")
		hero:ManageModelChanges()
		hero:AddNewModifier(hero, nil, "modifier_ursa_alt_model_lua", {})
		local ability = hero:FindAbilityByName("ursa_earthshock_datadriven")
		local ability_level = ability:GetLevel()
		hero:RemoveAbility("ursa_earthshock_datadriven")
		ability = hero:AddAbility("ursa_earthshock_datadriven_2")
		ability:SetLevel(ability_level)
	end
end

function setAltModel(hero)
	if hero:GetName() == "npc_dota_hero_skeleton_king" then
		hero:SetOriginalModel("models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_skeleton_melee.vmdl")
		hero:SetModel("models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_skeleton_melee.vmdl")
		hero:ManageModelChanges()
		hero:NotifyWearablesOfModelChange(false)
		hero:AddNewModifier(hero, nil, "modifier_skeleton_king_alt_model_lua", {})
	end
end
