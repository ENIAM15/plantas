Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem

$jsonContent = Get-Content "d:\Proyectos\Plantas\plantas_metadata.json" -Raw -Encoding UTF8
$plants = $jsonContent | ConvertFrom-Json

# Template base de document.xml con marcadores claros
$baseXml = Get-Content "d:\Proyectos\Plantas\docx_extracted\word\document.xml" -Raw -Encoding UTF8

foreach ($p in $plants) {
    Write-Host "=========================================="
    Write-Host "PROCESANDO PLANTA: $($p.nombreComun) ($($p.id))"
    Write-Host "=========================================="

    $tempDir = "$env:TEMP\docx_build_$($p.id)"
    if (Test-Path $tempDir) { Remove-Item -Recurse -Force $tempDir }
    
    # 1. Copiar estructura base
    Copy-Item -Recurse "d:\Proyectos\Plantas\docx_extracted" $tempDir

    # 2. Reemplazar imagen de la planta (image2.png)
    $fotoSrcPath = "d:\Proyectos\Plantas\$($p.foto)"
    if (Test-Path $fotoSrcPath) {
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
        if (Test-Path $destPng) { Remove-Item -Force $destPng }
        $bmp.Save($destPng, [System.Drawing.Imaging.ImageFormat]::Png)

        $g.Dispose()
        $bmp.Dispose()
        $srcImg.Dispose()
        Write-Host "-> Foto procesada correctamente para $($p.id)"
    }

    # 3. Reemplazar textos en document.xml
    $xml = $baseXml
    
    # Nombre y científico
    $xml = $xml -replace '<w:t>EPAZOTE</w:t>', "<w:t>$($p.nombreComun)</w:t>"
    $xml = $xml -replace 'Dysphania ambrosioides', "$($p.nombreCientifico)"
    
    # Remedio título y subtítulo
    $xml = $xml -replace '<w:t>Infusión digestiva y antiflatulenta</w:t>', "<w:t>$($p.remedioTitulo)</w:t>"
    $xml = $xml -replace '<w:t>Uso oral tradicional</w:t>', "<w:t>$($p.remedioTipo)</w:t>"

    # Descripción
    $xml = $xml -replace 'En la medicina tradicional se menciona el uso de las hojas de epazote, preparadas en infusión suave, para aliviar cólicos estomacales, indigestión, gases y ayudar a combatir parásitos intestinales\.', "$($p.remedioDesc)"

    # Pasos
    $xml = $xml -replace '<w:t>1\. Cosechar:</w:t>', "<w:t>$($p.prep1Titulo)</w:t>"
    $xml = $xml -replace 'Cortar de 3 a 5 hojas frescas del huerto y lavarlas bien con agua limpia\.', "$($p.prep1Desc.Trim())"

    $xml = $xml -replace '<w:t>2\. Hervir:</w:t>', "<w:t>$($p.prep2Titulo)</w:t>"
    $xml = $xml -replace 'Poner a calentar una taza de agua potable y retirar al primer hervor\.', "$($p.prep2Desc.Trim())"

    $xml = $xml -replace '<w:t>3\. Reposar:</w:t>', "<w:t>$($p.prep3Titulo)</w:t>"
    $xml = $xml -replace 'Agregar las hojas, tapar de 3 a 5 minutos, colar y beber tibio con moderación\.', "$($p.prep3Desc.Trim())"

    # Precaución
    $xml = $xml -replace 'Contiene ascaridol\. No consumir en exceso ni de forma prolongada\. Contraindicado en mujeres embarazadas, en lactancia y en niños pequeños\.', "$($p.precaucion)"

    [System.IO.File]::WriteAllText("$tempDir\word\document.xml", $xml, [System.Text.Encoding]::UTF8)

    # 4. Empaquetar DOCX
    $outDocx = "d:\Proyectos\Plantas\ficha_oficial_$($p.id).docx"
    if (Test-Path $outDocx) { Remove-Item -Force $outDocx }
    [System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $outDocx)
    Write-Host "-> DOCX creado: $outDocx"

    # 5. Generar HTML fiel con los estilos exactos de Word
    $htmlContent = @"
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>EMSaD 52 - $($p.nombreComun) - Huerto Escolar</title>
  <style>
    :root {
      --color-green-dark: #174B38;
      --color-gold-light: #E7D7B2;
      --color-green-sub: #2D7654;
      --color-red-title: #B51F32;
      --color-red-text: #8D1725;
      --color-gray-footer: #64756B;
      --font-family: Georgia, 'Times New Roman', serif;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
    @page { size: 11in 17in; margin: 0; }
    html, body {
      width: 11in; height: 17in; margin: 0; padding: 0; overflow: hidden;
      background-color: #FFFFFF; font-family: var(--font-family); color: #000000;
    }
    .page-container {
      width: 11in; height: 17in; padding: 0.25in 0.38in 0.25in 0.38in;
      display: flex; flex-direction: column; justify-content: space-between; position: relative;
    }
    .logos-row { width: 9.95in; height: 1.885in; margin: 0 auto; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
    .logos-row img { width: 100%; height: 100%; object-fit: contain; display: block; }
    .banner-emsad { width: 10.24in; margin: 0 auto; background-color: var(--color-green-dark); color: #FFFFFF; text-align: center; padding: 10px 14px; border-radius: 4px; flex-shrink: 0; }
    .banner-school-title { font-size: 16pt; font-weight: bold; letter-spacing: 1.5px; color: #FFFFFF; line-height: 1.15; }
    .banner-project-sub { font-size: 13pt; font-weight: bold; letter-spacing: 1.5px; color: var(--color-gold-light); margin: 4px 0; line-height: 1.15; }
    .banner-motto { font-size: 20pt; font-weight: bold; letter-spacing: 1.5px; color: #FFFFFF; line-height: 1.15; }
    .tesoro-row { text-align: center; font-size: 18pt; font-weight: bold; color: var(--color-green-dark); letter-spacing: 2px; margin: 4px 0; flex-shrink: 0; }
    .photo-row { width: 9.95in; height: 4.45in; margin: 0 auto; border: 3px solid var(--color-green-dark); border-radius: 10px; overflow: hidden; flex-shrink: 0; }
    .photo-row img { width: 100%; height: 100%; object-fit: cover; object-position: center 30%; display: block; }
    .plant-bar { width: 10.01in; margin: 0 auto; background-color: var(--color-green-dark); color: #FFFFFF; text-align: center; padding: 10px 14px; border-radius: 6px; flex-shrink: 0; }
    .plant-name { font-size: 48pt; font-weight: bold; letter-spacing: 2px; line-height: 1.05; color: #FFFFFF; }
    .plant-sub { font-size: 18pt; margin-top: 4px; }
    .plant-sub span.latin { font-style: italic; color: var(--color-gold-light); }
    .plant-sub span.normal { color: #FFFFFF; }
    .table-cards-row { width: 10.0in; margin: 0 auto; display: grid; grid-template-columns: 6.05in 3.8in; gap: 0.15in; height: 4.8in; align-items: stretch; flex-shrink: 0; }
    .card-remedy { background-color: #FFFFFF; border: 1px solid #E2E8F0; border-radius: 12px; padding: 18px 22px; display: flex; flex-direction: column; justify-content: space-between; box-shadow: 0 2px 6px rgba(0,0,0,0.03); }
    .remedy-sec-title { font-size: 14pt; font-weight: bold; color: var(--color-green-dark); margin-bottom: 6px; }
    .remedy-name-title { font-size: 12pt; font-weight: bold; color: #000000; margin-bottom: 2px; }
    .remedy-type-sub { font-size: 12pt; font-style: italic; color: var(--color-green-sub); margin-bottom: 8px; }
    .remedy-desc-p { font-size: 12pt; line-height: 1.45; color: #000000; margin-bottom: 10px; text-align: justify; }
    .prep-heading { font-size: 12pt; font-weight: bold; color: var(--color-green-dark); margin-bottom: 6px; }
    .prep-steps { display: flex; flex-direction: column; gap: 5px; font-size: 12pt; line-height: 1.35; color: #000000; margin-bottom: 10px; }
    .prep-steps strong { color: var(--color-green-dark); }
    .caution-box-clean { border-left: 4px solid var(--color-red-title); background-color: #FFF5F5; padding: 8px 12px; border-radius: 0 6px 6px 0; }
    .caution-title-red { font-size: 12pt; font-weight: bold; color: var(--color-red-title); margin-bottom: 2px; }
    .caution-text-red { font-size: 9pt; line-height: 1.35; color: var(--color-red-text); }
    .card-explore { background-color: var(--color-green-dark); color: #FFFFFF; border-radius: 12px; padding: 18px 14px; display: flex; flex-direction: column; align-items: center; justify-content: space-between; text-align: center; box-shadow: 0 3px 10px rgba(23, 75, 56, 0.25); }
    .explore-title-white { font-size: 16pt; font-weight: bold; color: #FFFFFF; letter-spacing: 1.5px; }
    .explore-sub-gold { font-size: 12pt; font-style: italic; color: var(--color-gold-light); margin-top: 3px; }
    .qr-white-card { width: 2.1in; height: 2.1in; background-color: #FFFFFF; border-radius: 10px; border: 2px solid var(--color-gold-light); display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 10px; box-shadow: 0 2px 6px rgba(0,0,0,0.15); }
    .qr-inner-title { font-size: 10pt; font-weight: bold; color: var(--color-green-dark); text-align: center; line-height: 1.3; }
    .escanea-word { font-size: 14pt; font-weight: bold; color: #FFFFFF; letter-spacing: 1.5px; }
    .escanea-sub-gold { font-size: 10pt; color: var(--color-gold-light); margin-top: 2px; }
    .footer-section { text-align: center; margin-top: 6px; flex-shrink: 0; }
    .footer-main-text { font-size: 14pt; font-weight: bold; color: var(--color-green-dark); letter-spacing: 1px; }
    .footer-sub-text { font-size: 8pt; color: var(--color-gray-footer); margin-top: 2px; }
  </style>
</head>
<body>
  <div class="page-container">
    <header class="logos-row"><img src="logos_originales_2k.png" alt="Logotipos Oficiales"></header>
    <section class="banner-emsad">
      <div class="banner-school-title">EMSaD 52</div>
      <div class="banner-project-sub">PROYECTO ESCOLAR  •  BOTÁNICA Y SABERES TRADICIONALES</div>
      <div class="banner-motto">DEL HUERTO A LA RED: MEDICINA QUE SE CULTIVA</div>
    </section>
    <div class="tesoro-row">TESORO VIVO DE NUESTRA TIERRA</div>
    <div class="photo-row"><img src="$($p.foto)" alt="$($p.nombreComun)"></div>
    <div class="plant-bar">
      <div class="plant-name">$($p.nombreComun)</div>
      <div class="plant-sub">
        <span class="latin">$($p.nombreCientifico)</span>
        <span class="normal">  |  Planta de nuestra riqueza natural</span>
      </div>
    </div>
    <main class="table-cards-row">
      <article class="card-remedy">
        <div>
          <div class="remedy-sec-title">SABER TRADICIONAL</div>
          <div class="remedy-name-title">$($p.remedioTitulo)</div>
          <div class="remedy-type-sub">$($p.remedioTipo)</div>
          <p class="remedy-desc-p">$($p.remedioDesc)</p>
          <div class="prep-heading">¿Cómo se prepara?</div>
          <div class="prep-steps">
            <div><strong>$($p.prep1Titulo)</strong>$($p.prep1Desc)</div>
            <div><strong>$($p.prep2Titulo)</strong>$($p.prep2Desc)</div>
            <div><strong>$($p.prep3Titulo)</strong>$($p.prep3Desc)</div>
          </div>
        </div>
        <div class="caution-box-clean">
          <div class="caution-title-red">PRECAUCIÓN</div>
          <div class="caution-text-red">$($p.precaucion)</div>
        </div>
      </article>
      <aside class="card-explore">
        <div>
          <div class="explore-title-white">EXPLORA</div>
          <div class="explore-sub-gold">y descubre más</div>
        </div>
        <div class="qr-white-card">
          <img src="qr_sitio_emsad52.png" alt="Código QR EMSaD 52" style="width: 100%; height: 100%; object-fit: contain; display: block;">
        </div>
        <div>
          <div class="escanea-word">ESCANEA</div>
          <div class="escanea-sub-gold">para ver el proyecto completo</div>
        </div>
      </aside>
    </main>
    <footer class="footer-section">
      <div class="footer-main-text">EMSaD 52  •  DEL HUERTO A LA RED: MEDICINA QUE SE CULTIVA</div>
      <div class="footer-sub-text">Información sobre uso tradicional; no sustituye la valoración ni el tratamiento médico.</div>
    </footer>
  </div>
</body>
</html>
"@

    $htmlPath = "d:\Proyectos\Plantas\ficha_$($p.id).html"
    [System.IO.File]::WriteAllText($htmlPath, $htmlContent, [System.Text.Encoding]::UTF8)

    # 6. Compilar PDF con Edge headless
    $outPdf = "d:\Proyectos\Plantas\ficha_oficial_$($p.id).pdf"
    $edgeProfile = "$env:TEMP\edge_p_$($p.id)"
    Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList "--headless=new", "--user-data-dir=$edgeProfile", "--no-pdf-header-footer", "--print-to-pdf=`"$outPdf`"", "file:///$($htmlPath.Replace('\', '/'))" -Wait
    Remove-Item -Recurse -Force $edgeProfile -ErrorAction SilentlyContinue
    Write-Host "-> PDF creado: $outPdf"

    # 7. Generar captura PNG HD
    $outPng = "d:\Proyectos\Plantas\ficha_oficial_$($p.id)_HD.png"
    $edgeProfile2 = "$env:TEMP\edge_p2_$($p.id)"
    Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList "--headless=new", "--user-data-dir=$edgeProfile2", "--window-size=1200,1854", "--screenshot=`"$outPng`"", "file:///$($htmlPath.Replace('\', '/'))" -Wait
    Remove-Item -Recurse -Force $edgeProfile2 -ErrorAction SilentlyContinue
    Write-Host "-> PNG HD creado: $outPng"

    # Limpiar tempDir
    Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
}

Write-Host "=========================================="
Write-Host "¡TODAS LAS 6 PLANTAS PROCESADAS CON ÉXITO!"
Write-Host "=========================================="
