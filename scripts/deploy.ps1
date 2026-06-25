# 编码设置
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$pm2_process_name = "linkly"

# 获取脚本所在目录
$workdir = $PSScriptRoot
Set-Location $workdir

Write-Host "当前目录pwd: $(Get-Location)"
Write-Host "`n🔄 开始更新代码"

git reset --hard
git pull
git reset --hard

Write-Host "`n📦 安装依赖："
pnpm i

Write-Host "`n🔨 构建应用："
pnpm build

Write-Host "`n文件夹大小："
$totalSize = (Get-ChildItem -Recurse | Measure-Object -Property Length -Sum).Sum
$sizeMB = [math]::Round($totalSize / 1MB, 2)
Write-Host "总目录大小：$sizeMB MB"

Write-Host "`n🚀 启动服务："
pm2 delete $pm2_process_name
pm2 start "pnpm start" --name $pm2_process_name