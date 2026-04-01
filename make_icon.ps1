Add-Type -AssemblyName System.Drawing

$bmp = New-Object System.Drawing.Bitmap 256, 256
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

# Background
$bgBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 26, 26, 46))
$g.FillRectangle($bgBrush, 0, 0, 256, 256)

# Border
$borderPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 255, 51, 0)), 4
$g.DrawRectangle($borderPen, 2, 2, 252, 252)

# Body
$bodyBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 45, 45, 45))
$g.FillEllipse($bodyBrush, 73, 65, 110, 130)

# Head
$headBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 58, 58, 58))
$g.FillEllipse($headBrush, 90, 37, 76, 76)

# Eyes (glow)
$eyeBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 51, 0))
$g.FillEllipse($eyeBrush, 104, 58, 20, 20)
$g.FillEllipse($eyeBrush, 132, 58, 20, 20)
$whiteBrush = [System.Drawing.Brushes]::White
$g.FillEllipse($whiteBrush, 111, 65, 6, 6)
$g.FillEllipse($whiteBrush, 139, 65, 6, 6)

# Arms
$g.FillRectangle($bodyBrush, 48, 80, 28, 80)
$g.FillRectangle($bodyBrush, 180, 80, 28, 80)

# Legs
$g.FillRectangle($bodyBrush, 95, 183, 24, 45)
$g.FillRectangle($bodyBrush, 137, 183, 24, 45)

# BIG text
$font = New-Object System.Drawing.Font("Arial Black", 22, [System.Drawing.FontStyle]::Bold)
$textBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 51, 0))
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center
$g.DrawString("BIG", $font, $textBrush, 128, 228, $sf)

$g.Dispose()
$outPath = Join-Path $PSScriptRoot "icon.png"
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "icon.png saved to $outPath"
