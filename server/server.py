from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from datetime import datetime
import queue
import threading 
import time
import subprocess
import sys

hostName = "192.168.0.168"
serverPort = 80
userLastUpdateDate = {}
gameInsertDate = {}
q = queue.SimpleQueue()
process_game_interval = 60 * 60
process_game_buffer = 90 * 60

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        user_id = int(self.path[1:])
        try:
            with open(f"files/{user_id}", 'r', encoding='utf-8') as fp:
                file_content = fp.read()
                print(file_content)
        except FileNotFoundError:
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(bytes("score:0", "utf-8"))
            return

        current_score = int(file_content.split(':')[1])
        if current_score > 10000:
            current_score = 10000
        elif current_score < 0:
            current_score = 0

        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        self.wfile.write(bytes(f"score:{current_score}", 'utf-8'))

    def do_POST(self):
        print("do_POST")
        if '/ladder_game/' not in self.path:
            print(f"Invalid path {self.path}")
            self.send_response(403)
            return
        game_id = int(self.path.split('/')[2])
        print(f"Adding game {game_id}")
        if game_id < 7000000000:
            print(f"[WARNING] game id looks weird {game_id}")
            self.send_response(403)
            return
        q.put(game_id)
        gameInsertDate[str(game_id)] = round(datetime.now().timestamp())
        self.send_response(200)
        print(f"do_POST {game_id} end")

shouldStopThread = False
class ParseGameThread(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.nextRunTime = datetime.now().timestamp()

    def run(self):
        while(not shouldStopThread):
            time.sleep(10)
            now = datetime.now().timestamp()
            if self.nextRunTime > now:
                continue
            self.nextRunTime = now + process_game_interval
            if q.empty():
                continue
            # clear queue
            game_ids = []
            while (not q.empty()):
                game_ids.append(str(q.get()))

            # put games not finished within 15 minutes back in the queue
            valid_game_ids = []
            for game_id in game_ids:
                if now < gameInsertDate[str(game_id)] + process_game_buffer:
                    print(f"Game {game_id} back in queue")
                    q.put(game_id)
                else:
                    valid_game_ids.append(game_id)

            if len(valid_game_ids) == 0:
                continue
            commands = ['python3', 'process_game_result.py', ','.join(valid_game_ids)]
            print(f"Executing command {commands})")
            process_timedout = False
            try:
                process = subprocess.run(commands, capture_output = True, timeout = 60)
                print(process)
            except TimeoutExpired:
                process_timedout = True
            #TODO if process failed, put game_ids back to queue
            if process_timedout or not 'All games processed' in process.stdout:
                print('Processing game failed, putting game ids back to queue.')
                for i in valid_game_ids:
                    q.put(i)
                print(q)

if __name__ == "__main__":

    t = ParseGameThread()
    t.start()
    webServer = ThreadingHTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    try:
        webServer.serve_forever()
    except:
        print('f')
    shouldStopThread = True
