# BigEnemyMode - Thunderstore/R2modman 패키지 빌드 스크립트
# 사용법: PowerShell에서 ./pack.ps1 실행

$ModName = "BigEnemyMode"
$OutDir  = ".\dist"
$ZipPath = "$OutDir\$ModName.zip"
$ScriptDir = $PSScriptRoot

Write-Host "=== $ModName 빌드 시작 ===" -ForegroundColor Cyan

# ─── [1/4] 아이콘 자동 생성 ────────────────────────────────────────────────
Write-Host "[1/4] icon.png 생성..." -ForegroundColor Yellow

Add-Type -AssemblyName System.Drawing

$bmp = New-Object System.Drawing.Bitmap(256, 256)
$g   = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

# 배경 그라디언트 (위=어두운 검정-빨강, 아래=짙은 빨강)
$gradBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    [System.Drawing.Point]::new(0,   0),
    [System.Drawing.Point]::new(0, 256),
    [System.Drawing.Color]::FromArgb(255, 18,  5,  5),
    [System.Drawing.Color]::FromArgb(255, 45, 10, 10)
)
$g.FillRectangle($gradBrush, 0, 0, 256, 256)

# 테두리
$borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 160, 30, 30), 5)
$g.DrawRectangle($borderPen, 3, 3, 249, 249)
$innerPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(80, 220, 60, 60), 2)
$g.DrawRectangle($innerPen, 8, 8, 239, 239)

# 몸통 (빅 적 실루엣)
$bodyPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$bodyPath.AddEllipse(54, 72, 148, 110)
$bodyBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    [System.Drawing.Point]::new(128, 72),
    [System.Drawing.Point]::new(128, 182),
    [System.Drawing.Color]::FromArgb(255, 200, 50, 50),
    [System.Drawing.Color]::FromArgb(255, 110, 20, 20)
)
$g.FillPath($bodyBrush, $bodyPath)

# 뿔 (왼쪽)
$hornL = New-Object System.Drawing.Drawing2D.GraphicsPath
[void]$hornL.AddPolygon(@(
    [System.Drawing.Point]::new(90,  72),
    [System.Drawing.Point]::new(82,  42),
    [System.Drawing.Point]::new(108, 68)
))
$hornBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 170, 35, 35))
$g.FillPath($hornBrush, $hornL)

# 뿔 (오른쪽)
$hornR = New-Object System.Drawing.Drawing2D.GraphicsPath
[void]$hornR.AddPolygon(@(
    [System.Drawing.Point]::new(166, 72),
    [System.Drawing.Point]::new(174, 42),
    [System.Drawing.Point]::new(148, 68)
))
$g.FillPath($hornBrush, $hornR)

# 눈 광채 (노란 빛남) - PathGradientBrush 사용
$glowPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$glowPath.AddEllipse(82, 86, 50, 44)
$glowBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($glowPath)
$glowBrush.CenterColor = [System.Drawing.Color]::FromArgb(200, 255, 240, 80)
$glowBrush.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 255, 200, 0))
$g.FillEllipse($glowBrush, 82, 86, 50, 44)

$glowPath2 = New-Object System.Drawing.Drawing2D.GraphicsPath
$glowPath2.AddEllipse(124, 86, 50, 44)
$glowBrush2 = New-Object System.Drawing.Drawing2D.PathGradientBrush($glowPath2)
$glowBrush2.CenterColor = [System.Drawing.Color]::FromArgb(200, 255, 240, 80)
$glowBrush2.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 255, 200, 0))
$g.FillEllipse($glowBrush2, 124, 86, 50, 44)

# 눈 본체 (노란색)
$eyeYellow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 215, 0))
$g.FillEllipse($eyeYellow, 92, 94, 30, 26)
$g.FillEllipse($eyeYellow, 134, 94, 30, 26)

# 동공 (검정)
$pupilBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 8, 8, 8))
$g.FillEllipse($pupilBrush, 101, 100, 14, 16)
$g.FillEllipse($pupilBrush, 143, 100, 14, 16)

# 눈 반짝임
$shineBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 255, 255, 255))
$g.FillEllipse($shineBrush, 97, 97, 7, 7)
$g.FillEllipse($shineBrush, 139, 97, 7, 7)

# 입 (이빨)
$mouthBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 15, 5, 5))
$g.FillRectangle($mouthBrush, 90, 144, 76, 18)
$toothBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 230, 230, 220))
foreach ($tx in @(93, 107, 121, 135, 149)) {
    $g.FillRectangle($toothBrush, $tx, 144, 10, 14)
}

# 텍스트 'BIG' (그림자 + 본체)
$font1 = New-Object System.Drawing.Font("Impact", 42, [System.Drawing.FontStyle]::Bold)
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center

$shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 80, 0, 0))
$g.DrawString("BIG", $font1, $shadowBrush, [System.Drawing.RectangleF]::new(2, 183, 256, 55), $sf)
$g.DrawString("BIG", $font1, $shadowBrush, [System.Drawing.RectangleF]::new(-2, 183, 256, 55), $sf)

$whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
$g.DrawString("BIG", $font1, $whiteBrush, [System.Drawing.RectangleF]::new(0, 181, 256, 55), $sf)

# 텍스트 'ENEMY MODE'
$font2 = New-Object System.Drawing.Font("Arial", 15, [System.Drawing.FontStyle]::Bold)
$grayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 200, 150, 150))
$g.DrawString("ENEMY MODE", $font2, $shadowBrush, [System.Drawing.RectangleF]::new(1, 224, 256, 28), $sf)
$g.DrawString("ENEMY MODE", $font2, $grayBrush, [System.Drawing.RectangleF]::new(0, 222, 256, 28), $sf)

$g.Dispose()
$iconPath = Join-Path $ScriptDir "icon.png"
$bmp.Save($iconPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "  icon.png 생성됨: $iconPath" -ForegroundColor Green

# ─── [2/4] 게임 DLL 참조 자동 생성 ───────────────────────────────────────
Write-Host "[2/4] 게임 DLL 참조 생성..." -ForegroundColor Yellow

$InteropPath = "C:\Users\qlsl9042\AppData\Roaming\r2modmanPlus-local\GTFO\profiles\vanilla\BepInEx\interop"
$CorePath    = "C:\Users\qlsl9042\AppData\Roaming\r2modmanPlus-local\GTFO\profiles\vanilla\BepInEx\core"

$refs = '<Project><ItemGroup>' + "`n"

# interop 폴더 전체 DLL 참조 (GameDataManager가 어느 DLL에 있든 자동 포함)
Get-ChildItem "$InteropPath\*.dll" | ForEach-Object {
    try {
        $asmName = [System.Reflection.Assembly]::LoadFile($_.FullName).GetName().Name
        $refs += "  <Reference Include=`"$asmName`">`n"
        $refs += "    <HintPath>$($_.FullName)</HintPath>`n"
        $refs += "    <Private>false</Private>`n"
        $refs += "  </Reference>`n"
    } catch {
        Write-Host "  건너뜀 (로드 불가): $($_.Name)" -ForegroundColor DarkGray
    }
}

# Il2CppInterop.Runtime (core 폴더)
$refs += "  <Reference Include=`"Il2CppInterop.Runtime`">`n"
$refs += "    <HintPath>$CorePath\Il2CppInterop.Runtime.dll</HintPath>`n"
$refs += "    <Private>false</Private>`n"
$refs += "  </Reference>`n"

$refs += '</ItemGroup></Project>'

$propsPath = Join-Path $ScriptDir "GameReferences.props"
$refs | Out-File -FilePath $propsPath -Encoding utf8
Write-Host "  GameReferences.props 생성됨 ($(((Get-Content $propsPath) -match '<Reference').Count)개 DLL 참조)" -ForegroundColor Green

# EnemyPopulationDataBlock 실제 멤버 탐색
Write-Host "  EnemyPopulationDataBlock 멤버 탐색 중..." -ForegroundColor Yellow
$targetTypes = @("EnemyPopulationDataBlock", "EnemyDataBlock", "GameDataBlockBase")
$foundMembers = @{}

Get-ChildItem "$InteropPath\*.dll" | ForEach-Object {
    try {
        $stream = [System.IO.File]::OpenRead($_.FullName)
        $peReader = [System.Reflection.PortableExecutable.PEReader]::new($stream)
        if (-not $peReader.HasMetadata) { $peReader.Dispose(); $stream.Dispose(); return }
        $mr = $peReader.GetMetadataReader()

        foreach ($tdh in $mr.TypeDefinitions) {
            $td = $mr.GetTypeDefinition($tdh)
            $typeName = $mr.GetString($td.Name)
            if ($typeName -notin $targetTypes) { continue }

            $members = @()
            foreach ($fh in $td.GetFields()) {
                $members += "F:" + $mr.GetString($mr.GetFieldDefinition($fh).Name)
            }
            foreach ($ph in $td.GetProperties()) {
                $members += "P:" + $mr.GetString($mr.GetPropertyDefinition($ph).Name)
            }
            foreach ($mh in $td.GetMethods()) {
                $mname = $mr.GetString($mr.GetMethodDefinition($mh).Name)
                if ($mname -match '^get_') { $members += "G:" + $mname.Substring(4) }
            }
            $members = $members | Where-Object { $_ -ne "F:" -and $_ -ne "P:" -and $_ -ne "G:" } | Sort-Object -Unique
            $foundMembers[$typeName] = $members
        }
        $peReader.Dispose(); $stream.Dispose()
    } catch { }
}

# population 관련 멤버 자동 수정
if ($foundMembers.ContainsKey("EnemyPopulationDataBlock") -and $foundMembers["EnemyPopulationDataBlock"].Count -gt 0) {
    Write-Host "  EnemyPopulationDataBlock 멤버: $($foundMembers['EnemyPopulationDataBlock'] -join ', ')" -ForegroundColor DarkCyan
    $popMember = $foundMembers["EnemyPopulationDataBlock"] | Where-Object { $_ -match "opulation|ntrie|eight|pawn" } | Select-Object -First 1
    if ($popMember) {
        $popName = $popMember -replace "^[FPG]:", ""
        Write-Host "  population 멤버: $popName" -ForegroundColor Green
        $patchFile = Join-Path $ScriptDir "Patches\EnemyPopulationPatch.cs"
        $content = Get-Content $patchFile -Raw
        $content = $content -replace '\.m_population', ".$popName"
        $content | Out-File -FilePath $patchFile -Encoding utf8 -NoNewline
        Write-Host "  EnemyPopulationPatch.cs 수정됨 (m_population → $popName)" -ForegroundColor Green
    }
} else {
    Write-Host "  EnemyPopulationDataBlock 멤버를 찾지 못했습니다 (컴파일러에 맡김)" -ForegroundColor Yellow
}


# ─── [3/4] dotnet 빌드 ────────────────────────────────────────────────────
Write-Host "[3/4] dotnet build..." -ForegroundColor Yellow

# obj 캐시 초기화 후 빌드
dotnet clean (Join-Path $ScriptDir "BigEnemyMode.csproj") -c Release | Out-Null
dotnet build -c Release (Join-Path $ScriptDir "BigEnemyMode.csproj")
if ($LASTEXITCODE -ne 0) {
    Write-Host "빌드 실패!" -ForegroundColor Red
    exit 1
}

# ─── [4/4] dist 폴더 준비 및 파일 복사 ────────────────────────────────────
Write-Host "[4/4] 파일 복사..." -ForegroundColor Yellow

$DistDir     = Join-Path $ScriptDir "dist"
$PluginDir   = Join-Path $DistDir "BepInEx\plugins\$ModName"

if (Test-Path $DistDir) { Remove-Item $DistDir -Recurse -Force }
New-Item -ItemType Directory -Path $PluginDir | Out-Null

# DLL 탐색 (bin\Release 폴더만, obj의 참조 어셈블리 제외)
$BinRelease = Join-Path $ScriptDir "bin\Release"
$DllSrc = Get-ChildItem -Path $BinRelease -Recurse -Filter "$ModName.dll" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if ($null -eq $DllSrc) {
    Write-Host "DLL을 찾을 수 없습니다." -ForegroundColor Red
    exit 1
}

Copy-Item $DllSrc.FullName (Join-Path $PluginDir "$ModName.dll")
Copy-Item (Join-Path $ScriptDir "manifest.json") (Join-Path $DistDir "manifest.json")
Copy-Item (Join-Path $ScriptDir "README.md")     (Join-Path $DistDir "README.md")
Copy-Item (Join-Path $ScriptDir "icon.png")      (Join-Path $DistDir "icon.png")

# ─── [4/4] ZIP 압축 ────────────────────────────────────────────────────────
Write-Host "[5/5] ZIP 생성..." -ForegroundColor Yellow
$ZipFull = Join-Path $ScriptDir "dist\$ModName.zip"
Compress-Archive -Path "$DistDir\*" -DestinationPath $ZipFull -Force

Write-Host ""
Write-Host "=== 완료! ===" -ForegroundColor Green
Write-Host "패키지: $ZipFull" -ForegroundColor Green
Write-Host ""
Write-Host "R2modman 로컬 설치:" -ForegroundColor Cyan
Write-Host "  Settings > Import local mod > dist\$ModName.zip 선택"
