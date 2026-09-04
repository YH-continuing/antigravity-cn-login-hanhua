<div align="center">

# 🛠️ Antigravity CN

> Make **Google Antigravity** **login and start the agent** on a mainland-China network, and **localize the UI to Chinese** in one click.
> **No TUN, no Proxifier, no changes to your Clash global config.**

<p>
  <img src="https://img.shields.io/badge/platform-Windows%20x64-2ea44f?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="License">
  <img src="https://img.shields.io/github/v/release/YH-continuing/antigravity-cn-login-hanhua?color=blue&style=flat-square" alt="Release">
  <img src="https://img.shields.io/github/stars/YH-continuing/antigravity-cn-login-hanhua?style=social" alt="Stars">
  <img src="https://img.shields.io/badge/coverage-hub%20%2B%20IDE-blueviolet?style=flat-square" alt="Coverage">
</p>

[简体中文](README.md) · [English](README.en.md)

</div>

---

## 📋 Table of Contents

- [Features](#-features)
- [How it works](#-how-it-works)
- [Quick start](#-quick-start)
- [Prerequisites](#-prerequisites)
- [Uninstall](#-uninstall)
- [Verify](#-verify)
- [FAQ](#-faq)
- [Project structure](#-project-structure)
- [License & acknowledgments](#-license--acknowledgments)

---

## ✨ Features

- 🚫 **No TUN / No Proxifier** — precise SOCKS5 injection into the target processes only, not your global network.
- 🎯 **Covers hub + IDE** — `Antigravity.exe`, `language_server.exe`, `Antigravity IDE.exe`, `antigravity-ide`, `node.exe`.
- 🈶 **One-click Chinese localization** — integrated into the install flow.
- 🔧 **Auto-troubleshoot** — enables the system proxy and disables the IDE's broken telemetry hook.
- ♻️ **One-click restore** — `uninstall.bat` returns to the official state.

## 🧠 How it works

Antigravity 2.0's language service processes (hub `resources\bin\language_server.exe`, IDE `bin\antigravity-ide`) are written in **Go** and **don't read the Windows system proxy**. They hit `daily-cloudcode-pa.googleapis.com`, `generativelanguage.googleapis.com`, etc. directly → login hangs, `context deadline exceeded`, agent won't start.

This project uses **`version.dll`** (loaded when Antigravity starts) to **precisely redirect those processes' traffic via SOCKS5** to your local proxy (default `127.0.0.1:7897`) — stable, and no TUN.

> Why not TUN? TUN can work but on some machines breaks Clash entirely (core crash, system proxy disabled). Precise process injection is more stable.

## 🚀 Quick start

1. Download & unzip `antigravity-cn-login-hanhua.zip` from [Releases](../../releases).
2. **Double-click `install.bat`**.
3. Reopen Antigravity / Antigravity IDE.

`install.bat` will: **enable the system proxy → inject proxy (hub + IDE) → disable the IDE's broken telemetry hook → apply the Chinese patch**.

> If there's no **Node.js ≥ 16**, the localization step is auto-skipped (the login fix still works). Proxy port isn't `7897`? Change `proxy.port` in `config.json`.

## ⚠️ Prerequisites

1. 🛰️ **Node must be a "US / supported region + residential IP"** — datacenter IPs get rejected by Google (`User location is not supported`).
2. 🌐 **System proxy must be ON** — handled automatically by `install.bat`; otherwise the window loses connection to the local language server (`Lost connection to the language server`).

## 🧹 Uninstall

Double-click **`uninstall.bat`**: removes `version.dll` + `config.json` and turns off the system proxy.

## ✅ Verify

After restarting, check `%LOCALAPPDATA%\Programs\antigravity\logs\proxy-YYYYMMDD.log`. You should see:

```
[成功] 已注入目标进程: language_server.exe
SOCKS5: 隧道建立成功, 目标=daily-cloudcode-pa.googleapis.com:443
```

## ❓ FAQ

| Symptom | Fix |
| --- | --- |
| `User location is not supported` | Switch to a **US / supported-region residential-IP** node. |
| `Lost connection to the language server` / `unknown certificate` | Make sure the **system proxy is on** (toggle Clash's "system proxy", restart Antigravity). |
| IDE agent errors `Agent execution terminated` when using tools | `install.bat` disables the broken hook; manually set `"enabled"` to `false` in `%USERPROFILE%\.gemini\config\plugins\googlecloudtools.datacloud_telemetry\hooks.json`, restart the IDE. |
| Localization/proxy gone after updating Antigravity | Normal — the update overwrites `app.asar` and may remove the injection files; re-run `install.bat` to fully restore. |

## 📁 Project structure

```
antigravity-cn-login-hanhua/
├─ install.bat     # one-click: system proxy + inject proxy + fix telemetry hook + localize
├─ uninstall.bat   # one-click: remove proxy & disable system proxy
├─ version.dll     # proxy-injection DLL (loaded when Antigravity starts)
├─ config.json     # proxy port / type / target processes (default 127.0.0.1:7897 SOCKS5)
├─ README.md       # docs (Chinese)
├─ README.en.md    # docs (English)
└─ LICENSE         # MIT
```

## 📄 License & acknowledgments

[![MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

- Proxy injection is based on [yuaotian/antigravity-proxy](https://github.com/yuaotian/antigravity-proxy).
- Chinese localization is based on [yiheng8023/antigravity-chinese](https://github.com/yiheng8023/antigravity-chinese).
- Respect their original licenses and attribution.
- **Not an official Google product**; changes are local to your client. If login shows `User location is not supported`, it's almost always a proxy-node issue.
