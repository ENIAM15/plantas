# Proyecto Escolar: Del Huerto a la Red - Medicina que se Cultiva
**Colegio de Bachilleres de Tabasco (COBATAB) — Centro EMSaD 52**

Fichas botánicas oficiales en formato **Tabloide (11 × 17 pulgadas)** diseñadas para la exposición escolar de plantas medicinales y saberes tradicionales.

---

## 🌿 Plantas Incluidas

1. **Epazote** (*Dysphania ambrosioides*) — Infusión digestiva y antiflatulenta.
2. **Belladona** (*Atropa belladonna*) — Emplasto analgésico y antiespasmódico (uso tópico externo).
3. **Oreganón** (*Plectranthus amboinicus*) — Jarabe e infusión para vías respiratorias.
4. **Vaporub** (*Plectranthus neochilus*) — Vahos descongestionantes y bálsamo pectoral.
5. **Maguey Morado** (*Tradescantia spathacea*) — Infusión pectoral y compresas cicatrizantes.
6. **Albahaca** (*Ocimum basilicum*) — Infusión carminativa y sedante digestivo.
7. **Mala Madre** (*Kalanchoe daigremontiana*) — Cataplasma dérmico cicatrizante y emoliente.
8. **Orégano** (*Origanum vulgare*) — Infusión digestiva, antitusiva y antiséptica.
9. **Sábila** (*Aloe vera*) — Gel regenerador dérmico y calmante estomacal.
10. **Zacate Limón** (*Cymbopogon citratus*) — Infusión relajante, digestiva y sudorífica.
11. **Sasafrás** (*Sassafras albidum*) — Infusión aromática y fricción antirreumática.
12. **Incienso** (*Plectranthus madagascariensis*) — Vahos aromáticos, relajante y repelente natural.
13. **Guayaba** (*Psidium guajava*) — Cocimiento antidiarreico y antiséptico bucal.
14. **Naranja Agria** (*Citrus × aurantium*) — Infusión sedante de hojas y digestivo amargo.
15. **Romero** (*Salvia rosmarinus*) — Infusión tonificante y loción capilar.
16. **Kalanchoe** (*Kalanchoe pinnata*) — Cataplasma antiinflamatorio y cicatrizante.

---

## 📁 Estructura del Repositorio

- **`index.html` y `plantas_web_data.js`**: Sitio web institucional interactivo del **EMSaD 52 — Ejido Vicente Guerrero** con información botánica extendida de las 17 plantas (características, lugares de cultivo, principios activos, audio guía e impresión de hoja resumen).
- **`qr_sitio_emsad52.png`**: Código QR oficial único del catálogo web (`https://eniam15.github.io/plantas/`).
- **`ficha_oficial_<planta>.docx`**: Documento editable en Microsoft Word con la estructura, tipografía (Georgia), paleta institucional y tamaños oficiales exactos.
- **`ficha_oficial_<planta>.pdf`**: Archivo listo para impresión profesional en tamaño Tabloide (11 × 17 in) en 1 sola página estricta y vectores nítidos.
- **`ficha_oficial_<planta>_HD.png`**: Vista previa digital en alta definición (1200 × 1854 px).
- **`plantas_metadata.json`**: Metadatos botánicos, nombres científicos, recetas en 3 pasos y precauciones médicas de cada especie.
- **`generar_todo_definitivo.ps1`**: Script de PowerShell que genera automáticamente los documentos `.docx`, los archivos `.pdf` y las imágenes `.png` incrustando imágenes y respetando los lineamientos institucionales.
- **`verificar_entrega.ps1`**: Script de validación de integridad para comprobar tamaños de archivo y conteo de páginas.
- **`docx_extracted/`**: Componentes base OpenXML para la generación programática de archivos Word.

---

## 🎨 Especificaciones de Diseño

- **Tipografía**: Georgia
- **Paleta de Colores**:
  - Verde obscuro institucional: `#174B38`
  - Dorado complementario: `#E7D7B2`
  - Verde secundario (subtítulos): `#2D7654`
  - Rojo precaución: `#B51F32` / `#8D1725`
  - Gris texto secundario: `#64756B`
- **Franja de Logos**: 9.95 in × 1.885 in (Gobierno de Tabasco, Secretaría de Educación, 50 Aniversario y COBATAB).
- **Marco de Fotografía**: 9.95 in × 4.45 in con borde `#174B38` de 3 pt y esquinas redondeadas.
- **Columnas**:
  - Saber Tradicional (Receta): 6.05 in
  - Explora / Código QR: 3.8 in
