from http.server import BaseHTTPRequestHandler, HTTPServer

hostName = "localhost"
serverPort = 4526

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        user_id = self.path[1:]
        print('files/' + user_id)
        try:
            with open('files/' + user_id, 'r', encoding='utf-8') as fp:
                file_content = fp.read()
                print(file_content)
        except FileNotFoundError:
            print("File not found: " + user_id)
            self.send_response(404)
            return
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        self.wfile.write(bytes(file_content, "utf-8"))

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
        with open('files/' + user_id, 'w', encoding='utf-8') as fp:
            fp.write(str(post_body, 'utf-8'))
        self.send_response(200)

if __name__ == "__main__":
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    webServer.serve_forever()
