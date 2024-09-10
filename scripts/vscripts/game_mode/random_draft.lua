require("hero_types")
--TODO Randomly picks a starting team
function initRDHeroSelection(game_mode)
	local heroes = unique_heroes
	-- shuffles
	for i=1,24 do
		local j=RandomInt(i,#heroes)
		local tmp = heroes[i];
		heroes[i] = heroes[j];
		heroes[j] = tmp;
		table.insert(game_mode.RandomDraftHeroPool, heroes[i])
	end
	--add all heroes to radiant 1st player's availability
	local radiantPlayerCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	local playerId = -1
	if radiantPlayerCount > 0 then
		playerId = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, 1)
		for i=1,#game_mode.RandomDraftHeroPool do
			local heroid = DOTAGameManager:GetHeroIDByName(game_mode.RandomDraftHeroPool[i])
			print("Opening hero " .. heroid .. " to player " .. playerId)
			GameRules:AddHeroToPlayerAvailability(playerId, DOTAGameManager:GetHeroIDByName(game_mode.RandomDraftHeroPool[i]))
		end
	end
	--send all heroes backed up to the clients
	CustomGameEventManager:Send_ServerToAllClients("random_draft_start", {sh = game_mode.RandomDraftHeroPool, spid = playerId})
	game_mode.hero_selection_state = "RD_PICK_RAD_1"
end
