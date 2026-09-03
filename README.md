# Antigravity 中文 No-TUN 一键方案

在**不开 TUN、不用 Proxifier** 的情况下，让大陆网络下的 Google Antigravity（2.0+）正常**登录、启动 Agent**，并可选一键**汉化**。

> 适用：Windows x64，Antigravity（`antigravity` / `Antigravity IDE`），本地代理（Clash / Mihomo / Clash Verge 等）已在运行。

---

## 为什么需要它

Antigravity 2.0 不只由 `Antigravity.exe` 负责联网。关键服务进程

```
resources\bin\language_server.exe
```

是由 **Go** 写的，它**不会读取 Windows 系统代理**，直接发起对 `daily-cloudcode-pa.googleapis.com` 等 Google 接口的请求。所以即使浏览器能上 Google、系统代理也开了，Antigravity 依然会：

- 登录页一直卡住 / `context deadline exceeded`
- Agent 无法启动 / 连不上

**开 TUN** 能解决，但对部分机器会破坏整个 Clash 网络（核心崩溃、系统代理被关）。本方案**不碰 TUN**，只针对 `language_server.exe` 等进程做精确的 SOCKS5 代理注入。

---

## 前置条件（都满足才能用）

1. 已安装 Antigravity（Windows x64）。
2. **本地代理在运行**，默认端口 `127.0.0.1:7897`（Clash / Mihomo 的 mixed 或 socks 端口都行）。
3. 你的代理节点能访问 Google。

---

## 使用方法（一步到位）

1. 下载本仓库 Release（或直接 clone）。
2. **双击运行 `install.bat`**（在仓库根目录）。
3. 完全退出并重新启动 Antigravity。

搞定。`install.bat` 会自动检测 Antigravity / Antigravity IDE 安装目录，把 `version.dll` + `config.json` 复制进去。

> 如果你的代理端口不是 `7897`：打开 `config.json`，把 `proxy.port` 改成你的端口即可。

---

## 可选：汉化

要中文界面，再跑一条命令（需要本机 Node.js ≥ 16）：

```bat
git clone https://github.com/yiheng8023/antigravity-chinese.git
cd antigravity-chinese
node cli.js install --with-plugin
```

然后同样完全退出重启 Antigravity 即可看到中文界面。

---

## 卸载（还原官方纯净状态）

双击运行仓库里的 **`uninstall.bat`**，会移除 `version.dll` 和 `config.json`，重启 Antigravity 即恢复原样。

---

## 文件说明

| 文件 | 作用 |
| --- | --- |
| `version.dll` | 代理注入 DLL，放到 `Antigravity` 安装目录后随应用启动加载 |
| `config.json` | 配置代理端口、代理类型、目标进程（默认 `127.0.0.1:7897` SOCKS5） |
| `install.bat` | 一键复制上述两个文件到 Antigravity 安装目录 |
| `uninstall.bat` | 一键移除 |

---

## 验证是否生效

重新启动 Antigravity 后，查看安装目录下的日志：

```
%LOCALAPPDATA%\Programs\antigravity\logs\proxy-YYYYMMDD.log
```

看到这行说明链路已经通了：

```
[成功] 已注入目标进程: language_server.exe
SOCKS5: 隧道建立成功, 目标=daily-cloudcode-pa.googleapis.com:443
```

---

## 免责声明

- 本项目仅是**本地代理注入**，非 Google 官方产品；修改仅发生在你本机客户端。
- 核心注入能力来自社区工具 **yuaotian/antigravity-proxy**，使用请遵守其原始许可证并保留作者信息。
- 若登录提示 `User location is not supported`，通常是代理出口节点 IP 被 Google 限制，换一个普通/住宅节点即可。
