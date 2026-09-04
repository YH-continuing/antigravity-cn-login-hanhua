# Antigravity CN · Login Fix + Chinese Localization (No-TUN, One-Click)

Make **Google Antigravity** (Windows x64 — both the **`antigravity` hub** and **`Antigravity IDE`**) **login and start the agent normally** on a mainland-China network, and optionally **localize the UI to Chinese** — **without TUN, without Proxifier**.

> [中文](README.md) | English

---

## What it solves

1. **Login / agent won't connect** — Antigravity 2.0's key service process (hub: `resources\bin\language_server.exe`, IDE: `bin\antigravity-ide`) is a **Go program that does NOT read the Windows system proxy**. It hits `daily-cloudcode-pa.googleapis.com`, `generativelanguage.googleapis.com`, etc. directly → login hangs, `context deadline exceeded`, agent won't start.
2. **Chinese UI** — applies the localization patch.

**Why not TUN?** TUN can solve #1 but on some machines breaks Clash entirely (core crashes, system proxy disabled). This approach only injects a precise SOCKS5 proxy into the target processes — stable, doesn't disturb your network.

---

## ⚠️ Two prerequisites (easy to miss)

### ① Proxy node must be a "US / supported region + residential ISP IP"
Google's Gemini/Antigravity service **rejects datacenter IPs (VPS/cloud) and unsupported regions**:
```
FAILED_PRECONDITION (code 400): User location is not supported for the API use.
```
- Pick a **US (or supported region), residential / normal ISP** exit node in Clash.
- Avoid DigitalOcean, Vultr, OVH, Google Cloud, AWS, etc. (**datacenter IPs**).

### ② System proxy must be ON
The window (Chromium) relies on the system proxy to reach the **local language server** (`https://127.0.0.1:<port>/`). Otherwise:
```
TLS handshake error ... tls: unknown certificate
Lost connection to the language server
```
The repo's `install.bat` enables the system proxy automatically (`127.0.0.1:7897`).

---

## Prerequisites

- Windows x64, Antigravity installed (`antigravity` / `Antigravity IDE`).
- **A local proxy is running**, default port `127.0.0.1:7897` (Clash / Mihomo mixed or SOCKS port).
- Proxy node satisfies prerequisite **①**.
- Localization needs Node.js ≥ 16 + git (optional — skip it and the login fix still works).

---

## Usage (one click)

1. Download and unzip `antigravity-cn-login-hanhua.zip` from [Releases](../../releases).
2. **Double-click `install.bat`**.
3. Reopen Antigravity / Antigravity IDE.

`install.bat` will auto: check proxy → enable system proxy → inject proxy into hub & IDE dirs → disable the IDE's broken telemetry hook → close Antigravity to release file locks → download & apply Chinese (if Node.js/git present; else skip, login fix still works).

> Proxy port isn't `7897`? Open `config.json` and change `proxy.port`.

---

## Uninstall (restore official state)

Double-click **`uninstall.bat`**: removes `version.dll` + `config.json` and turns off the system proxy.

---

## Files

| File | Purpose |
| --- | --- |
| `version.dll` | Proxy-injection DLL, loaded when Antigravity starts |
| `config.json` | Proxy port / type / target processes (default `127.0.0.1:7897` SOCKS5) |
| `install.bat` | One-click: enable system proxy + inject proxy + fix telemetry hook + localize |
| `uninstall.bat` | One-click: remove proxy & disable system proxy |

---

## Verify

After restarting, check `%LOCALAPPDATA%\Programs\antigravity\logs\proxy-YYYYMMDD.log`. You should see:

```
[成功] 已注入目标进程: language_server.exe
SOCKS5: 隧道建立成功, 目标=daily-cloudcode-pa.googleapis.com:443
```

---

## Troubleshooting

**① `User location is not supported`**
→ Switch to a **US / supported-region residential-IP** node (see prerequisite ①).

**② `Lost connection to the language server` / `unknown certificate`**
→ Make sure the **system proxy is ON** (handled by `install.bat`; or toggle Clash's "system proxy" on and restart Antigravity).

**③ In the IDE, the agent errors `Agent execution terminated due to error` when using tools**
→ This is Antigravity IDE's **broken telemetry hook** (the `googlecloudtools.datacloud_telemetry` PreToolUse hook path gets double-prefixed in IDE v2.8.1). `install.bat` disables it automatically. Manual fix: change `"enabled": true` to `"enabled": false` in
`%USERPROFILE%\.gemini\config\plugins\googlecloudtools.datacloud_telemetry\hooks.json`, then restart the IDE.

**④ Does the IDE need proxying too?**
→ Yes. The IDE is a separate install (`...\Programs\Antigravity IDE`). `install.bat` injects into both the hub and the IDE.

---

## Chinese localization (run separately)

If `install.bat` skipped localization (no Node.js), run manually:
```bat
git clone https://github.com/yiheng8023/antigravity-chinese.git
cd antigravity-chinese
node cli.js install --with-plugin
```
Then fully restart Antigravity to see the Chinese UI. Restore English: `node cli.js restore` (needs Node.js).

---

## Disclaimer

- This is a local proxy-injection + localization tool, **not** an official Google product; changes are local to your client.
- Proxy injection is based on the community tool [yuaotian/antigravity-proxy](https://github.com/yuaotian/antigravity-proxy); Chinese localization is based on [yiheng8023/antigravity-chinese](https://github.com/yiheng8023/antigravity-chinese). Respect their original licenses and attribution.
