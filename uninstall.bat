@echo off
chcp 65001 >nul
setlocal
title Antigravity CN No-TUN 方案 - 卸载

echo ==========================================================
echo   Antigravity No-TUN 方案 - 卸载（还原官方纯净状态）
echo ==========================================================
echo.

set "FOUND="
for %%D in ("%LOCALAPPDATA%\Programs\antigravity" "%LOCALAPPDATA%\Programs\Antigravity IDE" "%LOCALAPPDATA%\Programs\Antigravity") do (
  if exist "%%~D\version.dll" (
    del /f /q "%%~D\version.dll" >nul 2>&1
    del /f /q "%%~D\config.json" >nul 2>&1
    echo [OK] 已移除: %%~D
    set "FOUND=1"
  )
)

echo.
rem 关闭系统代理（还原网络）
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] 已关闭系统代理。

echo.
if not defined FOUND (
  echo [提示] 未找到已安装的代理文件（可能已卸载）。
) else (
  echo [完成] 已移除代理注入并关闭系统代理。请完全退出并重新启动 Antigravity。
)

echo.
pause
