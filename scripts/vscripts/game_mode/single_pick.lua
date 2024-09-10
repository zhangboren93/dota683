require('hero_types')

local function add3heoresToPlayerOfTeam(game_mode, team) 
	local radiantPlayerCount = PlayerResource:GetPlayerCountForTeam(team)
	if radiantPlayerCount > 0 then
		for i=1,radiantPlayerCount do
			local playerId = PlayerResource:GetNthPlayerIDOnTeam(team, i)
			for i=1,3 do
				local heroid = DOTAGameManager:GetHeroIDByName(game_mode.RandomDraftHeroPool[1])
				print("Opening hero " .. heroid .. " to player " .. playerId)
				GameRules:AddHeroToPlayerAvailability(playerId, DOTAGameManager:GetHeroIDByName(game_mode.RandomDraftHeroPool[i]))
				table.remove(game_mode.RandomDraftHeroPool, 1)
			end
		end
	end
end

function initSPHeroSelection(game_mode)
	local heroes = unique_heroes
	-- shuffles
	for i=1,30 do
		local j=RandomInt(i,#heroes)
		local tmp = heroes[i];
		heroes[i] = heroes[j];
		heroes[j] = tmp;
		table.insert(game_mode.RandomDraftHeroPool, heroes[i])
	end
	add3heoresToPlayerOfTeam(game_mode, DOTA_TEAM_GOODGUYS)
	add3heoresToPlayerOfTeam(game_mode, DOTA_TEAM_BADGUYS)
end
