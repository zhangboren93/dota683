ladder_heroes_2_ban = {}

function randomPickFromList(heroes, num)
	local ret_list = {}
	local picked_heroes = {}
	while table.getn(ret_list) < num do
		local hero = heroes[RandomInt(1, #heroes)]
		if picked_heroes[hero] == nil then
			picked_heroes[hero] = true
			table.insert(ret_list, hero)
		end
	end
	return ret_list
end

function pickLadderHeroes(self) 
    self.game_mode = "PIC"
    local picked_str_heroes = randomPickFromList(str_heroes, 20)
    local picked_agi_heroes = randomPickFromList(agi_heroes, 20)
    local picked_int_heroes = randomPickFromList(intellect_heroes, 20)
    DeepPrintTables(picked_str_heroes)
    for i=1,20 do
        ladder_heroes_2_ban[picked_str_heroes[i]] = 0
        ladder_heroes_2_ban[picked_agi_heroes[i]] = 0
        ladder_heroes_2_ban[picked_int_heroes[i]] = 0
    end
    CustomGameEventManager:Send_ServerToAllClients( "ladder_ban_start", {
        str_1  = picked_str_heroes[1],
        str_2  = picked_str_heroes[2],
        str_3  = picked_str_heroes[3],
        str_4  = picked_str_heroes[4],
        str_5  = picked_str_heroes[5],
        str_6  = picked_str_heroes[6],
        str_7  = picked_str_heroes[7],
        str_8  = picked_str_heroes[8],
        str_9  = picked_str_heroes[9],
        str_10 = picked_str_heroes[10],
        str_11 = picked_str_heroes[11],
        str_12 = picked_str_heroes[12],
        str_13 = picked_str_heroes[13],
        str_14 = picked_str_heroes[14],
        str_15 = picked_str_heroes[15],
        str_16 = picked_str_heroes[16],
        str_17 = picked_str_heroes[17],
        str_18 = picked_str_heroes[18],
        str_19 = picked_str_heroes[19],
        str_20 = picked_str_heroes[20],
        agi_1  = picked_agi_heroes[1],
        agi_2  = picked_agi_heroes[2],
        agi_3  = picked_agi_heroes[3],
        agi_4  = picked_agi_heroes[4],
        agi_5  = picked_agi_heroes[5],
        agi_6  = picked_agi_heroes[6],
        agi_7  = picked_agi_heroes[7],
        agi_8  = picked_agi_heroes[8],
        agi_9  = picked_agi_heroes[9],
        agi_10 = picked_agi_heroes[10],
        agi_11 = picked_agi_heroes[11],
        agi_12 = picked_agi_heroes[12],
        agi_13 = picked_agi_heroes[13],
        agi_14 = picked_agi_heroes[14],
        agi_15 = picked_agi_heroes[15],
        agi_16 = picked_agi_heroes[16],
        agi_17 = picked_agi_heroes[17],
        agi_18 = picked_agi_heroes[18],
        agi_19 = picked_agi_heroes[19],
        agi_20 = picked_agi_heroes[20],
        int_1  = picked_int_heroes[1],
        int_2  = picked_int_heroes[2],
        int_3  = picked_int_heroes[3],
        int_4  = picked_int_heroes[4],
        int_5  = picked_int_heroes[5],
        int_6  = picked_int_heroes[6],
        int_7  = picked_int_heroes[7],
        int_8  = picked_int_heroes[8],
        int_9  = picked_int_heroes[9],
        int_10 = picked_int_heroes[10],
        int_11 = picked_int_heroes[11],
        int_12 = picked_int_heroes[12],
        int_13 = picked_int_heroes[13],
        int_14 = picked_int_heroes[14],
        int_15 = picked_int_heroes[15],
        int_16 = picked_int_heroes[16],
        int_17 = picked_int_heroes[17],
        int_18 = picked_int_heroes[18],
        int_19 = picked_int_heroes[19],
        int_20 = picked_int_heroes[20],
    })
end