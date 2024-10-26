import os
import time
import math
import subprocess
import logging
logger = logging.getLogger(__name__)
logging.basicConfig(filename='process_games.log', level=logging.INFO)
path = 'unprocessed'
game_duration_max = 60 * 60 * 2 
time_delay_threshold = 60 * 60 * 24
dir_list = os.listdir(path)
current_time = math.floor(time.time())
logger.info(f"current time: {current_time}")
logger.info(dir_list)
games_to_process = []
for file in dir_list:
    f = open(path + '/' + file, 'r')
    timestamp = int(f.readline().strip())
    f.close()
    logger.info(f"{file}:{timestamp}")
    time_delay = current_time - timestamp
    logger.info(f"time delay: {time_delay}")
    if time_delay < game_duration_max:
        logger.info(f"game in progress")
        continue
    if time_delay > time_delay_threshold:
        logger.warning(f"game {file} that starts at {timestamp} has expired.")
        continue
    games_to_process.append(file)

logger.info(f"Games to process: {games_to_process}")
if len(games_to_process) > 0:
    commands = ['python3', 'process_game_result.py', ','.join(games_to_process)]
    logger.info(f"Executing command {commands})")
    process_timedout = False
    try:
        process = subprocess.run(commands, capture_output = True, timeout = 60)
        logger.info(process)
    except subprocess.TimeoutExpired:
        process_timedout = True
    if not process_timedout and 'All games processed' in str(process.stdout, 'utf-8'):
        #remove game id files
        logger.info('Processing game success, removing files...')
        for file in dir_list:
            os.remove(path + '/' + file)
        exit(0)
    else:
        logger.warning(f'Processing game failed, timeout: {process_timedout}.')
else:
    logger.info('no games to process')
exit(1)
