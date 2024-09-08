## RunPod kohya-ss/sd-scripts

RunPod で動作する、[kohya-ss/sd-scripts](https://github.com/kohya-ss/sd-scripts) の 実行環境です。
GUIなどは含まれていません。
実行する際は、ssh で接続するか、Jupyter Lab を利用してください。

## Template Requirements

| Port | Type (HTTP/TCP) | Function     |
|------|-----------------|--------------|
| 22   | TCP             | SSH          |
| 8888 | HTTP            | Jupyter Lab  |
