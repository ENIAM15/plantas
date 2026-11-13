const fs = require('fs');
const xml = fs.readFileSync('d:/Proyectos/Plantas/docx_extracted/word/document.xml', 'utf8');

const start = xml.indexOf('Cataplasma desinflamante');
const end = xml.indexOf('EXPLORA');
console.log(xml.substring(start - 100, end));
