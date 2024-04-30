from http.server import BaseHTTPRequestHandler, HTTPServer
from datetime import datetime

hostName = "localhost"
serverPort = 4526
userLastUpdateDate = {}

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

    def do_PUT(self):
        content_len = 0
        for i in self.headers:
            if i == 'Content-Length':
                content_len = int(self.headers[i])
                break;
        print(content_len)
        if content_len > 1000:
            self.send_response(403)
            return
        post_body = self.rfile.read(content_len)
        user_id = self.path[1:]
        file_content = 'score:0'
        try:
            with open('files/' + user_id, 'r', encoding='utf-8') as fp:
                file_content = fp.read()
        except:
            print("File not found {user_id}")
        current_score = int(file_content.split(':')[1])
        next_score = int(str(post_body, 'utf-8').split(':')[1])
        score_diff = next_score - current_score
        if score_diff > 50 or score_diff < -50:
            print(f"invalid score diff {current_score} -> {next_score}, {user_id}")
            self.send_response(200)
            return
        current_time = datetime.now().timestamp()
        if user_id in userLastUpdateDate:
            last_update_date = userLastUpdateDate[user_id]
            if current_time - last_update_date < 60 * 5:
                print(f"user update too often {current_time} -> {last_update_date}, {user_id}")
                self.send_response(200)
                return
        userLastUpdateDate[user_id] = current_time

        with open('files/' + user_id, 'w', encoding='utf-8') as fp:
            fp.write(str(post_body, 'utf-8'))
        self.send_response(200)

if __name__ == "__main__":
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    webServer.serve_forever()
