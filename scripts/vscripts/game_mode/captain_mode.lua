function captainModeCountTime(game_mode)
	local captain_pick_phase = game_mode.captain_pick_phase
	local captain_normal_time = game_mode.captain_normal_time
	local captain_radiant_extra_time = game_mode.captain_radiant_extra_time
	local captain_dire_extra_time = game_mode.captain_dire_extra_time
	if captain_pick_phase == 0
		or captain_pick_phase == 2
		or captain_pick_phase == 4
		or captain_pick_phase == 6
		or captain_pick_phase == 8
		or captain_pick_phase == 10
		or captain_pick_phase == 12
		or captain_pick_phase == 14
		or captain_pick_phase == 17
		or captain_pick_phase == 18
	then
		if captain_normal_time >= 2 then
			game_mode.captain_normal_time = captain_normal_time - 2
		elseif captain_radiant_extra_time >= 2 then
			game_mode.captain_radiant_extra_time = captain_radiant_extra_time - 2
		else
			game_mode.captain_normal_time = 0
			game_mode.captain_radiant_extra_time = 0
		end
		CustomGameEventManager:Send_ServerToAllClients("captain_pick_timer", 
			{ nt = game_mode.captain_normal_time, et = game_mode.captain_radiant_extra_time });
	else
		if captain_normal_time >= 2 then
			game_mode.captain_normal_time = captain_normal_time - 2
		elseif captain_dire_extra_time >= 2 then
			game_mode.captain_dire_extra_time = captain_dire_extra_time - 2
		else
			game_mode.captain_normal_time = 0
			game_mode.captain_dire_extra_time = 0
		end
		CustomGameEventManager:Send_ServerToAllClients("captain_pick_timer", 
			{ nt = game_mode.captain_normal_time, et = game_mode.captain_dire_extra_time });
	end
end
