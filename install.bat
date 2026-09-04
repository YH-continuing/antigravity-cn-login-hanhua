@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title Antigravity CN：登录修复 + 汉化（No-TUN 一步到位）

echo ==========================================================
echo   Antigravity CN：登录修复 + 汉化（不开 TUN/Proxifier）
echo   适用：主应用 antigravity + Antigravity IDE
echo ==========================================================
echo.

set "PROXY_HOST=127.0.0.1"
set "PROXY_PORT=7897"

rem ---------- 1. 检查本地代理端口 ----------
echo [1/4] 检查本地代理 %PROXY_HOST%:%PROXY_PORT% ...
powershell -NoProfile -Command "if (Test-NetConnection -ComputerName '%PROXY_HOST%' -Port %PROXY_PORT% -WarningAction SilentlyContinue).TcpTestSucceeded { exit 0 } else { exit 1 }"
if errorlevel 1 (
  echo        [!] 端口 %PROXY_PORT% 未监听。请先启动 Clash/Mihomo，或改 config.json 的 proxy.port。
) else (
  echo        [OK] 代理端口可用。
)

echo.
rem ---------- 2. 开启系统代理（窗口连本地语言服务器需要） ----------
echo [2/4] 开启系统代理 ...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "%PROXY_HOST%:%PROXY_PORT%" /f >nul 2>&1
echo        [OK] 系统代理已开启: %PROXY_HOST%:%PROXY_PORT%

echo.
rem ---------- 3. 注入代理到安装目录 ----------
echo [3/4] 注入代理到 Antigravity 安装目录 ...
set "FOUND="
for %%D in ("%LOCALAPPDATA%\Programs\antigravity" "%LOCALAPPDATA%\Programs\Antigravity IDE" "%LOCALAPPDATA%\Programs\Antigravity") do (
  if exist "%%~D\Antigravity.exe" (
    copy /y "%~dp0version.dll" "%%~D\version.dll" >nul
    copy /y "%~dp0config.json" "%%~D\config.json" >nul
    echo        [OK] 注入: %%~D
    set "FOUND=1"
  )
  if exist "%%~D\Antigravity IDE.exe" (
    copy /y "%~dp0version.dll" "%%~D\version.dll" >nul
    copy /y "%~dp0config.json" "%%~D\config.json" >nul
    echo        [OK] 注入: %%~D
    set "FOUND=1"
  )
)
if not defined FOUND echo        [!] 未找到 Antigravity 安装目录，请手动复制 version.dll + config.json。

echo.
rem ---------- 3.5 修复 IDE 遥测钩子（否则 Agent 用工具会报错） ----------
set "TELE=%USERPROFILE%\.gemini\config\plugins\googlecloudtools.datacloud_telemetry\hooks.json"
if exist "%TELE%" (
  findstr /c:"\"enabled\": true," "%TELE%" >nul 2>&1
  if not errorlevel 1 (
    powershell -NoProfile -Command "(Get-Content '%TELE%' -Raw) -replace '\"enabled\": true,', '\"enabled\": false,' | Set-Content '%TELE%' -NoNewline"
    echo        [OK] 已禁用 Antigravity IDE 的坏遥测钩子(googlecloudtools.datacloud_telemetry)
  ) else (
    echo        [OK] 遥测钩子已是禁用状态
  )
)

echo.
rem ---------- 4. 汉化（可选，需要 Node.js >= 16 + git） ----------
echo [4/4] 汉化中文界面 ...
where node >nul 2>&1
if errorlevel 1 (
  echo        [跳过] 未检测到 Node.js，跳过汉化（登录修复已生效）。
  goto :done
)
echo        正在关闭 Antigravity 以释放文件锁 ...
taskkill /F /IM "Antigravity.exe" >nul 2>&1
taskkill /F /IM "Antigravity IDE.exe" >nul 2>&1
set "CN_DIR=%~dp0antigravity-chinese"
if not exist "%CN_DIR%\cli.js" (
  echo        正在下载 antigravity-chinese（首次较慢，需联网）...
  git clone --depth 1 https://github.com/yiheng8023/antigravity-chinese.git "%CN_DIR%" >nul 2>&1
  if errorlevel 1 echo        [跳过] 下载失败，请检查网络/代理。
)
if exist "%CN_DIR%\cli.js" (
  pushd "%CN_DIR%" >nul
  echo        正在应用汉化补丁 ...
  node cli.js install --with-plugin
  popd >nul
)

:done
echo.
echo ==========================================================
echo   完成！请重新打开 Antigravity / Antigravity IDE：
echo     - 登录正常、启动 Agent、中文界面
echo     - 代理节点请用「美国/支持地区 + 普通住宅 IP」（数据中心 IP 会被 Google 拒）
echo   还原英文/移除代理：运行 uninstall.bat
echo ==========================================================
echo.
pause
