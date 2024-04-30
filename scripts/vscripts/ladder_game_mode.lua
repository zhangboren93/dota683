ladder_heroes_2_ban = {}
slot_2_heroes = {}
-- 37 strength heroes
str_heroes = {
    "npc_dota_hero_abaddon"             ,
    "npc_dota_hero_axe"                 ,
    "npc_dota_hero_beastmaster"         ,
    "npc_dota_hero_brewmaster"          ,
    "npc_dota_hero_centaur"             ,
    "npc_dota_hero_chaos_knight"        ,
    "npc_dota_hero_dragon_knight"       ,
    "npc_dota_hero_earthshaker"         ,
    "npc_dota_hero_life_stealer"        ,
    "npc_dota_hero_lycan"               ,
    "npc_dota_hero_magnataur"           ,
    "npc_dota_hero_night_stalker"       ,
    "npc_dota_hero_omniknight"          ,
    "npc_dota_hero_rattletrap"          ,
    "npc_dota_hero_skeleton_king"       ,
    "npc_dota_hero_slardar"             ,
    "npc_dota_hero_spirit_breaker"      ,
    "npc_dota_hero_sven"                ,
    "npc_dota_hero_tidehunter"          ,
    "npc_dota_hero_tusk"                ,
    "npc_dota_hero_abyssal_underlord"   ,
    "npc_dota_hero_alchemist"           ,
    "npc_dota_hero_earth_spirit"        ,
    "npc_dota_hero_elder_titan"         ,
    "npc_dota_hero_huskar"              ,
    "npc_dota_hero_phoenix"             ,
    "npc_dota_hero_sand_king"           ,
    "npc_dota_hero_shredder"            ,
    "npc_dota_hero_tiny"                ,
    "npc_dota_hero_treant"              ,
    "npc_dota_hero_bristleback"         ,
    "npc_dota_hero_pudge"               ,
    "npc_dota_hero_doom_bringer"        ,
    "npc_dota_hero_kunkka"              ,
    "npc_dota_hero_legion_commander"    ,
    "npc_dota_hero_undying"             ,
    "npc_dota_hero_wisp"                
}
-- 36 agi heroes
agi_heroes = {
    "npc_dota_hero_antimage"            ,
    "npc_dota_hero_arc_warden"          ,
    "npc_dota_hero_drow_ranger"         ,
    "npc_dota_hero_faceless_void"       ,
    "npc_dota_hero_juggernaut"          ,
    "npc_dota_hero_luna"                ,
    "npc_dota_hero_medusa"              ,
    "npc_dota_hero_morphling"           ,
    "npc_dota_hero_naga_siren"          ,
    "npc_dota_hero_nevermore"           ,
    "npc_dota_hero_nyx_assassin"        ,
    "npc_dota_hero_razor"               ,
    "npc_dota_hero_slark"               ,
    "npc_dota_hero_sniper"              ,
    "npc_dota_hero_terrorblade"         ,
    "npc_dota_hero_troll_warlord"       ,
    "npc_dota_hero_vengefulspirit"      ,
    "npc_dota_hero_viper"               ,
    "npc_dota_hero_weaver"              ,
    "npc_dota_hero_bounty_hunter"       ,
    "npc_dota_hero_clinkz"              ,
    "npc_dota_hero_ember_spirit"        ,
    "npc_dota_hero_gyrocopter"          ,
    "npc_dota_hero_phantom_assassin"    ,
    "npc_dota_hero_venomancer"          ,
    "npc_dota_hero_lone_druid"          ,
    "npc_dota_hero_mirana"              ,
    "npc_dota_hero_riki"                ,
    "npc_dota_hero_templar_assassin"    ,
    "npc_dota_hero_bloodseeker"         ,
    "npc_dota_hero_broodmother"         ,
    "npc_dota_hero_meepo"               ,
    "npc_dota_hero_phantom_lancer"      ,
    "npc_dota_hero_spectre"             ,
    "npc_dota_hero_ursa"    
}
-- 40 intel heroes
intellect_heroes = {
    "npc_dota_hero_ancient_apparition"  ,
    "npc_dota_hero_bane"                ,
    "npc_dota_hero_crystal_maiden"      ,
    "npc_dota_hero_dazzle"              ,
    "npc_dota_hero_leshrac"             ,
    "npc_dota_hero_lich"                ,
    "npc_dota_hero_lina"                ,
    "npc_dota_hero_lion"                ,
    "npc_dota_hero_obsidian_destroyer"  ,
    "npc_dota_hero_ogre_magi"           ,
    "npc_dota_hero_oracle"              ,
    "npc_dota_hero_pugna"               ,
    "npc_dota_hero_shadow_demon"        ,
    "npc_dota_hero_shadow_shaman"       ,
    "npc_dota_hero_skywrath_mage"       ,
    "npc_dota_hero_visage"              ,
    "npc_dota_hero_warlock"             ,
    "npc_dota_hero_windrunner"          ,
    "npc_dota_hero_witch_doctor"        ,
    "npc_dota_hero_death_prophet"       ,
    "npc_dota_hero_disruptor"           ,
    "npc_dota_hero_enigma"              ,
    "npc_dota_hero_invoker"             ,
    "npc_dota_hero_jakiro"              ,
    "npc_dota_hero_keeper_of_the_light" ,
    "npc_dota_hero_silencer"            ,
    "npc_dota_hero_tinker"              ,
    "npc_dota_hero_winter_wyvern"       ,
    "npc_dota_hero_storm_spirit"        ,
    "npc_dota_hero_dark_seer"           ,
    "npc_dota_hero_necrolyte"           ,
    "npc_dota_hero_puck"                ,
    "npc_dota_hero_queenofpain"         ,
    "npc_dota_hero_rubick"              ,
    "npc_dota_hero_techies"             ,
    "npc_dota_hero_zuus"                ,
    "npc_dota_hero_batrider"            ,
    "npc_dota_hero_chen"                ,
    "npc_dota_hero_enchantress"         ,
    "npc_dota_hero_furion"              
}
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
    local picked_str_heroes = randomPickFromList(str_heroes, 13)
    local picked_agi_heroes = randomPickFromList(agi_heroes, 13)
    local picked_int_heroes = randomPickFromList(intellect_heroes, 13)
    -- DeepPrintTables(picked_str_heroes)
    print(#picked_str_heroes)
    for i=1,13 do
        ladder_heroes_2_ban[picked_str_heroes[i]] = 0
        ladder_heroes_2_ban[picked_agi_heroes[i]] = 0
        ladder_heroes_2_ban[picked_int_heroes[i]] = 0
    end
    DeepPrintTable(ladder_heroes_2_ban)
    slot_2_heroes = {
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
    }
    CustomGameEventManager:Send_ServerToAllClients( "ladder_ban_start", slot_2_heroes)
end

RANK_MAP_NAME = "rank"
function isMapRanked()
	return GetMapName() == RANK_MAP_NAME 
end

function calculateLadderScoreLose(losing_team, player_2_score, host)
	print("calculateLadderScoreLose " .. losing_team)
	DeepPrintTable(player_2_score)
	-- get all player current score
	local winning_team = DOTA_TEAM_GOODGUYS
	local winning_team_total_score = 0
	local winning_team_players = {}
	local losing_team_total_score = 0
	local losing_team_players = {}
	if winning_team == losing_team then
		winning_team = DOTA_TEAM_BADGUYS
	end
	local n = PlayerResource:GetPlayerCountForTeam(winning_team)
	print("winning team count " .. n)
	for i=1,n do
		local playerid = PlayerResource:GetNthPlayerIDOnTeam(winning_team, i)
		winning_team_total_score = winning_team_total_score + tonumber(player_2_score[playerid])
		table.insert(winning_team_players, playerid)
	end
	local n = PlayerResource:GetPlayerCountForTeam(losing_team)
	print("losing team count " .. n)
	for i=1,n do
		local playerid = PlayerResource:GetNthPlayerIDOnTeam(losing_team, i)
		losing_team_total_score = losing_team_total_score + tonumber(player_2_score[playerid])
		table.insert(losing_team_players, playerid)
	end
	print("winning_team_total " .. winning_team_total_score .. " losing " .. losing_team_total_score)
	-- get score diff
	local diff = 25 - (winning_team_total_score - losing_team_total_score) / 250
	if diff - math.floor(diff) > 0.5 then
		diff = math.ceil(diff)
	else
		diff = math.floor(diff)
	end
	if diff > 50 then
		diff = 50
	elseif diff < 0 then
		diff = 0
	end
	print("diff " .. diff)
	DeepPrintTable(player_2_score)
	local accountId2Score = {}
	for player, score in pairs(player_2_score) do
		local accountid = PlayerResource:GetSteamAccountID(player)
		local sign = "+"
		if PlayerResource:GetTeam(player) == losing_team then
			score = score - diff
			sign = "-"
		else
			score = score + diff
		end
		if score < 0 then
			score = 0
		end
		print("Player " .. player .. " Account " .. accountid .. " score " .. score)
	--	GameRules:SendCustomMessage("玩家" .. player .. "分数:".. score .. "("..sign..diff..")", -1, -1)
		table.insert(accountId2Score, {accountid, score})
	end
	-- upload score
	uploadNewScore(accountId2Score, host)	

    uploadGameToServer(host)
end

function uploadNewScore(accountId2Score, host)
	if #accountId2Score > 0	then
		local request = CreateHTTPRequest("PUT", "http://" .. host .. "/" .. accountId2Score[1][1]);
		request:SetHTTPRequestRawPostBody("text/plain", "score:"..accountId2Score[1][2]);
		request:Send(function(response)
			print("post player score " .. response.StatusCode)
			table.remove(accountId2Score, 1)
			uploadNewScore(accountId2Score, host)
		end)
	end
end

function uploadGameToServer(host)
	CreateHTTPRequest("POST", "http://" .. host .. "/" .. CDOTAGameRules:Script_GetMatchID()):Send(
        function(response)
            print("Post game status " .. response.StatusCode)
        end);
end
