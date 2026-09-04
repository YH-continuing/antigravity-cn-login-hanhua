# Antigravity CN · 登录修复 + 汉化 (No-TUN 一步到位)

让大陆网络下的 **Google Antigravity**（Windows x64，含**主应用 `antigravity` 与 `Antigravity IDE`**）**正常登录、启动 Agent**，并一键**汉化中文界面**。全程**不开 TUN、不用 Proxifier**。

> 中文 | [English](README.en.md)

---

## 它解决两个问题

1. **登录 / Agent 连不上**：Antigravity 2.0 的关键服务进程（主应用是 `resources\bin\language_server.exe`，IDE 是 `bin\antigravity-ide`）是 **Go 程序，不读 Windows 系统代理**，直接请求 `daily-cloudcode-pa.googleapis.com`、`generativelanguage.googleapis.com` 等 Google 接口 → 登录页卡死、`context deadline exceeded`、Agent 无法启动。
2. **中文界面**：补上汉化补丁。

**为什么不开 TUN**：开 TUN 虽能解决，但部分机器会把整个 Clash 网络搞挂（核心崩溃、系统代理被关）。本方案只对目标进程做精确 SOCKS5 注入，稳定不破坏网络。

---

## ⚠️ 两个必须满足的前提（很容易忽略）

### ① 代理节点必须是「美国/支持地区 + 普通住宅 IP」
Google 的 Gemini/Antigravity 服务会**拒绝数据中心 IP（VPS/云厂商）和非支持地区**，报：
```
FAILED_PRECONDITION (code 400): User location is not supported for the API use.
```
- 请在 Clash 里选 **美国(US)或支持地区、普通住宅/ISP 出口 IP** 的节点。
- 避开 DigitalOcean、Vultr、OVH、Google Cloud、AWS 等**数据中心 IP**。

### ② 系统代理要开启
窗口（Chromium）连**本地语言服务器**（`https://127.0.0.1:<port>/`）时依赖系统代理，否则会报：
```
TLS handshake error ... tls: unknown certificate
Lost connection to the language server
```
本仓库的 `install.bat` 会自动开启系统代理（`127.0.0.1:7897`）。

---

## 前置条件

- Windows x64，已安装 Antigravity（`antigravity` / `Antigravity IDE`）。
- **本地代理在运行**，默认端口 `127.0.0.1:7897`（Clash / Mihomo mixed 或 SOCKS 端口均可）。
- 代理节点满足上面的**前提①**。
- 汉化需要 Node.js ≥ 16 + git（可选；跳过汉化则只需前两项）。

---

## 使用方法（一步到位）

1. 下载并解压本仓库 Release 的 `antigravity-cn-login-hanhua.zip`。
2. **双击运行 `install.bat`**。
3. 重新打开 Antigravity / Antigravity IDE。

`install.bat` 会自动：检查代理 → 开启系统代理 → 注入代理到主应用与 IDE 目录 → 禁用 IDE 坏掉的遥测钩子 → 关闭 Antigravity 释放文件锁 → 下载并应用汉化（若本机有 Node.js/git；缺失则跳过，登录修复仍生效）。

> 代理端口不是 `7897`？打开 `config.json`，改 `proxy.port`。

---

## 卸载（还原官方纯净）

双击 **`uninstall.bat`**：移除 `version.dll` + `config.json` 并关闭系统代理。

> 若还要还原汉化过的 app.asar，在对应安装目录执行还原（见下方“汉化”）。

---

## 文件说明

| 文件 | 作用 |
| --- | --- |
| `version.dll` | 代理注入 DLL，放 Antigravity 安装目录后随应用启动加载 |
| `config.json` | 配置代理端口/类型/目标进程（默认 `127.0.0.1:7897` SOCKS5） |
| `install.bat` | 一键：开启系统代理 + 注入代理 + 修遥测钩子 + 汉化 |
| `uninstall.bat` | 一键：移除代理并关闭系统代理 |

---

## 验证是否生效

重启后查看安装目录日志 `%LOCALAPPDATA%\Programs\antigravity\logs\proxy-YYYYMMDD.log`，看到即成功：

```
[成功] 已注入目标进程: language_server.exe
SOCKS5: 隧道建立成功, 目标=daily-cloudcode-pa.googleapis.com:443
```

---

## 常见问题

**① 报 `User location is not supported`**
→ 换**美国/支持地区 + 普通住宅 IP** 的节点（见前提①）。

**② 报 `Lost connection to the language server` / `unknown certificate`**
→ 确认**系统代理已开启**（`install.bat` 已处理；也可在 Clash 里打开“系统代理”开关后重启 Antigravity）。

**③ IDE 里 Agent 用工具就报 `Agent execution terminated due to error`**
→ 这是 Antigravity IDE 的**遥测钩子路径损坏**导致（`googlecloudtools.datacloud_telemetry` 插件的 PreToolUse 钩子在 IDE v2.8.1 里路径被重复拼接）。`install.bat` 已自动禁用。手动禁：把
`%USERPROFILE%\.gemini\config\plugins\googlecloudtools.datacloud_telemetry\hooks.json` 里的 `"enabled": true` 改为 `false`，再重启 IDE。

**④ IDE 也要用代理吗？**
→ 是。IDE 是独立安装（`...\Programs\Antigravity IDE`），`install.bat` 会同时给主应用和 IDE 注入。

---

## 汉化（单独执行）

若 `install.bat` 因本机无 Node.js 跳过了汉化，可手动：
```bat
git clone https://github.com/yiheng8023/antigravity-chinese.git
cd antigravity-chinese
node cli.js install --with-plugin
```
然后完全退出重启 Antigravity，即可看到中文界面。还原英文：`node cli.js restore`（需 Node.js）。

---

## 免责声明

- 本项目为**本地代理注入 + 汉化**，非 Google 官方产品，修改仅发生在你本机客户端。
- 核心代理注入能力来自社区工具 [yuaotian/antigravity-proxy](https://github.com/yuaotian/antigravity-proxy)，汉化来自 [yiheng8023/antigravity-chinese](https://github.com/yiheng8023/antigravity-chinese)，请遵守其原始许可证并保留作者信息。
