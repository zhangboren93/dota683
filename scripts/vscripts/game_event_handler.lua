require('ladder_game_mode')
require('creepspawn')

function HandleGameStateChange(game_mode, event, playerId2LadderScore)
	if event.new_state == 5 then
		local first_creep_spawned = false
		GameRules:GetGameModeEntity():SetThink(function()
			if first_creep_spawned then
				SpawnNeutralCreepSecondTime("neutralcamp_good_")
				SpawnNeutralCreepSecondTime("neutralcamp_evil_")
				return 60
			else
				first_creep_spawned = true
				SpawnNeutralCreepFirstTime("neutralcamp_good_")
				SpawnNeutralCreepFirstTime("neutralcamp_evil_")
				return 30
			end
		end, "spawn neutral creep", 30)
		if game_mode.isValidRankedGame and not game_mode.hasGameEnded then
			GameRules:GetGameModeEntity():SetThink(function()
				if game_mode.isValidRankedGame and not game_mode.hasGameEnded then
					uploadGameToServer(LADDER_HOST)
				end
			end, "validate rank game after 5 minutes", 300)
		end
	elseif event.new_state == 4 then
		CustomGameEventManager:Send_ServerToAllClients("player_ladder_scores", playerId2LadderScore)
	end
end
