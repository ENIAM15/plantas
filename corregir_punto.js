const fs = require('fs');
const xmlPath = 'd:/Proyectos/Plantas/docx_extracted/word/document.xml';
let xml = fs.readFileSync(xmlPath, 'utf8');
xml = xml.replace(/pequeños\.\s*<\/w:t><\/w:r><w:r><w:rPr><w:color w:val="8D1725"\/><w:sz w:val="16"\/><\/w:rPr><w:t>\.<\/w:t>/g, 'pequeños.</w:t>');
fs.writeFileSync(xmlPath, xml, 'utf8');
console.log('Punto corregido');
