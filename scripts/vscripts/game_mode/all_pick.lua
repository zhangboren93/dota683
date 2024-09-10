function handleAPRepick(game_mode, playerid)
	if PlayerResource:GetSelectedHeroName(playerid) == "" or game_mode.playerRepicked[playerid] then
		GameRules:SendCustomMessage("无法重新选择英雄", -1, -1)
		return
	end
	if PlayerResource:GetGold(playerid) < 100 then
		GameRules:SendCustomMessage("金钱小于250时无法重新选择英雄", -1, -1)
		return
	end
	local player = PlayerResource:GetPlayer(playerid)
	player:SetSelectedHero("")
	PlayerResource:ModifyGold(playerid, -100, false, DOTA_ModifyGold_SelectionPenalty)
	if PlayerResource:HasRandomed(playerid) then
		PlayerResource:ModifyGold(playerid, -250, false, DOTA_ModifyGold_SelectionPenalty)
	end
	game_mode.playerRepicked[playerid] = true
end
