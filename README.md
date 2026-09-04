<p align="center">
  <h2 align="center">🛠️ Antigravity CN</h2>
  <p align="center">
    让 <b>Google Antigravity</b> 在中国大陆网络下<b>正常登录、启动 Agent</b>，并<b>一键汉化</b>中文界面。<br>
    <sub>Login fix + Chinese localization for Google Antigravity on mainland China — no TUN, no Proxifier.</sub>
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
  <b>简体中文</b> · <a href="./README.en.md">English</a>
</p>

---

## 📌 项目简介

为**中国大陆网络**下的 Google Antigravity（Windows x64）提供**开箱即用**的免 TUN 方案：

- 解决 **登录卡死 / Agent 无法启动**（`language_server.exe`、`antigravity-ide` 不读系统代理导致的 Google 连接失败）。
- 可选 **一键汉化** 中文界面。
- **不开 TUN、不用 Proxifier**，稳定且不破坏 Clash 网络。

---

## ✨ 特性

- 🚫 **免 TUN / 免 Proxifier**：改用精确的 SOCKS5 进程注入，只影响目标进程，不动全局网络。
- 🎯 **精准目标进程**：覆盖主应用 `Antigravity.exe` + 语言服务 `language_server.exe` + IDE `Antigravity IDE.exe` / `antigravity-ide` + `node.exe`。
- 🧩 **主应用 + IDE 双覆盖**：`install.bat` 自动检测并注入两个安装目录。
- 🈶 **一键汉化**：顺带把中文界面打上（非必需，可跳过）。
- 🔧 **自动排障**：自动开启系统代理、自动禁用 IDE 坏掉的遥测钩子（`googlecloudtools.datacloud_telemetry`）。
- ♻️ **一键还原**：`uninstall.bat` 清掉注入并关闭系统代理，恢复官方纯净状态。

---

## 🧠 原理

Antigravity 2.0 的关键服务进程由 **Go** 编写：

```
主应用 → resources\bin\language_server.exe
IDE    → bin\antigravity-ide
```

它们**不读取 Windows 系统代理**，直接请求 `daily-cloudcode-pa.googleapis.com`、`generativelanguage.googleapis.com` 等 Google 接口。即使浏览器能上 Google、系统代理也开了，它们依然直连 → 登录卡死、`context deadline exceeded`、Agent 起不来。

**本方案**通过 `version.dll`（Windows 的 DLL 加载机制，随 Antigravity 启动注入）把目标进程的流量**用 SOCKS5 精确重定向**到本地代理（默认 `127.0.0.1:7897`），不动 TUN、不动 Clash 全局配置。

```
Antigravity(An...IDE.exe)
   └─ 注入 version.dll → 目标进程流量 → SOCKS5 → 本地 Clash → Google ✅
```

> **为什么不用 TUN**：开 TUN 虽能解决，但在部分机器上会把整个 Clash 网络搞挂（核心崩溃、系统代理被关）。精确注入更稳。

---

## ⚠️ 两个重要前提（极易忽略）

### ① 代理节点必须是「美国/支持地区 + 普通住宅 IP」
Google Gemini/Antigravity 会**拒绝数据中心 IP（VPS/云厂商）与非支持地区**：

```
FAILED_PRECONDITION (code 400): User location is not supported for the API use.
```

- 选 **美国(US)或支持地区、普通住宅 / ISP 出口 IP** 的节点。
- 避开 DigitalOcean、Vultr、OVH、Google Cloud、AWS 等**数据中心 IP**。

### ② 系统代理必须开启
窗口（Chromium）连**本地语言服务器**（`https://127.0.0.1:<port>/`）依赖系统代理，否则：

```
TLS handshake error ... tls: unknown certificate
Lost connection to the language server
```

本仓库的 `install.bat` 会自动开启系统代理（`127.0.0.1:7897`）。

---

## 📦 前置条件

| 条件 | 说明 |
| --- | --- |
| 系统 | Windows x64 |
| 应用 | 已安装 Antigravity（`antigravity` / `Antigravity IDE`） |
| 代理 | 本地代理在运行，默认 `127.0.0.1:7897`（Clash / Mihomo mixed 或 SOCKS 端口） |
| 节点 | 满足**前提①**（支持地区 + 住宅 IP） |
| 汉化（可选） | Node.js ≥ 16 + git；跳过汉化则只需要前三项 |

---

## 🚀 快速开始

**一步到位：**

1. 下载并解压 Release 的 `antigravity-cn-login-hanhua.zip`。
2. 双击运行 **`install.bat`**。
3. 重新打开 Antigravity / Antigravity IDE。

`install.bat` 会依次：检查代理 → 开启系统代理 → 注入代理（主应用 + IDE）→ 禁用 IDE 坏遥测钩子 → 关闭 Antigravity 释放文件锁 → 下载并应用汉化（需 Node.js/git，缺失则跳过）。

> 代理端口不是 `7897`？打开 `config.json`，修改 `proxy.port`。

---

## 🗑️ 卸载（还原官方纯净）

双击 **`uninstall.bat`**：移除 `version.dll` + `config.json` 并关闭系统代理。

---

## 📁 目录结构

```
antigravity-cn-login-hanhua/
├─ install.bat        # 一键：系统代理 + 注入代理 + 修遥测钩子 + 汉化
├─ uninstall.bat      # 一键：移除代理并关闭系统代理
├─ version.dll        # 代理注入 DLL（随 Antigravity 启动加载）
├─ config.json        # 代理端口 / 类型 / 目标进程（默认 127.0.0.1:7897 SOCKS5）
├─ README.md          # 说明文档（中文）
├─ README.en.md       # 说明文档（英文）
└─ LICENSE            # MIT
```

---

## ✅ 验证是否生效

重启后查看安装目录日志：

```
%LOCALAPPDATA%\Programs\antigravity\logs\proxy-YYYYMMDD.log
```

出现即成功：

```
[成功] 已注入目标进程: language_server.exe
SOCKS5: 隧道建立成功, 目标=daily-cloudcode-pa.googleapis.com:443
```

---

## ❓ 常见问题（FAQ）

| 现象 | 处理 |
| --- | --- |
| `User location is not supported` | 换**美国/支持地区 + 住宅 IP** 节点（见前提①）。 |
| `Lost connection to the language server` / `unknown certificate` | 确认**系统代理已开启**（`install.bat` 已处理；或在 Clash 打开“系统代理”后重启 Antigravity）。 |
| IDE 里 Agent 用工具报 `Agent execution terminated due to error` | 是 IDE **遥测钩子路径损坏**。`install.bat` 已自动禁用。手动：把 `%USERPROFILE%\.gemini\config\plugins\googlecloudtools.datacloud_telemetry\hooks.json` 的 `"enabled": true` 改为 `false`，重启 IDE。 |
| IDE 也要代理吗？ | 是。IDE 是独立安装，`install.bat` 会同时注入主应用与 IDE。 |
| 更新 Antigravity 后汉化/代理没了？ | 正常，更新会覆盖 `app.asar` 并可能清掉 `version.dll`/`config.json`。重跑一次 `install.bat` 即可全量恢复。 |

---

## 🈶 汉化（单独执行）

若本机无 Node.js 导致 `install.bat` 跳过汉化，可手动：

```bat
git clone https://github.com/yiheng8023/antigravity-chinese.git
cd antigravity-chinese
node cli.js install --with-plugin
```

完全退出重启 Antigravity 即得中文界面。还原英文：`node cli.js restore`（需 Node.js）。

---

## 📜 许可证与致谢

- 本仓库采用 [MIT](./LICENSE) 许可证。
- 核心代理注入能力来自社区工具 [yuaotian/antigravity-proxy](https://github.com/yuaotian/antigravity-proxy)。
- 汉化补丁来自 [yiheng8023/antigravity-chinese](https://github.com/yiheng8023/antigravity-chinese)。
- 请遵守上述项目的原始许可证并保留作者信息。
- **非 Google 官方产品**，修改仅发生在你本机客户端；若登录提示 `User location is not supported`，多为代理节点问题，与本工具无关。
