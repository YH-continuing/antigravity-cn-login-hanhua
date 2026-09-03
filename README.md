# Antigravity CN · 登录修复 + 汉化 (No-TUN 一步到位)

让大陆网络下的 **Google Antigravity**（Windows x64）**正常登录、启动 Agent**，并一键**汉化中文界面**。全程**不开 TUN、不用 Proxifier**，也不改 Clash 全局配置。

> 中文 | [English](README.en.md)

---

## 它解决两个问题

1. **登录 / Agent 连不上**：Antigravity 2.0 的关键服务进程 `resources\bin\language_server.exe`（Go 编写）**不读 Windows 系统代理**，直接请求 `daily-cloudcode-pa.googleapis.com` 等 Google 接口，导致登录页卡死、`context deadline exceeded`、Agent 无法启动。
2. **中文界面**：补上汉化补丁。

**为什么不用 TUN**：开 TUN 虽能解决，但部分机器会把整个 Clash 网络搞挂（核心崩溃、系统代理被关）。本方案只对 `language_server.exe` 等目标进程做精确 SOCKS5 注入，稳定不破坏网络。

---

## 前置条件

- Windows x64，已安装 Antigravity（`antigravity` / `Antigravity IDE`）。
- **本地代理在运行**，默认端口 `127.0.0.1:7897`（Clash / Mihomo 的 mixed / socks 端口均可）。
- 代理节点能访问 Google。
- 汉化需要 Node.js ≥ 16 和 git（可选；跳过汉化则只需前两项）。

---

## 使用方法（一步到位）

1. 下载并解压本仓库 Release 的 `antigravity-cn-login-hanhua.zip`。
2. **双击运行 `install.bat`**。
3. 重新打开 Antigravity。

`install.bat` 会自动：注入代理 → 关闭 Antigravity 释放文件锁 → 下载并应用汉化（若本机有 Node.js/git；否则跳过汉化，登录修复仍生效）。

> 代理端口不是 `7897`？打开 `config.json`，改 `proxy.port`。

---

## 卸载（还原官方纯净）

双击运行 **`uninstall.bat`**，移除 `version.dll` + `config.json`，并卸载汉化插件（若已装）。重启 Antigravity 即恢复。

---

## 文件说明

| 文件 | 作用 |
| --- | --- |
| `version.dll` | 代理注入 DLL，放 Antigravity 安装目录后随应用启动加载 |
| `config.json` | 配置代理端口 / 类型 / 目标进程（默认 `127.0.0.1:7897` SOCKS5） |
| `install.bat` | 一键注入代理 + 汉化 |
| `uninstall.bat` | 一键还原 |

---

## 验证是否生效

重启后查看安装目录日志 `%LOCALAPPDATA%\Programs\antigravity\logs\proxy-YYYYMMDD.log`，看到即成功：

```
[成功] 已注入目标进程: language_server.exe
SOCKS5: 隧道建立成功, 目标=daily-cloudcode-pa.googleapis.com:443
```

---

## 免责声明

- 本项目为**本地代理注入 + 汉化**，非 Google 官方产品，修改仅发生在你本机客户端。
- 核心代理注入能力来自社区工具 [yuaotian/antigravity-proxy](https://github.com/yuaotian/antigravity-proxy)，汉化来自 [yiheng8023/antigravity-chinese](https://github.com/yiheng8023/antigravity-chinese)，请遵守其原始许可证并保留作者信息。
- 若登录提示 `User location is not supported`，通常是代理出口节点 IP 被 Google 限制，换一个普通/住宅节点即可。
