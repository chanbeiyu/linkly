@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "pm2_process_name=bmm"
:: 获取脚本所在目录
set "workdir=%~dp0"
cd /d "%workdir%"

echo 当前目录pwd: %cd%
echo.
echo 🔄 开始更新代码
git reset --hard
git pull
git reset --hard

echo.
echo 📦 安装依赖：
pnpm i

echo.
echo 🔨 构建应用：
pnpm build

echo.
echo 文件夹大小：
powershell -Command "Get-ChildItem . | Measure-Object -Property Length -Sum; Write-Host ('总大小: ' + ('{0:N2}' -f ($sum.Sum / 1MB)) + ' MB')"

echo.
echo 🚀 启动服务：
pm2 delete %pm2_process_name%
pm2 start "pnpm start" --name %pm2_process_name%

pause
endlocal