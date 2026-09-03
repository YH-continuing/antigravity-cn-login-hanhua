# Antigravity CN · Login Fix + Chinese Localization (No-TUN, One-Click)

Make **Google Antigravity** (Windows x64) work on a mainland-China network — **login and start the agent normally** — and optionally **localize the UI to Chinese** — **without TUN, without Proxifier**, and without touching your Clash global config.

> [中文](README.md) | English

---

## What it solves

1. **Login / agent won't connect** — Antigravity 2.0's key service process `resources\bin\language_server.exe` is written in **Go** and **does NOT read the Windows system proxy**. It hits `daily-cloudcode-pa.googleapis.com` directly, so the login page hangs, you get `context deadline exceeded`, and the agent won't start.
2. **Chinese UI** — applies the localization patch.

**Why not TUN?** TUN can solve #1, but on some machines it breaks Clash entirely (core crashes, system proxy gets disabled). This approach only injects a precise SOCKS5 proxy into the target processes, so it's stable and doesn't disturb your network.

---

## Prerequisites

- Windows x64, Antigravity installed (`antigravity` / `Antigravity IDE`).
- **A local proxy is running**, default port `127.0.0.1:7897` (Clash / Mihomo mixed or SOCKS port).
- Your proxy node can reach Google.
- Hanhua (Chinese) needs Node.js ≥ 16 + git (optional — skip it and the login fix still works).

---

## Usage (one click)

1. Download and unzip `antigravity-cn-login-hanhua.zip` from the [Releases](../../releases) page.
2. **Double-click `install.bat`**.
3. Reopen Antigravity.

`install.bat` will: inject the proxy → close Antigravity to release file locks → download & apply the Chinese patch (if Node.js/git present; otherwise it skips the localization, and the login fix still works).

> Proxy port isn't `7897`? Open `config.json` and change `proxy.port`.

---

## Uninstall (restore official state)

Double-click **`uninstall.bat`** — it removes `version.dll` + `config.json` and uninstalls the localization plugin. Restart Antigravity to return to the official state.

---

## Files

| File | Purpose |
| --- | --- |
| `version.dll` | Proxy-injection DLL, loaded when Antigravity starts |
| `config.json` | Proxy port / type / target processes (default `127.0.0.1:7897` SOCKS5) |
| `install.bat` | One-click: inject proxy + localize |
| `uninstall.bat` | One-click revert |

---

## Verify

After restarting, check `%LOCALAPPDATA%\Programs\antigravity\logs\proxy-YYYYMMDD.log`. You should see:

```
[成功] 已注入目标进程: language_server.exe
SOCKS5: 隧道建立成功, 目标=daily-cloudcode-pa.googleapis.com:443
```

---

## Disclaimer

- This is a local proxy-injection + localization tool, **not** an official Google product; changes are local to your client.
- Proxy injection is based on the community tool [yuaotian/antigravity-proxy](https://github.com/yuaotian/antigravity-proxy); Chinese localization is based on [yiheng8023/antigravity-chinese](https://github.com/yiheng8023/antigravity-chinese). Respect their original licenses and attribution.
- If login shows `User location is not supported`, your proxy exit IP is likely blocked by Google — switch to a regular / residential node.
