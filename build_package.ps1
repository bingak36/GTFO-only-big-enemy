# 1. icon.png 생성
Write-Host "=== icon.png 생성 중 ===" -ForegroundColor Cyan
& "$PSScriptRoot\make_icon.ps1"

# 2. DLL 빌드
Write-Host "`n=== DLL 빌드 중 ===" -ForegroundColor Cyan
Push-Location $PSScriptRoot
dotnet build -c Release
if ($LASTEXITCODE -ne 0) {
    Write-Host "빌드 실패!" -ForegroundColor Red
    exit 1
}
Pop-Location

# 빌드된 DLL 찾기
$dll = Get-ChildItem -Path $PSScriptRoot -Recurse -Filter "BigEnemyMode.dll" |
       Where-Object { $_.FullName -match "Release" } |
       Select-Object -First 1

if (-not $dll) {
    # Release 없으면 아무 DLL이나
    $dll = Get-ChildItem -Path $PSScriptRoot -Recurse -Filter "BigEnemyMode.dll" |
           Select-Object -First 1
}

if (-not $dll) {
    Write-Host "BigEnemyMode.dll을 찾을 수 없습니다." -ForegroundColor Red
    exit 1
}

Write-Host "DLL 경로: $($dll.FullName)" -ForegroundColor Green

# 3. 패키지 폴더 구성
Write-Host "`n=== 패키지 구성 중 ===" -ForegroundColor Cyan
$pkgDir = Join-Path $PSScriptRoot "package_temp"
$pluginDir = Join-Path $pkgDir "BepInEx\plugins"

if (Test-Path $pkgDir) { Remove-Item $pkgDir -Recurse -Force }
New-Item -ItemType Directory -Path $pluginDir -Force | Out-Null

Copy-Item $dll.FullName -Destination $pluginDir
Copy-Item (Join-Path $PSScriptRoot "manifest.json") -Destination $pkgDir
Copy-Item (Join-Path $PSScriptRoot "README.md") -Destination $pkgDir
Copy-Item (Join-Path $PSScriptRoot "icon.png") -Destination $pkgDir

# 4. zip 생성
Write-Host "`n=== zip 패키지 생성 중 ===" -ForegroundColor Cyan
$zipPath = Join-Path $PSScriptRoot "BigEnemyMode.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path "$pkgDir\*" -DestinationPath $zipPath
Remove-Item $pkgDir -Recurse -Force

Write-Host "`n완료! 파일 위치: $zipPath" -ForegroundColor Green
Write-Host "r2modman -> Settings -> Import local mod 에서 이 zip을 선택하세요." -ForegroundColor Yellow
