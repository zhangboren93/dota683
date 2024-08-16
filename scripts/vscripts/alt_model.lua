function setAltModel(hero)
	if hero:GetName() == "npc_dota_hero_skeleton_king" then
		hero:SetOriginalModel("models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_skeleton_melee.vmdl")
		hero:SetModel("models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_skeleton_melee.vmdl")
		hero:ManageModelChanges()
		hero:NotifyWearablesOfModelChange(false)
		hero:AddNewModifier(hero, nil, "modifier_skeleton_king_alt_model_lua", {})
	end
end
