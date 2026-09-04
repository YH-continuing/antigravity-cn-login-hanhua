<div align="center">

# Antigravity CN

Make Google Antigravity **login and start the agent** on a mainland-China network, and **localize the UI to Chinese** in one click.
**No TUN, no Proxifier, no changes to your Clash global config.**

[Windows x64](https://img.shields.io/badge/platform-Windows%20x64-2ea44f?style=flat-square)
[MIT License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)
[Release v1.2.0](https://img.shields.io/github/v/release/YH-continuing/antigravity-cn-login-hanhua?color=blue&style=flat-square)
[Stars](https://img.shields.io/github/stars/YH-continuing/antigravity-cn-login-hanhua?style=social)

[简体中文](README.md) · [English](README.en.md)

</div>

---

## ✨ Highlights

- No TUN / No Proxifier — precise SOCKS5 injection into the target processes only, not your global network.
- Covers hub + IDE: `Antigravity.exe` / `language_server.exe` / `Antigravity IDE.exe` / `antigravity-ide` / `node.exe`.
- One-click Chinese localization (part of the install flow).
- Auto-enables the system proxy and disables the IDE's broken telemetry hook.
- One-click restore to the official state.

## 🧠 How it works

Antigravity 2.0's language service processes (`language_server.exe` / `antigravity-ide`) are written in **Go** and **don't read the Windows system proxy**, so they hit Google's APIs directly → login hangs, agent won't start.

This project uses **`version.dll`** (loaded when Antigravity starts) to precisely redirect those processes' traffic to your local proxy (default `127.0.0.1:7897`) — stable, and no TUN.

> Why not TUN? TUN can work but on some machines breaks Clash entirely (core crash, system proxy disabled). Precise injection is more stable.

## 🚀 Quick start

1. Download & unzip `antigravity-cn-login-hanhua.zip` from [Releases](../../releases).
2. **Double-click `install.bat`**.
3. Reopen Antigravity / Antigravity IDE.

`install.bat` will: enable the system proxy → inject proxy (hub + IDE) → disable the IDE's broken telemetry hook → apply Chinese (needs Node.js ≥ 16; else auto-skips and the login fix still works).

> Proxy port isn't `7897`? Change `proxy.port` in `config.json`.

## ⚠️ Two prerequisites

1. **Node must be a "US / supported region + residential IP"** — datacenter IPs get rejected by Google (`User location is not supported`).
2. **System proxy must be ON** — handled automatically by `install.bat`; otherwise the window loses connection to the local language server (`Lost connection to the language server`).

## 🧹 Uninstall

Double-click `uninstall.bat`: removes `version.dll` + `config.json` and turns off the system proxy.

## ❓ FAQ

| Symptom | Fix |
| --- | --- |
| `User location is not supported` | Switch to a US / supported-region residential-IP node. |
| `Lost connection to the language server` | Make sure the system proxy is on (toggle Clash's "system proxy", restart Antigravity). |
| IDE agent errors `Agent execution terminated` when using tools | `install.bat` disables the broken hook; manually set `"enabled"` to `false` in `%USERPROFILE%\.gemini\config\plugins\googlecloudtools.datacloud_telemetry\hooks.json`. |
| Localization/proxy gone after updating Antigravity | Normal — the update overwrites `app.asar` and may remove the injection files. Re-run `install.bat` to fully restore. |

## 📄 License

[![MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

Proxy injection is based on [yuaotian/antigravity-proxy](https://github.com/yuaotian/antigravity-proxy); Chinese localization is based on [yiheng8023/antigravity-chinese](https://github.com/yiheng8023/antigravity-chinese). Respect their original licenses and attribution. Not an official Google product.
