Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

function New-ZipWithForwardSlashes($sourceDir, $zipPath) {
    if (Test-Path -LiteralPath $zipPath) { Remove-Item -LiteralPath $zipPath -Force }
    $zipStream = [System.IO.File]::Open($zipPath, [System.IO.FileMode]::Create)
    $archive = New-Object System.IO.Compression.ZipArchive($zipStream, [System.IO.Compression.ZipArchiveMode]::Create)
    
    $sourceDirClean = $sourceDir.TrimEnd('\', '/')
    $files = Get-ChildItem -LiteralPath $sourceDirClean -Recurse -File
    foreach ($file in $files) {
        $relPath = $file.FullName.Substring($sourceDirClean.Length).TrimStart('\', '/')
        $entryName = $relPath.Replace('\', '/')
        $entry = $archive.CreateEntry($entryName, [System.IO.Compression.CompressionLevel]::Optimal)
        $entryStream = $entry.Open()
        $fileStream = [System.IO.File]::OpenRead($file.FullName)
        $fileStream.CopyTo($entryStream)
        $fileStream.Dispose()
        $entryStream.Dispose()
    }
    $archive.Dispose()
    $zipStream.Dispose()
}

$jsonContent = Get-Content "d:\Proyectos\Plantas\plantas_metadata.json" -Raw -Encoding UTF8
$plants = $jsonContent | ConvertFrom-Json

# Base XML de Word extraído del template del usuario
$baseXml = Get-Content "d:\Proyectos\Plantas\docx_extracted\word\document.xml" -Raw -Encoding UTF8

foreach ($p in $plants) {
    Write-Host "-> Reempaquetando DOCX oficial con forward-slashes para: $($p.nombreComun)"
    $tempDir = "$env:TEMP\docx_clean_$($p.id)"
    if (Test-Path -LiteralPath $tempDir) { Remove-Item -LiteralPath $tempDir -Recurse -Force }
    Copy-Item -LiteralPath "d:\Proyectos\Plantas\docx_extracted" -Destination $tempDir -Recurse

    # 1. Foto recortada e insertada como image2.png
    $fotoSrcPath = "d:\Proyectos\Plantas\$($p.foto)"
    if (Test-Path -LiteralPath $fotoSrcPath) {
        $srcImg = [System.Drawing.Image]::FromFile($fotoSrcPath)
        $targetWidth = 1191
        $targetHeight = 855
        $bmp = New-Object System.Drawing.Bitmap($targetWidth, $targetHeight)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

        $srcRatio = $srcImg.Width / $srcImg.Height
        $targetRatio = $targetWidth / $targetHeight
        if ($srcRatio -gt $targetRatio) {
            $cropW = [int]($srcImg.Height * $targetRatio)
            $cropH = $srcImg.Height
            $cropX = [int](($srcImg.Width - $cropW) / 2)
            $cropY = 0
        } else {
            $cropW = $srcImg.Width
            $cropH = [int]($srcImg.Width / $targetRatio)
            $cropX = 0
            $cropY = [int](($srcImg.Height - $cropH) / 2)
        }

        $srcRect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
        $destRect = New-Object System.Drawing.Rectangle(0, 0, $targetWidth, $targetHeight)
        $g.DrawImage($srcImg, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)

        $destPng = "$tempDir\word\media\image2.png"
        if (Test-Path -LiteralPath $destPng) { Remove-Item -LiteralPath $destPng -Force }
        $bmp.Save($destPng, [System.Drawing.Imaging.ImageFormat]::Png)

        $g.Dispose()
        $bmp.Dispose()
        $srcImg.Dispose()
    }

    # 2. Textos en document.xml
    $xml = $baseXml
    $xml = $xml -replace '<w:t>EPAZOTE</w:t>', "<w:t>$($p.nombreComun)</w:t>"
    $xml = $xml -replace 'Dysphania ambrosioides', "$($p.nombreCientifico)"
    $xml = $xml -replace '<w:t>Infusión digestiva y antiflatulenta</w:t>', "<w:t>$($p.remedioTitulo)</w:t>"
    $xml = $xml -replace '<w:t>Uso oral tradicional</w:t>', "<w:t>$($p.remedioTipo)</w:t>"
    $xml = $xml -replace 'En la medicina tradicional se menciona el uso de las hojas de epazote, preparadas en infusión suave, para aliviar cólicos estomacales, indigestión, gases y ayudar a combatir parásitos intestinales\.', "$($p.remedioDesc)"
    $xml = $xml -replace '<w:t>1\. Cosechar:</w:t>', "<w:t>$($p.prep1Titulo)</w:t>"
    $xml = $xml -replace 'Cortar de 3 a 5 hojas frescas del huerto y lavarlas bien con agua limpia\.', "$($p.prep1Desc.Trim())"
    $xml = $xml -replace '<w:t>2\. Hervir:</w:t>', "<w:t>$($p.prep2Titulo)</w:t>"
    $xml = $xml -replace 'Poner a calentar una taza de agua potable y retirar al primer hervor\.', "$($p.prep2Desc.Trim())"
    $xml = $xml -replace '<w:t>3\. Reposar:</w:t>', "<w:t>$($p.prep3Titulo)</w:t>"
    $xml = $xml -replace 'Agregar las hojas, tapar de 3 a 5 minutos, colar y beber tibio con moderación\.', "$($p.prep3Desc.Trim())"
    $xml = $xml -replace 'Contiene ascaridol\. No consumir en exceso ni de forma prolongada\. Contraindicado en mujeres embarazadas, en lactancia y en niños pequeños\.', "$($p.precaucion)"

    [System.IO.File]::WriteAllText("$tempDir\word\document.xml", $xml, [System.Text.Encoding]::UTF8)

    # 3. Empaquetar
    $outDocx = "d:\Proyectos\Plantas\ficha_oficial_$($p.id).docx"
    New-ZipWithForwardSlashes $tempDir $outDocx
    Remove-Item -LiteralPath $tempDir -Recurse -Force
    Write-Host "   OK: $outDocx"
}

# También asegurar que ficha_oficial_epazote.docx esté perfectamente empaquetada
$tempDirEpazote = "$env:TEMP\docx_clean_epazote"
if (Test-Path -LiteralPath $tempDirEpazote) { Remove-Item -LiteralPath $tempDirEpazote -Recurse -Force }
Copy-Item -LiteralPath "d:\Proyectos\Plantas\docx_extracted" -Destination $tempDirEpazote -Recurse
New-ZipWithForwardSlashes $tempDirEpazote "d:\Proyectos\Plantas\ficha_oficial_epazote.docx"
Remove-Item -LiteralPath $tempDirEpazote -Recurse -Force
Write-Host "-> Reempaquetado epazote oficial: d:\Proyectos\Plantas\ficha_oficial_epazote.docx"
