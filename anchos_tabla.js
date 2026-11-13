const fs = require('fs');
const xml = fs.readFileSync('d:/Proyectos/Plantas/docx_extracted/word/document.xml', 'utf8');

const tcMatches = xml.match(/<w:tcW[^>]*w:w="([^"]+)"[^>]*\/>/g) || [];
console.log('Anchos de celda (w:tcW):', tcMatches);

const tblMatches = xml.match(/<w:tblW[^>]*w:w="([^"]+)"[^>]*\/>/g) || [];
console.log('Anchos de tabla (w:tblW):', tblMatches);

// Ver padding de las celdas (w:tcMar)
const tcMarMatches = xml.match(/<w:tcMar>(.*?)<\/w:tcMar>/gs) || [];
console.log('Padding de celdas (tcMar):', tcMarMatches.slice(0, 3));
