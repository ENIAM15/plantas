Add-Type -AssemblyName System.Drawing

$baseImg = [System.Drawing.Image]::FromFile("d:\Proyectos\Plantas\plantilla_original_maguey.jpg")
$epazoteImg = [System.Drawing.Image]::FromFile("d:\Proyectos\Plantas\epazote_sembrado.jpg")

$bmp = New-Object System.Drawing.Bitmap($baseImg.Width, $baseImg.Height)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# 1. Dibujar la plantilla base original completa
$g.DrawImage($baseImg, 0, 0, $baseImg.Width, $baseImg.Height)

# 2. Dibujar la foto de epazote sembrado en (32, 245, 598, 327) con esquinas redondeadas
$rectPhoto = New-Object System.Drawing.Rectangle(32, 245, 598, 327)
$pathPhoto = New-Object System.Drawing.Drawing2D.GraphicsPath
$radius = 20
$pathPhoto.AddArc($rectPhoto.X, $rectPhoto.Y, $radius, $radius, 180, 90)
$pathPhoto.AddArc($rectPhoto.Right - $radius, $rectPhoto.Y, $radius, $radius, 270, 90)
$pathPhoto.AddArc($rectPhoto.Right - $radius, $rectPhoto.Bottom - $radius, $radius, $radius, 0, 90)
$pathPhoto.AddArc($rectPhoto.X, $rectPhoto.Bottom - $radius, $radius, $radius, 90, 90)
$pathPhoto.CloseFigure()

$oldClip = $g.Clip
$g.SetClip($pathPhoto)
$g.DrawImage($epazoteImg, $rectPhoto.X, $rectPhoto.Y - 50, $rectPhoto.Width, $rectPhoto.Height + 100)
$g.Clip = $oldClip

# Borde verde oscuro (#133f2d)
$greenPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(19, 63, 45), 3)
$g.DrawPath($greenPen, $pathPhoto)

# 3. Barra del Nombre de la Planta en (35, 588, 592, 61)
$rectBar = New-Object System.Drawing.Rectangle(35, 588, 592, 61)
$pathBar = New-Object System.Drawing.Drawing2D.GraphicsPath
$rBar = 14
$pathBar.AddArc($rectBar.X, $rectBar.Y, $rBar, $rBar, 180, 90)
$pathBar.AddArc($rectBar.Right - $rBar, $rectBar.Y, $rBar, $rBar, 270, 90)
$pathBar.AddArc($rectBar.Right - $rBar, $rectBar.Bottom - $rBar, $rBar, $rBar, 0, 90)
$pathBar.AddArc($rectBar.X, $rectBar.Bottom - $rBar, $rBar, $rBar, 90, 90)
$pathBar.CloseFigure()

$greenBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(19, 63, 45))
$g.FillPath($greenBrush, $pathBar)

$fontTitle = New-Object System.Drawing.Font("Georgia", 22, [System.Drawing.FontStyle]::Bold)
$fontSub = New-Object System.Drawing.Font("Arial", 10.5, [System.Drawing.FontStyle]::Regular)

$whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$sfCenter = New-Object System.Drawing.StringFormat
$sfCenter.Alignment = [System.Drawing.StringAlignment]::Center
$sfCenter.LineAlignment = [System.Drawing.StringAlignment]::Center

$rectTitleText = New-Object System.Drawing.RectangleF(35.0, 592.0, 592.0, 32.0)
$g.DrawString("EPAZOTE", $fontTitle, $whiteBrush, $rectTitleText, $sfCenter)

$rectSubText = New-Object System.Drawing.RectangleF(35.0, 624.0, 592.0, 20.0)
$g.DrawString("Dysphania ambrosioides  |  Planta de nuestra riqueza natural", $fontSub, $whiteBrush, $rectSubText, $sfCenter)

# 4. Tarjeta SABER TRADICIONAL (15, 675, 345, 224)
$rectCard = New-Object System.Drawing.Rectangle(15, 675, 345, 224)
$pathCard = New-Object System.Drawing.Drawing2D.GraphicsPath
$rCard = 24
$pathCard.AddArc($rectCard.X, $rectCard.Y, $rCard, $rCard, 180, 90)
$pathCard.AddArc($rectCard.Right - $rCard, $rectCard.Y, $rCard, $rCard, 270, 90)
$pathCard.AddArc($rectCard.Right - $rCard, $rectCard.Bottom - $rCard, $rCard, $rCard, 0, 90)
$pathCard.AddArc($rectCard.X, $rectCard.Bottom - $rCard, $rCard, $rCard, 90, 90)
$pathCard.CloseFigure()

$whiteCardBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.FillPath($whiteCardBrush, $pathCard)

$fontSaberHead = New-Object System.Drawing.Font("Arial", 12.0, [System.Drawing.FontStyle]::Bold)
$fontRemedyTitle = New-Object System.Drawing.Font("Arial", 9.8, [System.Drawing.FontStyle]::Bold)
$fontRemedyType = New-Object System.Drawing.Font("Arial", 7.8, [System.Drawing.FontStyle]::Italic)
$fontBody = New-Object System.Drawing.Font("Arial", 8.0, [System.Drawing.FontStyle]::Regular)
$fontBodyBold = New-Object System.Drawing.Font("Arial", 8.0, [System.Drawing.FontStyle]::Bold)

$blackBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 30, 30))
$grayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 110, 110))

[float]$posX = 35.0
[float]$posY = 688.0

$g.DrawString("SABER TRADICIONAL", $fontSaberHead, $greenBrush, $posX, $posY)
$posY = $posY + 22.0

$g.DrawString("Infusion digestiva y antiflatulenta", $fontRemedyTitle, $blackBrush, $posX, $posY)
$posY = $posY + 16.0

$g.DrawString("Uso oral tradicional", $fontRemedyType, $grayBrush, $posX, $posY)
$posY = $posY + 14.0

$rectDesc = New-Object System.Drawing.RectangleF($posX, $posY, 305.0, 35.0)
$g.DrawString("En la medicina tradicional se menciona el uso de las hojas de epazote, preparadas en infusion suave, para aliviar colicos estomacales, indigestion y expulsar parasitos intestinales.", $fontBody, $blackBrush, $rectDesc)
$posY = $posY + 35.0

$g.DrawString("Como se prepara?", $fontBodyBold, $blackBrush, $posX, $posY)
$posY = $posY + 14.0

$rectSteps = New-Object System.Drawing.RectangleF($posX, $posY, 305.0, 45.0)
$stepsText = "1. Cosechar: Cortar de 3 a 5 hojas frescas del huerto y lavarlas bien.`n2. Hervir: Poner a calentar agua potable y retirar al primer hervor.`n3. Reposar: Agregar las hojas, tapar 3 a 5 min, colar y beber tibio."
$g.DrawString($stepsText, $fontBody, $blackBrush, $rectSteps)
$posY = $posY + 44.0

# Caja de PRECAUCION
$rectCaution = New-Object System.Drawing.RectangleF($posX, $posY, 305.0, 30.0)
$pinkBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(254, 237, 237))
$g.FillRectangle($pinkBrush, $rectCaution)

$redPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 38, 38), 3)
$g.DrawLine($redPen, [float]$rectCaution.X, [float]$rectCaution.Y, [float]$rectCaution.X, [float]$rectCaution.Bottom)

$fontCautionTitle = New-Object System.Drawing.Font("Arial", 7.2, [System.Drawing.FontStyle]::Bold)
$fontCautionText = New-Object System.Drawing.Font("Arial", 6.8, [System.Drawing.FontStyle]::Regular)
$redBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(185, 28, 28))

$g.DrawString("PRECAUCION", $fontCautionTitle, $redBrush, [float]($posX + 6.0), [float]($posY + 2.0))
$rectCautionBody = New-Object System.Drawing.RectangleF([float]($posX + 6.0), [float]($posY + 12.0), 292.0, 16.0)
$cautionMsg = "Contiene ascaridol. No abusar de la dosis ni prolongar su uso. Contraindicado en embarazo, lactancia y en ninos pequenos."
$g.DrawString($cautionMsg, $fontCautionText, $redBrush, $rectCautionBody)

# Guardar la imagen compuesta en alta calidad
$bmp.Save("d:\Proyectos\Plantas\ficha_epazote_fiel.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)

# Limpieza
$g.Dispose()
$bmp.Dispose()
$baseImg.Dispose()
$epazoteImg.Dispose()

Write-Output "GENERACION_EXITOSA: d:\Proyectos\Plantas\ficha_epazote_fiel.jpg"
