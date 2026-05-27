from __future__ import annotations

from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import json
from pathlib import Path
import secrets
import threading


ROOT = Path(__file__).resolve().parent.parent
RUNTIME_DIRECTORY = ROOT / ".runtime"
SERVER_INFO_PATH = RUNTIME_DIRECTORY / "server.json"
HOST = "127.0.0.1"
PORT = 4173


def write_server_info(token: str) -> None:
    RUNTIME_DIRECTORY.mkdir(exist_ok=True)
    SERVER_INFO_PATH.write_text(
        json.dumps({"host": HOST, "port": PORT, "shutdownToken": token}),
        encoding="utf-8",
    )


def clear_server_info(token: str) -> None:
    try:
        saved = json.loads(SERVER_INFO_PATH.read_text(encoding="utf-8"))
    except (FileNotFoundError, json.JSONDecodeError):
        return
    if saved.get("shutdownToken") == token:
        SERVER_INFO_PATH.unlink(missing_ok=True)


def main() -> None:
    shutdown_token = secrets.token_urlsafe(24)

    class GardenRequestHandler(SimpleHTTPRequestHandler):
        def do_POST(self) -> None:
            if self.path != f"/__academic_garden_shutdown__/{shutdown_token}":
                self.send_error(404)
                return
            self.send_response(204)
            self.end_headers()
            threading.Thread(target=self.server.shutdown, daemon=True).start()

    handler = partial(GardenRequestHandler, directory=str(ROOT))
    with ThreadingHTTPServer((HOST, PORT), handler) as server:
        write_server_info(shutdown_token)
        try:
            server.serve_forever()
        finally:
            clear_server_info(shutdown_token)


if __name__ == "__main__":
    main()
