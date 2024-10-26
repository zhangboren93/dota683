from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from datetime import datetime
import queue
import threading 
import time
import subprocess
import sys
import logging
import os.path
logger = logging.getLogger(__name__)
logging.basicConfig(filename='server.log', level=logging.INFO)

hostName = "192.168.0.168"
serverPort = 80
userLastUpdateDate = {}
gameInsertDate = {}
q = queue.SimpleQueue()
process_game_interval = 60 * 60
process_game_buffer = 90 * 60
file_name = "unprocessed_game_id.txt"

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        user_id = int(self.path[1:])
        try:
            with open(f"files/{user_id}", 'r', encoding='utf-8') as fp:
                file_content = fp.read()
                logger.info(file_content)
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
        logger.info("do_POST")
        if '/ladder_game/' not in self.path:
            logger.info(f"Invalid path {self.path}")
            self.send_response(403)
            return
        game_id = int(self.path.split('/')[2])
        logger.info(f"Adding game {game_id}")
        if game_id < 7000000000:
            logger.info(f"[WARNING] game id looks weird {game_id}")
            self.send_response(403)
            return
        if not os.path.isfile(f"unprocessed/{game_id}"):
            f = open(f"unprocessed/{game_id}", 'w')
            f.write(str(round(datetime.now().timestamp())))
            f.close()
        else:
            logger.info(f"[INFO] game id {game_id} already created")

        self.send_response(200)
        logger.info(f"do_POST {game_id} end")

if __name__ == "__main__":

    webServer = ThreadingHTTPServer((hostName, serverPort), MyServer)
    logger.info("Server started http://%s:%s" % (hostName, serverPort))

    webServer.serve_forever()
