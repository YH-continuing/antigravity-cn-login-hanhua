<p align="center">
  <h2 align="center">🛠️ Antigravity CN</h2>
  <p align="center">
    Make <b>Google Antigravity</b> <b>login and start the agent</b> on a mainland-China network, and <b>localize the UI to Chinese</b> in one click.<br>
    <sub>Login fix + Chinese localization for Google Antigravity — no TUN, no Proxifier.</sub>
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-Windows%20x64-2ea44f?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="License">
  <img src="https://img.shields.io/github/v/release/YH-continuing/antigravity-cn-login-hanhua?color=blue&style=flat-square" alt="Release">
  <img src="https://img.shields.io/github/stars/YH-continuing/antigravity-cn-login-hanhua?style=social" alt="Stars">
  <img src="https://img.shields.io/badge/covers-hub%20%2B%20IDE-blueviolet?style=flat-square" alt="Covers hub + IDE">
</p>

<p align="center">
  <a href="./README.md">简体中文</a> · <b>English</b>
</p>

---

## 📌 Overview

A **turn-key, no-TUN** solution for **Google Antigravity** (Windows x64) on a mainland-China network:

- Fixes **login hangs / agent won't start** (`language_server.exe` and `antigravity-ide` don't read the Windows system proxy, so their Google calls fail).
- Optional **one-click Chinese localization**.
- **No TUN, no Proxifier** — stable and doesn't disturb your Clash network.

---

## ✨ Features

- 🚫 **No TUN / No Proxifier** — precise SOCKS5 process injection; only the target processes are affected, not your global network.
- 🎯 **Precise targets** — covers the hub `Antigravity.exe` + language server `language_server.exe` + IDE `Antigravity IDE.exe` / `antigravity-ide` + `node.exe`.
- 🧩 **Hub + IDE both covered** — `install.bat` auto-detects and injects both install dirs.
- 🈶 **One-click Chinese localization**.
- 🔧 **Auto-troubleshoot** — enables the system proxy and disables the IDE's broken telemetry hook automatically.
- ♻️ **One-click revert** — `uninstall.bat` removes the injection and turns off the system proxy.

---

## 🧠 How it works

Antigravity 2.0's key service processes are written in **Go**:

```
Hub → resources\bin\language_server.exe
IDE → bin\antigravity-ide
```

They **do NOT read the Windows system proxy**. They hit `daily-cloudcode-pa.googleapis.com`, `generativelanguage.googleapis.com`, etc. directly — so even if your browser reaches Google and the system proxy is on, they still connect directly → login hangs, `context deadline exceeded`, agent won't start.

**This project** uses `version.dll` (Windows DLL loading — injected when Antigravity starts) to **precisely redirect the target processes' traffic via SOCKS5** to your local proxy (default `127.0.0.1:7897`), without touching TUN or your Clash global config.

```
Antigravity / Antigravity IDE
   └─ inject version.dll → target process traffic → SOCKS5 → local Clash → Google ✅
```

> **Why not TUN?** TUN can work but on some machines it breaks Clash entirely (core crash, system proxy disabled). Precise injection is more stable.

---

## ⚠️ Two prerequisites (easy to miss)

### ① Proxy node must be a "US / supported region + residential ISP IP"
Google's Gemini/Antigravity service **rejects datacenter IPs (VPS/cloud) and unsupported regions**:

```
FAILED_PRECONDITION (code 400): User location is not supported for the API use.
```

- Pick a **US (or supported region), residential / normal ISP** exit node.
- Avoid DigitalOcean, Vultr, OVH, Google Cloud, AWS, etc. (**datacenter IPs**).

### ② System proxy must be ON
The window (Chromium) relies on the system proxy to reach the **local language server** (`https://127.0.0.1:<port>/`). Otherwise:

```
TLS handshake error ... tls: unknown certificate
Lost connection to the language server
```

The repo's `install.bat` enables the system proxy automatically (`127.0.0.1:7897`).

---

## 📦 Prerequisites

| Condition | Notes |
| --- | --- |
| OS | Windows x64 |
| App | Antigravity installed (`antigravity` / `Antigravity IDE`) |
| Proxy | Local proxy running, default `127.0.0.1:7897` (Clash / Mihomo mixed or SOCKS port) |
| Node | Satisfies prerequisite **①** (supported region + residential IP) |
| Localization (optional) | Node.js ≥ 16 + git; skip it and the login fix still works |

---

## 🚀 Quick start (one click)

1. Download and unzip `antigravity-cn-login-hanhua.zip` from [Releases](../../releases).
2. **Double-click `install.bat`**.
3. Reopen Antigravity / Antigravity IDE.

`install.bat` will: check proxy → enable system proxy → inject proxy (hub + IDE) → disable the IDE's broken telemetry hook → close Antigravity to release file locks → download & apply Chinese (needs Node.js/git, else skipped).

> Proxy port isn't `7897`? Open `config.json` and change `proxy.port`.

---

## 🗑️ Uninstall (restore official state)

Double-click **`uninstall.bat`**: removes `version.dll` + `config.json` and turns off the system proxy.

---

## 📁 Project structure

```
antigravity-cn-login-hanhua/
├─ install.bat        # one-click: system proxy + inject proxy + fix telemetry hook + localize
├─ uninstall.bat      # one-click: remove proxy & disable system proxy
├─ version.dll        # proxy-injection DLL (loaded when Antigravity starts)
├─ config.json        # proxy port / type / target processes (default 127.0.0.1:7897 SOCKS5)
├─ README.md          # docs (Chinese)
├─ README.en.md       # docs (English)
└─ LICENSE            # MIT
```

---

## ✅ Verify

After restarting, check `%LOCALAPPDATA%\Programs\antigravity\logs\proxy-YYYYMMDD.log`. You should see:

```
[成功] 已注入目标进程: language_server.exe
SOCKS5: 隧道建立成功, 目标=daily-cloudcode-pa.googleapis.com:443
```

---

## ❓ FAQ

| Symptom | Fix |
| --- | --- |
| `User location is not supported` | Switch to a **US / supported-region residential-IP** node (see prerequisite ①). |
| `Lost connection to the language server` / `unknown certificate` | Make sure the **system proxy is ON** (handled by `install.bat`; or toggle Clash's "system proxy" and restart Antigravity). |
| IDE agent errors `Agent execution terminated due to error` when using tools | It's the IDE's **broken telemetry hook**. `install.bat` disables it automatically. Manual: set `"enabled": true` → `false` in `%USERPROFILE%\.gemini\config\plugins\googlecloudtools.datacloud_telemetry\hooks.json`, restart the IDE. |
| Does the IDE need proxying too? | Yes. The IDE is a separate install; `install.bat` injects into both hub and IDE. |
| After updating Antigravity the localization/proxy is gone? | Normal — the update overwrites `app.asar` and may remove `version.dll`/`config.json`. Re-run `install.bat` to fully restore. |

---

## 🈶 Chinese localization (run separately)

If `install.bat` skipped localization (no Node.js), run manually:

```bat
git clone https://github.com/yiheng8023/antigravity-chinese.git
cd antigravity-chinese
node cli.js install --with-plugin
```

Then fully restart Antigravity to see the Chinese UI. Restore English: `node cli.js restore` (needs Node.js).

---

## 📜 License & Acknowledgments

- This repo is licensed under the [MIT](./LICENSE) license.
- Proxy injection is based on [yuaotian/antigravity-proxy](https://github.com/yuaotian/antigravity-proxy).
- Chinese localization is based on [yiheng8023/antigravity-chinese](https://github.com/yiheng8023/antigravity-chinese).
- Respect their original licenses and attribution.
- **Not an official Google product**; changes are local to your client. If login shows `User location is not supported`, it's almost always a proxy-node issue unrelated to this tool.
