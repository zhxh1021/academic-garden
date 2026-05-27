from __future__ import annotations

import json
from pathlib import Path
from urllib.error import URLError
from urllib.request import Request, urlopen


ROOT = Path(__file__).resolve().parent.parent
SERVER_INFO_PATH = ROOT / ".runtime" / "server.json"


def main() -> int:
    try:
        server_info = json.loads(SERVER_INFO_PATH.read_text(encoding="utf-8"))
    except (FileNotFoundError, json.JSONDecodeError):
        print("Academic Garden is not running from this launcher.")
        return 0

    url = (
        f"http://{server_info['host']}:{server_info['port']}"
        f"/__academic_garden_shutdown__/{server_info['shutdownToken']}"
    )
    try:
        request = Request(url, method="POST")
        with urlopen(request, timeout=1):
            pass
        print("Academic Garden has been stopped.")
    except (OSError, URLError):
        SERVER_INFO_PATH.unlink(missing_ok=True)
        print("The saved Academic Garden server is no longer running.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
