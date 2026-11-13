const fs = require('fs');
const {
  Document,
  Packer,
  Paragraph,
  TextRun,
  Table,
  TableRow,
  TableCell,
  WidthType,
  AlignmentType,
  BorderStyle,
  ImageRun,
  ShadingType,
  convertInchesToTwip
} = require('docx');

async function createEpazoteDocx() {
  const logosBuf = fs.readFileSync('d:/Proyectos/Plantas/logos_institucionales.png');
  const epazoteBuf = fs.readFileSync('d:/Proyectos/Plantas/epazote_sembrado.jpg');

  // Bordes invisibles para tablas contenedor
  const noBorder = {
    top: { style: BorderStyle.NONE, size: 0, color: "FFFFFF" },
    bottom: { style: BorderStyle.NONE, size: 0, color: "FFFFFF" },
    left: { style: BorderStyle.NONE, size: 0, color: "FFFFFF" },
    right: { style: BorderStyle.NONE, size: 0, color: "FFFFFF" },
  };

  const doc = new Document({
    sections: [{
      properties: {
        page: {
          size: {
            width: convertInchesToTwip(11),   // Tabloide 11 in
            height: convertInchesToTwip(17),  // Tabloide 17 in
          },
          margin: {
            top: convertInchesToTwip(0.4),
            bottom: convertInchesToTwip(0.4),
            left: convertInchesToTwip(0.5),
            right: convertInchesToTwip(0.5),
          },
        },
      },
      children: [
        // 1. TIRA OFICIAL DE LOGOS
        new Paragraph({
          alignment: AlignmentType.CENTER,
          spacing: { after: 120 },
          children: [
            new ImageRun({
              data: logosBuf,
              transformation: {
                width: 650,
                height: 120,
              },
            }),
          ],
        }),

        // 2. BANNER EMSaD 52 (VERDE OSCURO)
        new Table({
          width: { size: 100, type: WidthType.PERCENTAGE },
          borders: noBorder,
          rows: [
            new TableRow({
              children: [
                new TableCell({
                  shading: { type: ShadingType.CLEAR, fill: "133F2D" },
                  margins: { top: 140, bottom: 140, left: 200, right: 200 },
                  children: [
                    new Paragraph({
                      alignment: AlignmentType.CENTER,
                      spacing: { after: 40 },
                      children: [
                        new TextRun({
                          text: "EMSaD 52",
                          bold: true,
                          size: 32,
                          color: "FFFFFF",
                          font: "Arial",
                        }),
                      ],
                    }),
                    new Paragraph({
                      alignment: AlignmentType.CENTER,
                      spacing: { after: 40 },
                      children: [
                        new TextRun({
                          text: "PROYECTO ESCOLAR  •  BOTÁNICA Y SABERES TRADICIONALES",
                          bold: true,
                          size: 16,
                          color: "CBD5E1",
                          font: "Arial",
                        }),
                      ],
                    }),
                    new Paragraph({
                      alignment: AlignmentType.CENTER,
                      children: [
                        new TextRun({
                          text: "DEL HUERTO A LA RED: MEDICINA QUE SE CULTIVA",
                          bold: true,
                          size: 22,
                          color: "FFFFFF",
                          font: "Arial",
                        }),
                      ],
                    }),
                  ],
                }),
              ],
            }),
          ],
        }),

        // 3. TESORO VIVO DE NUESTRA TIERRA
        new Paragraph({
          alignment: AlignmentType.CENTER,
          spacing: { before: 140, after: 140 },
          children: [
            new TextRun({
              text: "TESORO VIVO DE NUESTRA TIERRA",
              bold: true,
              size: 24,
              color: "133F2D",
              font: "Arial",
            }),
          ],
        }),

        // 4. FOTOGRAFÍA DE LA PLANTA SEMBRADA EN TIERRA
        new Paragraph({
          alignment: AlignmentType.CENTER,
          spacing: { after: 100 },
          children: [
            new ImageRun({
              data: epazoteBuf,
              transformation: {
                width: 650,
                height: 380,
              },
            }),
          ],
        }),

        // 5. FRANJA NOMBRE DE LA PLANTA (VERDE OSCURO)
        new Table({
          width: { size: 100, type: WidthType.PERCENTAGE },
          borders: noBorder,
          rows: [
            new TableRow({
              children: [
                new TableCell({
                  shading: { type: ShadingType.CLEAR, fill: "133F2D" },
                  margins: { top: 120, bottom: 120, left: 200, right: 200 },
                  children: [
                    new Paragraph({
                      alignment: AlignmentType.CENTER,
                      spacing: { after: 40 },
                      children: [
                        new TextRun({
                          text: "EPAZOTE",
                          bold: true,
                          size: 44,
                          color: "FFFFFF",
                          font: "Georgia",
                        }),
                      ],
                    }),
                    new Paragraph({
                      alignment: AlignmentType.CENTER,
                      children: [
                        new TextRun({
                          text: "Dysphania ambrosioides",
                          italics: true,
                          size: 20,
                          color: "FFFFFF",
                          font: "Georgia",
                        }),
                        new TextRun({
                          text: "  |  Planta de nuestra riqueza natural",
                          size: 20,
                          color: "F1F5F9",
                          font: "Arial",
                        }),
                      ],
                    }),
                  ],
                }),
              ],
            }),
          ],
        }),

        new Paragraph({ spacing: { after: 140 } }),

        // 6. TABLA INFERIOR DE 2 COLUMNAS (SABER TRADICIONAL + EXPLORA QR)
        new Table({
          width: { size: 100, type: WidthType.PERCENTAGE },
          borders: noBorder,
          rows: [
            new TableRow({
              children: [
                // COLUMNA IZQUIERDA: SABER TRADICIONAL
                new TableCell({
                  width: { size: 62, type: WidthType.PERCENTAGE },
                  shading: { type: ShadingType.CLEAR, fill: "FFFFFF" },
                  margins: { top: 180, bottom: 180, left: 200, right: 200 },
                  borders: {
                    top: { style: BorderStyle.SINGLE, size: 8, color: "E2E8F0" },
                    bottom: { style: BorderStyle.SINGLE, size: 8, color: "E2E8F0" },
                    left: { style: BorderStyle.SINGLE, size: 8, color: "E2E8F0" },
                    right: { style: BorderStyle.SINGLE, size: 8, color: "E2E8F0" },
                  },
                  children: [
                    new Paragraph({
                      spacing: { after: 60 },
                      children: [
                        new TextRun({
                          text: "SABER TRADICIONAL",
                          bold: true,
                          size: 26,
                          color: "133F2D",
                          font: "Arial",
                        }),
                      ],
                    }),
                    new Paragraph({
                      spacing: { after: 40 },
                      children: [
                        new TextRun({
                          text: "Infusión digestiva y antiflatulenta",
                          bold: true,
                          size: 20,
                          color: "0F172A",
                          font: "Arial",
                        }),
                      ],
                    }),
                    new Paragraph({
                      spacing: { after: 100 },
                      children: [
                        new TextRun({
                          text: "Uso oral tradicional",
                          italics: true,
                          size: 16,
                          color: "64748B",
                          font: "Arial",
                        }),
                      ],
                    }),
                    new Paragraph({
                      spacing: { after: 120 },
                      children: [
                        new TextRun({
                          text: "En la medicina tradicional se menciona el uso de las hojas de epazote, preparadas en infusión suave, para aliviar cólicos estomacales, indigestión, gases y ayudar a expulsar parásitos intestinales.",
                          size: 17,
                          color: "334155",
                          font: "Arial",
                        }),
                      ],
                    }),
                    new Paragraph({
                      spacing: { after: 60 },
                      children: [
                        new TextRun({
                          text: "¿Cómo se prepara?",
                          bold: true,
                          size: 18,
                          color: "133F2D",
                          font: "Arial",
                        }),
                      ],
                    }),
                    new Paragraph({
                      spacing: { after: 40 },
                      children: [
                        new TextRun({
                          text: "1. Cosechar: ",
                          bold: true,
                          size: 16,
                          color: "0F172A",
                          font: "Arial",
                        }),
                        new TextRun({
                          text: "Cortar de 3 a 5 hojas frescas del huerto y lavarlas bien con agua limpia.",
                          size: 16,
                          color: "334155",
                          font: "Arial",
                        }),
                      ],
                    }),
                    new Paragraph({
                      spacing: { after: 40 },
                      children: [
                        new TextRun({
                          text: "2. Hervir: ",
                          bold: true,
                          size: 16,
                          color: "0F172A",
                          font: "Arial",
                        }),
                        new TextRun({
                          text: "Poner a hervir una taza de agua potable y retirar del fuego al primer hervor.",
                          size: 16,
                          color: "334155",
                          font: "Arial",
                        }),
                      ],
                    }),
                    new Paragraph({
                      spacing: { after: 140 },
                      children: [
                        new TextRun({
                          text: "3. Reposar: ",
                          bold: true,
                          size: 16,
                          color: "0F172A",
                          font: "Arial",
                        }),
                        new TextRun({
                          text: "Agregar las hojas, tapar de 3 a 5 minutos, colar y beber tibio con moderación.",
                          size: 16,
                          color: "334155",
                          font: "Arial",
                        }),
                      ],
                    }),

                    // RECUADRO DE PRECAUCIÓN
                    new Table({
                      width: { size: 100, type: WidthType.PERCENTAGE },
                      borders: {
                        top: { style: BorderStyle.NONE, size: 0, color: "FFFFFF" },
                        bottom: { style: BorderStyle.NONE, size: 0, color: "FFFFFF" },
                        left: { style: BorderStyle.SINGLE, size: 24, color: "DC2626" }, // Barra roja
                        right: { style: BorderStyle.NONE, size: 0, color: "FFFFFF" },
                      },
                      rows: [
                        new TableRow({
                          children: [
                            new TableCell({
                              shading: { type: ShadingType.CLEAR, fill: "FFF5F5" },
                              margins: { top: 80, bottom: 80, left: 100, right: 100 },
                              children: [
                                new Paragraph({
                                  spacing: { after: 20 },
                                  children: [
                                    new TextRun({
                                      text: "PRECAUCIÓN",
                                      bold: true,
                                      size: 15,
                                      color: "B91C1C",
                                      font: "Arial",
                                    }),
                                  ],
                                }),
                                new Paragraph({
                                  children: [
                                    new TextRun({
                                      text: "Contiene ascaridol. No consumir en exceso ni de forma prolongada. Contraindicado en mujeres embarazadas, en lactancia y en niños pequeños.",
                                      size: 14,
                                      color: "7F1D1D",
                                      font: "Arial",
                                    }),
                                  ],
                                }),
                              ],
                            }),
                          ],
                        }),
                      ],
                    }),
                  ],
                }),

                // ESPACIO ENTRE COLUMNAS
                new TableCell({
                  width: { size: 3, type: WidthType.PERCENTAGE },
                  borders: noBorder,
                  children: [new Paragraph({})],
                }),

                // COLUMNA DERECHA: EXPLORA Y QR
                new TableCell({
                  width: { size: 35, type: WidthType.PERCENTAGE },
                  shading: { type: ShadingType.CLEAR, fill: "133F2D" },
                  margins: { top: 180, bottom: 180, left: 140, right: 140 },
                  children: [
                    new Paragraph({
                      alignment: AlignmentType.CENTER,
                      spacing: { after: 20 },
                      children: [
                        new TextRun({
                          text: "EXPLORA",
                          bold: true,
                          size: 28,
                          color: "FFFFFF",
                          font: "Arial",
                        }),
                      ],
                    }),
                    new Paragraph({
                      alignment: AlignmentType.CENTER,
                      spacing: { after: 140 },
                      children: [
                        new TextRun({
                          text: "y descubre más",
                          size: 18,
                          color: "A7F3D0",
                          font: "Arial",
                        }),
                      ],
                    }),

                    // CUADRO BLANCO PARA EL CÓDIGO QR
                    new Table({
                      width: { size: 80, type: WidthType.PERCENTAGE },
                      borders: {
                        top: { style: BorderStyle.SINGLE, size: 12, color: "C59B27" },
                        bottom: { style: BorderStyle.SINGLE, size: 12, color: "C59B27" },
                        left: { style: BorderStyle.SINGLE, size: 12, color: "C59B27" },
                        right: { style: BorderStyle.SINGLE, size: 12, color: "C59B27" },
                      },
                      rows: [
                        new TableRow({
                          children: [
                            new TableCell({
                              shading: { type: ShadingType.CLEAR, fill: "FFFFFF" },
                              margins: { top: 200, bottom: 200, left: 100, right: 100 },
                              children: [
                                new Paragraph({
                                  alignment: AlignmentType.CENTER,
                                  spacing: { after: 40 },
                                  children: [
                                    new TextRun({
                                      text: "COLOCA AQUÍ",
                                      bold: true,
                                      size: 16,
                                      color: "133F2D",
                                      font: "Arial",
                                    }),
                                  ],
                                }),
                                new Paragraph({
                                  alignment: AlignmentType.CENTER,
                                  children: [
                                    new TextRun({
                                      text: "EL CÓDIGO QR",
                                      bold: true,
                                      size: 16,
                                      color: "133F2D",
                                      font: "Arial",
                                    }),
                                  ],
                                }),
                              ],
                            }),
                          ],
                        }),
                      ],
                    }),

                    new Paragraph({
                      alignment: AlignmentType.CENTER,
                      spacing: { before: 140, after: 20 },
                      children: [
                        new TextRun({
                          text: "ESCANEA",
                          bold: true,
                          size: 20,
                          color: "FFFFFF",
                          font: "Arial",
                        }),
                      ],
                    }),
                    new Paragraph({
                      alignment: AlignmentType.CENTER,
                      children: [
                        new TextRun({
                          text: "para ver el proyecto completo",
                          size: 15,
                          color: "A7F3D0",
                          font: "Arial",
                        }),
                      ],
                    }),
                  ],
                }),
              ],
            }),
          ],
        }),

        // 7. PIE DE PÁGINA INSTITUCIONAL
        new Paragraph({
          alignment: AlignmentType.CENTER,
          spacing: { before: 200, after: 40 },
          children: [
            new TextRun({
              text: "EMSaD 52  •  DEL HUERTO A LA RED: MEDICINA QUE SE CULTIVA",
              bold: true,
              size: 17,
              color: "133F2D",
              font: "Arial",
            }),
          ],
        }),
        new Paragraph({
          alignment: AlignmentType.CENTER,
          children: [
            new TextRun({
              text: "Información sobre uso tradicional; no sustituye la valoración ni el tratamiento médico.",
              size: 14,
              color: "64748B",
              font: "Arial",
            }),
          ],
        }),
      ],
    }],
  });

  const buffer = await Packer.toBuffer(doc);
  fs.writeFileSync('d:/Proyectos/Plantas/ficha_oficial_epazote.docx', buffer);
  console.log("DOCUMENTO WORD CREADO EXITOSAMENTE: d:/Proyectos/Plantas/ficha_oficial_epazote.docx");
}

createEpazoteDocx().catch(err => {
  console.error("Error al crear DOCX:", err);
});
