$plants = @(
    @{ id = "belladona"; name = "Belladona" },
    @{ id = "oreganon"; name = "Oreganón" },
    @{ id = "vaporub"; name = "Vaporub" },
    @{ id = "maguey_morado"; name = "Maguey Morado" },
    @{ id = "albahaca"; name = "Albahaca" },
    @{ id = "malamadre"; name = "Mala Madre" },
    @{ id = "epazote"; name = "Epazote" }
)

Write-Host "================================================================="
Write-Host "ESTADO FINAL DE ENTREGABLES (DOCX, PDF 1 HOJA, PNG HD)"
Write-Host "================================================================="

foreach ($p in $plants) {
    $id = $p.id
    $docx = "d:\Proyectos\Plantas\ficha_oficial_$id.docx"
    $pdf = "d:\Proyectos\Plantas\ficha_oficial_$id.pdf"
    $png = "d:\Proyectos\Plantas\ficha_oficial_${id}_HD.png"

    $docxOk = (Test-Path $docx) -and ((Get-Item $docx).Length -gt 1000000)
    $pdfOk = (Test-Path $pdf) -and ((Get-Item $pdf).Length -gt 300000)
    $pngOk = (Test-Path $png) -and ((Get-Item $png).Length -gt 400000)

    $docxSize = if (Test-Path $docx) { [math]::Round((Get-Item $docx).Length / 1MB, 2).ToString() + " MB" } else { "Falta" }
    $pdfSize = if (Test-Path $pdf) { [math]::Round((Get-Item $pdf).Length / 1MB, 2).ToString() + " MB" } else { "Falta" }
    $pngSize = if (Test-Path $png) { [math]::Round((Get-Item $png).Length / 1KB, 0).ToString() + " KB" } else { "Falta" }

    Write-Host "$($p.name.PadRight(16)) | DOCX: $docxSize | PDF: $pdfSize | PNG: $pngSize | Estado: $(if ($docxOk -and $pdfOk -and $pngOk) {'COMPLETO 100%'} else {'REVISAR'})"
}
Write-Host "================================================================="
