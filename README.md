<div align="center">

# Antigravity CN

让 Google Antigravity 在中国大陆网络下正常登录、启动 Agent，并一键汉化中文界面。
**不开 TUN、不用 Proxifier，不动 Clash 全局配置。**

[平台 Windows x64](https://img.shields.io/badge/platform-Windows%20x64-2ea44f?style=flat-square)
[许可 MIT](https://img.shields.io/badge/license-MIT-blue?style=flat-square)
[下载 v1.2.0](https://img.shields.io/github/v/release/YH-continuing/antigravity-cn-login-hanhua?color=blue&style=flat-square)
[Stars](https://img.shields.io/github/stars/YH-continuing/antigravity-cn-login-hanhua?style=social)

[简体中文](README.md) · [English](README.en.md)

</div>

---

## ✨ 特性

- 免 TUN / 免 Proxifier：仅对目标进程做 SOCKS5 精确注入，不动全局网络。
- 主应用 + IDE 双覆盖：`Antigravity.exe` / `language_server.exe` / `Antigravity IDE.exe` / `antigravity-ide` / `node.exe`。
- 一键汉化中文界面（并入安装流程）。
- 自动开启系统代理、自动禁用 IDE 坏掉的遥测钩子。
- 一键还原官方状态。

## 🧠 原理

Antigravity 2.0 的语言服务进程（`language_server.exe` / `antigravity-ide`）用 **Go** 编写，**不读 Windows 系统代理**，直连 Google 接口 → 登录卡死、Agent 起不来。

本方案用 **`version.dll`**（随 Antigravity 启动加载）将这些进程的流量精确重定向到本地代理（默认 `127.0.0.1:7897`），稳定且不动 TUN。

> 为什么不用 TUN：开 TUN 在部分机器上会把整个 Clash 搞挂（核心崩溃、系统代理被关）。精确注入更稳。

## 🚀 快速开始

1. 下载并解压 Release 的 `antigravity-cn-login-hanhua.zip`。
2. **双击 `install.bat`**。
3. 重新打开 Antigravity / Antigravity IDE。

`install.bat` 会依次：开启系统代理 → 注入代理（主应用+IDE）→ 禁用 IDE 坏遥测钩子 → 应用汉化（需 Node.js ≥ 16；缺失则自动跳过，登录修复仍生效）。

> 代理端口不是 `7897`？改 `config.json` 里的 `proxy.port`。

## ⚠️ 两个前提

1. **节点用「美国/支持地区 + 普通住宅 IP」**——数据中心 IP 会被 Google 拒（`User location is not supported`）。
2. **系统代理需开启**——`install.bat` 已自动处理；否则窗口连本地语言服务器报 `Lost connection to the language server`。

## 🧹 卸载

双击 `uninstall.bat`：移除 `version.dll` + `config.json` 并关闭系统代理，还原官方状态。

## ❓ 常见问题

| 现象 | 处理 |
| --- | --- |
| `User location is not supported` | 换美国/支持地区 + 住宅 IP 节点。 |
| `Lost connection to the language server` | 确认系统代理已开启（Clash 打开“系统代理”，重启 Antigravity）。 |
| IDE 里 Agent 用工具报错 `Agent execution terminated` | `install.bat` 已禁用坏遥测钩子；手动改 `%USERPROFILE%\.gemini\config\plugins\googlecloudtools.datacloud_telemetry\hooks.json` 的 `"enabled"` 为 `false`。 |
| 更新 Antigravity 后汉化/代理没了 | 正常——更新会覆盖 `app.asar` 并可能清掉注入文件。重跑一次 `install.bat` 即可全量恢复。 |

## 📄 许可

[![MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

代理注入基于 [yuaotian/antigravity-proxy](https://github.com/yuaotian/antigravity-proxy)，汉化基于 [yiheng8023/antigravity-chinese](https://github.com/yiheng8023/antigravity-chinese)。请遵守其原始许可证并保留作者信息。非 Google 官方产品。
