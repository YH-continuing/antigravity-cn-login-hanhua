@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title Antigravity 中文 No-TUN 一键安装

echo ==========================================================
echo   Antigravity 中国大陆 No-TUN 代理方案 - 一键安装
echo ==========================================================
echo.

rem 检查本地代理端口是否可用
set "PROXY_HOST=127.0.0.1"
set "PROXY_PORT=7897"
echo [检查] 本地代理 %PROXY_HOST%:%PROXY_PORT% ...
powershell -NoProfile -Command "if (Test-NetConnection -ComputerName '%PROXY_HOST%' -Port %PROXY_PORT% -WarningAction SilentlyContinue).TcpTestSucceeded { exit 0 } else { exit 1 }"
if errorlevel 1 (
  echo [警告] 端口 %PROXY_PORT% 似乎未监听，请确认您的 Clash/Mihomo 代理已开启，或修改 config.json 里的 proxy.port。
) else (
  echo [OK] 代理端口可用。
)

echo.
set "FOUND="
for %%D in ("%LOCALAPPDATA%\Programs\antigravity" "%LOCALAPPDATA%\Programs\Antigravity IDE" "%LOCALAPPDATA%\Programs\Antigravity") do (
  if exist "%%~D\Antigravity.exe" (
    copy /y "%~dp0version.dll" "%%~D\version.dll" >nul
    copy /y "%~dp0config.json" "%%~D\config.json" >nul
    echo [OK] 已写入: %%~D
    set "FOUND=1"
  )
  if exist "%%~D\Antigravity IDE.exe" (
    copy /y "%~dp0version.dll" "%%~D\version.dll" >nul
    copy /y "%~dp0config.json" "%%~D\config.json" >nul
    echo [OK] 已写入: %%~D
    set "FOUND=1"
  )
)

echo.
if not defined FOUND (
  echo [错误] 未找到 Antigravity 安装目录。
  echo 请确认已安装 Antigravity，或手动把 version.dll 和 config.json 放到
  echo   Antigravity.exe / Antigravity IDE.exe 所在目录。
) else (
  echo [完成] 代理注入就绪。请完全退出并重新启动 Antigravity 即可。
)

echo.
pause
