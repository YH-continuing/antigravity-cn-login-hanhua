@echo off
chcp 65001 >nul
setlocal
title Antigravity 中文 No-TUN 方案 - 卸载

echo ==========================================================
echo   Antigravity No-TUN 代理方案 - 卸载（还原纯净官方状态）
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
if not defined FOUND (
  echo [提示] 未找到已安装的代理文件，无需卸载。
) else (
  echo [完成] 已移除代理注入。请完全退出并重新启动 Antigravity。
)

echo.
pause
