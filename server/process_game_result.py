from datetime import datetime
import queue
import threading 

from steam.client import SteamClient
from dota2.client import Dota2Client
import dota2.protobufs.dota_gcmessages_client_pb2 as dota_gcmessages_client__pb2

import sys
import math

PRODUCTION = True

game_ids = sys.argv[1].split(',')

print(f"Game_ids {game_ids}")

client = SteamClient()
dota = Dota2Client(client)

@client.on('logged_on')
def start_dota():
    print("start_dota")
    dota.launch()

@dota.on('ready')
def do_dota_stuff():
    print("dota ready")
    for game_id in game_ids:
        jobId = dota.request_match_details(int(game_id))
        print(f"Created job {jobId} for game {game_id}")
        response = dota.wait_msg(jobId, timeout = 120)
        print(response)
        custom_game_id = response.match.custom_game_data.custom_game_id
        print(f"custom game id {custom_game_id}")
        if custom_game_id != 2927073313:
            continue
        map_name = response.match.custom_game_data.map_name
        print(f"map name {map_name}")
        if map_name != 'rank':
            continue
        human_players = response.match.human_players
        print(f"human players {human_players}")
        if human_players != 10:
            continue
        duration = response.match.duration
        print(f"duration {duration}")
        if duration < 100:
            return
        print(f"start time {response.match.startTime}")
        if PRODUCTION and (datetime.now().timestamp() - response.match.startTime - duration > 60 * 60 * 24):
            print("Start time more than 24 hours before, skipping")
            continue
        print(f"match outcome {response.match.match_outcome}")
        if response.match.match_outcome != 2 and response.match.match_outcome != 3:
            continue
            
        winning_player_ids=[]
        losing_player_ids=[]
        for player in response.match.players:
            if player.custom_game_data.winner:
                winning_player_ids.append(player.account_id)
            else:
                losing_player_ids.append(player.account_id)
        print(f"winning players {winning_player_ids}, losing {losing_player_ids}")
        #get player id to score map

        playerid2score = {}
        for pid in winning_player_ids + losing_player_ids:
            file_content = 'score:0'
            try:
                with open('files/' + str(pid), 'r', encoding='utf-8') as fp:
                    file_content = fp.read()
            except FileNotFoundError:
                print(f"new player {pid}")
            score = 0
            if len(file_content) > 0:
                score = int(file_content.split(':')[1])
            playerid2score[pid] = score
        winning_team_total = 0
        losing_team_total = 0
        for pid in winning_player_ids:
            winning_team_total += playerid2score[pid]
        for pid in losing_player_ids:
            losing_team_total += playerid2score[pid]
        print(f"wining total {winning_team_total}, losing {losing_team_total}")
        diff = round(25 - (winning_team_total - losing_team_total) / 250)
        if diff < 0:
            diff = 0
        elif diff > 50:
            diff = 50
        print(f"diff {diff}")
        for pid in winning_player_ids:
            playerid2score[pid] = playerid2score[pid] + diff
            if playerid2score[pid] > 10000:
                playerid2score[pid] = 10000
        for pid in losing_player_ids:
            playerid2score[pid] = playerid2score[pid] - diff
            if playerid2score[pid] < 0:
                playerid2score[pid] = 0
        print(f"New play scores {playerid2score}")
        for pid in winning_player_ids + losing_player_ids:
            with open('files/' + str(pid), 'w', encoding='utf-8') as fp:
                fp.write('score:' + str(playerid2score[pid]))
        print(f"Success add game {game_id}")
    print("All games processed")
    quit()


client.login(username='', password='')
client.run_forever()
