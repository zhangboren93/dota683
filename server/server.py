from http.server import BaseHTTPRequestHandler, HTTPServer
from datetime import datetime
import queue
import threading 
import time
import subprocess

hostName = "192.168.1.4"
serverPort = 4526
userLastUpdateDate = {}
q = queue.SimpleQueue()

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        user_id = self.path[1:]
        print('files/' + user_id)
        try:
            with open('files/' + user_id, 'r', encoding='utf-8') as fp:
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
        game_id = int(self.path[1:])
        q.put(game_id)
        self.send_response(200)
        print(f"do_POST {game_id} end")

class ParseGameThread(threading.Thread):
    def run(self):
        while(True):
            time.sleep(10)
            if q.empty():
                continue
            # clear queue
            game_ids = []
            while (not q.empty()):
                game_ids.append(str(q.get()))
            commands = ['python', 'process_game_result.py', ','.join(game_ids)]
            print(f"Executing command {commands})")
            process = subprocess.run(commands, capture_output = True)
            print(process)

if __name__ == "__main__":

    ParseGameThread().start()
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    webServer.serve_forever()
