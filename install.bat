@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title Antigravity CN 登录修复 + 汉化（No-TUN 一步到位）

echo ==========================================================
echo   Antigravity CN：登录修复 + 汉化（不开 TUN/Proxifier）
echo ==========================================================
echo.

set "PROXY_HOST=127.0.0.1"
set "PROXY_PORT=7897"

rem ---------- 1. 检查本地代理端口 ----------
echo [1/3] 检查本地代理 %PROXY_HOST%:%PROXY_PORT% ...
powershell -NoProfile -Command "if (Test-NetConnection -ComputerName '%PROXY_HOST%' -Port %PROXY_PORT% -WarningAction SilentlyContinue).TcpTestSucceeded { exit 0 } else { exit 1 }"
if errorlevel 1 (
  echo        [!] 端口 %PROXY_PORT% 未监听，请先启动 Clash/Mihomo，或修改 config.json 里的 proxy.port。
) else (
  echo        [OK] 代理端口可用。
)

echo.
rem ---------- 2. 注入代理（解决登录 / Agent 连不上） ----------
echo [2/3] 注入代理到 Antigravity 安装目录 ...
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
if not defined FOUND (
  echo        [错误] 未找到 Antigravity 安装目录，请手动复制 version.dll + config.json。
)

echo.
rem ---------- 3. 汉化（可选，需要 Node.js >= 16 + git） ----------
echo [3/3] 汉化中文界面 ...
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
echo   完成！请重新打开 Antigravity：登录正常、启动 Agent、中文界面。
echo   还原英文/移除代理：运行 uninstall.bat
echo ==========================================================
echo.
pause
