<div align="center">

# 🛠️ Antigravity CN

> 让 **Google Antigravity** 在中国大陆网络下 **正常登录、启动 Agent**，并**一键汉化**中文界面。
> **不开 TUN、不用 Proxifier、不动 Clash 全局配置。**

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

## 📋 目录

- [特性](#-特性)
- [原理](#-原理)
- [快速开始](#-快速开始)
- [重要前提](#-重要前提)
- [卸载](#-卸载)
- [验证](#-验证)
- [常见问题](#-常见问题)
- [目录结构](#-目录结构)
- [许可证与致谢](#-许可证与致谢)

---

## ✨ 特性

- 🚫 **免 TUN / 免 Proxifier** —— 仅对目标进程做 SOCKS5 精确注入，不改变全局网络。
- 🎯 **主应用 + IDE 双覆盖** —— `Antigravity.exe`、`language_server.exe`、`Antigravity IDE.exe`、`antigravity-ide`、`node.exe`。
- 🈶 **一键汉化** —— 中文界面补丁并入安装流程。
- 🔧 **自动排障** —— 自动开启系统代理、自动禁用 IDE 坏掉的遥测钩子。
- ♻️ **一键还原** —— `uninstall.bat` 恢复官方纯净状态。

## 🧠 原理

Antigravity 2.0 的语言服务进程（主应用 `resources\bin\language_server.exe`，IDE `bin\antigravity-ide`）由 **Go** 编写，**不读取 Windows 系统代理**，直接请求 `daily-cloudcode-pa.googleapis.com`、`generativelanguage.googleapis.com` 等 Google 接口，导致登录卡死、`context deadline exceeded`、Agent 无法启动。

本方案通过 **`version.dll`**（随 Antigravity 启动加载）将这些进程的流量**用 SOCKS5 精确重定向**到本地代理（默认 `127.0.0.1:7897`）——稳定且不动 TUN，不破坏 Clash 网络。

> 为什么不开 TUN：开 TUN 虽能解决，但在部分机器上会把整个 Clash 搞挂（核心崩溃、系统代理被关）。精确进程注入更稳。

## 🚀 快速开始

1. 下载并解压 **Release** 的 `antigravity-cn-login-hanhua.zip`。
2. **双击运行 `install.bat`**。
3. 重新打开 Antigravity / Antigravity IDE。

`install.bat` 会自动完成：**开启系统代理 → 注入代理（主应用 + IDE）→ 禁用 IDE 坏遥测钩子 → 应用汉化补丁**。

> 若本机 **无 Node.js ≥ 16**，汉化步骤会自动跳过（登录修复仍生效）。代理端口不是 `7897`？修改 `config.json` 的 `proxy.port`。

## ⚠️ 重要前提

1. 🛰️ **节点必须是「美国/支持地区 + 普通住宅 IP」** —— 数据中心 IP 会被 Google 拒（`User location is not supported`）。
2. 🌐 **系统代理需开启** —— `install.bat` 已自动处理；否则窗口连本地语言服务器报 `Lost connection to the language server`。

## 🧹 卸载

双击 **`uninstall.bat`**：移除 `version.dll` + `config.json` 并关闭系统代理，还原官方状态。

## ✅ 验证

重启后查看 `%LOCALAPPDATA%\Programs\antigravity\logs\proxy-YYYYMMDD.log`，出现即成功：

```
[成功] 已注入目标进程: language_server.exe
SOCKS5: 隧道建立成功, 目标=daily-cloudcode-pa.googleapis.com:443
```

## ❓ 常见问题

| 现象 | 处理 |
| --- | --- |
| `User location is not supported` | 换**美国/支持地区 + 住宅 IP** 节点。 |
| `Lost connection to the language server` / `unknown certificate` | 确认**系统代理已开启**（Clash 打开“系统代理”后重启）。 |
| IDE 里 Agent 用工具报 `Agent execution terminated` | `install.bat` 已禁用坏遥测钩子；手动改 `%USERPROFILE%\.gemini\config\plugins\googlecloudtools.datacloud_telemetry\hooks.json` 的 `"enabled"` 为 `false`，重启 IDE。 |
| 更新 Antigravity 后汉化/代理没了 | 正常——更新会覆盖 `app.asar` 并可能清掉注入文件；重跑一次 `install.bat` 即可全量恢复。 |

## 📁 目录结构

```
antigravity-cn-login-hanhua/
├─ install.bat     # 一键：系统代理 + 注入代理 + 修遥测钩子 + 汉化
├─ uninstall.bat   # 一键：移除代理并关闭系统代理
├─ version.dll     # 代理注入 DLL（随 Antigravity 启动加载）
├─ config.json     # 代理端口/类型/目标进程（默认 127.0.0.1:7897 SOCKS5）
├─ README.md       # 说明文档（中文）
├─ README.en.md    # 说明文档（英文）
└─ LICENSE         # MIT
```

## 📄 许可证与致谢

[![MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

- 代理注入能力基于社区工具 [yuaotian/antigravity-proxy](https://github.com/yuaotian/antigravity-proxy)。
- 汉化补丁基于 [yiheng8023/antigravity-chinese](https://github.com/yiheng8023/antigravity-chinese)。
- 请遵守上述项目的原始许可证并保留作者信息。
- **非 Google 官方产品**，修改仅发生在你本机客户端；若登录提示 `User location is not supported`，多为代理节点问题。
