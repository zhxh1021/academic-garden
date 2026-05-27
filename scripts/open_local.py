from __future__ import annotations

import os
from pathlib import Path
import subprocess
import sys
import time
from urllib.error import URLError
from urllib.request import urlopen


ROOT = Path(__file__).resolve().parent.parent
SERVER_SCRIPT = ROOT / "scripts" / "serve_local.py"
RUNTIME_DIRECTORY = ROOT / ".runtime"
LOG_PATH = RUNTIME_DIRECTORY / "server.log"
URL = "http://127.0.0.1:4173"


def is_garden_available() -> bool:
    try:
        with urlopen(URL, timeout=0.4) as response:
            return b"Academic Garden" in response.read(4096)
    except (OSError, URLError):
        return False


def start_server() -> None:
    RUNTIME_DIRECTORY.mkdir(exist_ok=True)
    creation_flags = subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0
    with LOG_PATH.open("a", encoding="utf-8") as log_file:
        subprocess.Popen(
            [sys.executable, str(SERVER_SCRIPT)],
            cwd=str(ROOT),
            creationflags=creation_flags,
            stdout=log_file,
            stderr=log_file,
        )


def open_browser() -> bool:
    if os.name == "nt":
        openers = (
            lambda: subprocess.Popen(
                ["explorer.exe", URL],
                creationflags=subprocess.CREATE_NO_WINDOW,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            ),
            lambda: os.startfile(URL),
            lambda: subprocess.Popen(
                ["rundll32.exe", "url.dll,FileProtocolHandler", URL],
                creationflags=subprocess.CREATE_NO_WINDOW,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            ),
        )
        for opener in openers:
            try:
                opener()
                return True
            except OSError:
                continue
        return False
    import webbrowser

    return webbrowser.open(URL)


def main() -> int:
    no_browser = "--no-browser" in sys.argv
    if not is_garden_available():
        start_server()
        for _ in range(20):
            time.sleep(0.15)
            if is_garden_available():
                break

    if not is_garden_available():
        print(f"Unable to open Academic Garden. See log: {LOG_PATH}")
        return 1
    if not no_browser and not open_browser():
        print(f"Please open this address manually: {URL}")
        return 1
    print(f"Academic Garden is available at {URL}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
